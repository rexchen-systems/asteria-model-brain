Asteria Model Brain Prototype v0.8

Purpose
- Remove the v0.7 full-candidate-index advantage.
- Use natural-language intent, a small region directory, one bounded candidate shard, and deterministic relation/source traversal.
- Preserve fail-closed UNKNOWN, incomplete evidence, speaker attribution, lifecycle, authority, and multi-event reconstruction.

Runtime path
Brain Entry
→ Region Index
→ semantic region candidate
→ one bounded candidate shard
→ deterministic node edges
→ bounded working set

Safety
- Fully synthetic data only.
- Runtime must not read archive/Full Node Catalog.txt.
- Oracle and Runtime remain separate.
- No formal Asteria or person data is read or modified.
- v0.7 evidence is hash-frozen before and after the run.

Dependencies
- Windows PowerShell 7 or later.
- A locally running Ollama service at 127.0.0.1:11434.
- Core model: qwen3.5:4b.
- Embedding model: bge-m3.
- The package does not download models, start Ollama, or contact a cloud service.

Run
powershell -NoProfile -ExecutionPolicy Bypass -File .\Run-v08.ps1

The command creates fresh `runs` and `results` output. The recorded v0.8 evidence is preserved under `evidence/v0.8` and is not used as run output.

Evidence status
- The included report records PASS_ONCE across seeds 808, 1808, and 9808.
- This is a preserved historical result, not a claim that this public copy has been rerun on your machine.
- See Release Manifest v0.1.txt for the public-copy changes and current verification status.

