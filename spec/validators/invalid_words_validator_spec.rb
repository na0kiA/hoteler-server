# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvalidWordsValidator, type: :model do
  describe 'validators/invalid_words_validator.rb #validate_each' do
    before do
      mock.valid?
    end

    let(:mock) { build_validator_mock.new(attribute: value) }

    context '正常な場合' do
      let(:value) { 'よかったです' }

      it 'バリデーションをパスすること' do
        expect(mock).to be_valid
      end
    end

    context 'ブラックリストに検出される場合' do
      let(:value) { 'うんち' }

      it 'エラーが返ること' do
        expect(mock).to be_invalid
        expect(mock.errors).to be_added(:attribute, :contain_blacklist_words)
      end
    end

    context '同じ文字が5文字以上続いた場合' do
      let(:value) { 'aaaaaaaaaa' }

      it 'エラーが返ること' do
        expect(mock).to be_invalid
        expect(mock.errors).to be_added(:attribute, :contain_same_words)
      end
    end

    context 'URLを入力した場合' do
      let(:value) { 'http://example.com' }

      it 'エラーが返ること' do
        expect(mock).to be_invalid
        expect(mock.errors).to be_added(:attribute, :contain_invalid_regex)
      end
    end

    context 'HTMLタグを入力した場合' do
      let(:value) { '<><><><><>' }

      it 'エラーが返ること' do
        expect(mock).to be_invalid
        expect(mock.errors).to be_added(:attribute, :contain_invalid_regex)
      end
    end
  end
end
