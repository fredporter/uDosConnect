const statusTokens = {
  todo: "TODO",
  active: "LIVE",
  blocked: "HOLD",
  done: "DONE",
};

export function buildWorkflowBoard({ title, lanes }) {
  return {
    title,
    lanes: lanes.map((lane) => ({
      id: lane.id,
      title: lane.title,
      tasks: lane.tasks.map((task) => ({
        id: task.id,
        title: task.title,
        status: task.status,
        statusLabel: statusTokens[task.status] ?? "INFO",
        summary: task.summary ?? "",
      })),
    })),
  };
}

export function buildWorkflowBoardFromGtxForm(formPrototype, options = {}) {
  const laneId = options.laneId ?? "setup";
  const laneTitle = options.laneTitle ?? "Setup";
  const taskPrefix = options.taskPrefix ?? "gtx";

  return buildWorkflowBoard({
    title: options.title ?? `${formPrototype.title} workflow`,
    lanes: [
      {
        id: laneId,
        title: laneTitle,
        tasks: (formPrototype.steps ?? []).map((step) => ({
          id: `${taskPrefix}-${step.id}`,
          title: step.prompt ?? step.id,
          status: "todo",
          summary: `gtx_step_id=${step.id}`,
        })),
      },
    ],
  });
}

export function renderWorkflowText(board) {
  const lines = [`Workflow: ${board.title}`];
  for (const lane of board.lanes) {
    lines.push(``);
    lines.push(`# ${lane.title}`);
    for (const task of lane.tasks) {
      lines.push(`- ${task.statusLabel} ${task.title}`);
      if (task.summary) {
        lines.push(`  ${task.summary}`);
      }
    }
  }
  return lines;
}
