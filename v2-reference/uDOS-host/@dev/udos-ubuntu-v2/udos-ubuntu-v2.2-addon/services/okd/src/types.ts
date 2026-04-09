export type RequestClass =
  | "summarize"
  | "draft"
  | "classify"
  | "analysis"
  | "research"
  | "code"
  | "multimodal"
  | "transformation";

export type BudgetGroup =
  | "offline_only"
  | "tier0_free"
  | "tier1_economy"
  | "tier2_premium"
  | "tierX_locked";

export interface OkJob {
  id: string;
  requestClass: RequestClass;
  input: string;
  target?: {
    binder?: string;
    workspacePath?: string;
    mode?: "append" | "merge" | "new";
  };
  allowRemote?: boolean;
  requireStructuredOutput?: boolean;
  budgetGroup?: BudgetGroup;
}

export interface RouteDecision {
  strategy: "deterministic" | "local_model" | "cache" | "provider" | "defer";
  providerId?: string;
  reason: string;
  degraded?: boolean;
}
