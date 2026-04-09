import { buildBinderOperatorSnapshot } from '$lib/operator/binder-operator-state';
import type { BinderSpinePayloadV1 } from '$lib/spine/binder-spine-v1';
import { validateBinderSpineV1Json } from '$lib/spine/binder-spine-v1';

/** Core-aligned spine v1 sample (Round A/B/C); validated at module load. */
export const binderSpinePayloadV1: BinderSpinePayloadV1 = {
  schema_version: '1',
  id: 'footloose-adelaide-launch',
  title: 'Footloose Adelaide Launch',
  items: [
    {
      id: 't1',
      title: 'Venue confirmation',
      recordType: 'task',
      status: 'todo',
      dueAt: '2026-04-03',
      owner: 'Ops'
    },
    {
      id: 't2',
      title: 'IG rollout',
      recordType: 'task',
      status: 'doing',
      dueAt: '2026-04-04',
      owner: 'Empire'
    },
    {
      id: 't3',
      title: 'Press calls',
      recordType: 'task',
      status: 'done',
      dueAt: '2026-04-01',
      owner: 'PR'
    },
    {
      id: 'doc-footloose',
      title: 'Campaign brief',
      recordType: 'doc',
      summary: 'Binder-first markdown workspace charter'
    }
  ]
};

validateBinderSpineV1Json(binderSpinePayloadV1);

/** Compile manifest + inspector: campaign profile (not spine root fields). */
export const binder = {
  id: binderSpinePayloadV1.id,
  title: binderSpinePayloadV1.title,
  type: 'campaign',
  status: 'active'
};

export const binderOperatorSnapshot = buildBinderOperatorSnapshot(binderSpinePayloadV1);

type TaskLane = 'todo' | 'doing' | 'done';

export const tasks = binderSpinePayloadV1.items
  .filter((i) => i.recordType === 'task')
  .map((i) => ({
    id: i.id,
    title: i.title,
    status: (i.status as TaskLane) ?? 'todo',
    owner: typeof i.owner === 'string' ? i.owner : '—',
    due: typeof i.dueAt === 'string' ? i.dueAt : '—'
  }));

export const locations = [
  { id: 'l1', name: 'Adelaide Festival Centre', layer: 'earth-australia', lat: -34.9205, lng: 138.6007 },
  { id: 'l2', name: 'Rundle Mall Activation', layer: 'earth-australia', lat: -34.9237, lng: 138.5999 }
];

export const compileManifest = `version: 1
binder:
  id: footloose-adelaide-launch
  type: campaign
  title: Footloose Adelaide Launch
compile:
  id: compile-footloose-dashboard
  target: dashboard
  provider: wizard
  status: draft
  template: campaign-dashboard
views:
  - id: summary
    kind: card-grid
  - id: task_board
    kind: kanban
  - id: route_map
    kind: map
`;

export const compileManifestObject = {
  version: 1,
  binder: {
    id: 'footloose-adelaide-launch',
    type: 'campaign',
    title: 'Footloose Adelaide Launch'
  },
  compile: {
    id: 'compile-footloose-dashboard',
    target: 'dashboard',
    provider: 'wizard',
    status: 'draft',
    template: 'campaign-dashboard'
  },
  views: [
    { id: 'summary', kind: 'card-grid', fields: ['title', 'status', 'next_milestone'] },
    { id: 'task_board', kind: 'kanban', fields: ['task_title', 'owner', 'stage', 'due_at'] },
    { id: 'route_map', kind: 'map', fields: ['location_name', 'lat', 'lng', 'layer'] }
  ]
};
