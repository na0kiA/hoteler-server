# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  context '通知が複数存在する場合' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:with_user_completed_hotel) }
    let_it_be(:favorite) { create(:favorite, hotel: accepted_hotel, user: client_user) }
    let_it_be(:notification) { create(:notification, :with_hotel_updates, user: client_user, sender: accepted_hotel.user, hotel: accepted_hotel) }
    let_it_be(:other_notification) { create(:notification, :with_hotel_updates, user: client_user, sender: accepted_hotel.user, hotel: accepted_hotel) }

    it '全てのfalseのreadをtrueに更新できること' do
      read_notification = Notification.update_read(client_user.notifications)
      expect(read_notification.first.read).to be(true)
      expect(read_notification.last.read).to be(true)
    end
  end
end
