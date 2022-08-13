require 'rails_helper'

RSpec.describe Hotel, type: :model do
  # describe "models/hotel.rb #create!" do
  #   let_it_be(:user) { create(:user) }

  #   context "ホテルを作成できる場合" do
  #     it "paramsに必要項目が含まれていること" do
  #       expect do
  #         ActiveRecord::Base.transaction do
  #           hotel = described_class.new(name: "Trance", content: "Kobe Kitanosaka is location", user_id: user.id)
  #           hotel.save!
  #           hotel_images = HotelImage.new(hotel_id: hotel.id, key: "upload/test", file_url: "https://example/aws/s3")
  #           hotel_images.save!
  #         end
  #       end.to change(described_class, :count).by(1)
  #     end

  #     it "saveができること" do
  #       ActiveRecord::Base.transaction do
  #         hotel = described_class.new(name: "Trance", content: "Kobe Kitanosaka is location", user_id: user.id)
  #         expect { hotel.save! }.to change(described_class, :count).by(1)

  #         hotel_images = HotelImage.new(hotel_id: hotel.id, key: "upload/test2", file_url: "https://example/aws/s3/2")
  #         expect { hotel_images.save! }.to change(HotelImage, :count).by(1)
  #       end
  #     end
  #   end

  #   context "ホテルを作成できない場合" do
  #     it "hotel_imagesの保存に失敗した場合にRollbackすること" do
  #       expect do
  #         ActiveRecord::Base.transaction do
  #           hotel = described_class.new(name: "trance", content: "", user_id: user.id)
  #           hotel.save!
  #           hotel_images = HotelImage.new(hotel_id: "", key: "", file_url: "")
  #           hotel_images.save!
  #         end.to eq ["を入力してください"]
  #       end
  #     end
  #   end
  # end
end
