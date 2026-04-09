export interface CompileManifest {
  version: number;
  binder: { id: string; type: string; title: string };
  compile: {
    id: string;
    target: string;
    provider: 'wizard';
    status: 'draft' | 'queued' | 'compiled';
    template?: string;
  };
  views: Array<{ id: string; kind: string; fields?: string[] }>;
}

export function validateCompileManifest(manifest: unknown): string[] {
  const errors: string[] = [];

  if (!manifest || typeof manifest !== 'object') {
    return ['manifest must be an object'];
  }

  const candidate = manifest as Partial<CompileManifest>;

  if (candidate.version !== 1) {
    errors.push('version must be 1');
  }
  if (!candidate.binder?.id) {
    errors.push('binder.id is required');
  }
  if (!candidate.binder?.type) {
    errors.push('binder.type is required');
  }
  if (!candidate.binder?.title) {
    errors.push('binder.title is required');
  }
  if (!candidate.compile?.id) {
    errors.push('compile.id is required');
  }
  if (!candidate.compile?.target) {
    errors.push('compile.target is required');
  }
  if (candidate.compile?.provider !== 'wizard') {
    errors.push('compile.provider must be wizard');
  }
  if (!candidate.compile?.status) {
    errors.push('compile.status is required');
  } else if (!['draft', 'queued', 'compiled'].includes(candidate.compile.status)) {
    errors.push('compile.status must be draft, queued, or compiled');
  }
  if (!Array.isArray(candidate.views) || candidate.views.length === 0) {
    errors.push('views must contain at least one entry');
  } else {
    candidate.views.forEach((view, index) => {
      if (!view?.id) {
        errors.push(`views[${index}].id is required`);
      }
      if (!view?.kind) {
        errors.push(`views[${index}].kind is required`);
      }
      if (view?.fields && !Array.isArray(view.fields)) {
        errors.push(`views[${index}].fields must be an array when present`);
      }
    });
  }

  return errors;
}
