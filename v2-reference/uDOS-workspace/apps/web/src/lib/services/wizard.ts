import { validateCompileManifest } from '$lib/services/manifest';

export interface WizardCompileDispatchRequest {
  executionBackend?: 'native' | 'deerflow';
  executionMode?: 'preview' | 'controlled';
  manifest: unknown;
}

export interface WizardCompileDispatchResponse {
  dispatch_version: string;
  dispatch_id: string;
  binder_id: string;
  compile_id: string;
  target: string;
  provider: string;
  execution_backend: 'native' | 'deerflow';
  execution_mode: 'preview' | 'controlled';
  executor: string;
  transport: string;
  status: string;
  manifest: unknown;
  execution_result?: unknown;
  workflow_preview?: unknown;
  graph_preview?: unknown;
  result_preview?: unknown;
  pin_status?: unknown;
}

const DEFAULT_WIZARD_URL = 'http://127.0.0.1:8787';

export async function submitCompile(
  request: WizardCompileDispatchRequest,
  wizardUrl = DEFAULT_WIZARD_URL
): Promise<WizardCompileDispatchResponse> {
  const errors = validateCompileManifest(request.manifest);
  if (errors.length > 0) {
    throw new Error(`Compile manifest validation failed: ${errors.join('; ')}`);
  }

  const response = await fetch(`${wizardUrl}/compile/dispatch`, {
    method: 'POST',
    headers: {
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      execution_backend: request.executionBackend ?? 'native',
      execution_mode: request.executionMode ?? 'preview',
      manifest: request.manifest
    })
  });

  if (!response.ok) {
    const details = await response.text();
    throw new Error(`Wizard compile dispatch failed: ${response.status} ${details}`.trim());
  }

  return (await response.json()) as WizardCompileDispatchResponse;
}
