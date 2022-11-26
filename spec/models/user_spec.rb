# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "has_many #hotels" do
    let_it_be(:user) { create(:user) }
    context "userを削除した場合" do
      it "userを削除したときuserが投稿したhotelsは削除されること" do
        create(:accepted_hotel, user:)
        expect { user.destroy }.to change(Hotel, :count).by(-1)
      end
    end
  end
end
