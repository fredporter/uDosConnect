import { createBinderSourceFromLocationSearch } from "@thinui/workspace/binder-source";
import type { BinderWorkspaceModel, WorkspaceItem, WorkspaceMode } from "@thinui/workspace/types";
import { formatBinderMarkdown } from "./workspace-markdown";

type ModeDef = { id: WorkspaceMode; label: string; blurb: string };

const MODES: ModeDef[] = [
  {
    id: "board",
    label: "Board",
    blurb: "Status lanes — same binder items as cards (AppFlowy-style slice).",
  },
  {
    id: "table",
    label: "Table",
    blurb: "Record rows — shared identity across columns.",
  },
  {
    id: "docs",
    label: "Docs",
    blurb: "Outline-style tree + reading pane for markdown bodies.",
  },
  {
    id: "calendar",
    label: "Calendar",
    blurb: "Due and scheduled dates on one timeline.",
  },
  {
    id: "social",
    label: "Social",
    blurb: "Mixpost-style queue: platforms, campaign, post state.",
  },
  {
    id: "ops",
    label: "Ops",
    blurb: "Budibase-style quick fields for internal records.",
  },
  {
    id: "editor",
    label: "Editor",
    blurb: "Markdown-first lane (Typo-like; renderer preview adjacent in Docs).",
  },
];

const STATUS_ORDER: NonNullable<WorkspaceItem["status"]>[] = [
  "todo",
  "doing",
  "done",
  "blocked",
];

function byId(items: WorkspaceItem[], id: string | null): WorkspaceItem | undefined {
  if (!id) {
    return undefined;
  }
  return items.find((i) => i.id === id);
}

class WorkspaceDemoApp {
  private readonly binder: BinderWorkspaceModel;
  private mode: WorkspaceMode = "board";
  private selectedId: string | null;
  private drawerOpen = false;
  private paletteOpen = false;
  private paletteSelected = 0;
  private paletteFilter = "";

  constructor(binder: BinderWorkspaceModel) {
    this.binder = binder;
    this.selectedId = binder.items[0]?.id ?? null;
  }

  mount(): void {
    this.bindDom();
    this.renderChrome();
    this.renderMain();
    this.renderDrawer();
    window.addEventListener("keydown", (e) => this.onKeydown(e));
  }

  private bindDom(): void {
    document.getElementById("ws-toggle-drawer")?.addEventListener("click", () => {
      this.toggleDrawer();
    });
    document.getElementById("ws-drawer-close")?.addEventListener("click", () => {
      this.setDrawerOpen(false);
    });
    document.getElementById("ws-toggle-fullscreen")?.addEventListener("click", () => {
      document.body.classList.toggle("ws-fullscreen");
    });
    document.getElementById("ws-cmd-search")?.addEventListener("click", () => {
      this.openPalette();
    });
    const backdrop = document.getElementById("ws-palette-backdrop");
    backdrop?.addEventListener("click", () => this.closePalette());
    const input = document.getElementById("ws-palette-input") as HTMLInputElement | null;
    input?.addEventListener("input", () => {
      this.paletteFilter = input.value.trim().toLowerCase();
      this.paletteSelected = 0;
      this.renderPaletteList();
    });
    input?.addEventListener("keydown", (e) => {
      const entries = this.paletteEntries();
      if (e.key === "ArrowDown") {
        e.preventDefault();
        this.paletteSelected = Math.min(this.paletteSelected + 1, Math.max(0, entries.length - 1));
        this.renderPaletteList();
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        this.paletteSelected = Math.max(this.paletteSelected - 1, 0);
        this.renderPaletteList();
      } else if (e.key === "Enter") {
        e.preventDefault();
        const pick = entries[this.paletteSelected];
        if (pick) {
          pick.run();
          this.closePalette();
        }
      }
    });
  }

  private onKeydown(e: KeyboardEvent): void {
    const meta = e.metaKey || e.ctrlKey;
    if (meta && e.key.toLowerCase() === "k") {
      e.preventDefault();
      if (this.paletteOpen) {
        this.closePalette();
      } else {
        this.openPalette();
      }
      return;
    }
    if (e.key === "Escape") {
      if (this.paletteOpen) {
        e.preventDefault();
        this.closePalette();
      }
    }
  }

  private openPalette(): void {
    this.paletteOpen = true;
    this.paletteFilter = "";
    this.paletteSelected = 0;
    const backdrop = document.getElementById("ws-palette-backdrop");
    const pal = document.getElementById("ws-palette");
    const input = document.getElementById("ws-palette-input") as HTMLInputElement | null;
    backdrop?.removeAttribute("hidden");
    pal?.removeAttribute("hidden");
    this.renderPaletteList();
    window.requestAnimationFrame(() => input?.focus());
  }

  private closePalette(): void {
    this.paletteOpen = false;
    document.getElementById("ws-palette-backdrop")?.setAttribute("hidden", "");
    document.getElementById("ws-palette")?.setAttribute("hidden", "");
  }

  private paletteEntries(): { label: string; run: () => void }[] {
    const q = this.paletteFilter;
    const out: { label: string; run: () => void }[] = [];
    for (const m of MODES) {
      const label = `Mode: ${m.label}`;
      if (!q || label.toLowerCase().includes(q) || m.id.includes(q)) {
        out.push({
          label,
          run: () => {
            this.setMode(m.id);
          },
        });
      }
    }
    for (const it of this.binder.items) {
      const label = `Open: ${it.title}`;
      if (!q || label.toLowerCase().includes(q) || it.id.includes(q)) {
        out.push({
          label,
          run: () => {
            this.selectItem(it.id);
            this.setDrawerOpen(true);
          },
        });
      }
    }
    return out;
  }

  private renderPaletteList(): void {
    const ul = document.getElementById("ws-palette-list");
    if (!ul) {
      return;
    }
    ul.replaceChildren();
    const entries = this.paletteEntries();
    entries.forEach((ent, idx) => {
      const li = document.createElement("li");
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "ws-palette__item";
      btn.textContent = ent.label;
      btn.setAttribute("aria-selected", idx === this.paletteSelected ? "true" : "false");
      btn.addEventListener("click", () => {
        ent.run();
        this.closePalette();
      });
      li.appendChild(btn);
      ul.appendChild(li);
    });
  }

  private setMode(m: WorkspaceMode): void {
    this.mode = m;
    this.renderChrome();
    this.renderMain();
  }

  private selectItem(id: string): void {
    this.selectedId = id;
    this.renderMain();
    this.renderDrawer();
  }

  private toggleDrawer(): void {
    this.setDrawerOpen(!this.drawerOpen);
  }

  private setDrawerOpen(open: boolean): void {
    this.drawerOpen = open;
    const drawer = document.getElementById("ws-drawer");
    const btn = document.getElementById("ws-toggle-drawer");
    drawer?.toggleAttribute("hidden", !open);
    if (drawer) {
      drawer.setAttribute("aria-hidden", open ? "false" : "true");
    }
    btn?.setAttribute("aria-expanded", open ? "true" : "false");
    if (open) {
      this.renderDrawer();
    }
  }

  private renderChrome(): void {
    document.getElementById("ws-binder-title")!.textContent = this.binder.title;
    document.getElementById("ws-binder-id")!.textContent = `#${this.binder.id}`;

    const nav = document.getElementById("ws-modes");
    if (nav) {
      nav.replaceChildren();
      for (const m of MODES) {
        const b = document.createElement("button");
        b.type = "button";
        b.className = "ws-mode-btn";
        b.textContent = m.label;
        b.setAttribute("aria-current", m.id === this.mode ? "true" : "false");
        b.addEventListener("click", () => this.setMode(m.id));
        nav.appendChild(b);
      }
    }

    const def = MODES.find((x) => x.id === this.mode)!;
    document.getElementById("ws-mode-title")!.textContent = def.label;
    document.getElementById("ws-mode-blurb")!.textContent = def.blurb;
  }

  private renderMain(): void {
    const main = document.getElementById("ws-main");
    if (!main) {
      return;
    }
    main.replaceChildren();
    switch (this.mode) {
      case "board":
        main.appendChild(this.renderBoard());
        break;
      case "table":
        main.appendChild(this.renderTable());
        break;
      case "docs":
        main.appendChild(this.renderDocs());
        break;
      case "calendar":
        main.appendChild(this.renderCalendar());
        break;
      case "social":
        main.appendChild(this.renderSocial());
        break;
      case "ops":
        main.appendChild(this.renderOps());
        break;
      case "editor":
        main.appendChild(this.renderEditor());
        break;
      default:
        main.textContent = "Unknown mode";
    }
  }

  private renderBoard(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-board";
    const byStatus = new Map<string, WorkspaceItem[]>();
    for (const s of STATUS_ORDER) {
      byStatus.set(s, []);
    }
    for (const it of this.binder.items) {
      const st = it.status ?? "todo";
      const list = byStatus.get(st) ?? byStatus.get("todo")!;
      list.push(it);
    }
    for (const s of STATUS_ORDER) {
      const col = document.createElement("div");
      col.className = "ws-col";
      const h = document.createElement("h3");
      h.className = "ws-col__title";
      h.textContent = s;
      col.appendChild(h);
      for (const it of byStatus.get(s) ?? []) {
        col.appendChild(this.makeCard(it));
      }
      root.appendChild(col);
    }
    return root;
  }

  private makeCard(it: WorkspaceItem): HTMLButtonElement {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = "ws-card";
    const t = document.createElement("div");
    t.className = "ws-card__title";
    t.textContent = it.title;
    btn.appendChild(t);
    const meta = document.createElement("div");
    meta.className = "ws-card__meta";
    const parts: string[] = [];
    if (it.recordType) {
      parts.push(it.recordType);
    }
    if (it.dueAt) {
      parts.push(`due ${it.dueAt}`);
    }
    meta.textContent = parts.join(" · ");
    btn.appendChild(meta);
    btn.addEventListener("click", () => {
      this.selectItem(it.id);
      this.setDrawerOpen(true);
    });
    return btn;
  }

  private renderTable(): HTMLElement {
    const wrap = document.createElement("div");
    wrap.className = "ws-table-wrap";
    const table = document.createElement("table");
    table.className = "ws-table";
    const thead = document.createElement("thead");
    thead.innerHTML =
      "<tr><th>Title</th><th>Status</th><th>Due</th><th>Type</th><th>Campaign</th></tr>";
    table.appendChild(thead);
    const tbody = document.createElement("tbody");
    for (const it of this.binder.items) {
      const tr = document.createElement("tr");
      const tdTitle = document.createElement("td");
      const link = document.createElement("button");
      link.type = "button";
      link.textContent = it.title;
      link.addEventListener("click", () => {
        this.selectItem(it.id);
        this.setDrawerOpen(true);
      });
      tdTitle.appendChild(link);
      tr.appendChild(tdTitle);
      const tdSt = document.createElement("td");
      tdSt.textContent = it.status ?? "—";
      tr.appendChild(tdSt);
      const tdDue = document.createElement("td");
      tdDue.textContent = it.dueAt ?? it.scheduledAt ?? "—";
      tr.appendChild(tdDue);
      const tdType = document.createElement("td");
      tdType.textContent = it.recordType ?? "—";
      tr.appendChild(tdType);
      const tdCamp = document.createElement("td");
      tdCamp.textContent = it.campaignId ?? "—";
      tr.appendChild(tdCamp);
      tbody.appendChild(tr);
    }
    table.appendChild(tbody);
    wrap.appendChild(table);
    return wrap;
  }

  private renderDocs(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-docs";
    const ul = document.createElement("ul");
    ul.className = "ws-tree";
    const sel = this.selectedId;
    for (const it of this.binder.items) {
      const li = document.createElement("li");
      const btn = document.createElement("button");
      btn.type = "button";
      btn.textContent = it.title;
      btn.setAttribute("aria-current", it.id === sel ? "true" : "false");
      btn.addEventListener("click", () => this.selectItem(it.id));
      li.appendChild(btn);
      ul.appendChild(li);
    }
    const article = document.createElement("article");
    article.className = "ws-doc ws-md";
    const item = byId(this.binder.items, this.selectedId);
    if (item?.markdown) {
      article.innerHTML = formatBinderMarkdown(item.markdown);
    } else {
      article.innerHTML = "<p class=\"ws-md-empty\">Select an item with markdown.</p>";
    }
    root.append(ul, article);
    return root;
  }

  private renderCalendar(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-cal";
    const dates = new Map<string, WorkspaceItem[]>();
    for (const it of this.binder.items) {
      const d = it.dueAt ?? it.scheduledAt?.slice(0, 10);
      if (!d) {
        continue;
      }
      const list = dates.get(d) ?? [];
      list.push(it);
      dates.set(d, list);
    }
    const sorted = [...dates.keys()].sort();
    if (sorted.length === 0) {
      root.innerHTML = "<p class=\"ws-muted\">No dated items in this binder.</p>";
      return root;
    }
    for (const d of sorted) {
      const day = document.createElement("section");
      day.className = "ws-cal-day";
      const h = document.createElement("h3");
      h.className = "ws-cal-day__label";
      h.textContent = d;
      day.appendChild(h);
      for (const it of dates.get(d) ?? []) {
        const row = document.createElement("div");
        row.className = "ws-cal-item";
        const b = document.createElement("button");
        b.type = "button";
        b.className = "ws-btn ws-btn--ghost";
        b.style.padding = "0";
        b.style.border = "none";
        b.style.minWidth = "unset";
        b.textContent = it.title;
        b.addEventListener("click", () => {
          this.selectItem(it.id);
          this.setDrawerOpen(true);
        });
        const span = document.createElement("span");
        span.className = "ws-muted";
        span.textContent = it.scheduledAt
          ? `scheduled ${it.scheduledAt}`
          : it.dueAt
            ? `due ${it.dueAt}`
            : "";
        row.append(b, span);
        day.appendChild(row);
      }
      root.appendChild(day);
    }
    return root;
  }

  private renderSocial(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-social";
    const queue = this.binder.items.filter(
      (i) => i.postState || (i.platforms && i.platforms.length > 0),
    );
    if (queue.length === 0) {
      root.innerHTML = "<p class=\"ws-muted\">No social-scoped items.</p>";
      return root;
    }
    for (const it of queue) {
      const card = document.createElement("article");
      card.className = "ws-social-card";
      const head = document.createElement("div");
      head.style.display = "flex";
      head.style.flexWrap = "wrap";
      head.style.gap = "0.5rem";
      head.style.alignItems = "center";
      const titleBtn = document.createElement("button");
      titleBtn.type = "button";
      titleBtn.className = "ws-btn ws-btn--ghost";
      titleBtn.style.fontWeight = "600";
      titleBtn.style.color = "var(--ws-text)";
      titleBtn.textContent = it.title;
      titleBtn.addEventListener("click", () => {
        this.selectItem(it.id);
        this.setDrawerOpen(true);
      });
      const st = document.createElement("span");
      st.className = `ws-state ws-state--${it.postState ?? "draft"}`;
      st.textContent = it.postState ?? "draft";
      head.append(titleBtn, st);
      card.appendChild(head);
      if (it.summary) {
        const p = document.createElement("p");
        p.className = "ws-muted";
        p.style.margin = "0.35rem 0 0";
        p.textContent = it.summary;
        card.appendChild(p);
      }
      const chips = document.createElement("div");
      chips.className = "ws-chips";
      if (it.campaignId) {
        const c = document.createElement("span");
        c.className = "ws-chip";
        c.textContent = `campaign: ${it.campaignId}`;
        chips.appendChild(c);
      }
      for (const p of it.platforms ?? []) {
        const c = document.createElement("span");
        c.className = "ws-chip";
        c.textContent = p;
        chips.appendChild(c);
      }
      card.appendChild(chips);
      root.appendChild(card);
    }
    return root;
  }

  private renderOps(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-ops-grid";
    for (const it of this.binder.items) {
      const card = document.createElement("section");
      card.className = "ws-ops-card";
      const h = document.createElement("h3");
      const hb = document.createElement("button");
      hb.type = "button";
      hb.className = "ws-btn ws-btn--ghost";
      hb.style.padding = "0";
      hb.style.border = "none";
      hb.style.fontSize = "inherit";
      hb.style.fontWeight = "650";
      hb.style.color = "var(--ws-text)";
      hb.textContent = it.title;
      hb.addEventListener("click", () => {
        this.selectItem(it.id);
        this.setDrawerOpen(true);
      });
      h.appendChild(hb);
      card.appendChild(h);
      const fields = it.fields ?? {};
      for (const [k, v] of Object.entries(fields)) {
        const wrap = document.createElement("div");
        wrap.className = "ws-field";
        const lab = document.createElement("label");
        lab.htmlFor = `${it.id}-${k}`;
        lab.textContent = k;
        const inp = document.createElement("input");
        inp.id = `${it.id}-${k}`;
        inp.readOnly = true;
        inp.value = v;
        wrap.append(lab, inp);
        card.appendChild(wrap);
      }
      if (Object.keys(fields).length === 0) {
        const p = document.createElement("p");
        p.className = "ws-muted";
        p.textContent = "No fields on this record.";
        card.appendChild(p);
      }
      root.appendChild(card);
    }
    return root;
  }

  private renderEditor(): HTMLElement {
    const root = document.createElement("div");
    root.className = "ws-editor";
    const item = byId(this.binder.items, this.selectedId);
    const toolbar = document.createElement("div");
    toolbar.className = "ws-muted";
    toolbar.textContent = item
      ? `Editing: ${item.title} (demo is read-only; bind to core for persist)`
      : "Select an item in Docs or Table first.";
    const ta = document.createElement("textarea");
    ta.readOnly = true;
    ta.value = item?.markdown ?? "";
    ta.setAttribute("aria-label", "Markdown body");
    root.append(toolbar, ta);
    return root;
  }

  private renderDrawer(): void {
    const title = document.getElementById("ws-drawer-title");
    const body = document.getElementById("ws-drawer-body");
    if (!title || !body) {
      return;
    }
    const it = byId(this.binder.items, this.selectedId);
    if (!it) {
      title.textContent = "Detail";
      body.innerHTML = "<p class=\"ws-muted\">Nothing selected.</p>";
      return;
    }
    title.textContent = it.title;
    const dl = document.createElement("dl");
    dl.className = "ws-kv";
    const rows: [string, string][] = [
      ["id", it.id],
      ["status", it.status ?? "—"],
      ["recordType", it.recordType ?? "—"],
      ["dueAt", it.dueAt ?? "—"],
      ["scheduledAt", it.scheduledAt ?? "—"],
      ["campaignId", it.campaignId ?? "—"],
      ["postState", it.postState ?? "—"],
      ["platforms", (it.platforms ?? []).join(", ") || "—"],
      ["docSlug", it.docSlug ?? "—"],
    ];
    for (const [k, v] of rows) {
      const dt = document.createElement("dt");
      dt.textContent = k;
      const dd = document.createElement("dd");
      dd.textContent = v;
      dl.append(dt, dd);
    }
    body.replaceChildren(dl);
    if (it.summary) {
      const p = document.createElement("p");
      p.className = "ws-muted";
      p.textContent = it.summary;
      body.appendChild(p);
    }
    if (it.markdown) {
      const prev = document.createElement("div");
      prev.className = "ws-doc ws-md";
      prev.style.marginTop = "0.75rem";
      prev.innerHTML = formatBinderMarkdown(it.markdown);
      body.appendChild(prev);
    }
  }
}

function escapeHtmlMessage(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

async function bootstrap(): Promise<void> {
  const main = document.getElementById("ws-main");
  const source = createBinderSourceFromLocationSearch(window.location.search);
  try {
    const binder = await source.loadBinder();
    const app = new WorkspaceDemoApp(binder);
    app.mount();
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    if (main) {
      main.innerHTML = `<p class="ws-muted"><strong>Binder load failed.</strong> ${escapeHtmlMessage(msg)}</p><p class="ws-muted">Try <code>?binder=/demo-binder.json</code> (spine v1 when <code>schema_version</code> is set), <code>?binderLegacy=1</code> for legacy JSON, or omit <code>binder</code> for the bundled demo.</p>`;
    }
    console.error(err);
  }
}

void bootstrap();
