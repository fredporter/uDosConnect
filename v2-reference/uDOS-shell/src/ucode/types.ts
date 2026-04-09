export type ParsedCommand = {
  namespace: string;
  action: string;
  args: Record<string, string>;
  raw: string;
};
