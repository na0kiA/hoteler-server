# frozen_string_literal: true

class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :rest_rates, through: :days, dependent: :destroy
  has_many :stay_rates, through: :days, dependent: :destroy
  has_many :special_periods, through: :days, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user, dependent: :destroy
  has_many :reviewer, through: :reviews, source: :user, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, length: { maximum: 50 }, presence: true, invalid_words: true
  validates :content, length: { minimum: 10, maximum: 2000 }, presence: true, invalid_words: true
  validates :prefecture, length: { maximum: 10 }, presence: true, invalid_words: true
  validates :city, length: { maximum: 10 }, presence: true, invalid_words: true
  validates :street_address, length: { maximum: 50 }, presence: true, invalid_words: true
  validates :phone_number, length: {  maximum: 13 }, presence: true, invalid_words: true
  validates :company, length: { maximum: 30 }, presence: true, invalid_words: true

  after_commit :create_days, on: %i[create]

  DAY_OF_THE_WEEK = %w[月曜から木曜 金曜 土曜 日曜 祝日 祝前日 特別期間].freeze

  def send_notification_when_update(hotel_manager:, user_id_list:, hotel_id:, message:)
    user_id_list.each do |id|
      hotel_manager.send_notifications.create(kind: "hotel_updates", message:, user_id: id, hotel_id:)
    end
  end

  private

    def create_days
      Day.create(generate_days_hash)
    end

    def generate_days_hash
      hash = {}
      DAY_OF_THE_WEEK.each do |val|
        hash = { day: val, hotel_id: id }
      end
      hash
    end
end
