<script lang="ts">
  import type { PublishQueueEntry } from '$lib/services/wizard-state';

  export let queue: PublishQueueEntry[] = [];
</script>

<section class="panel">
  <h2>Publish</h2>
  <p>Empire-owned social scheduling panel driven by Wizard compile outputs.</p>
  {#if queue.length === 0}
    <p>No scheduled publish items yet.</p>
  {:else}
    <div class="list">
      {#each queue as item}
        <article class="card">
          <strong>{item.publish_id}</strong>
          <p>Binder: {item.binder_id}</p>
          <p>Compile: {item.compile_id}</p>
          <p>Backend: {item.execution_backend}</p>
          <p>Mode: {item.execution_mode}</p>
          <p>Status: {item.status}</p>
          <p>Channel: {item.channel}</p>
        </article>
      {/each}
    </div>
  {/if}
</section>

<style>
  .panel {
    border: 1px solid var(--ws-border);
    border-radius: 16px;
    padding: 18px;
    background: var(--ws-panel);
    box-shadow: var(--ws-shadow);
  }
  .list { display: grid; gap: 12px; }
  .card {
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-card);
  }
  h2 { margin-top: 0; }
</style>
