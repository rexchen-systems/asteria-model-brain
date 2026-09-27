# Asteria

> Initial public research release · v0.1 · 2026-09-28

## 繁體中文

Asteria 探索一種模型與持續性 Brain 分離的 AI 系統：模型負責理解與推理，Brain 保存可尋址、可驗證、可逐步累積的知識與能力。目標是研究如何讓不同 Core 重用同一個 Brain；這是研究目標，尚非已證明成果。

### 目前公開範圍

- **Core**：架構仍在研究中。本專案暫不發布自製 Core 實作。
- **Brain**：首批公開材料包含只使用合成資料的 Model Brain Prototype v0.8，涵蓋受限檢索、來源關係遍歷與小型 Working Set；以 MIT License 發布。
- **證據狀態**：v0.8 測試報告標示 `PASS_ONCE`。結果限於該合成測試，不代表已驗證真實人物連續性、自然人格、多語能力、低階硬體效能或雲端級可靠度。

## English

Asteria explores an AI system that separates a replaceable model from a persistent Brain. The model handles language understanding and reasoning; the Brain stores addressable, verifiable knowledge and reusable capabilities. We are investigating whether different Cores can reuse the same Brain. This is a research goal, not an established result.

### Current public scope

- **Core**: Under research. No custom Core implementation is released yet.
- **Brain**: The initial public materials include Model Brain Prototype v0.8, using synthetic data only. It explores bounded retrieval, source-linked traversal, and a small working set. It is released under the MIT License.
- **Evidence status**: The v0.8 report is marked `PASS_ONCE`. This result applies only to that synthetic test. It does not establish real-person continuity, natural personality, multilingual capability, low-end hardware performance, or cloud-level reliability.

## 日本語

Asteria は、交換可能なモデルと永続的な Brain を分離する AI システムを研究しています。モデルは言語理解と推論を担い、Brain は検索可能で検証可能な知識と再利用できる能力を蓄積します。異なる Core が同じ Brain を再利用できるかを調べています。これは研究目標であり、実証済みの成果ではありません。

### 現在の公開範囲

- **Core**：研究中です。独自 Core の実装はまだ公開していません。
- **Brain**：初回公開資料には、合成データのみを使う Model Brain Prototype v0.8 が含まれます。範囲を限定した検索、出典に基づく関係探索、小さな Working Set を検証し、MIT License で公開しています。
- **検証状況**：v0.8 の報告書は `PASS_ONCE` です。この結果は当該の合成テストに限られます。実在人物の継続性、自然な人格、多言語能力、低性能 PC での動作、クラウド級の信頼性を証明するものではありません。

## Project principles

1. Keep Core and Brain as separate research areas.
2. Publish methods, evidence, limitations, and corrections as research progresses.
3. Use synthetic data in public prototypes; exclude private personas, memories, chat records, and formal workspaces.
4. Keep Chinese, English, and Japanese project descriptions aligned. Language support claims require separate tests.
5. Treat every result as bounded by its stated setup and evidence.

## Release status

This project is released under the MIT License. See `LICENSE` for the terms. See `CHANGELOG.txt`, `LICENSE-STATUS.txt`, and `brain/Model Brain Prototype v0.8/Release Manifest v0.1.txt` for release details.
