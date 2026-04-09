export interface OrchestrationStatus {
  services: Array<{ service: string; executor: string; transport: string }>;
  execution_backends: Array<{ backend_id: string; label: string; optional: boolean; owner: string; executor: string }>;
}

export interface CompileResultEntry {
  dispatch_id: string;
  status: string;
  result: {
    binder_id?: string;
    compile_id?: string;
    execution_backend?: 'native' | 'deerflow';
    execution_mode?: 'preview' | 'controlled';
    execution_result?: {
      status?: string;
      summary?: { completed?: number; failed?: number; artifactsProduced?: number; message?: string };
      artifacts?: Array<{ kind?: string; path?: string; label?: string }>;
    };
  };
}

export interface PublishQueueEntry {
  publish_id: string;
  binder_id: string;
  compile_id: string;
  execution_backend: 'native' | 'deerflow';
  execution_mode: 'preview' | 'controlled';
  status: string;
  channel: string;
  dispatch_id: string;
}

const DEFAULT_WIZARD_URL = 'http://127.0.0.1:8787';

async function fetchJson<T>(path: string, wizardUrl = DEFAULT_WIZARD_URL): Promise<T> {
  const response = await fetch(`${wizardUrl}${path}`);
  if (!response.ok) {
    throw new Error(`Wizard request failed: ${response.status}`);
  }
  return (await response.json()) as T;
}

export async function fetchOrchestrationStatus(wizardUrl = DEFAULT_WIZARD_URL): Promise<OrchestrationStatus> {
  return fetchJson<OrchestrationStatus>('/orchestration/status', wizardUrl);
}

export async function fetchCompileResults(
  wizardUrl = DEFAULT_WIZARD_URL
): Promise<{ count: number; results: CompileResultEntry[] }> {
  return fetchJson<{ count: number; results: CompileResultEntry[] }>('/compile/results', wizardUrl);
}

export async function fetchPublishQueue(
  wizardUrl = DEFAULT_WIZARD_URL
): Promise<{ count: number; queue: PublishQueueEntry[] }> {
  return fetchJson<{ count: number; queue: PublishQueueEntry[] }>('/publish/queue', wizardUrl);
}
