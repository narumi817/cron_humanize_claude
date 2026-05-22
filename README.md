# Cron Humanize

Cron Humanize は、cron式を人間が読みやすい説明文に変換し、次回以降の実行予定を表示するRailsアプリケーションです。

デフォルトは日本語表示で、`/en` から英語表示にも切り替えられます。

## 機能

- 標準的な5フィールドのcron式を日本語または英語の説明文に変換
- 有効なcron式の次回実行予定を5件表示
- 無効な入力に対するエラーと入力形式のヒントを表示
- よく使うcron式をサンプルリンクからワンクリックで入力
- プライバシーポリシーページを提供

## 変換例

| cron式 | 日本語 | 英語 |
| --- | --- | --- |
| `* * * * *` | 毎分 | Every minute |
| `*/5 * * * *` | 5分ごと | Every 5 minutes |
| `0 9 * * *` | 毎日 9:00 | Every day 9:00 |
| `0 9 * * 1-5` | 毎週月〜金 9:00 | Every Mon-Fri 9:00 |
| `0 0 1 * *` | 毎月1日 0:00 | Every month on day 1 0:00 |

## 技術スタック

- Ruby 3.4.2
- Rails 8.1
- Fugit
- Propshaft
- Puma / Thruster
- Docker / Docker Compose

## 必要なもの

- Docker Desktop
- Docker Compose

macOSでホームディレクトリ配下にリポジトリを置いている場合は、Docker Desktopのファイル共有設定で対象パスへのアクセスを許可してください。

## セットアップ

開発用コンテナをビルドして起動します。

```bash
docker-compose build
docker-compose up
```

起動後、以下のURLにアクセスできます。

- 日本語: http://localhost:3000
- 英語: http://localhost:3000/en
- ヘルスチェック: http://localhost:3000/up

## 開発コマンド

テストを実行します。

```bash
docker-compose run --rm web bundle exec rails test
```

RuboCopを実行します。

```bash
docker-compose run --rm web bundle exec rubocop
```

bundler-auditを実行します。

```bash
docker-compose run --rm web bundle exec bundler-audit check
```

Rails consoleを起動します。

```bash
docker-compose run --rm web bundle exec rails console
```

## ディレクトリ構成

```text
.
├── app/
│   ├── controllers/
│   │   └── cron_expressions_controller.rb  # 変換画面のリクエスト処理
│   ├── services/
│   │   └── cron_humanize_service.rb        # cron解析、説明文生成、次回実行予定の算出
│   └── views/
│       └── cron_expressions/
│           └── index.html.erb              # メインの変換画面
├── config/
│   └── locales/
│       ├── ja.yml                          # 日本語UIと変換文言
│       └── en.yml                          # 英語UIと変換文言
├── test/
│   └── services/
│       └── cron_humanize_service_test.rb   # 変換ロジックのテスト
└── render.yaml                             # Render向けのデプロイ設定
```

## cron式の形式

標準的な5フィールドのcron式を受け付けます。

```text
分 時 日 月 曜日
```

ワイルドカード、ステップ値、カンマ区切り、範囲指定に対応しています。

- `* * * * *`
- `*/5 * * * *`
- `0,30 9 * * *`
- `0 9-17 * * *`
- `0 9 * * 1,3-5`

曜日は `0` から `6` で指定します。`0` が日曜日、`6` が土曜日です。

## デプロイ

`render.yaml` にRender向けのWebサービス設定を用意しています。

本番環境では以下の環境変数を設定します。

- `RAILS_ENV=production`
- `RAILS_MASTER_KEY`
- `GOOGLE_ANALYTICS_ID` - GA4の測定ID

ヘルスチェックのパスは `/up` です。
