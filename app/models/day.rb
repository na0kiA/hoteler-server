class Day < ApplicationRecord
  belongs_to :hotel
  has_many :rest_rates, dependent: :dependent
end
