require 'rails_helper'

RSpec.describe "V1::Images", type: :request do
  describe "GET /v1/images - v1/images#signed_url" do
    context "ログインしている場合" do
      it "署名付きURLを発行できること" do

      end
    context "ログインしていない場合" do
      it "署名付きURLを発行できないこと" do

      end
    end

    describe "GET /v1/images - v1/images#save_hotel_key" do
      it "KeyをImagesテーブルのhotel_s3_keyカラムに保存できること" do
        
      end
      it "KeyをImagesテーブルのuser_s3_keyカラムに保存できること" do

      end
    end
  end


















end