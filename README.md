# anime-info-api

[https://github.com/kazama1209/simple-anime-database](https://github.com/kazama1209/simple-anime-database)

↑で使用するための自作API。現状、アニメの情報を体系的に取得できるサービスがほとんど存在しないため、スクレイピングなども絡めて扱いやすいデータに整形している。

## セットアップ

gemをインストール。

```
$ bundle install --path vendor/bundle
```

Sinatraを起動。

```
$ ruby app.rb
```

各API（anime_details、schedule）にアクセス。

```
http://localhost:4567/api/anime_details?tid=2077

→ {"staffs":[{"role":"原作","name":"Magica Quartet"},{"role":"監督","name":"新房昭之"},{"role":"キャラクター原案","name":"蒼樹うめ"},{"role":"キャラクターデザイン","name":"岸田隆宏"},{"role":"シリーズ構成・脚本","name":"虚淵玄"},{"role":"シリーズディレクター","name":"宮本幸裕"},{"role":"総作画監督","name":"谷口淳一郎"},{"role":"アクションディレクター","name":"阿部望"},{"role":"レイアウト設計","name":"牧孝雄"},{"role":"異空間設計","name":"劇団イヌカレー"},{"role":"美術監督","name":"稲葉邦彦"},{"role":"美術設定","name":"大原盛仁"},{"role":"色彩設計","name":"日比野仁"},{"role":"ビジュアルエフェクト","name":"酒井基"},{"role":"撮影監督","name":"江藤慎一郎"},{"role":"編集","name":"松原理恵"},{"role":"音響監督","name":"鶴岡陽太"},{"role":"音響制作","name":"楽音舎"},{"role":"音楽","name":"梶浦由記"},{"role":"音楽制作","name":"アニプレックス"},{"role":"アニメーション制作","name":"SHAFT"},{"role":"製作","name":"Magica Partners"}],"casts":[{"character":"鹿目まどか","name":"悠木碧"},{"character":"暁美ほむら","name":"斎藤千和"},{"character":"巴マミ／鹿目タツヤ","name":"水橋かおり"},{"character":"美樹さやか","name":"喜多村英梨"},{"character":"佐倉杏子","name":"野中藍"},{"character":"キュゥべえ","name":"加藤英美里"},{"character":"志筑仁美","name":"新谷良子"},{"character":"鹿目詢子","name":"後藤邑子"},{"character":"鹿目知久","name":"岩永哲哉"},{"character":"上条恭介","name":"吉田聖子"},{"character":"早乙女和子","name":"岩男潤子"}]}
```

```
http://localhost:4567/api/schedule?span=1

→ [{"title":"SDガンダムワールド ヒーローズ","sub_title":"正義を呼ぶ声","st_time":"2021-04-20 22:29:00 +0900","ed_time":"2021-04-20 23:00:00 +0900","ch_name":"TOKYO MX","ch_id":19},{"title":"転生したらスライムだった件 転スラ日記","sub_title":"ジュラの夏","st_time":"2021-04-20 23:00:00 +0900","ed_time":"2021-04-20 23:30:00 +0900","ch_name":"TOKYO MX","ch_id":19},{"title":"聖女の魔力は万能です","sub_title":"王都","st_time":"2021-04-21 00:30:00 +0900","ed_time":"2021-04-21 01:00:00 +0900","ch_name":"TOKYO MX","ch_id":19},{"title":"お願い！ランキング","sub_title":"声優コレクション ゲスト：小林由美子、森川智之","st_time":"2021-04-21 00:50:00 +0900","ed_time":"2021-04-21 01:20:00 +0900","ch_name":"テレビ朝日","ch_id":6},{"title":"りばあす","sub_title":"私達の三位一体","st_time":"2021-04-21 01:00:00 +0900","ed_time":"2021-04-21 01:05:00 +0900","ch_name":"TOKYO MX","ch_id":19},{"title":"BLACK LAGOON","sub_title":"Die Rückkehr des Adlers","st_time":"2021-04-21 01:05:00 +0900","ed_time":"2021-04-21 01:35:00 +0900","ch_name":"TOKYO MX","ch_id":19},{"title":"ガールガンレディ","sub_title":"","st_time":"2021-04-21 01:28:00 +0900","ed_time":"2021-04-21 01:58:00 +0900","ch_name":"TBS","ch_id":5},{"title":"擾乱 THE PRINCESS OF SNOW AND BLOOD","sub_title":"機密事項六一四シシシンチュウムシ","st_time":"2021-04-21 01:29:00 +0900","ed_time":"2021-04-21 01:59:00 +0900","ch_name":"日本テレビ","ch_id":4},{"title":"ドラゴンボール改","sub_title":"命をかけた闘い！悟空とピッコロ捨て身の猛攻","st_time":"2021-04-21 01:35:00 +0900","ed_time":"2021-04-21 02:05:00 +0900","ch_name":"フジテレビ","ch_id":3},{"title":"ウソかホントかわからない やりすぎ都市伝説 ザ・ドラマ","sub_title":"きさらぎ駅","st_time":"2021-04-21 01:35:00 +0900","ed_time":"2021-04-21 02:05:00 +0900","ch_name":"テレビ東京","ch_id":7},{"title":"HUNTER×HUNTER(2011)","sub_title":"カイブツ×ト×カイブツ","st_time":"2021-04-21 01:59:00 +0900","ed_time":"2021-04-21 02:29:00 +0900","ch_name":"日本テレビ","ch_id":4}]
```

- tid: [しょぼいカレンダー](https://cal.syoboi.jp/) のタイトルID
- span: 何日先までの情報を取得するか指定（1→ 1日）

## デプロイ

S3バケット（デプロイ用のコード置き場）を作成。

参照: [AWS S3のバケットの作り方](https://qiita.com/miriwo/items/41e488b79fb58fa7c952)

デプロイ用のコードをパッケージング。

```
$ docker-compose up
```

Lambda関数とAPI Gatewayを作成。

```
$ aws cloudformation package \                                                   
     --template-file template.yaml \
     --output-template-file serverless-output.yaml \
     --s3-bucket <S3バケット名> --profile <AWS CLIのプロフィール名>
```

すると、ディレクトリ内に「serverless-output.yaml」というファイルが自動生成されているはずなので、続いて次のコマンドを実行。

```
$ aws cloudformation deploy --template-file serverless-output.yaml \             
     --stack-name <任意のスタック名> \
     --capabilities CAPABILITY_IAM --profile <AWS CLIのプロフィール名>
```

「Successfully」と表示されればデプロイ成功。

AWSコンソール画面から「Lambda」→「関数」と進むと先ほどデプロイした内容が表示されるので、「API Gateway」内に記載されているAPIエンドポイント（例https://********.execute-api.ap-northeast-1.amazonaws.com/Prod/api/anime_details?tid=2077）にアクセスし、無事レスポンスが返ってくればOK。
: 
