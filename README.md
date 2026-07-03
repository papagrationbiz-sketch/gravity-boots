# gravity-boots 🥾

[English](#english) | [日本語](#日本語)

---

## English

A grounding kit for Google Antigravity (Gemini) that stabilizes floating AI agents (preventing hallucinations, filler words, and token waste), making them truthful, concise, and efficient.

### 🚀 Key Features

1. **Genshijin / Caveman Mode (Always-On)**
   - Reduces output tokens by **65% to 75%** (measured).
   - Automatically drops articles, filler words, pleasantries, and redundant grammatical structures in both English and Japanese.
2. **Quality Gates (Hallucination Prevention)**
   - Enforces pre-implementation planning, verification testing before declaring "complete", strict `file:line` referencing, and early termination rules on repetitive failures.
3. **RTK (Rust Token Killer) Integration**
   - Automatically prefixes shell commands with `rtk` (e.g., `rtk git status`).
   - Filters and compresses terminal command output locally, saving **60% to 90%** of input tokens.
4. **Custom StatusLine for Antigravity CLI**
   - Renders a functional, real-time terminal status line.
   - Beautifully displays Git repository/branch, local CWD, model context usage, and quota limits with localized reset times (e.g., `07/08 22:05`).

### 📂 Directory Structure

```text
gravity-boots/
├── plugin.json                 # Plugin manifest
├── LICENSE                     # MIT License
├── README.md                   # This document
├── rules/
│   ├── quality-gate-rules.md   # Quality Gates & Genshijin rules
│   └── antigravity-rtk-rules.md # RTK rules
├── scripts/
│   ├── setup.sh                # Setup and patch script
│   └── statusline.sh           # Custom statusline script for Antigravity CLI
└── skills/
    ├── caveman/                # English Caveman skill
    ├── caveman-commit/
    ├── caveman-review/
    ├── caveman-compress/
    ├── genshijin/              # Japanese Genshijin skill
    ├── genshijin-commit/
    ├── genshijin-review/
    └── genshijin-compress/
```

### 🛠 Installation

#### Manual Installation
1. Place this repository in `~/.gemini/antigravity-cli/plugins/`:
   ```bash
   mkdir -p ~/.gemini/antigravity-cli/plugins/
   git clone https://github.com/papagrationbiz-sketch/gravity-boots.git ~/.gemini/antigravity-cli/plugins/gravity-boots
   ```
2. Restart Antigravity. Rules and skills will be loaded automatically.

#### ⚙️ Automatic RTK Setup
If `rtk` is not installed on your system, the agent will automatically detect it and run `./scripts/setup.sh` after user confirmation to install and configure it.
(You can also manually run `sh ./scripts/setup.sh` to configure the environment).

### 💡 Usage
- Toggle Genshijin/Caveman mode by typing `/genshijin` (or `/caveman`, "talk like caveman") in the chat.
- Disable it by saying "normal mode" or "原始人やめて".
- Shell commands run by the agent will automatically be prefixed with `rtk`.

---

## 日本語

Google Antigravity（Gemini）でフワフワ浮きがち（嘘、無駄口、コンテキスト浪費）なAIエージェントをしっかりと地に足つかせ、実直かつ寡黙に機能させるための初期装備（グラウンディングキット）プラグインです。

### 🚀 主な機能

1. **Genshijin / Caveman モード (常時起動)**
   - AIエージェントの出力トークンを **約65%〜75%削減** します。
   - 日本語特有の冗長表現（助詞、接続詞、丁寧表現、クッション言葉）を徹底的に削り、情報密度を最大化します。
   - 英語および多言語会話時の圧縮（冠詞・接続詞の省略等）にも対応します。
2. **作業品質ゲート (AIの嘘・適当な動作の抑止)**
   - 変更前の「計画提示」、完了前の「実機テスト・ビルド検証」、変更内容の「`file:line` 引用による根拠明示」、複数回失敗時の「停止・報告」を義務付けます。
3. **RTK (Rust Token Killer) 自動連携**
   - コマンド実行時、自動的に `rtk` をプレフィックスとして付与します（例: `rtk git status`）。
   - コマンドの出力結果をローカルで自動圧縮し、入力トークンを **60%〜90%削減** します。
4. **Antigravity CLI (agy) 用 StatusLine**
   - リアルタイムにターミナル下部へ美しいステータスラインを表示します。
   - Gitリポジトリ/ブランチ名、カレントディレクトリ短縮表示、モデル、コンテキスト使用率、クォータ制限のリセット予定時刻（ローカル時間換算：`07/08 22:05`）などを表示します。

### 📂 ディレクトリ構成

```text
gravity-boots/
├── plugin.json                 # プラグインマニフェスト
├── LICENSE                     # MIT ライセンス
├── README.md                   # 本ドキュメント
├── rules/
│   ├── quality-gate-rules.md   # 品質ゲート & Genshijinルール
│   └── antigravity-rtk-rules.md # RTK自動適用ルール
├── scripts/
│   ├── setup.sh                # セットアップ & パッチ適用スクリプト
│   └── statusline.sh           # Antigravity CLI用カスタムステータスラインスクリプト
└── skills/
    ├── caveman/                # 英語版 原始人スキル
    ├── caveman-commit/
    ├── caveman-review/
    ├── caveman-compress/
    ├── genshijin/              # 日本語版 原始人スキル
    ├── genshijin-commit/
    ├── genshijin-review/
    └── genshijin-compress/
```

### 🛠 導入方法

#### 手動インストール
1. 本リポジトリを `~/.gemini/antigravity-cli/plugins/` に配置します。
   ```bash
   mkdir -p ~/.gemini/antigravity-cli/plugins/
   git clone https://github.com/papagrationbiz-sketch/gravity-boots.git ~/.gemini/antigravity-cli/plugins/gravity-boots
   ```
2. Antigravity を再起動します。ルールとスキルが自動的にロードされます。

#### ⚙️ RTKの自動セットアップ
環境内に `rtk` がインストールされていない場合、エージェントが自動的にそれを検出し、確認後に `./scripts/setup.sh` を実行してインストールと設定を行います。
（手動で `sh ./scripts/setup.sh` を実行して環境を整えることも可能です）

### 💡 使い方
- 原始人モードのON/OFF: チャットで `/genshijin` (または `/caveman`, 「talk like caveman」) と指示すると起動。
- 「通常モード」または「原始人やめて」と指示すると一時解除。
- コマンド実行時、自動的に `rtk` が適用されます。

---

## 🤝 Credits & Acknowledgements / クレジット・謝辞

This project was built by porting and integrating the following excellent open-source projects. Special thanks to the original authors.
本プロジェクトは、以下の素晴らしいオープンソースプロジェクトおよびルールの移植・統合によって開発されました。元作者の皆様に深く感謝いたします。

- **Caveman (English Version)**: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT License)
- **Genshijin (Japanese Version)**: [InterfaceX-co-jp/genshijin](https://github.com/InterfaceX-co-jp/genshijin) (MIT License)
- **RTK (Rust Token Killer)**: [rtk-ai/rtk](https://github.com/rtk-ai/rtk) (MIT License)
- **QUALITY_GATE.md**: User-specific quality guidelines

---

## 📄 License / ライセンス

This project is licensed under the **MIT License**. See [LICENSE](./LICENSE) for details.
本プロジェクトは **MIT ライセンス** の下で公開されています。詳細は [LICENSE](./LICENSE) を参照してください。
