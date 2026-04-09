import type { OkJob } from "../types.js";

export interface LocalModelResult {
  providerId: "local_model";
  status: "completed" | "failed";
  output?: string;
  note?: string;
}

export class LocalModelClient {
  async run(job: OkJob): Promise<LocalModelResult> {
    // Stub for GPT4All or another local server.
    return {
      providerId: "local_model",
      status: "failed",
      note: "local model not configured"
    };
  }
}
