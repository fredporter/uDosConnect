<script lang="ts">
  import { browser } from '$app/environment';
  import { onMount } from 'svelte';
  import { binder, binderOperatorSnapshot } from '$lib/data/sample';
  import { workspaceShellCssVars } from '$lib/theme/browserDefaultShell';

  if (browser) {
    for (const [key, value] of Object.entries(workspaceShellCssVars)) {
      document.documentElement.style.setProperty(key, value);
    }
  }
  import {
    fetchCompileResults,
    fetchOrchestrationStatus,
    fetchPublishQueue,
    type CompileResultEntry,
    type PublishQueueEntry
  } from '$lib/services/wizard-state';
  import SurfaceNav from '$lib/shell/SurfaceNav.svelte';
  import Inspector from '$lib/shell/Inspector.svelte';
  import BottomTray from '$lib/shell/BottomTray.svelte';
  import DocsSurface from '$lib/surfaces/DocsSurface.svelte';
  import TasksSurface from '$lib/surfaces/TasksSurface.svelte';
  import CalendarSurface from '$lib/surfaces/CalendarSurface.svelte';
  import MapSurface from '$lib/surfaces/MapSurface.svelte';
  import PublishSurface from '$lib/surfaces/PublishSurface.svelte';
  import CompileSurface from '$lib/surfaces/CompileSurface.svelte';

  const surfaces = ['overview', 'docs', 'tasks', 'calendar', 'map', 'publish', 'compile', 'history'] as const;
  let active: string = 'docs';
  let compileResults: CompileResultEntry[] = [];
  let publishQueue: PublishQueueEntry[] = [];
  let wizardStatus = 'loading';
  let compileStatus = 'draft';
  let syncError = '';

  function selectSurface(id: string) {
    active = id;
  }

  async function syncWizardState() {
    try {
      const [status, compileData, publishData] = await Promise.all([
        fetchOrchestrationStatus(),
        fetchCompileResults(),
        fetchPublishQueue()
      ]);
      compileResults = compileData.results;
      publishQueue = publishData.queue;
      wizardStatus = status.services.length > 0 ? 'ready' : 'idle';
      compileStatus = compileResults[0]?.status ?? 'draft';
      syncError = '';
    } catch (error) {
      wizardStatus = 'offline';
      syncError = error instanceof Error ? error.message : 'Wizard sync failed';
    }
  }

  onMount(() => {
    void syncWizardState();
    const interval = window.setInterval(() => {
      void syncWizardState();
    }, 5000);
    return () => window.clearInterval(interval);
  });
</script>

<svelte:head>
  <title>{binder.title} — uDOS Workspace</title>
</svelte:head>

<div class="workspace">
  <header class="topbar">
    <div class="brand">
      <span class="brand-mark">uw</span>
      <span>uDOS-workspace</span>
    </div>
    <div class="title">
      <span class="eyebrow">binder workspace</span>
      <span>{binder.title}</span>
    </div>
    <div class="actions">
      spine v{binderOperatorSnapshot.schemaVersion} · {binderOperatorSnapshot.itemCount} items · {compileStatus} · wizard {wizardStatus}
    </div>
  </header>

  <div class="body">
    <aside class="left">
      <SurfaceNav {surfaces} {active} onSelect={selectSurface} />
    </aside>

    <main class="main">
      {#if active === 'docs' || active === 'overview'}
        <DocsSurface />
      {:else if active === 'tasks'}
        <TasksSurface />
      {:else if active === 'calendar'}
        <CalendarSurface />
      {:else if active === 'map'}
        <MapSurface />
      {:else if active === 'publish'}
        <PublishSurface queue={publishQueue} />
      {:else if active === 'compile'}
        <CompileSurface />
      {:else}
        <section class="panel">
          <h2>History</h2>
          {#if compileResults.length === 0}
            <p>No compile runs recorded yet.</p>
          {:else}
            <div class="history">
              {#each compileResults as result}
                <article class="history-card">
                  <strong>{result.dispatch_id}</strong>
                  <p>Status: {result.status}</p>
                  <p>Backend: {result.result.execution_backend ?? 'native'}</p>
                  <p>Mode: {result.result.execution_mode ?? 'preview'}</p>
                  <p>Artifacts: {result.result.execution_result?.summary?.artifactsProduced ?? 0}</p>
                </article>
              {/each}
            </div>
          {/if}
        </section>
      {/if}
      {#if syncError}
        <section class="panel error">
          <h2>Wizard Sync</h2>
          <p>{syncError}</p>
        </section>
      {/if}
    </main>

    <aside class="right">
      <Inspector {compileResults} {publishQueue} binderOperator={binderOperatorSnapshot} />
    </aside>
  </div>

  <BottomTray {compileStatus} {wizardStatus} publishCount={publishQueue.length} mapLayer="earth-australia" />
</div>

<style>
  :global(html) {
    color-scheme: light;
  }

  :global(body) {
    margin: 0;
    font-family: "Avenir Next", "Segoe UI", sans-serif;
    background:
      radial-gradient(circle at top, var(--ws-accent-soft), transparent 32%),
      linear-gradient(180deg, var(--ws-bg) 0%, var(--ws-panel-deep) 55%, var(--ws-bg) 100%);
    color: var(--ws-fg);
  }
  .workspace {
    min-height: 100vh;
    display: grid;
    grid-template-rows: 64px 1fr 40px;
  }
  .topbar {
    display: grid;
    grid-template-columns: 220px 1fr 220px;
    align-items: center;
    padding: 0 18px;
    border-bottom: 1px solid var(--ws-border);
    background: var(--ws-topbar-glass);
    backdrop-filter: blur(10px);
    box-shadow: var(--ws-shadow);
  }
  .brand {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 700;
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }
  .brand-mark {
    display: inline-grid;
    place-items: center;
    width: 34px;
    height: 34px;
    border-radius: 11px;
    background: linear-gradient(135deg, var(--ws-accent) 0%, var(--ws-accent-end) 100%);
    color: var(--ws-panel);
    font-family: "IBM Plex Mono", "SFMono-Regular", monospace;
    font-size: 13px;
  }
  .title {
    display: flex;
    flex-direction: column;
    text-align: center;
    gap: 3px;
    font-weight: 600;
  }
  .eyebrow {
    color: var(--ws-fg-muted);
    font-size: 11px;
    letter-spacing: 0.16em;
    text-transform: uppercase;
  }
  .actions {
    text-align: right;
    color: var(--ws-fg-muted);
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 0.08em;
  }
  .body {
    display: grid;
    grid-template-columns: 220px 1fr 300px;
    min-height: 0;
  }
  .left, .right {
    background: var(--ws-sidebar-glass);
    border-right: 1px solid var(--ws-border);
    backdrop-filter: blur(8px);
  }
  .right {
    border-right: 0;
    border-left: 1px solid var(--ws-border);
  }
  .main {
    padding: 18px;
    overflow: auto;
  }
  .panel {
    border: 1px solid var(--ws-border);
    border-radius: 16px;
    padding: 18px;
    background: var(--ws-panel);
    box-shadow: var(--ws-shadow);
  }
  .history {
    display: grid;
    gap: 12px;
  }
  .history-card {
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-card);
  }
  .error {
    margin-top: 16px;
    border-color: var(--ws-error);
    color: var(--ws-error);
    background: var(--ws-error-bg);
  }
  @media (max-width: 960px) {
    .body { grid-template-columns: 180px 1fr; }
    .right { display: none; }
  }
</style>
