# cron_humanize_claude

Claude AIを使ってcron式を人間が読みやすい形式に変換するツールです。

## 概要

cron式（例: `0 9 * * 1-5`）を自然言語（例: 「平日の毎朝9時」）に翻訳します。

## 使い方

```
cron_humanize_claude <cron式>
```

## 例

```
$ cron_humanize_claude "0 9 * * 1-5"
平日の毎朝9時に実行
```

## 必要条件

- `ANTHROPIC_API_KEY` 環境変数にAnthropicのAPIキーを設定

## ライセンス

MIT
