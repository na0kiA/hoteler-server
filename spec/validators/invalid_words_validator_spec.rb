require 'rails_helper'

RSpec.describe InvalidWordsValidator, type: :model do
  describe 'validators/invalid_words_validator.rb #validate_each' do
    before do
      mock.valid?
    end

    let(:mock) { build_validator_mock.new(attribute: value) }

    context 'ブラックリストに検出される場合' do
      let(:value) { '<><><><><>' }

      it 'エラーメッセージが表示されること' do
        puts mock
        expect(mock).to be_invalid

        p mock.errors
        p mock.errors.messages
        expect(mock.errors.added?(:attribute, :contain_invalid_regex)).to be_truthy
      end
    end
  end
end
