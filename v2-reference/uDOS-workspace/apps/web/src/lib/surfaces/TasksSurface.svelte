<script lang="ts">
  import { tasks } from '$lib/data/sample';
</script>

<section class="panel">
  <h2>Tasks</h2>
  <div class="board">
    {#each ['todo', 'doing', 'done'] as lane}
      <div class="lane">
        <h3>{lane}</h3>
        {#each tasks.filter((task) => task.status === lane) as task}
          <article class="card">
            <strong>{task.title}</strong>
            <div>{task.owner}</div>
            <small>{task.due}</small>
          </article>
        {/each}
      </div>
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
  .board { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
  .lane {
    border: 1px dashed var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-panel-deep);
  }
  .card {
    border: 1px solid var(--ws-border);
    border-radius: 10px;
    padding: 10px;
    background: var(--ws-card);
    margin-bottom: 10px;
  }
</style>
