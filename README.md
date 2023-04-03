# 詳細設計図

| バックエンド |
| --- |
| Ruby 3.1.2 |
| Rails 7.0.4.2 |
| Rspec, Rubocop |

| フロントエンド |
| --- |
| React 18.2.0 |
| Next.js(SSR) 13.1.1 |
| TypeScript |
| Jest, React Testing Librar |
| prettier, eslint |
| TailwindCSS, daisyUI |

| インフラ |
| --- |
| Docker / Docker-Compose |
| AWS(ECS, Fargate, ECR, Amplify, CodeDeploy, ALB, SSM, ParameterStore, RDS, CloudWatch, S3, Route53, VPC) |
| IaC(Terraform) |
| Github Actions(ECR, ECS, CodeDeploy, Rubocop, Rspec, Slack) |

## インフラ

![スクリーンショット 2023-03-30 2.47.16.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/42fee8f7-a6a9-4480-a1a1-55d3243e9723/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88_2023-03-30_2.47.16.png)

## ER図

![スクリーンショット 2023-03-30 3.08.55.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/de9fffe5-412d-4379-b020-1f73f123bc54/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88_2023-03-30_3.08.55.png)

# 使用技術

### フロントエンド

- React  18.2.0
- Next.js(SSR) 13.1.1
- TypeScript
- Jest, React Testing Librar
- prettier, eslint
- TailwindCSS, daisyUI

### バックエンド

- Ruby 3.1.2
- Ruby on Rails 7.0.4.2
- RSpec, Rubocop

### インフラ

- AWS(ECS, Fargate, ECR, Amplify, CodeDeploy, ALB, SSM, ParameterStore, RDS, CloudWatch, S3, Route53, VPC)
- IaC(Terraform)
- Github Actions(ECR, ECS, CodeDeploy, Rubocop, Rspec, Slack)

# 機能一覧

### ホテル

- CRUD
- 画像の投稿、編集、削除(クライアントサイドファイルアップロード)
- お気に入りの登録と解除
- 現在の曜日と時間に基づいて、ホテルに登録されてある最安の料金を表示
- お気に入り登録をしているユーザーに向けて更新メッセージの通知

### レビュー

- CRUD
- 星５つ機能
- 参考になったの登録と解除

### ユーザー

- ログイン、ログアウト、新規登録、退会、パスワード再設定
- プロフィール編集
- プロフィール画像の投稿、編集(クライアントサイドファイルアップロード)
- お気に入り一覧
- 通知
- キーワード検索
- ホテルのアメニティ・設備の絞り込み
- 休憩料金、宿泊料金、レビュー数、お気に入り数の並び替え

### その他

- レスポンシブ対応
- useSWRInfiniteを用いた無限スクロール
- React Hook Formを用いたフォーム入力
- useFieldArrayを用いてテーブル形式でのホテル料金のCRUD
