from __future__ import annotations

from pathlib import Path

from .actions import failure, success, to_action_frame
from .binder import BinderEngine
from .foundation import (
    CapabilityRegistry,
    foundation_manifest,
    release_lane_manifest,
    runtime_services_manifest,
)
from .jobs import JobScheduler
from .mdc import MdcEngine
from .plugins import PluginRegistry
from .render import RenderEngine
from .script_runtime import ScriptDocumentError, load_script_document
from .ucode import parse_ucode
from .vault import VaultRecord, VaultStore


class RuntimeKernel:
    def __init__(self) -> None:
        self.binders = BinderEngine()
        self.capabilities = CapabilityRegistry()
        self.vault = VaultStore()
        self.plugins = PluginRegistry()
        self.jobs = JobScheduler()
        self.mdc = MdcEngine()
        self.render = RenderEngine()
        self.state: dict[str, str] = {}
        self.workflow_runs: dict[str, dict[str, str]] = {}
        self.draw_history: list[dict[str, str]] = []

    def execute(self, raw_command: str) -> dict:
        cmd = parse_ucode(raw_command)
        frame = to_action_frame(cmd)

        if cmd.namespace == "system" and cmd.action == "invalid":
            return failure(cmd, "invalid ucode syntax").__dict__

        if cmd.namespace == "system" and cmd.action == "noop":
            return success(cmd, frame=frame, note="no-op").__dict__

        if cmd.namespace == "system" and cmd.action == "foundation":
            return success(cmd, frame=frame, manifest=foundation_manifest()).__dict__

        if cmd.namespace == "state" and cmd.action == "set":
            target = cmd.args.get("target", "")
            value = cmd.args.get("value", "")
            if not target:
                return failure(cmd, "missing state target").__dict__
            if not value:
                return failure(cmd, "missing state value").__dict__
            self.state[target] = value
            return success(
                cmd,
                frame=frame,
                state={"target": target, "value": value, "count": len(self.state)},
            ).__dict__

        if cmd.namespace == "status" and cmd.action == "show":
            target = cmd.args.get("target", "")
            snapshot = self._status_snapshot()
            if target:
                return success(
                    cmd,
                    frame=frame,
                    status={
                        "target": target,
                        "value": self.state.get(target),
                        "known": target in self.state,
                    },
                    snapshot=snapshot,
                ).__dict__
            return success(cmd, frame=frame, status=snapshot).__dict__

        if cmd.namespace == "workflow" and cmd.action == "run":
            target = cmd.args.get("target", "")
            if not target:
                return failure(cmd, "missing workflow target").__dict__
            job = self.jobs.enqueue(
                job_id=f"workflow:{target}",
                job_type="workflow.run",
                payload={"target": target},
            )
            workflow = {"target": target, "state": "running", "job_id": job["job_id"]}
            self.workflow_runs[target] = workflow
            return success(cmd, frame=frame, workflow=workflow, job=job).__dict__

        if cmd.namespace == "draw" and cmd.action == "render":
            return self._execute_draw(cmd, frame)

        if cmd.namespace == "script" and cmd.action == "run":
            path = cmd.args.get("path", "")
            if not path:
                return failure(cmd, "missing script path").__dict__
            return self._execute_script(cmd, frame, path)

        if cmd.namespace == "binder" and cmd.action == "create":
            binder_id = cmd.args.get("items", "untitled-binder")
            return success(cmd, frame=frame, binder=self.binders.create(binder_id)).__dict__

        if cmd.namespace == "binder" and cmd.action == "list":
            return success(cmd, frame=frame, binders=self.binders.summary()).__dict__

        if cmd.namespace == "vault" and cmd.action == "health":
            return success(cmd, frame=frame, vault=self.vault.health()).__dict__

        if cmd.namespace == "capability" and cmd.action == "resolve":
            key = cmd.args.get("key", cmd.args.get("items", ""))
            if not key:
                return failure(cmd, "missing capability key").__dict__
            return success(
                cmd,
                frame=frame,
                capability=self.capabilities.resolve(key),
            ).__dict__

        if cmd.namespace == "capability" and cmd.action == "list":
            return success(
                cmd,
                frame=frame,
                capabilities=self.capabilities.summary(),
            ).__dict__

        if cmd.namespace == "release" and cmd.action == "lanes":
            return success(cmd, frame=frame, lanes=release_lane_manifest()).__dict__

        if cmd.namespace == "runtime" and cmd.action == "services":
            return success(
                cmd,
                frame=frame,
                services=runtime_services_manifest(),
            ).__dict__

        if cmd.namespace == "mdc" and cmd.action == "contract":
            return success(
                cmd,
                frame=frame,
                mdc=self.mdc.contract_summary(),
            ).__dict__

        if cmd.namespace == "mdc" and cmd.action == "classify":
            source = cmd.args.get("source", cmd.args.get("items", ""))
            if not source:
                return failure(cmd, "missing mdc source path").__dict__
            return success(
                cmd,
                frame=frame,
                classification=self.mdc.classify(source),
            ).__dict__

        if cmd.namespace == "mdc" and cmd.action == "normalize":
            source = cmd.args.get("source", cmd.args.get("items", ""))
            if not source:
                return failure(cmd, "missing mdc source path").__dict__
            return success(
                cmd,
                frame=frame,
                normalized=self.mdc.normalize(source),
            ).__dict__

        if cmd.namespace == "render" and cmd.action == "contract":
            return success(
                cmd,
                frame=frame,
                render_contract=self.render.contract(),
            ).__dict__

        if cmd.namespace == "render" and cmd.action == "preview":
            title = cmd.args.get("title", "Untitled")
            body = cmd.args.get("body", cmd.args.get("items", ""))
            markdown = f"# {title}\n\n{body}".strip()
            target = cmd.args.get("target", "gui-preview")
            metadata = {
                key: value
                for key, value in cmd.args.items()
                if key not in {"title", "body", "items", "target"}
            }
            return success(
                cmd,
                frame=frame,
                preview=self.render.preview(markdown, metadata=metadata, target=target),
            ).__dict__

        if cmd.namespace == "render" and cmd.action == "export":
            title = cmd.args.get("title", "Untitled")
            body = cmd.args.get("body", cmd.args.get("items", ""))
            markdown = f"# {title}\n\n{body}".strip()
            target = cmd.args.get("target", "web-prose")
            metadata = {
                key: value
                for key, value in cmd.args.items()
                if key not in {"title", "body", "items", "target"}
            }
            return success(
                cmd,
                frame=frame,
                export=self.render.export(markdown, metadata=metadata, target=target),
            ).__dict__

        if cmd.namespace == "render" and cmd.action == "exports":
            return success(
                cmd,
                frame=frame,
                exports=self.render.list_exports(),
            ).__dict__

        if cmd.namespace == "record" and cmd.action == "save":
            title = cmd.args.get("title", cmd.args.get("items", "Untitled"))
            record = VaultRecord(
                udos_id=cmd.args.get("id", "rec_demo"),
                record_type=cmd.args.get("type", "binder_note"),
                title=title,
                body=cmd.args.get("body", "placeholder"),
            )
            return success(cmd, frame=frame, path=self.vault.save_record(record)).__dict__

        if cmd.namespace == "plugin" and cmd.action == "register":
            name = cmd.args.get("name", cmd.args.get("items", "demo-plugin"))
            capability = cmd.args.get("capability", "demo")
            return success(cmd, frame=frame, plugin=self.plugins.register(name, capability)).__dict__

        if cmd.namespace == "plugin" and cmd.action == "list":
            return success(cmd, frame=frame, plugins=self.plugins.list_plugins()).__dict__

        if cmd.namespace == "job" and cmd.action == "enqueue":
            job_id = cmd.args.get("id", "job_demo")
            job_type = cmd.args.get("type", "demo")
            return success(
                cmd,
                frame=frame,
                job=self.jobs.enqueue(job_id=job_id, job_type=job_type, payload=cmd.args),
            ).__dict__

        if cmd.namespace == "job" and cmd.action == "list":
            return success(cmd, frame=frame, jobs=self.jobs.list_jobs()).__dict__

        return failure(cmd, "unknown command").__dict__

    def _status_snapshot(self) -> dict:
        return {
            "state": dict(self.state),
            "workflow_runs": list(self.workflow_runs.values()),
            "draw_count": len(self.draw_history),
        }

    def _execute_draw(self, cmd, frame: dict) -> dict:
        mode = cmd.args.get("mode", "")
        if mode == "block":
            target = cmd.args.get("target", "")
            if not target:
                return failure(cmd, "missing draw block target").__dict__
            block_path = Path(target).expanduser().resolve()
            if not block_path.exists():
                return failure(cmd, f"draw block not found: {block_path}").__dict__
            payload = {
                "mode": mode,
                "target": str(block_path),
                "content": block_path.read_text(encoding="utf-8"),
            }
            self.draw_history.append({"mode": mode, "target": str(block_path)})
            return success(cmd, frame=frame, draw=payload).__dict__

        if mode == "pat" and cmd.args.get("pattern_type") == "text":
            value = cmd.args.get("value", "")
            if not value:
                return failure(cmd, "missing draw pat text value").__dict__
            width = len(value) + 4
            rendered = "\n".join(
                [
                    "+" + "-" * (width - 2) + "+",
                    f"| {value} |",
                    "+" + "-" * (width - 2) + "+",
                ]
            )
            payload = {"mode": "pat_text", "value": value, "rendered": rendered}
            self.draw_history.append({"mode": "pat_text", "target": value})
            return success(cmd, frame=frame, draw=payload).__dict__

        return failure(cmd, "unsupported draw command").__dict__

    def _execute_script(self, cmd, frame: dict, path: str) -> dict:
        try:
            document = load_script_document(path)
        except ScriptDocumentError as exc:
            return failure(cmd, str(exc)).__dict__

        executed: list[dict] = []
        for block in document.blocks:
            for line in block.content.splitlines():
                statement = line.strip()
                if not statement:
                    continue
                result = self.execute(statement)
                executed.append({"statement": statement, "result": result})
                if not result["ok"]:
                    return failure(cmd, f"script statement failed: {statement}").__dict__ | {
                        "data": {
                            "frame": frame,
                            "script": {
                                "path": document.path,
                                "metadata": document.metadata,
                                "executed": executed,
                            },
                        }
                    }

        return success(
            cmd,
            frame=frame,
            script={
                "path": document.path,
                "metadata": document.metadata,
                "blocks": len(document.blocks),
                "executed": executed,
            },
        ).__dict__
