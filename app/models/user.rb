# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :hotels, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :days, through: :hotels
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :send_notifications,
           class_name: "Notification",
           foreign_key: "sender_id",
           inverse_of: "sender",
           dependent: :destroy

  # after_commit :insart_a_default_key_when_create, on: %i[create]

  validates :name, length: { maximum: 10 }, presence: true, invalid_words: true

    # def insart_a_default_key_when_create
    #   User.update!(image: "uploads/hoteler/4786f605-a290-4849-929f-cafbacb46beb/blank-profile-picture-g89cfeb4dc_640.png")
    # end
end
