# UCI Command Palette Session

This example shows the shell-first UCI posture for `v2.4`.

## Goals

- open the command palette from a controller semantic action
- move between command results without leaving the controller mode
- accept a predicted command or text fragment without blocking on remote
  ranking

## Example Flow

1. Controller sends the reserved `palette` semantic action while in `nav` mode.
2. Shell opens the command palette and switches the active input context to
   `command`.
3. Directional input moves through command candidates.
4. Accept-prediction inserts the selected command fragment.
5. Submit triggers the same shell command route that keyboard entry would use.

## Expected Boundary

- Core owns the event and prediction contract
- Shell owns the palette interaction flow
- Wizard may optionally rerank suggestions, but the shell flow must remain
  usable when remote ranking is absent
