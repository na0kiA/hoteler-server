# require 'rails_helper'

# RSpec.describe FiveStarRateValidator, type: :model do
#   describe 'validators/five_star_ratevalidator.rb #validate_each' do
#     before do
#       mock.valid?
#     end

#     let(:mock) { build_validator_mock.new(attribute: value) }

#     context '正常な場合' do
#       let(:value) { 3.5 }

#       it 'バリデーションをパスすること' do
#         expect(mock).to be_valid
#       end
#     end

#     context '小数点第一位が .5 以外の場合' do
#       let(:value) { 3.4 }

#       it 'エラーが返ること' do
#         expect(mock).to be_invalid
#         expect(mock.errors).to be_added(:attribute, :only_five_decimal_places)
#       end
#     end
#   end
# end
