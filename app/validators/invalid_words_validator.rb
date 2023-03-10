# frozen_string_literal: true

class InvalidWordsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, :contain_invalid_regex) if url_and_sign_validator(value)

    record.errors.add(attribute, :contain_same_words) if same_words_validator(value)

    record.errors.add(attribute, :contain_blacklist_words) if blacklist_words_validator(value)
  end

  private

    def url_and_sign_validator(value)
      invalid_regex = {
        url_regex: %r{https?://[\w/:%#{Regexp.last_match(0)}?()~.=+-]+},
        html_regex: /<(".*?"|'.*?'|[^'"])*?>/
      }
      invalid_regex.any? { |_invalid_key, invalid_value| invalid_value.match?(value) }
    end

    def same_words_validator(value)
      same_words_regex = /(.)\1{4,}/
      value.match?(same_words_regex)
    end

    def blacklist_words_validator(value)
      blacklist = YAML.load_file("./config/blacklist.yml")
      blacklist.any? { |word| value.include?(word) }
    end
end
