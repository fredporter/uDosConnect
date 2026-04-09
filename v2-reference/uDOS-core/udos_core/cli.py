import json
import sys

from .runtime import RuntimeKernel


def _run_once(argv: list[str]) -> int:
    kernel = RuntimeKernel()

    if argv[0] == "run-script":
        if len(argv) < 2:
            print("usage: udos-core run-script <path-to-script.md>", file=sys.stderr)
            return 2
        command = f"RUN {argv[1]}"
    elif argv[0] == "run":
        if len(argv) < 2:
            print("usage: udos-core run <ucode-command>", file=sys.stderr)
            return 2
        command = " ".join(argv[1:])
    else:
        print(f"unknown command: {argv[0]}", file=sys.stderr)
        return 2

    result = kernel.execute(command)
    print(json.dumps(result, indent=2))
    return 0 if result["ok"] else 1


def main() -> None:
    argv = sys.argv[1:]
    if argv:
        raise SystemExit(_run_once(argv))

    kernel = RuntimeKernel()
    print("uDOS-core runtime kernel")
    print("Type 'exit' to quit.")
    while True:
        try:
            raw = input("uCODE> ").strip()
        except EOFError:
            break
        if raw.lower() in {"exit", "quit"}:
            break
        result = kernel.execute(raw)
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
