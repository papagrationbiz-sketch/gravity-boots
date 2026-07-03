# Google Antigravityのトークンを80%削減し、嘘を黙らせるプラグイン「gravity-boots」を作った

こんにちは！個人開発でAIエージェント（主にGoogle AntigravityやClaude Code）を使い倒している開発者です。

AIエージェントとのペアプログラミングは非常に快適ですが、誰もが一度は以下の「絶望」に直面したことがあるのではないでしょうか。

- **会話が長くなるとAIの回答が急に雑になる / 命令を無視し始める**（コンテキスト・ロット現象）
- **「おそらく動くはずです」とAIが言うが、実行するとエラーで動かない**（検証サボり・ハルシネーション）
- **気づいたら想定より遥かに多くのAPIトークン（お財布）を消費している**（トークン浪費）

これらの課題を解決し、浮つきがちなAIエージェントを「地に足つかせ（品質担保）」、「寡黙に（トークン節約）」動作させるための初期装備（グラウンディングキット）プラグイン **`gravity-boots` 🥾** を開発し、OSSとして公開しました。

- **GitHubリポジトリ**: [https://github.com/papagrationbiz-sketch/gravity-boots.git](https://github.com/papagrationbiz-sketch/gravity-boots.git)

---

## 🥾 gravity-boots とは？

Google Antigravity（Gemini）向けに最適化されたプラグインです。以下の3つのコア要素を全自動で適用し、エージェントの挙動を劇的に改善します。

1. **品質ゲート (Quality Gates)**: AIの嘘、サボり、無断変更の完全抑止。
2. **Genshijin / Caveman モード**: 日本語・英語の出力を極限まで削る超圧縮対話。
3. **RTK (Rust Token Killer) 自動連携**: ターミナルコマンド出力を圧縮し、入力トークンを激減。

---

## 🛠 3つのアプローチでAIを最強にする

### 1. 嘘と妥協を許さない「品質ゲート」

AIが「完了しました」と嘘を言うのを防ぐため、以下の制約をシステムプロンプトとしてAIに常時強制（Always-On）します。

- **根拠必須**: コードに言及する際は必ず `file:line` のリンク形式での引用を義務付け。読んでいないファイルや推測は「推測：」と明示させる。
- **検証ゲート**: 「完了」報告の前に、ビルド・テスト・実行確認をAI自身にターミナルで実行させ、その成功ログを引用させる。「動くはず」での完了報告は禁止。
- **計画ゲート**: 3ファイル以上の変更や設計判断が必要な場合、実装前に「計画書」を提示させ、ユーザーの合意を得ることを義務付け。

### 2. トークンを最大75%削減する「原始人（Genshijin / Caveman）モード」

AIの出力トークンを削減するため、接続詞・敬語・丁寧表現を排除し、「カタコトの単語とコードのみ」で応答させます。

- **Before (通常)**:
  > ご質問ありがとうございます。コンポーネントが再レンダリングされるのは、レンダリングごとに新しいオブジェクト参照がインラインで生成されることが原因と考えられます。`useMemo`で包むと解決できます。
- **After (Genshijin)**:
  > インラインオブジェクトprop → 新ref → 再レンダリング。`useMemo`で解決。

意味は100%通じるまま、返答トークン数を劇的に削減します。日本語の「助詞・接続詞・クッション言葉」の排除に最適化されたルールと、英語会話時のCavemanルールが自動で切り替わるハイブリッド仕様です。

### 3. コマンド結果を最大90%圧縮する「RTK自動フック」

AIエージェントが裏で実行する `git status` や `cargo test`、`xcodebuild` などのコマンド結果は、会話のターンをまたぐたびにコンテキストに積み重なり、トークンを激しく浪費します。

`gravity-boots` を導入すると、AIが実行するコマンドの頭に自動で `rtk` プレフィックスが付与されます。
これによって出力をローカルで自動パース・圧縮し、**入力トークンを60〜90%削減**します。

- `git status` 出力: 119文字 → 28文字（76%削減）
- テスト実行ログ: 155行 → 3行（98%削減）

---

## 📈 削減効果シミュレーション（10ターン会話時）

10ターンのやり取りを行った場合の累積コンテキストの推計です。

- **未対策（通常動作）**: 累積 約**18,000** トークン
- **gravity-boots 導入後**: 累積 約**3,800** トークン

**⇒ 総消費トークンを約80%削減。**
APIコストが安くなるだけでなく、コンテキストが小さく維持されるため、エージェントの処理速度が大幅に上がり、指示を失念するバグも激減します。

---

## 🚀 導入はワンコマンド

ターミナルで以下のコマンドを実行するだけで、RTKの自動インストール（macOS/Linux対応）と言語選択（日本語/英語）が対話形式で行われ、セットアップが即座に完了します。

```bash
# 1. プラグインをクローン
git clone https://github.com/papagrationbiz-sketch/gravity-boots.git ~/.gemini/antigravity-cli/plugins/gravity-boots

# 2. セットアップスクリプトを実行
sh ~/.gemini/antigravity-cli/plugins/gravity-boots/scripts/setup.sh
```

実行時に対話プロンプトで `1: Japanese` または `2: English` を選ぶと、自動的に `~/.gemini/GEMINI.md` にインポート設定が追加され、全プロジェクトで自動的に重力ブーツが機能し始めます。

---

## 🤝 クレジット・ライセンス

本プラグインは、以下の優れたオープンソースツールおよびルールを統合・移植して作成されました。

- **Caveman (English Mode)**: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (MIT License)
- **Genshijin (Japanese Mode)**: [InterfaceX-co-jp/genshijin](https://github.com/InterfaceX-co-jp/genshijin) (MIT License)
- **RTK (Rust Token Killer)**: [rtk-ai/rtk](https://github.com/rtk-ai/rtk) (MIT License)

ライセンスは **MIT ライセンス** で公開しています。

ぜひ皆さんの環境でも `gravity-boots` を履かせて、快適なAIエージェントライフを送ってください！
リポジトリへのStarやコントリビュートもお待ちしております！
[https://github.com/papagrationbiz-sketch/gravity-boots.git](https://github.com/papagrationbiz-sketch/gravity-boots.git)
