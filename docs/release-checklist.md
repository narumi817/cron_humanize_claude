# リリースチェックリスト

## 公開前対応

### must

- [x] favicon 差し替え（デフォルト赤丸 → 時計アイコン）
- [x] `lang="ja"` / `meta description` / `application-name` 修正
- [x] `config.force_ssl = true` 有効化
- [ ] `render.yaml` 作成

### should

- [ ] `og:url` 追加
- [ ] canonical タグ追加
- [ ] `robots.txt` に内容追記

---

## Render 公開作業

### コード

- [ ] `render.yaml` 作成

### Render ダッシュボード

- [ ] GitHub リポジトリを連携してサービス作成
- [ ] `RAILS_MASTER_KEY` を環境変数に設定（`config/master.key` の中身）
- [ ] デプロイ確認（`/up` ヘルスチェック通過）
- [ ] カスタムドメイン設定（`cron_humanize.mizk.net`）

### DNS

- [ ] `cron_humanize.mizk.net` の CNAME レコードを Render のホスト名に向ける

### 確認

- [ ] OGP シェアカード確認（production URL で Twitter Card Validator 等）
