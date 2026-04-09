import { buildCacheKey, getCached, setCached } from "./cache.js";
import { tryDeterministic } from "./deterministic.js";
import { LocalModelClient } from "./providers/localModel.js";
import { OpenRouterClient } from "./providers/openrouter.js";
import type { OkJob, RouteDecision } from "./types.js";

export class OkRoutingEngine {
  private readonly localModel = new LocalModelClient();
  private readonly openRouter = new OpenRouterClient({});

  classifyComplexity(job: OkJob): "L0" | "L1" | "L2" | "L3" | "L4" {
    const length = job.input.length;
    if (length < 500) return "L0";
    if (length < 1500) return "L1";
    if (length < 4000) return "L2";
    if (length < 8000) return "L3";
    return "L4";
  }

  async run(job: OkJob): Promise<{ decision: RouteDecision; output: string }> {
    const cacheKey = buildCacheKey(job.input, job.requestClass);
    const cached = getCached(cacheKey);
    if (cached) {
      return {
        decision: { strategy: "cache", reason: "cache_hit" },
        output: cached
      };
    }

    const deterministic = await tryDeterministic(job);
    if (deterministic) {
      setCached(cacheKey, deterministic);
      return {
        decision: { strategy: "deterministic", reason: "deterministic_transform" },
        output: deterministic
      };
    }

    const localResult = await this.localModel.run(job);
    if (localResult.status === "completed" && localResult.output) {
      setCached(cacheKey, localResult.output);
      return {
        decision: { strategy: "local_model", reason: "local_model_success" },
        output: localResult.output
      };
    }

    if (job.allowRemote === false || job.budgetGroup === "offline_only") {
      return {
        decision: {
          strategy: "defer",
          reason: "remote_disallowed",
          degraded: true
        },
        output: "Local deterministic output unavailable; remote execution disabled."
      };
    }

    const complexity = this.classifyComplexity(job);
    const tier =
      complexity === "L0" || complexity === "L1"
        ? "free"
        : complexity === "L2"
          ? "economy"
          : "premium";

    const remote = await this.openRouter.run(job, tier);
    if (remote.status === "completed" && remote.output) {
      setCached(cacheKey, remote.output);
      return {
        decision: { strategy: "provider", providerId: "openrouter", reason: `openrouter_${tier}` },
        output: remote.output
      };
    }

    return {
      decision: { strategy: "defer", reason: "all_routes_failed", degraded: true },
      output: "Completed in degraded mode: no provider route succeeded."
    };
  }
}
