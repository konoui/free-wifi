require 'rails_helper'
require 'spec_helper'

RSpec.describe Parameter, type: :model do
  describe "validチェック" do
    context "全てvalidの時" do
      before do
        @parameter = build(:parameter)
      end
      example "valid" do
        expect(@parameter).to be_valid
      end
      example "radiusはデフォルト500" do
        expect(@parameter.radius).to eq(500)
      end
      example "limitのデフォルトは5" do
        expect(@parameter.limit).to eq(5)
      end
      example "langはデフォルトja" do
        expect(@parameter.lang).to eq('ja')
      end
    end

    describe "#lon" do
      example "180以下ならvalid" do
        parameter = build(:parameter, :lon => "180")
        expect(parameter).to be_valid
      end
      example "-180以上ならvalid" do
        parameter = build(:parameter, :lon => "-180")
        expect(parameter).to be_valid
      end
      example "数字と文字を含んでいてもlonの範囲内ならvalid" do
        parameter = build(:parameter, :lon => "180aa")
        expect(parameter).to be_valid
      end
    end

    describe "#lat" do
      example "90以下ならvalid" do
        parameter = build(:parameter, :lat => "90")
        expect(parameter).to be_valid
      end
      example "-90以上ならvalid" do
        parameter = build(:parameter, :lat => "-90")
        expect(parameter).to be_valid
      end
      example "数字と文字を含んでいてもlatの範囲内ならvalid" do
        parameter = build(:parameter, :lat => "90aaa")
        expect(parameter).to be_valid
      end
    end

    describe "#radius" do
      example "0以上ならvalid" do
        parameter = build(:parameter, :radius => "0")
        expect(parameter).to be_valid
      end
      example "MAX_RADIUS以下ならvalid" do
        parameter = build(:parameter, :radius => "10000")
        expect(parameter).to be_valid
      end
      context "文字列の時" do
        before do
          @parameter = build(:parameter, :radius => "test12")
        end
        example "valid" do
          expect(@parameter).to be_valid
        end
        example "デフォルト値500" do
          expect(@parameter.radius).to eq(500)
        end
      end
    end

    describe "#limit" do
      example "0以上ならvalid" do
        parameter = build(:parameter, :limit => "0", )
        expect(parameter).to be_valid
      end
      example "MAX_LIMIT以下ならvalid" do
        parameter = build(:parameter, :limit => "20", )
        expect(parameter).to be_valid
      end
      context "文字列の時" do
        before do
          @parameter = build(:parameter, :limit => "TEST12", )
        end    
        example "valid" do
          expect(@parameter).to be_valid
        end
        example "デフォルト値5" do
          expect(@parameter.limit).to eq(5)
        end
      end
      example "整数部分がMAX_LIMIT以下ならvalid" do
        parameter = build(:parameter, :limit => "20.7", )
        expect(parameter).to be_valid
      end
    end
  
    describe "#lang" do
      example "langがjaならvalid" do
        parameter = build(:parameter, :lang => "ja")
        expect(parameter).to be_valid
      end
      example "langがenならvalid" do
        parameter = build(:parameter, :lang => "en")
        expect(parameter).to be_valid
      end
    end   
  end

  
  describe "invalidチェック" do
    describe "#lon" do
      example "文字ならinvalid" do
        parameter = build(:parameter, :lon => "TEST123")
        expect(parameter).not_to be_valid
      end
      example  "nilならinvalid" do
        parameter = build(:parameter, :lon => nil)
        expect(parameter).not_to be_valid
      end
      example "180を超えたならinvalid" do
        parameter = build(:parameter, :lon => "180.01")
        expect(parameter).not_to be_valid
      end
      example "-180未満ならinvalid" do
        parameter = build(:parameter, :lon => "-180.01")
        expect(parameter).not_to be_valid
      end
    end

    describe "#lat" do
      example "文字ならinvalid" do
        parameter = build(:parameter, :lat => "TEST123")
        expect(parameter).not_to be_valid
      end
      example "nilならinvalid" do
        parameter = build(:parameter, :lat => nil)
        expect(parameter).not_to be_valid
      end
      example  "90超えたならinvalid" do
        parameter = build(:parameter, :lat => "90.01")
        expect(parameter).not_to be_valid
      end
      example  "-90未満ならinvalid" do
        parameter = build(:parameter, :lat => "-90.01")
        expect(parameter).not_to be_valid
      end
    end

    describe "#radius" do
      example "0未満ならinvalid" do
        parameter = build(:parameter, :radius => "-1")
        expect(parameter).not_to be_valid
      end
      example "MAX_RADIUSを超えるならinvalid" do
        parameter = build(:parameter, :radius => "100001")
        expect(parameter).not_to be_valid
      end
    end

    describe "#limit" do
      example "0未満ならinvalid" do
        parameter = build(:parameter, :limit => "-1")
        expect(parameter).not_to be_valid
      end
      example "MAX_LIMITを超えるならinvalid" do
        parameter = build(:parameter, :limit => "21")
        expect(parameter).not_to be_valid
      end
    end
 
    describe "#lang" do
      example "jaまたはen以外はinvalid" do
         parameter = build(:parameter, :lang => "aa")
         expect(parameter).not_to be_valid
      end
    end
  end
end
