export interface BinderRef {
  id: string;
  type: string;
  title: string;
  status?: string;
}

export interface WorkspaceSurface {
  id: string;
  label: string;
  provider: 'workspace' | 'empire' | 'wizard';
}
