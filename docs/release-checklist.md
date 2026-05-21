# リリースチェックリスト

## 公開前対応

### must

- [x] favicon 差し替え（デフォルト赤丸 → 時計アイコン）
- [x] `lang="ja"` / `meta description` / `application-name` 修正
- [x] `config.force_ssl = true` 有効化
- [x] `render.yaml` 作成

### should

- [x] `og:url` 追加
- [x] canonical タグ追加
- [x] `robots.txt` に内容追記

---

## Render 公開作業

### コード

- [x] `render.yaml` 作成

### Render ダッシュボード

- [x] GitHub リポジトリを連携してサービス作成
- [x] `RAILS_MASTER_KEY` を環境変数に設定（`config/master.key` の中身）
- [x] デプロイ確認（`/up` ヘルスチェック通過）
- [x] カスタムドメイン設定（`cron-humanize.mizk.net`）

### DNS

- [x] `cron-humanize.mizk.net` の CNAME レコードを Render のホスト名に向ける

### 確認

- [x] OGP シェアカード確認（production URL で Twitter Card Validator 等）
