
# サービス概要

https://www.hoteler.jp/

私は5年間レジャーホテル2店舗でフロント業務をしてきました。そのため、常日頃からお客様からのお問い合わせやお申しつけを受ける立場でした。その経験から、レジャーホテルの問題点を当アプリに落とし込みました。

- 電話対応でのお問い合わせで最も多いのは 「今空いていますか？」　

- 来店されたお客様からのお申し付けで最も多いのは　「なんでこんなに高いんですか？」

#### これらの問い合わせを当アプリを見るだけですぐに解決できるように、「空室状況」、「今日の曜日の今の時間の最安の料金」をトップページに記載しました
![トップ画面](https://user-images.githubusercontent.com/96788618/229489642-685c4da7-8c08-432c-940e-de2cb109191f.gif)

#### また、ホテル運営者はワンクリックで満室と空室を切り替えられます。
![満室切り替え10fps](https://user-images.githubusercontent.com/96788618/229475206-118bb083-bc36-41e2-adb3-564971d95ee0.gif)

#### 曜日と時間と時期によって料金が変動するレジャーホテルでは、10個以上の休憩料金があることも珍しくありません。そこで、ホテル運営者は下記のようにテーブル形式で料金を管理できます。
![料金表20fps](https://user-images.githubusercontent.com/96788618/229476831-68f190c6-426e-41ec-b0aa-86c46646646c.gif)


#### 休憩料金、宿泊料金、口コミ数、お気に入り数による並び替え機能や、設備アメニティによる絞り込み機能もあります。
![検索](https://user-images.githubusercontent.com/96788618/229491452-c490b0c3-d64f-4e99-9f96-9013b58cbee6.gif)


#### ホテル運営者がホテルの料金やコンテンツを編集した際と、ユーザーが口コミを書いた際にホテル運営者が、それぞれ通知を受け取れます。
![ホテルからの通知](https://user-images.githubusercontent.com/96788618/229484327-77fc141b-eb7e-4c0b-9710-b431abec6e97.gif)
![ホテルが口コミを受ける通知](https://user-images.githubusercontent.com/96788618/229493460-60a40624-9861-426a-9001-7825201f7bf1.gif)


#### 星5つで口コミを書くことができます。

#### 


# インフラ構成図
<img width="1072" alt="スクリーンショット 2023-03-30 2 47 16" src="https://user-images.githubusercontent.com/96788618/229451278-b0894507-db98-499a-929d-c1c1850dd4b5.png">

# ER図
<img width="1071" alt="スクリーンショット 2023-03-30 3 08 55" src="https://user-images.githubusercontent.com/96788618/229451346-49f59fe2-f1b1-44b9-8bd9-991a3877d98f.png">

# 使用技術

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

# 機能一覧

### ホテル

- CRUD
- 画像の投稿、編集、削除(S3の署名付きURLを用いた、クライアントサイドからの画像アップロード)
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
- プロフィール画像の投稿、編集(S3の署名付きURLを用いた、クライアントサイドからの画像アップロード)
- お気に入り一覧
- 通知
- キーワード検索
- ホテルのアメニティ・設備で絞り込み
- 休憩料金、宿泊料金、レビュー数、お気に入り数の並び替え

### その他

- レスポンシブ対応
- useSWRInfiniteを用いた無限スクロール
- React Hook Formを用いたフォーム入力
- useFieldArrayを用いてテーブル形式でのホテル料金のCRUD


# 工夫したところ

## バックエンド
### N + 1 問題
Bullet gemを導入して、RSpecの設定に取り込むことによって、テスト実行時もN + 1が発生した際にはテストが落ちるようにしました。
また、N + 1 問題に対しては、includesを使わずに、preloadとeager_loadを使い分けるようにしました。理由としては、includesの場合はRailsがよしなにpreloadとeager_loadを振り分けるため、制御しずらく、意図せぬ動作をしてしまうことがあるからです。
そのため、左外部結合をして一つのクエリにまとめるのか(eager_load)、クエリを２つ吐いてIN句でまとめてしまうのか(preload)、絞り込みをする必要があるからeager_loadを使うのか、主テーブルのレコード数が多くてIN句が大きくなりすぎるからpreloadは使わないのか、考えて使うようにしました。

### テスト
- 全体を通してのカバレッジは99%を維持しました。

## フロントエンド
- 二重クリックによる誤送信を、useRefを用いてフラグをたてて、通信が終わったら次のクリックをできるようにしました。
 
## インフラ
- Github Actionsを用い
