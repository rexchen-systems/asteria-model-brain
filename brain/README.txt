Brain — Research Area

Status: LOCAL PUBLIC-RELEASE CANDIDATE / NOT PUBLISHED

Model Brain Prototype v0.8 is the first public Brain release candidate. Its report records PASS_ONCE on three seeds using synthetic data. It tests bounded semantic candidate selection followed by deterministic source/relation traversal and a bounded working set.

The staged copy is self-contained with its synthetic v0.7 baseline. Private experimental references were removed from the public copy. Original source and evidence remain unchanged. The recorded v0.8 run evidence is stored under `Model Brain Prototype v0.8/evidence/v0.8/`; reruns write fresh output under `runs/` and `results/`.

Known limits include no proof of real-person continuity, natural personality, multilingual performance, low-end hardware performance, or cloud-level reliability. Its runtime-access conclusion was based on explicit read-path evidence and implementation structure, not an OS-level file-read tracer.

The prototype requires a local Ollama service with `qwen3.5:4b` and `bge-m3` available. The package does not install models or start a service. See the prototype README and release manifest before running it.
