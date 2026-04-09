import type { ThinUiMode, ThinUiSurfaceContext } from "../contracts/state";

/**
 * Subset of uDOS-surface profile JSON (see profiles tree) consumed by ThinUI at runtime.
 * Keep in sync with uDOS-surface/profiles/ubuntu-gnome/surface.json.
 */
export class SurfaceProfileValidationError extends Error {
  readonly issues: string[];

  constructor(message: string, issues: string[]) {
    super(message);
    this.name = "SurfaceProfileValidationError";
    this.issues = issues;
  }
}

export type SurfaceProfileThinUiV01 = {
  id: string;
  schemaVersion?: string;
  layout: string;
  navigation: string;
  input: string[];
  modes: Array<"windowed" | "fullscreen">;
  thinui: {
    density: string;
    theme: string;
    components: string[];
  };
  session: {
    multiWindow: boolean;
    restoreState: boolean;
  };
};

/** Canonical ubuntu-gnome profile (mirror of uDOS-surface JSON). */
export const UBUNTU_GNOME_SURFACE_PROFILE: SurfaceProfileThinUiV01 = {
  id: "ubuntu-gnome",
  schemaVersion: "0.1",
  layout: "split",
  navigation: "panel",
  input: ["keyboard", "controller"],
  modes: ["windowed", "fullscreen"],
  thinui: {
    density: "comfortable",
    theme: "udos-default",
    components: ["panel", "list", "command"],
  },
  session: {
    multiWindow: true,
    restoreState: true,
  },
};

function defaultBootMode(profile: SurfaceProfileThinUiV01): ThinUiMode {
  if (profile.modes.includes("windowed")) {
    return "windowed";
  }
  return profile.modes[0] ?? "fullscreen";
}

/** Maps surface profile `thinui.theme` string to ThinUI resolver theme id. */
export function surfaceThemeToThinUiThemeId(surfaceThemeId: string): string {
  if (surfaceThemeId === "udos-default") {
    return "udos-default";
  }
  return surfaceThemeId;
}

/**
 * Maps a surface profile into ThinUI seed state + surface context.
 * Does not set view/title; caller merges with other seed fields.
 */
export function thinUiSeedFromSurfaceProfile(
  profile: SurfaceProfileThinUiV01,
): {
  seed: {
    mode: ThinUiMode;
    themeId: string;
    surface: ThinUiSurfaceContext;
  };
} {
  const bootMode = defaultBootMode(profile);
  const homeMode: ThinUiMode = profile.modes.includes("windowed")
    ? "windowed"
    : bootMode;
  const themeId = surfaceThemeToThinUiThemeId(profile.thinui.theme);

  return {
    seed: {
      mode: bootMode,
      themeId,
      surface: {
        profileId: profile.id,
        layout: profile.layout,
        navigation: profile.navigation,
        homeMode,
        thinuiTheme: profile.thinui.theme,
        density: profile.thinui.density,
      },
    },
  };
}

export function resolveBuiltinSurfaceProfile(id: string): SurfaceProfileThinUiV01 | undefined {
  if (id === "ubuntu-gnome") {
    return UBUNTU_GNOME_SURFACE_PROFILE;
  }
  return undefined;
}

const VALID_SURFACE_MODES = new Set<"windowed" | "fullscreen">(["windowed", "fullscreen"]);

/**
 * Parse and validate JSON (e.g. from uDOS-surface/profiles/.../surface.json).
 * Throws {@link SurfaceProfileValidationError} when shape is invalid.
 */
export function parseSurfaceProfileThinUiV01FromJson(data: unknown): SurfaceProfileThinUiV01 {
  const issues: string[] = [];
  if (!data || typeof data !== "object") {
    throw new SurfaceProfileValidationError("surface profile root must be an object", [
      "root must be an object",
    ]);
  }
  const o = data as Record<string, unknown>;
  const need = (key: string) => {
    if (!(key in o)) {
      issues.push(`missing required key '${key}'`);
    }
  };
  for (const key of ["id", "layout", "navigation", "input", "modes", "thinui", "session"] as const) {
    need(key);
  }
  if (issues.length) {
    throw new SurfaceProfileValidationError("invalid surface profile", issues);
  }

  if (!Array.isArray(o.input) || !o.input.length || !o.input.every((x) => typeof x === "string")) {
    issues.push("'input' must be a non-empty string array");
  }
  if (!Array.isArray(o.modes) || !o.modes.length) {
    issues.push("'modes' must be a non-empty array");
  } else {
    for (const m of o.modes) {
      if (m !== "windowed" && m !== "fullscreen") {
        issues.push(`invalid mode '${String(m)}' (expected windowed|fullscreen)`);
      }
    }
  }
  const tu = o.thinui;
  if (!tu || typeof tu !== "object") {
    issues.push("'thinui' must be an object");
  } else {
    const t = tu as Record<string, unknown>;
    for (const key of ["density", "theme", "components"] as const) {
      if (!(key in t)) {
        issues.push(`thinui missing '${key}'`);
      }
    }
    if (Array.isArray(t.components) && t.components.length === 0) {
      issues.push("thinui.components must be non-empty");
    }
  }
  const sess = o.session;
  if (!sess || typeof sess !== "object") {
    issues.push("'session' must be an object");
  } else {
    const s = sess as Record<string, unknown>;
    for (const key of ["multiWindow", "restoreState"] as const) {
      if (!(key in s)) {
        issues.push(`session missing '${key}'`);
      } else if (typeof s[key] !== "boolean") {
        issues.push(`session.${key} must be boolean`);
      }
    }
  }

  for (const key of ["id", "layout", "navigation"] as const) {
    if (typeof o[key] !== "string" || !(o[key] as string).trim()) {
      issues.push(`'${key}' must be a non-empty string`);
    }
  }

  if (issues.length) {
    throw new SurfaceProfileValidationError("invalid surface profile", issues);
  }

  const modes = o.modes as unknown[];
  const normalizedModes = modes.filter((m): m is "windowed" | "fullscreen" =>
    VALID_SURFACE_MODES.has(m as "windowed" | "fullscreen"),
  );

  return {
    id: String(o.id),
    schemaVersion: o.schemaVersion !== undefined ? String(o.schemaVersion) : undefined,
    layout: String(o.layout),
    navigation: String(o.navigation),
    input: o.input as string[],
    modes: normalizedModes,
    thinui: {
      density: String((o.thinui as Record<string, unknown>).density),
      theme: String((o.thinui as Record<string, unknown>).theme),
      components: (o.thinui as Record<string, unknown>).components as string[],
    },
    session: {
      multiWindow: Boolean((o.session as Record<string, unknown>).multiWindow),
      restoreState: Boolean((o.session as Record<string, unknown>).restoreState),
    },
  };
}
