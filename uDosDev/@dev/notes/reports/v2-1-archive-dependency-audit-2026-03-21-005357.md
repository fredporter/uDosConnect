# v2.1 Archive Dependency Audit

Generated: 2026-03-21-005357 UTC

## Runtime Dependency Result

- status: FAIL
- rule: no active v2.1 runtime/config dependency on archived folders

## Archive Inventory (Code Root)

- OBSC-android-app-v1-archived
- uDOS-v1-8-archived
- uHOME-android-app-v1-archived
- uHOME-server-v1-archived

## Target Archive Folder Presence

| Folder | Exists |
| --- | --- |
| uDOS-v1-8-archived | yes |
| uHOME-server-v1-archived | yes |
| uHOME-android-app-v1-archived | yes |
| OBSC-android-app-v1-archived | yes |
| OBSC-mac-app-v1-archived | no |

## Runtime/Config Surface Matches (docs and @dev excluded)

```
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:14:  "uDOS-v1-8-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:15:  "uHOME-server-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:16:  "uHOME-android-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:17:  "OBSC-android-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:18:  "OBSC-mac-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:44:PATTERN='uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived|/Users/fredbook/Code/[^[:space:]]+-archived'
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:45:NAME_PATTERN='uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived'
```

## All References (for classification)

```
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:8:- archived browser GUI work in `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:54:- [`wizard/web/templates/base.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/base.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:55:- [`wizard/web/templates/dashboard.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/dashboard.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:56:- [`wizard/web/templates/devices.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/devices.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:57:- [`wizard/web/templates/config.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/config.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:58:- [`wizard/web/templates/catalog.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/catalog.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:59:- [`wizard/web/templates/logs.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/logs.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:60:- [`wizard/web/templates/webhooks.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/webhooks.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:61:- [`wizard/web/templates/hotkeys.html`](/Users/fredbook/Code/uDOS-v1-8-archived/wizard/web/templates/hotkeys.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:89:- [`apps/admin/README.md`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/README.md)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:90:- [`apps/admin/src/routes/+layout.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/routes/+layout.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:91:- [`apps/admin/src/routes/+page.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/routes/+page.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:95:- [`apps/admin/src/lib/components/ThemePicker.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/ThemePicker.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:96:- [`apps/admin/src/lib/components/MissionQueue.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/MissionQueue.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:97:- [`apps/admin/src/lib/components/ContributionQueue.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/ContributionQueue.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:98:- [`apps/admin/src/lib/components/RendererPreview.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/RendererPreview.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:99:- [`apps/admin/src/lib/components/SpatialPanel.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/SpatialPanel.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:100:- [`apps/admin/src/lib/components/TaskPanel.svelte`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/components/TaskPanel.svelte)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:101:- [`apps/admin/src/lib/services/opsService.ts`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/services/opsService.ts)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:102:- [`apps/admin/src/lib/services/rendererService.ts`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/services/rendererService.ts)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:103:- [`apps/admin/src/lib/services/spatialService.ts`](/Users/fredbook/Code/uDOS-v1-8-archived/apps/admin/src/lib/services/spatialService.ts)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:133:- [`modules/thin-gui/README.md`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/README.md)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:134:- [`modules/thin-gui/assets/index.html`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/assets/index.html)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:135:- [`modules/thin-gui/assets/thin-gui.js`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/assets/thin-gui.js)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:136:- [`modules/thin-gui/assets/thin-gui.css`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/assets/thin-gui.css)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:510:- Thin GUI single-window/intent logic from [`modules/thin-gui/assets/thin-gui.js`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/assets/thin-gui.js)
/Users/fredbook/Code/uDOS-wizard/docs/gui-assessment-and-plan.md:511:- Thin GUI shell layout ideas from [`modules/thin-gui/assets/index.html`](/Users/fredbook/Code/uDOS-v1-8-archived/modules/thin-gui/assets/index.html)
/Users/fredbook/Code/uDOS-dev/docs/development-roadmap.md:89:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/docs/development-roadmap.md:90:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/docs/development-roadmap.md:91:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/docs/development-roadmap.md:92:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/docs/development-roadmap.md:93:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/requests/binder-dev-v2-1-release-and-archive-gate.md:22:- uDOS-v1-8-archived
/Users/fredbook/Code/uDOS-dev/@dev/requests/binder-dev-v2-1-release-and-archive-gate.md:23:- uHOME-server-v1-archived
/Users/fredbook/Code/uDOS-dev/@dev/requests/binder-dev-v2-1-release-and-archive-gate.md:24:- uHOME-android-app-v1-archived
/Users/fredbook/Code/uDOS-dev/@dev/requests/binder-dev-v2-1-release-and-archive-gate.md:25:- OBSC-android-app-v1-archived
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2.1-rounds.md:170:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2.1-rounds.md:171:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2.1-rounds.md:172:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2.1-rounds.md:173:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:11:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:12:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:13:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:14:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:18:### `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:39:### `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:53:### `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/roadmap/v2-archive-recovery-plan.md:70:### `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233616.md:190:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233616.md:191:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233616.md:192:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233616.md:193:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233616.md:194:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135551.md:233:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135551.md:234:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135551.md:235:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135551.md:236:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135551.md:237:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-142323.md:238:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-142323.md:239:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-142323.md:240:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-142323.md:241:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-142323.md:242:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235717.md:205:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235717.md:206:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235717.md:207:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235717.md:208:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235717.md:209:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135129.md:232:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135129.md:233:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135129.md:234:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135129.md:235:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-135129.md:236:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235250.md:202:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235250.md:203:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235250.md:204:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235250.md:205:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-235250.md:206:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140218.md:233:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140218.md:234:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140218.md:235:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140218.md:236:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140218.md:237:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140556.md:235:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140556.md:236:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140556.md:237:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140556.md:238:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-140556.md:239:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000000.md:208:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000000.md:209:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000000.md:210:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000000.md:211:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000000.md:212:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234840.md:199:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234840.md:200:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234840.md:201:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234840.md:202:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234840.md:203:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000518.md:215:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000518.md:216:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000518.md:217:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000518.md:218:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000518.md:219:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-002949.md:223:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-002949.md:224:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-002949.md:225:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-002949.md:226:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-002949.md:227:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010444.md:226:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010444.md:227:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010444.md:228:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010444.md:229:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010444.md:230:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-005923.md:224:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-005923.md:225:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-005923.md:226:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-005923.md:227:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-005923.md:228:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-143141.md:238:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-143141.md:239:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-143141.md:240:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-143141.md:241:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-143141.md:242:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010753.md:227:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010753.md:228:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010753.md:229:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010753.md:230:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010753.md:231:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-012358.md:228:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-012358.md:229:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-012358.md:230:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-012358.md:231:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-012358.md:232:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010308.md:226:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010308.md:227:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010308.md:228:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010308.md:229:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-010308.md:230:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000147.md:211:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000147.md:212:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000147.md:213:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000147.md:214:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-000147.md:215:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-001029.md:218:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-001029.md:219:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-001029.md:220:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-001029.md:221:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-001029.md:222:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-185220.md:249:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-185220.md:250:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-185220.md:251:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-185220.md:252:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-15-185220.md:253:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234519.md:196:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234519.md:197:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234519.md:198:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234519.md:199:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-234519.md:200:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233936.md:193:- `uHOME-server-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233936.md:194:- `uHOME-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233936.md:195:- `OBSC-android-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233936.md:196:- `OBSC-mac-app-v1-archived`
/Users/fredbook/Code/uDOS-dev/@dev/notes/reports/roadmap-status-2026-03-14-233936.md:197:- `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:14:  "uDOS-v1-8-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:15:  "uHOME-server-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:16:  "uHOME-android-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:17:  "OBSC-android-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:18:  "OBSC-mac-app-v1-archived"
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:44:PATTERN='uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived|/Users/fredbook/Code/[^[:space:]]+-archived'
/Users/fredbook/Code/uDOS-dev/scripts/run-v2-1-archive-dependency-audit.sh:45:NAME_PATTERN='uDOS-v1-8-archived|uHOME-server-v1-archived|uHOME-android-app-v1-archived|OBSC-android-app-v1-archived|OBSC-mac-app-v1-archived'
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:5:- preserve high-value conceptual work from `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:43:- `uDOS-v1-8-archived/docs/decisions/v1-5-2-EMPIRE-SERVER.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:44:- `uDOS-v1-8-archived/modules/empire/docs/ARCHITECTURE.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:45:- `uDOS-v1-8-archived/modules/empire/docs/HUBSPOT-SCHEMA.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:63:- `uDOS-v1-8-archived/docs/reference/specs/WORKFLOW-MANAGER-CONTRACT-v1.5.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:64:- `uDOS-v1-8-archived/docs/reference/specs/WORKFLOW-SCHEDULER-v1.5.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:65:- `uDOS-v1-8-archived/docs/decisions/v1-5-workflow-manager.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:84:- `uDOS-v1-8-archived/docs/decisions/01-05-06-web-publish.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:85:- `uDOS-v1-8-archived/docs/reference/specs/PUBLISH-EMAIL-RENDERER-CONTRACT-v1.5.8.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:86:- `uDOS-v1-8-archived/docs/reference/specs/BINDER-COMPILE-v1.5.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:104:- `uDOS-v1-8-archived/docs/concepts/features/beacon-portal.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:105:- `uDOS-v1-8-archived/docs/concepts/features/wizard-networking.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:123:- `uDOS-v1-8-archived/docs/decisions/uDOS-education-dev-brief.md`
/Users/fredbook/Code/uDOS-docs/architecture/05_v1_archive_relevance_assessment.md:124:- `uDOS-v1-8-archived/docs/decisions/v1-5-4-REPO-BOUNDARIES.md`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:5:- assess reusable non-concept assets from `uDOS-v1-8-archived`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:27:- `uDOS-v1-8-archived/courses/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:28:- `uDOS-v1-8-archived/wiki/Education-Pathways.md`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:61:- `uDOS-v1-8-archived/wiki/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:93:- `uDOS-v1-8-archived/modules/empire/templates/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:94:- `uDOS-v1-8-archived/modules/empire/docs/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:95:- `uDOS-v1-8-archived/modules/empire/scripts/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:130:- `uDOS-v1-8-archived/wizard/docs/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:131:- `uDOS-v1-8-archived/wizard/mcp/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:132:- `uDOS-v1-8-archived/wizard/tools/`
/Users/fredbook/Code/uDOS-docs/architecture/06_v1_archive_asset_migration_matrix.md:133:- selected `uDOS-v1-8-archived/wizard/tests/`
```
