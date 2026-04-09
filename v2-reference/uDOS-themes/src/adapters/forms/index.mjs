import { createGtxFormPrototype } from "./gtx-form-prototype.mjs";

export { createGtxFormPrototype };

export function getFormStep(form, stepIndex) {
  const step = form.steps[stepIndex];
  return {
    ...step,
    progress: {
      current: stepIndex + 1,
      total: form.steps.length,
    },
  };
}

export function renderBrowserFormStep(form, stepIndex) {
  const step = getFormStep(form, stepIndex);
  const choices = (step.choices ?? [])
    .map((choice) => `<button class="udos-choice">${escapeHtml(choice)}</button>`)
    .join("");
  return `
    <section class="udos-form-step prose">
      <p class="udos-step-count">${step.progress.current}/${step.progress.total}</p>
      <h1>${escapeHtml(step.prompt)}</h1>
      ${step.type === "choice-grid" ? `<div class="udos-choice-grid">${choices}</div>` : `<input placeholder="${escapeHtml(step.placeholder ?? "")}" />`}
    </section>`;
}

export function renderThinUiFormStep(form, stepIndex) {
  const step = getFormStep(form, stepIndex);
  return {
    title: form.title,
    subtitle: `${step.progress.current}/${step.progress.total}`,
    lines: [
      `> ${step.prompt}`,
      step.placeholder ? `  ${step.placeholder}` : "",
      ...(step.choices ?? []).map((choice, index) => `  ${index + 1}. ${choice}`),
    ].filter(Boolean),
  };
}

export function renderTuiFormStep(form, stepIndex) {
  const step = getFormStep(form, stepIndex);
  return [
    `${form.title} (${step.progress.current}/${step.progress.total})`,
    "",
    step.prompt,
    ...(step.choices ?? []).map((choice, index) => `${index + 1}. ${choice}`),
    step.placeholder ? `> ${step.placeholder}` : ">",
  ];
}

export function submitForm(form, answers) {
  return {
    formId: form.id,
    completed: form.steps.every((step) => answers[step.id]),
    answers,
  };
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}
