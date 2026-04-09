<script lang="ts">
  import { binder } from '$lib/data/sample';
  import type { BinderOperatorSnapshot } from '$lib/operator/binder-operator-state';
  import type { CompileResultEntry, PublishQueueEntry } from '$lib/services/wizard-state';

  export let compileResults: CompileResultEntry[] = [];
  export let publishQueue: PublishQueueEntry[] = [];
  export let binderOperator: BinderOperatorSnapshot;

  $: lastCompile = compileResults[0];
  $: spineTypes = Object.entries(binderOperator.recordTypes)
    .map(([k, v]) => `${k}:${v}`)
    .join(', ');
</script>

<section class="inspector">
  <h3>Inspector</h3>
  <div class="card">
    <strong>{binder.title}</strong>
    <p>Type: {binder.type}</p>
    <p>Status: {binder.status}</p>
  </div>
  <div class="card">
    <strong>Binder spine (v1)</strong>
    <p>schema_version: {binderOperator.schemaVersion}</p>
    <p>Items: {binderOperator.itemCount}</p>
    <p class="muted">recordTypes: {spineTypes || '—'}</p>
    <p class="muted">Source: {binderOperator.source} (Core owns canonical truth)</p>
  </div>
  <div class="card">
    <strong>Compile status</strong>
    <p>Runs: {compileResults.length}</p>
    <p>Latest: {lastCompile?.status ?? 'not-run'}</p>
    <p>Backend: {lastCompile?.result?.execution_backend ?? 'native'}</p>
    <p>Mode: {lastCompile?.result?.execution_mode ?? 'preview'}</p>
  </div>
  <div class="card">
    <strong>Publish queue</strong>
    <p>Queued items: {publishQueue.length}</p>
    {#if publishQueue[0]}
      <p>Next channel: {publishQueue[0].channel}</p>
      <p>Next status: {publishQueue[0].status}</p>
    {/if}
  </div>
  <div class="card">
    <strong>Quick actions</strong>
    <ul>
      <li>Open linked publish queue</li>
      <li>Inspect locations</li>
      <li>Run compile handoff</li>
    </ul>
  </div>
</section>

<style>
  .inspector { padding: 16px; }
  .card {
    border: 1px solid var(--ws-border);
    border-radius: 14px;
    padding: 12px;
    margin-bottom: 12px;
    background: var(--ws-card);
    box-shadow: var(--ws-shadow);
  }
  h3 { margin-top: 0; }
  ul { margin: 8px 0 0 18px; }
  .muted {
    color: var(--ws-fg-muted);
    font-size: 12px;
    line-height: 1.35;
  }
</style>
