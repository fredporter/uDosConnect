# Always-On Server Model

uDOS-Ubuntu is the persistent node in the uDOS ecosystem.

## Named Google MVP host profile

- `always-on local mirror/cache host`

## Duties

- run local daemon processes
- expose local APIs where appropriate
- maintain caches and mirrors
- coordinate sync windows
- host Empire services
- provide stable local execution for background tasks
- keep rebuildable local cache for optional Google-backed mirrors
- surface degraded mode when remote mirrors or shared rooms are unavailable

## Cloud relationship

Ubuntu may connect to cloud services, but it should not surrender system truth to them.

The local vault remains authoritative.

For the first Google MVP lane:

- local cache remains the recovery baseline
- local artifact staging remains authoritative for handoff back into repo-owned
  files
- Firestore may mirror approved state, but it does not replace local truth
- remote collaboration can enhance the runtime, but it does not define the base
  runtime
