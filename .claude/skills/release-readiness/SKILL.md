---
name: release-readiness
description: （公開前）公開前のレビューを依頼されたときに使用する。
---

# MVP Release Readiness Skill

MVPアプリを公開前の観点でレビューしてください。

目的:
- 最低限の公開品質を満たす
- URL共有時に適切な表示にする
- 初見ユーザーでも安心して使える状態にする
- MVPとして過剰実装を避ける

まずコード修正は行わず、
公開前に必要な作業を整理してください。

以下の観点をレビューしてください:

## Metadata / Sharing

- page title
- meta description
- OGP
- favicon
- share preview quality

## UX

- 初見ユーザーが迷わないか
- 最低限の説明があるか
- TOPページで手が止まらないか

## SEO (minimum)

- title
- description
- canonical
- robots
- sitemap（必要なら）

## Rails / Deployment

- production setting
- Render設定
- ENV variables
- error page
- health check

出力形式:

1. must（公開前に最低限必要）
2. should（できればやる）
3. nice to have（後回し可）
4. 個人MVPとして不要な作業

MVP前提なので、過剰実装は避けてください。

30分以内で対応できる改善を優先してください。