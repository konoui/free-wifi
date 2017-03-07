require 'rails_helper'
require "spec_helper"

RSpec.describe Api::V1::SpotsController, type: :controller do
  describe "GET api/v1/spots/json?" do
    example "HTTPレスポンスが200" do
      get :json
      expect(response.status).to eq 200
    end

    describe "status" do
      example  "正常なリクエストではOKを返す" do
        get :json, attributes_for(:parameter)
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json['status']).to eq("OK")
      end
      example "エラーリクエストではBad Requestを返す" do
        get :json, attributes_for(:parameter, :lon => nil)
        json = JSON.parse(response.body)
        expect(json['status']).to eq("Bad Request")
      end
    end

    describe "results" do
      example "正常なリクエストではresultsを返す" do
        get :json, attributes_for(:parameter)
        json = JSON.parse(response.body)
        expect(json.has_key?("results")).to eq true
      end
      example "エラーリクエストではresultsを返す" do
        get :json, attributes_for(:parameter, :lon => nil)
        json = JSON.parse(response.body)
        expect(json.has_key?("results")).to eq true
      end
    end

    describe "errors" do
      example "正常なリクエストではerrorsを返さない" do
        get :json, attributes_for(:parameter)
        json = JSON.parse(response.body)
        expect(json.has_key?("errors")).to eq false
      end
      example "エラーリクエストではerrorsを返す" do
        get :json, attributes_for(:parameter, :lon => nil)
        json = JSON.parse(response.body)
        expect(json.has_key?("errors")).to eq true
      end 
    end

    describe "resultsのフィールド" do
      before do
        @parameter = attributes_for(:parameter)
        @spot = create(:spot, :lonlat => "POINT(#{@parameter[:lon]} #{@parameter[:lat]})")
        get :json, @parameter
        @json = JSON.parse(response.body) 
      end
      example "lonlatを取得できる" do
        expect(@json["results"][0]["longitude"]).to eq(@parameter[:lon].to_f)
        expect(@json["results"][0]["latitude"]).to eq(@parameter[:lat].to_f)
      end
      example "distanceを取得できる" do
        expect(@json["results"][0]["distance"]).to eq(0)
      end
      example "ssidを取得できる" do
        expect(@json["results"][0]["ssid"]).to eq(@spot.ssid)
      end
      example "spot_nameを取得できる" do
        expect(@json["results"][0]["spot_name"]).to eq(@spot.ja_spot_name)
      end
      example "addressを取得できる" do
        expect(@json["results"][0]["address"]).to eq(@spot.ja_address)
      end
      example "business_hoursを取得できる" do
        expect(@json["results"][0]["business_hours"]).to eq(@spot.business_hours)
      end
      example "restrictionを取得できる" do
        expect(@json["results"][0]["restriction"]).to eq(@spot.restriction)
      end
      example "proceduresを取得できる" do
        expect(@json["results"][0]["procedures"]).to eq(@spot.procedures)
      end
    end

    describe "resutlsの件数" do
      before do
        parameter = build(:parameter)
        spots = create_list(:spot, 50, :lonlat => "POINT(#{parameter.lon} #{parameter.lat})")
      end
      example "デフォルト5件取得" do
          get :json, attributes_for(:parameter, :limit => nil)
          json = JSON.parse(response.body)
          expect(json["results"].length).to eq(5)
      end
      example "10件取得" do
          get :json, attributes_for(:parameter, :limit => "10")
          json = JSON.parse(response.body)
          expect(json["results"].length).to eq(10)
      end
      example "MAX_LIMIT件T取得" do
          get :json, attributes_for(:parameter, :limit => "20")
          json = JSON.parse(response.body)
          expect(json["results"].length).to eq(20)
      end
    end

    describe "distanceの値" do
      before do
        # 成田国際空港の緯度経度を使用
        @parameter = attributes_for(:parameter, :radius => "10000")
        # spot => 成田国際空港駅の緯度経度を使用
        @spot = create(:spot, :ja_spot_name => "成田空港駅", :lonlat => "POINT(140.3838938 35.76381035)")
      end
      example "distance誤差が1m以内" do
        get :json, @parameter
        json = JSON.parse(response.body)
        require "#{Rails.root.to_s}/file/lonlat"
        include LonLat
        # ヒュベニの公式を用いて2点間の距離を計算
        # APIの性質上，10km以上離れた情報は取得しないと仮定し，
        # ヒュベニの公式の精度で十分であると考える
        expected = LonLat.dist(json["results"][0]["longitude"], json["results"][0]["latitude"], @parameter[:lon], @parameter[:lat])
        # 成田国際空港から成田国際空港駅のスポットまでの距離の誤差を求める
        expect(json["results"][0]["spot_name"]).to eq("成田空港駅")
        expect(json["results"][0]["distance"]).to be_within(1).of(expected)
      end
      example "distanceの値の小さい順に表示" do
        # spot2 => 成田国際空港の緯度経度を使用
        spot2 = create(:spot)
        # spot3 => SAT株式会社の緯度経度を使用
        spot3 = create(:spot, :ja_spot_name => "SAT株式会社", :lonlat => "POINT(140.3977254 35.78850176)")
        get :json, @parameter
        json = JSON.parse(response.body)
        expect(json["results"][0]["distance"]).to be <= json["results"][1]["distance"]
        expect(json["results"][1]["distance"]).to be <= json["results"][2]["distance"]
      end 
    end

    describe "langによるレスポンス" do
      before do
        @parameter = attributes_for(:parameter)
        @spot = create(:spot, :lonlat => "POINT(#{@parameter[:lon]} #{@parameter[:lat]})")
      end
      example "jaなら日本語のスポット名と住所を返す" do
        get :json, @parameter
        json = JSON.parse(response.body)
        expect(json["results"][0]["spot_name"]).to eq(@spot[:ja_spot_name])
        expect(json["results"][0]["address"]).to eq(@spot[:ja_address])
      end
      example "enなら英語のスポット名と住所を返す" do
        @parameter[:lang] = "en"
        get :json, @parameter
        json = JSON.parse(response.body)
        expect(json["results"][0]["spot_name"]).to eq(@spot[:en_spot_name])
        expect(json["results"][0]["address"]).to eq(@spot[:en_address])
      end
    end
  end
end
