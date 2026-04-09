import type { OkJob } from "../types.js";

export interface OpenRouterResult {
  providerId: "openrouter";
  status: "completed" | "completed_degraded" | "failed";
  output?: string;
  note?: string;
}

export interface OpenRouterClientOptions {
  apiKey?: string;
  baseUrl?: string;
  freeModel?: string;
  economyModel?: string;
  premiumModel?: string;
}

export class OpenRouterClient {
  constructor(private readonly options: OpenRouterClientOptions) {}

  async run(job: OkJob, tier: "free" | "economy" | "premium" = "free"): Promise<OpenRouterResult> {
    const apiKey = this.options.apiKey ?? process.env.OPENROUTER_API_KEY;
    if (!apiKey) {
      return {
        providerId: "openrouter",
        status: "failed",
        note: "OPENROUTER_API_KEY not configured"
      };
    }

    const model =
      tier === "free"
        ? this.options.freeModel ?? "openrouter/free"
        : tier === "economy"
          ? this.options.economyModel ?? "openai/gpt-4.1-mini"
          : this.options.premiumModel ?? "anthropic/claude-3.7-sonnet";

    // Scaffold only: wire real fetch here.
    return {
      providerId: "openrouter",
      status: "completed",
      output: `[openrouter:${model}] ${job.input.slice(0, 500)}`
    };
  }
}
