<script lang="ts">
  import { compileManifest, compileManifestObject } from '$lib/data/sample';
  import { validateCompileManifest } from '$lib/services/manifest';
  import { submitCompile, type WizardCompileDispatchResponse } from '$lib/services/wizard';

  let dispatch: WizardCompileDispatchResponse | null = null;
  let error = '';
  let loading = false;
  let executionBackend: 'native' | 'deerflow' = 'native';
  let executionMode: 'preview' | 'controlled' = 'preview';
  const validationErrors = validateCompileManifest(compileManifestObject);

  async function queueCompile() {
    loading = true;
    error = '';
    try {
      dispatch = await submitCompile({
        executionBackend,
        executionMode,
        manifest: compileManifestObject
      });
    } catch (err) {
      dispatch = null;
      error = err instanceof Error ? err.message : 'Unknown compile dispatch failure';
    } finally {
      loading = false;
    }
  }
</script>

<section class="panel">
  <h2>Compile</h2>
  <p>Budibase-inspired binder → app compiler surface.</p>
  <div class="controls">
    <label>
      Execution backend
      <select bind:value={executionBackend}>
        <option value="native">Native</option>
        <option value="deerflow">Deer Flow</option>
      </select>
    </label>
    <label>
      Execution mode
      <select bind:value={executionMode} disabled={executionBackend === 'native'}>
        <option value="preview">Preview</option>
        <option value="controlled">Controlled</option>
      </select>
    </label>
    <button on:click={queueCompile} disabled={loading}>
      {#if loading}Queueing…{:else}Queue Compile{/if}
    </button>
  </div>
  {#if dispatch}
    <div class="dispatch">
      <strong>Wizard dispatch recorded</strong>
      <p>ID: {dispatch.dispatch_id}</p>
      <p>Backend: {dispatch.execution_backend}</p>
      <p>Mode: {dispatch.execution_mode}</p>
      <p>Executor: {dispatch.executor}</p>
      <p>Status: {dispatch.status}</p>
      {#if dispatch.graph_preview}
        <p>Graph preview: ready</p>
      {/if}
    </div>
  {/if}
  {#if error}
    <div class="error">{error}</div>
  {/if}
  {#if validationErrors.length > 0}
    <div class="error">
      <strong>Manifest errors</strong>
      <ul>
        {#each validationErrors as validationError}
          <li>{validationError}</li>
        {/each}
      </ul>
    </div>
  {/if}
  {#if dispatch?.workflow_preview}
    <div class="dispatch">
      <strong>Workflow Preview</strong>
      <pre>{JSON.stringify(dispatch.workflow_preview, null, 2)}</pre>
    </div>
  {/if}
  {#if dispatch?.graph_preview}
    <div class="dispatch">
      <strong>Deer Flow Graph Preview</strong>
      <pre>{JSON.stringify(dispatch.graph_preview, null, 2)}</pre>
    </div>
  {/if}
  {#if dispatch?.result_preview}
    <div class="dispatch">
      <strong>Execution Result</strong>
      <pre>{JSON.stringify(dispatch.result_preview, null, 2)}</pre>
    </div>
  {/if}
  {#if dispatch?.execution_result}
    <div class="dispatch">
      <strong>Native Execution Result</strong>
      <pre>{JSON.stringify(dispatch.execution_result, null, 2)}</pre>
    </div>
  {/if}
  <pre>{compileManifest}</pre>
</section>

<style>
  .panel {
    border: 1px solid var(--ws-border);
    border-radius: 16px;
    padding: 18px;
    background: var(--ws-panel);
    box-shadow: var(--ws-shadow);
  }
  .controls {
    display: flex;
    gap: 12px;
    align-items: end;
    margin-bottom: 16px;
  }
  label {
    display: flex;
    flex-direction: column;
    gap: 6px;
    color: var(--ws-fg-muted);
    font-size: 14px;
  }
  select, button {
    border: 1px solid var(--ws-border);
    border-radius: 10px;
    background: var(--ws-input-bg);
    color: var(--ws-fg);
    padding: 10px 12px;
  }
  button {
    cursor: pointer;
    background: linear-gradient(135deg, var(--ws-accent) 0%, var(--ws-accent-end) 100%);
    color: var(--ws-panel);
    border-color: var(--ws-border-strong);
  }
  button:disabled {
    cursor: progress;
    opacity: 0.7;
  }
  .dispatch, .error {
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    margin-bottom: 16px;
    background: var(--ws-panel-deep);
  }
  .error {
    border-color: var(--ws-error);
    color: var(--ws-error);
    background: var(--ws-error-bg);
  }
  pre {
    white-space: pre-wrap;
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-card);
    overflow: auto;
    color: var(--ws-fg);
  }
</style>
