<script lang="ts">
  import { locations } from '$lib/data/sample';
</script>

<section class="panel">
  <h2>Map</h2>
  <p>Spatial layer view consuming binder location records.</p>
  <div class="grid">
    {#each locations as location}
      <article class="card">
        <strong>{location.name}</strong>
        <p>{location.layer}</p>
        <small>{location.lat}, {location.lng}</small>
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
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; }
  .card {
    border: 1px solid var(--ws-border);
    border-radius: 12px;
    padding: 12px;
    background: var(--ws-card);
  }
</style>
