export type WorkflowStep = {
  id: string;
  kind?: string;
  label?: string;
  dependsOn?: string[];
  config?: Record<string, unknown>;
};

export type Workflow = {
  workflowId: string;
  steps: WorkflowStep[];
  policy?: Record<string, unknown>;
};

export function buildGraph(workflow: Workflow) {
  const nodes = workflow.steps.map((step) => ({
    id: step.id,
    kind: step.kind ?? "task",
    label: step.label ?? step.id,
    config: step.config ?? {},
  }));

  const edges = workflow.steps.flatMap((step) =>
    (step.dependsOn ?? []).map((dep) => ({ from: dep, to: step.id }))
  );

  return {
    translationVersion: "0.1.0",
    workflowId: workflow.workflowId,
    nodes,
    edges,
    policy: workflow.policy ?? {
      trustClass: "local-wrapped",
      networkProfile: "offline",
      filesystemProfile: "staged-output-only",
    },
  };
}
