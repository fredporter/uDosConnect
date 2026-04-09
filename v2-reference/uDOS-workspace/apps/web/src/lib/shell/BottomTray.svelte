<script lang="ts">
  export let compileStatus = 'draft';
  export let wizardStatus = 'idle';
  export let publishCount = 0;
  export let mapLayer = 'earth-australia';
</script>

<footer class="tray">
  <span>Compile: {compileStatus}</span>
  <span>Wizard: {wizardStatus}</span>
  <span>Empire queue: {publishCount} scheduled</span>
  <span>Map layer: {mapLayer}</span>
</footer>

<style>
  .tray {
    display: flex;
    gap: 16px;
    align-items: center;
    padding: 0 16px;
    border-top: 1px solid var(--ws-border);
    background: var(--ws-tray-glass);
    color: var(--ws-fg-muted);
    font-size: 13px;
    backdrop-filter: blur(10px);
  }
</style>
