# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :lockable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :hotels, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy
  has_many :days, through: :hotels
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :send_notifications,
           class_name: "Notification",
           foreign_key: "sender_id",
           inverse_of: "sender",
           dependent: :destroy
end
