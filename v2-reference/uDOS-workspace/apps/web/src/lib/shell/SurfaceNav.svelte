<script lang="ts">
  export let surfaces: readonly string[] = [];
  export let active = 'docs';
  export let onSelect: (id: string) => void = () => {};
</script>

<nav class="nav">
  <div class="binder">#binder</div>
  {#each surfaces as surface}
    <button class:active={surface === active} on:click={() => onSelect(surface)}>
      {surface}
    </button>
  {/each}
</nav>

<style>
  .nav { display: flex; flex-direction: column; gap: 8px; padding: 16px; }
  .binder {
    margin-bottom: 8px;
    color: var(--ws-fg-muted);
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: .08em;
  }
  button {
    text-align: left;
    border: 1px solid var(--ws-border);
    background: var(--ws-card);
    color: var(--ws-fg);
    border-radius: 12px;
    padding: 10px 12px;
    cursor: pointer;
    text-transform: capitalize;
    transition: background 120ms ease, border-color 120ms ease, transform 120ms ease;
  }
  button:hover {
    background: var(--ws-panel);
    border-color: var(--ws-accent);
    transform: translateY(-1px);
  }
  button.active {
    background: linear-gradient(135deg, var(--ws-accent) 0%, var(--ws-accent-end) 100%);
    border-color: var(--ws-border-strong);
    color: var(--ws-panel);
  }
</style>
