# InvalidWordsValidatorの部分は先ほど付けた名前をキャメルケースにしたものを使う。
class InvalidWordsValidator < ActiveModel::EachValidator
  SAME_CHARACTER_REGEX = /(.)\1{4,}/
  def validate_each(record, _attribute, value)
    blacklist = YAML.load_file('./config/blacklist.yml')
    record.errors.add(:contain_blacklist_words, '暴力的もしくは卑猥なワードが含まれています') if value.present? && blacklist.any? { |word| value.include?(word) }

    record.errors.add(:contain_same_words, '同じ文字が5文字以上連続しています') if value.present? && value.match?(SAME_CHARACTER_REGEX)

    invalid_regex = {
      url_regex: %r{https?://[\w/:%#{Regexp.last_match(0)}?()~.=+\-]+},
      html_regex: /<(".*?"|'.*?'|[^'"])*?>/
    }

    record.errors.add(:contain_invalid_regex, '無効な記号やURLが含まれています') if value.present? && invalid_regex.any? { |_invalid_key, invalid_value| invalid_value.match?(value) }
  end
end
