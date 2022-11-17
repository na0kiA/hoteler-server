# frozen_string_literal: true

class Helpfulness < ApplicationRecord
  belongs_to :review
  belongs_to :user
end
