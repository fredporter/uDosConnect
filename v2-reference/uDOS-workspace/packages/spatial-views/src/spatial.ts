export interface Layer {
  id: string;
  type: 'physical' | 'virtual' | 'network' | 'orbital';
  projection: 'web-mercator' | 'grid';
}

export interface SpatialLocation {
  id: string;
  layerId: string;
  lat?: number;
  lng?: number;
  x?: number;
  y?: number;
}
