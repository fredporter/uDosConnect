import readline from "node:readline";
import { parseUcode } from "./ucode/parser.js";
import { renderCommandPreview } from "./ucode/preview.js";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  prompt: "uCODE> "
});

console.log("uDOS-shell starter");
console.log("Type 'exit' to quit.");
rl.prompt();

rl.on("line", (line: string) => {
  const raw = line.trim();
  if (raw === "exit" || raw === "quit") {
    rl.close();
    return;
  }

  const parsed = parseUcode(raw);
  const preview = renderCommandPreview(parsed);
  console.log(JSON.stringify(preview, null, 2));
  rl.prompt();
});

rl.on("close", () => {
  console.log("Shell closed.");
  process.exit(0);
});
