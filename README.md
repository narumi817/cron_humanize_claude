# Cron Humanize

cron式を日本語に変換するWebアプリケーション。

## 機能

- cron式を日本語の説明文に変換
- 次回実行予定を5件表示
- 無効なcron式のエラー表示

**変換例**

| cron式 | 説明 |
|---|---|
| `* * * * *` | 毎分 |
| `*/5 * * * *` | 5分ごと |
| `0 9 * * *` | 毎日 9:00 |
| `0 9 * * 1-5` | 毎週月〜金 9:00 |
| `0 0 1 * *` | 毎月1日 0:00 |

## 技術スタック

- Ruby 3.4.2
- Rails 8.1
- Docker / Docker Compose

## 開発環境のセットアップ

Docker Desktop でファイル共有（`/Users/your_name/...`）を有効にしてから実行してください。

```bash
docker-compose build
docker-compose up
```

http://localhost:3000 でアクセスできます。

## テスト

```bash
docker-compose run --rm web bundle exec rails test
```

## Rubocop

```bash
docker-compose run --rm web bundle exec rubocop
```
