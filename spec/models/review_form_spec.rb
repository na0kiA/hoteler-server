# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewForm, type: :model do
  describe "models/review_form.rb #validation" do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    context "入力値が正常な場合" do
      it "titleとcontentとfive_star_rateが正常なこと" do
        params = { title: "よかったです", content: "部屋が綺麗", five_star_rate: 5 }
        review_form = described_class.new(attributes: params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect(review_form).to be_valid
      end

      it "titleが30文字、contentが1000文字、入力できること" do
        max_length_params = { title: "このホテル" * 6, content: "綺麗でした" * 200, five_star_rate: 5 }
        review_form = described_class.new(attributes: max_length_params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect(review_form).to be_valid
      end
    end

    context "入力値が異常な場合" do
      it "titleかcontentかfive_star_rateが無ければエラーを返すこと" do
        nil_params = { title: nil, content: nil, five_star_rate: nil }
        review_form = described_class.new(attributes: nil_params, hotel_id: accepted_hotel.id, user_id: user.id)
        review_form.valid?
        expect(review_form).to be_invalid
        expect(review_form.errors.messages[:title]).to eq ["タイトルを入力してください。", "タイトルは2文字以上入力してください。"]
        expect(review_form.errors.messages[:content]).to eq ["内容を入力してください。", "内容は5文字以上入力してください。"]
        expect(review_form.errors.messages[:five_star_rate]).to eq ["5つ星を入力してください。", "5つ星は1から5の整数のみです。"]
      end

      it "titleが51文字、contentが1001文字入力できないこと" do
        too_length_params = { title: "#{'このホテル' * 6}1", content: "#{'Hotel' * 200}1", five_star_rate: 5 }
        review_form = described_class.new(attributes: too_length_params, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_invalid
      end

      it "five_star_rateに小数点がつくと丸められること" do
        bad_five_star_rate = { title: "このホテル", content: "よかったです", five_star_rate: 4.9 }
        review_form = described_class.new(attributes: bad_five_star_rate, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_truthy
      end

      it "five_star_rateが0のとき失敗すること" do
        bad_five_star_rate = { title: "このホテル", content: "よかったです", five_star_rate: 0 }
        review_form = described_class.new(attributes: bad_five_star_rate, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_invalid
        expect(review_form.errors.messages[:five_star_rate]).to eq ["5つ星は1から5の整数のみです。"]
      end
    end
  end

  describe "models/review_form.rb #save" do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    context "正常に保存ができる場合" do
      it "口コミに画像がなくても保存できること" do
        not_image_params = {
          "title" => "よかったです",
          "content" => "コノホテルはよかったです",
          "five_star_rate" => 3,
          "hotel_id" => accepted_hotel.id,
          "user_id" => user.id
        }
        review_form = described_class.new(not_image_params)
        expect(review_form.save).to be true
        expect { review_form.save }.to change(Review, :count).by(1)
      end

      it "画像をつけるとReviewImageも更新されること" do
        include_image_params = {
          "title" => "よかったです",
          "content" => "コノホテルはよかったです",
          "five_star_rate" => 3,
          "key" => ["randum/secure/key", "key19982"],
          "hotel_id" => accepted_hotel.id,
          "user_id" => user.id
        }
        review_form = described_class.new(include_image_params)
        expect(review_form.save).to be true
        expect { review_form.save }.to change(Review, :count).by(1).and change(ReviewImage, :count).by(2)
      end

      it "Hotelのreview_countが1増えること" do
        params = {
          "title" => "よかったです",
          "content" => "コノホテルはよかったです",
          "five_star_rate" => 3,
          "hotel_id" => accepted_hotel.id,
          "user_id" => user.id
        }
        review_form = described_class.new(params)
        expect(review_form.save).to be true
        expect { review_form.save }.to change { Hotel.pluck(:reviews_count) }.from([1]).to([2])
      end
    end

    context "値が不正な場合" do
      it "returnで終了してnilを返すこと" do
        invalid_params = {
          "title" => "",
          "content" => "コノホテルはよかったです",
          "five_star_rate" => 3,
          "hotel_id" => accepted_hotel.id,
          "user_id" => user.id
        }
        review_form = described_class.new(invalid_params)
        expect(review_form.save).to be_nil
      end
    end
  end
end
