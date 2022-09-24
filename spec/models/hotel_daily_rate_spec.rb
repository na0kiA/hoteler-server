require 'rails_helper'

RSpec.describe ReviewEdit, type: :model do
  describe 'models/review_edit.rb #update' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
  end
end
