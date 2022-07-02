require 'rails_helper'

RSpec.describe User, type: :model do
  describe "has_many #hotels" do
    let_it_be(:user) { create(:user) }
    context "userを削除した場合" do
      it "userを削除したときuserが投稿したhotelsも削除されること" do
        user.hotels.create(name: "Hotel_name", content: "Hotel_content")
        expect { user.destroy }.to change(Hotel, :count).by(-1)
      end
    end
  end
end
