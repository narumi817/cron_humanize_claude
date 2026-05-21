---
name: analytics-setup
description: MVPアプリの公開後に最低限必要な計測・観測を整理を依頼されたときに使用する。
---

# MVP Observability Skill

MVPアプリの公開後に最低限必要な計測・観測を整理してください。

目的:
- 最低限の利用状況を把握する
- 過剰実装を避ける
- 小さいMVPを素早く改善できるようにする

前提:
- 個人開発
- MVP
- 低コスト運用
- Rails / Web app が多い

観点:

## Analytics

- Google Analytics (GA4)
- production only
- localhost除外
- Render ENV

## Search / SEO

- Google Search Console
- sitemap
- robots

## Sharing

- title
- meta description
- OGP

## What to observe

最低限見るべき指標:
- リアルタイムアクセス
- 流入元
- ページ閲覧数
- 離脱ポイント

出力形式:

1. must（今やる）
2. should（少しアクセス出たら）
3. later（後回し可）
4. MVPとして不要な設定

MVP前提なので過剰実装を避けてください。

30分以内で対応できる内容を優先してください。