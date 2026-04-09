import type { BinderWorkspaceModel, PostState, TaskStatus, WorkspaceItem } from "./types";

function isRecord(v: unknown): v is Record<string, unknown> {
  return typeof v === "object" && v !== null && !Array.isArray(v);
}

function asString(v: unknown, field: string): string {
  if (typeof v === "string" && v.length > 0) {
    return v;
  }
  throw new Error(`demo-binder: expected string ${field}`);
}

function optionalString(v: unknown): string | undefined {
  return typeof v === "string" ? v : undefined;
}

const TASK_STATUSES: TaskStatus[] = ["todo", "doing", "done", "blocked"];
const POST_STATES: PostState[] = ["draft", "scheduled", "published"];

function asTaskStatus(v: unknown): TaskStatus | undefined {
  if (v === undefined || v === null) {
    return undefined;
  }
  if (typeof v === "string" && TASK_STATUSES.includes(v as TaskStatus)) {
    return v as TaskStatus;
  }
  throw new Error(`demo-binder: bad status`);
}

function asPostState(v: unknown): PostState | undefined {
  if (v === undefined || v === null) {
    return undefined;
  }
  if (typeof v === "string" && POST_STATES.includes(v as PostState)) {
    return v as PostState;
  }
  throw new Error(`demo-binder: bad postState`);
}

function parseItem(raw: unknown): WorkspaceItem {
  if (!isRecord(raw)) {
    throw new Error("demo-binder: item must be object");
  }
  const id = asString(raw.id, "id");
  const title = asString(raw.title, "title");
  const item: WorkspaceItem = { id, title };
  item.summary = optionalString(raw.summary);
  if (raw.parentId === null) {
    item.parentId = null;
  } else if (typeof raw.parentId === "string") {
    item.parentId = raw.parentId;
  }
  item.docSlug = optionalString(raw.docSlug);
  item.markdown = optionalString(raw.markdown);
  item.dueAt = optionalString(raw.dueAt);
  item.scheduledAt = optionalString(raw.scheduledAt);
  item.campaignId = optionalString(raw.campaignId);
  item.recordType = optionalString(raw.recordType);
  if (raw.status !== undefined) {
    item.status = asTaskStatus(raw.status);
  }
  if (raw.postState !== undefined) {
    item.postState = asPostState(raw.postState);
  }
  if (Array.isArray(raw.platforms)) {
    item.platforms = raw.platforms.filter((p): p is string => typeof p === "string");
  }
  if (isRecord(raw.fields)) {
    const fields: Record<string, string> = {};
    for (const [k, val] of Object.entries(raw.fields)) {
      if (typeof val === "string") {
        fields[k] = val;
      }
    }
    if (Object.keys(fields).length > 0) {
      item.fields = fields;
    }
  }
  return item;
}

export function parseDemoBinderJson(raw: unknown): BinderWorkspaceModel {
  if (!isRecord(raw)) {
    throw new Error("demo-binder: root must be object");
  }
  const id = asString(raw.id, "id");
  const title = asString(raw.title, "title");
  if (!Array.isArray(raw.items)) {
    throw new Error("demo-binder: items must be array");
  }
  const items = raw.items.map(parseItem);
  return { id, title, items };
}
