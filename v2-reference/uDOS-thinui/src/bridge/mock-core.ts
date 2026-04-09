import type { ThinUiEvent } from "../contracts/event";
import type { ThinUiAction, ThinUiStatePacket } from "../contracts/state";
import { hydrateThinUiState } from "../runtime/state-hydrator";
import type { ThinUiCoreBridge } from "../runtime/types";

const backNav: ThinUiAction = { id: "back", label: "Back", kind: "nav" };

function homeActions(): ThinUiAction[] {
  return [
    { id: "open-binder", label: "Binders", kind: "primary" },
    { id: "open-progress", label: "Progress", kind: "secondary" },
    { id: "open-sync", label: "Sync status", kind: "secondary" },
    { id: "open-recovery", label: "Recovery", kind: "danger" },
    { id: "open-handoff", label: "Browser handoff", kind: "nav" },
    { id: "open-utilities", label: "Utilities", kind: "secondary" },
    { id: "open-teletext", label: "Teletext", kind: "secondary" },
    backNav,
  ];
}

function subViewActions(extra: ThinUiAction[] = []): ThinUiAction[] {
  return [...extra, backNav];
}

export class MockThinUiCoreBridge implements ThinUiCoreBridge {
  private state: ThinUiStatePacket;
  private readonly stack: string[] = [];

  constructor(seedState?: Partial<ThinUiStatePacket>) {
    this.state = hydrateThinUiState(seedState);
  }

  getState(): ThinUiStatePacket {
    return this.state;
  }

  private pushView(nextView: string): void {
    this.stack.push(this.state.view);
    this.state = { ...this.state, view: nextView };
  }

  private popView(): boolean {
    const prev = this.stack.pop();
    if (!prev) {
      return false;
    }
    if (prev === "home-launcher") {
      this.state = {
        ...this.state,
        view: "home-launcher",
        mode: this.state.surface?.homeMode ?? "fullscreen",
        actions: homeActions(),
        title: "uDOS ThinUI",
        subtitle: "Choose a lane",
        status: "running",
      };
      return true;
    }
    if (prev === "boot-loader") {
      this.state = {
        ...this.state,
        view: "boot-loader",
        mode: "fullscreen",
        title: "uDOS ThinUI",
        subtitle: "Runtime scaffold ready",
        status: "running",
        progress: { current: 1, total: 3, label: "Loading services" },
        actions: [
          { id: "continue", label: "Continue", kind: "primary" },
          { id: "refresh", label: "Refresh", kind: "secondary" },
        ],
      };
      return true;
    }
    if (prev === "recovery-panel") {
      this.state = {
        ...this.state,
        view: "recovery-panel",
        mode: "recovery",
        title: "Recovery",
        subtitle: "Safe mode surface",
        status: "warning",
        diagnostics: { ...this.state.diagnostics, safeMode: true },
        actions: subViewActions([
          { id: "refresh", label: "Refresh", kind: "secondary" },
        ]),
      };
      return true;
    }
    this.state = { ...this.state, view: prev, mode: "fullscreen" };
    return true;
  }

  dispatchEvent(event: ThinUiEvent): ThinUiStatePacket {
    if (event.type === "select" && event.targetId === "theme") {
      const tid =
        (typeof event.value === "string" && event.value) ||
        (typeof event.meta?.themeId === "string" ? event.meta.themeId : "");
      if (tid) {
        this.state = { ...this.state, themeId: tid };
      }
      return this.state;
    }

    if (event.type === "navigate" && event.targetId === "back") {
      this.popView();
      return this.state;
    }

    if (event.type === "launch-browser") {
      this.state = {
        ...this.state,
        status: "complete",
        subtitle: "Browser launch requested (host would open URL)",
      };
      return this.state;
    }

    if (event.type === "request-refresh") {
      this.state = {
        ...this.state,
        status: "running",
        progress: {
          current: 2,
          total: 3,
          label: "Refresh complete",
        },
      };
      return this.state;
    }

    if (event.type === "action" && event.targetId) {
      const id = event.targetId;

      if (id === "continue") {
        this.stack.length = 0;
        this.stack.push("boot-loader");
        const homeMode = this.state.surface?.homeMode ?? "fullscreen";
        this.state = {
          ...this.state,
          view: "home-launcher",
          mode: homeMode,
          title: "uDOS ThinUI",
          subtitle: "Choose a lane",
          status: "running",
          progress: { current: 3, total: 3, label: "Ready" },
          actions: homeActions(),
          diagnostics: { ...this.state.diagnostics, safeMode: false },
        };
        return this.state;
      }

      if (id === "refresh") {
        this.state = {
          ...this.state,
          status: "running",
          progress: { current: 2, total: 3, label: "Refreshed" },
        };
        return this.state;
      }

      if (id === "open-binder") {
        this.pushView("binder-select");
        this.state = {
          ...this.state,
          title: "Binder vault",
          subtitle: "Choose vault context",
          actions: subViewActions([
            { id: "pick-alpha", label: "Select Alpha", kind: "primary" },
            { id: "pick-beta", label: "Select Beta", kind: "secondary" },
          ]),
        };
        return this.state;
      }

      if (id === "open-progress") {
        this.pushView("operation-progress");
        this.state = {
          ...this.state,
          title: "Operation",
          subtitle: "Pipeline",
          status: "running",
          progress: { current: 2, total: 5, label: "Applying manifests" },
          actions: subViewActions([
            { id: "tick-progress", label: "Advance step (demo)", kind: "secondary" },
          ]),
        };
        return this.state;
      }

      if (id === "open-sync") {
        this.pushView("sync-status");
        this.state = {
          ...this.state,
          title: "Sync status",
          subtitle: "Operator readout",
          actions: subViewActions(),
        };
        return this.state;
      }

      if (id === "open-recovery") {
        this.pushView("recovery-panel");
        this.state = {
          ...this.state,
          mode: "recovery",
          title: "Recovery",
          subtitle: "Safe mode surface",
          status: "warning",
          diagnostics: { ...this.state.diagnostics, safeMode: true },
          actions: subViewActions([
            { id: "refresh", label: "Refresh", kind: "secondary" },
          ]),
        };
        return this.state;
      }

      if (id === "open-handoff") {
        this.pushView("handoff-to-browser");
        this.state = {
          ...this.state,
          title: "Browser handoff",
          subtitle: "Wizard / Surface",
          status: "complete",
          panels: [
            {
              id: "handoff",
              kind: "link",
              title: "Target",
              body: "http://127.0.0.1:8787/app",
            },
          ],
          actions: subViewActions([
            { id: "launch-browser-ui", label: "Launch browser", kind: "primary" },
          ]),
        };
        return this.state;
      }

      if (id === "open-utilities") {
        this.pushView("utility-panel");
        this.state = {
          ...this.state,
          title: "Utilities",
          subtitle: "Sonic lane",
          actions: subViewActions(),
        };
        return this.state;
      }

      if (id === "open-teletext") {
        this.pushView("teletext-display");
        this.state = {
          ...this.state,
          title: "uDOS Teletext",
          subtitle: "Service display",
          actions: subViewActions([
            { id: "page-101", label: "Page 101", kind: "secondary" },
          ]),
        };
        return this.state;
      }

      if (id === "tick-progress") {
        const cur = this.state.progress?.current ?? 0;
        const tot = this.state.progress?.total ?? 5;
        const next = Math.min(cur + 1, tot);
        this.state = {
          ...this.state,
          progress: {
            ...this.state.progress,
            current: next,
            total: tot,
            label: next >= tot ? "Complete" : this.state.progress?.label ?? "Running",
          },
          status: next >= tot ? "complete" : "running",
        };
        return this.state;
      }

      if (id === "pick-alpha" || id === "pick-beta") {
        this.state = {
          ...this.state,
          subtitle: `Bound: ${id === "pick-alpha" ? "Alpha" : "Beta"}`,
          status: "complete",
        };
        return this.state;
      }

      if (id === "launch-browser-ui") {
        return this.dispatchEvent({ type: "launch-browser" });
      }

      if (id === "page-101") {
        this.state = {
          ...this.state,
          subtitle: "Page 101 — startup summary",
        };
        return this.state;
      }
    }

    return this.state;
  }
}
