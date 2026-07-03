# gravity-boots 🥾

Google Antigravity（Gemini）でフワフワ浮きがち（嘘、無駄口、コンテキスト浪費）なAIエージェントをしっかりと地に足つかせ、実直かつ寡黙に機能させるための初期装備（グラウンディングキット）プラグインです。

---

## 🚀 主な機能

1. **Genshijin / Caveman モード (常時起動)**
   - AIエージェントの出力トークンを **約65%〜75%削減** します。
   - 日本語特有の冗長表現（助詞、接続詞、丁寧表現、クッション言葉）を徹底的に削り、情報密度を最大化します。
   - 英語および多言語会話時の圧縮（冠詞・接続詞の省略等）にも対応します。
2. **作業品質ゲート (AIの嘘・適当な動作の抑止)**
   - 変更前の「計画提示」、完了前の「実機テスト・ビルド検証」、変更内容の「`file:line` 引用による根拠明示」、複数回失敗時の「停止・報告」を義務付けます。
3. **RTK (Rust Token Killer) 自動連携**
   - コマンド実行時、自動的に `rtk` をプレフィックスとして付与します（例: `rtk git status`）。
   - コマンドの出力結果をローカルで自動圧縮し、入力トークンを **60%〜90%削減** します。

---

## 📂 ディレクトリ構成

```text
gravity-boots/
├── plugin.json                 # プラグインマニフェスト
├── LICENSE                     # MIT ライセンス
├── README.md                   # 本ドキュメント
├── rules/
│   ├── quality-gate-rules.md   # 品質ゲート & Genshijinルール
│   └── antigravity-rtk-rules.md # RTK自動適用ルール
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

---

## 🛠 導入方法

### 手動インストール

1. 本リポジトリを `~/.gemini/antigravity-cli/plugins/` に配置します。
   ```bash
   mkdir -p ~/.gemini/antigravity-cli/plugins/
   git clone https://github.com/papagrationbiz-sketch/gravity-boots.git ~/.gemini/antigravity-cli/plugins/gravity-boots
   ```
2. Antigravity を再起動します。ルールとスキルが自動的にロードされます。

### ⚙️ RTKの自動セットアップ
環境内に `rtk` がインストールされていない場合、エージェントが自動的にそれを検出し、確認後に `./scripts/setup.sh` を実行してインストールと設定を行います。
（手動で `sh ./scripts/setup.sh` を実行して環境を整えることも可能です）

---

## 💡 使い方

### 原始人口調のON/OFF
- `/genshijin` または 「talk like caveman」とチャットで指示すると起動。
- 「通常モード」または「原始人やめて」と指示すると一時解除。

### コマンド実行
- コマンド実行時、自動的に `rtk` が適用されます。手動で `rtk git status` などと入力しても動作します。

---

## 🤝 クレジット・謝辞

本プロジェクトは、以下の素晴らしいオープンソースプロジェクトおよびルールの移植・統合によって開発されました。元作者の皆様に深く感謝いたします。

- **Caveman (English Version)**: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT License)
- **Genshijin (Japanese Version)**: [InterfaceX-co-jp/genshijin](https://github.com/InterfaceX-co-jp/genshijin) (MIT License)
- **RTK (Rust Token Killer)**: [rtk-ai/rtk](https://github.com/rtk-ai/rtk) (MIT License)
- **QUALITY_GATE.md**: ユーザー固有の品質定義

---

## 📄 ライセンス

本プロジェクトは **MIT ライセンス** の下で公開されています。詳細は [LICENSE](./LICENSE) を参照してください。
