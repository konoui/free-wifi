Free Wi-Fi API
====

## Description
ユーザの現在位置が緯度経度として与えられたときに，その付近の無料Wi-Fiスポットの情報を返します．

## 仕様

### エンドポイント
`http://localhost/api/v1/spots/json`

### リクエスト形式
`http://localhost/api/v1/spots/json?paramters`   
パラメータには、必須パラメータと省略可能なパラメータがあります．パラメータはアンパサンド（&）文字を使用して区切ります．

### パラメータ
##### 必須パラメータ
- `lon` - 経度を表します．数字以外は指定しないでください．
- `lat` - 緯度を表します．数字以外は指定しないでください．

##### 省略可能パラメータ
- `radius` - 半径を表します．指定された半径[m]以内に存在するFree Wi-Fiスポットの情報を返します．
    * - デフォルト値: `500`，最大値: `10000`
- `limit` - レスポンスの件数を表します．指定された件数のFree Wi-Fiスポットの情報を返します．
    * - デフォルト値: `5`, 最大値: `20`
- `lang` - 施設名および住所を返す言語を表します．
    * - デフォルト言語 日本語: `ja`，指定可能言語 英語: `en`

### レスポンス
JSON形式のレスポンスを返します．   
レスポンスは，結果を表す `results`フィールドとステータスコードを表す`status`フィールドから成り立ちます．        
リクエストが正常な場合は，ステータスコード"OK"を返します．   
リクエストがエラーの場合は，ステータスコード"Bad Request"を返します．    
エラーの場合，エラー内容を表す`errors`が含まれることがあります．   

リクエストが正常な例    
`$ curl localhost:3000/api/v1/spots/json?lon=140.3845965\&lat=35.76410755`

```json
{
  "results": [
    {
      "spot_name": "成田国際空港",
      "address": "千葉県成田市三里塚字御料牧場1-1",
      "business_hours": "NoData",
      "restriction": "unlimited to re-entry",
      "procedures": "to select the SSID, and to agree to the Terms of Use",
      "ssid": "FreeWiFi-NARITA",
      "longitude": 140.3845965,
      "latitude": 35.76410755,
      "distance": 0.0
    },
    {
      "spot_name": "成田空港駅",
      "address": "千葉県成田市三里塚御料牧場",
      "business_hours": "NoData",
      "restriction": "3hours/per entry",
      "procedures": "to register your e-mail address",
      "ssid": "JR-EAST_FREE_Wi-Fi",
      "longitude": 140.3838938,
      "latitude": 35.76381035,
      "distance": 71.592798838
    }
  ],
  "status": "OK"
}
```
#### 結果
レスポンスの結果は，results配列内に格納されます．   
返す結果がない場合でも，空のresults配列が返されます．   
結果には，次のフィールドが含まれます．
- `spot_name` - 施設名を表します．
- `address` - 施設の住所を表します．
- `business_hours` - 営業時間を表します．
- `restriction` - 利用時間・回数等を表します．
- `procedures` - 利用するにあたっての利用手続きを表します．
- `ssid` - SSIDの名称を表します．
- `longitude` - 施設の経度を表します．
- `latitude` - 施設の緯度を表します．
- `distance` - 与えられた緯度経度から施設までの距離[m]を表します．

リクエストがエラーの例

`$ curl http://localhost:3000/api/v1/spots/json`

```json
{
  "results": [

  ],
  "status": "Bad Request",
  "errors": {
    "lon": [
      "can't be blank",
      "is not a number"
    ],
    "lat": [
      "can't be blank",
      "is not a number"
    ]
  }
}
```
## Install
`bundle install`   
`rake db:create`   
`rake db:gis:setup`   
`rake db:migrate`   
`rake db:seed`   
[](
空間インデックスを作成すると実行速度が速くなることがあります．   \
`CREATE INDEX gist_geotable on spots USING GIST (lonlat);`\
)
`rails s`   

### requirements
postgresql   
postgis 

## Testing
`rake db:test:prepare`    
`bundle exec rspec`

## 無料公衆無線ＬＡＮスポットのデータ（jta_free_wifi.csv）について
出典：歩行者移動支援サービスに関するデータサイト（ https://www.hokoukukan.go.jp/free_wifi.html ）    
「無料公衆無線ＬＡＮスポット」（国土交通省観光庁） （ https://www.hokoukukan.go.jp/download/jta_free_wifi.csv ）を加工して使用
