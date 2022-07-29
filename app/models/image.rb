class Image < ApplicationRecord
  # belongs_to :hotel
  # has_one :user
  # has_one :hotel
  belongs_to :user

  belongs_to :hotel
end
