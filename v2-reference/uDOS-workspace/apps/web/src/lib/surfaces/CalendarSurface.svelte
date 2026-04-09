<script lang="ts">
  import { tasks } from '$lib/data/sample';
</script>

<section class="panel">
  <h2>Calendar</h2>
  <p>Editorial, milestone, and task schedule derived from binder task deadlines.</p>
  <div class="list">
    {#each [...tasks].sort((left, right) => left.due.localeCompare(right.due)) as task}
      <article class="card">
        <strong>{task.due}</strong>
        <p>{task.title}</p>
        <small>{task.owner} · {task.status}</small>
      </article>
    {/each}
  </div>
</section>

<style>
  .panel {
    border: 1px solid var(--ws-border);
    border-radius: 16px;
    padding: 18px;
    background: var(--ws-panel);
    box-shadow: var(--ws-shadow);
  }
  .list { display: grid; gap: 10px; }
  .card {
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-card);
  }
  h2 { margin-top: 0; }
</style>
