export type Panel = {
  id: string;
  title: string;
  kind: "workspace" | "log" | "preview";
};

export const defaultPanels: Panel[] = [
  { id: "command-preview", title: "Command Preview", kind: "preview" },
  { id: "workspace-main", title: "Workspace", kind: "workspace" },
  { id: "shell-log", title: "Shell Log", kind: "log" }
];
