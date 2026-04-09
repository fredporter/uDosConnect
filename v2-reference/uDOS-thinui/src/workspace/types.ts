/** View modes for one #binder in the unified ThinUI shell (Phase 2–3 scaffold). */
export type WorkspaceMode =
  | "board"
  | "table"
  | "docs"
  | "calendar"
  | "social"
  | "ops"
  | "editor";

export type TaskStatus = "todo" | "doing" | "done" | "blocked";

export type PostState = "draft" | "scheduled" | "published";

/** One binder-linked object surfaced across board, table, docs, schedule, social, and ops. */
export type WorkspaceItem = {
  id: string;
  title: string;
  summary?: string;
  /** Board / task lane */
  status?: TaskStatus;
  /** Docs tree */
  parentId?: string | null;
  docSlug?: string;
  /** Markdown body (editor / docs preview) */
  markdown?: string;
  /** Calendar facets (ISO 8601 date or date-time) */
  dueAt?: string;
  scheduledAt?: string;
  /** Social / Empire-oriented */
  platforms?: string[];
  campaignId?: string;
  postState?: PostState;
  /** Ops / record */
  recordType?: string;
  fields?: Record<string, string>;
};

export type BinderWorkspaceModel = {
  id: string;
  title: string;
  items: WorkspaceItem[];
};
