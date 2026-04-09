import type { ParsedCommand } from "./types.js";

export function parseUcode(input: string): ParsedCommand {
  const raw = input.trim();

  if (!raw) {
    return {
      namespace: "system",
      action: "noop",
      args: {},
      raw
    };
  }

  const parts = raw.split(/\s+/);
  const head = parts[0];

  let namespace = "system";
  let action = head;
  let rest = parts.slice(1);

  if (head.startsWith("#")) {
    namespace = head.slice(1);
    action = parts[1] ?? "run";
    rest = parts.slice(2);
  }

  const args: Record<string, string> = {};
  const positional: string[] = [];

  for (const item of rest) {
    if (item.includes(":") && !item.startsWith('"')) {
      const [key, ...value] = item.split(":");
      args[key] = value.join(":").replace(/^"|"$/g, "");
    } else {
      positional.push(item.replace(/^"|"$/g, ""));
    }
  }

  if (positional.length) {
    args.items = positional.join(" ");
  }

  return {
    namespace,
    action,
    args,
    raw
  };
}
