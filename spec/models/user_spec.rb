require 'rails_helper'

RSpec.describe User, type: :model do
  describe "has_many #hotels" do
    let!(:user) { create(:user)}
    let!(:hotel) { create(:hotel)}

    context "userを削除した場合" do
      it "userを削除したときuserが投稿したhotelsも削除されること" do
        expect
      end
    end
  end
end
