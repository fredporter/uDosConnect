const inMemoryCache = new Map<string, string>();

export function buildCacheKey(input: string, requestClass: string): string {
  return `${requestClass}:${input.trim().toLowerCase()}`;
}

export function getCached(key: string): string | undefined {
  return inMemoryCache.get(key);
}

export function setCached(key: string, value: string): void {
  inMemoryCache.set(key, value);
}
