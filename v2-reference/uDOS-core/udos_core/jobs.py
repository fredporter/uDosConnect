from __future__ import annotations
from dataclasses import dataclass, asdict
from typing import Any

@dataclass
class Job:
    job_id: str
    job_type: str
    payload: dict[str, Any]
    state: str = "queued"

class JobScheduler:
    def __init__(self) -> None:
        self.jobs: dict[str, Job] = {}

    def enqueue(self, job_id: str, job_type: str, payload: dict[str, Any]) -> dict:
        job = Job(job_id=job_id, job_type=job_type, payload=payload)
        self.jobs[job_id] = job
        return asdict(job)

    def list_jobs(self) -> dict:
        return {"count": len(self.jobs), "jobs": [asdict(j) for j in self.jobs.values()]}
