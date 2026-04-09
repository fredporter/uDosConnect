export interface TaskRecord {
  id: string;
  title: string;
  stage: string;
  owner?: string;
  dueAt?: string;
  locationId?: string;
  publishState?: string;
}
