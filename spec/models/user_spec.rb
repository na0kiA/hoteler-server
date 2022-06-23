require 'rails_helper'

RSpec.describe User, type: :model do
  describe "has_many #hotels" do
    let!(:user) { create(:user) }
    # let!(:hotel) { create(:hotel)}

    context "userを削除した場合" do
      it "userを削除したときuserが投稿したhotelsも削除されること" do
        user.hotels.create(name: "rada-tu", content: "this is")
        expect { user.destroy }.to change(Hotel, :count).by(-1)
      end
    end
  end
end
