# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :lockable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :hotels, dependent: :nullify
  has_many :helpfulnesses, dependent: :destroy
end
