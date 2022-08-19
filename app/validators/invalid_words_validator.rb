class InvalidWordsValidator < ActiveModel::EachValidator
  SAME_CHARACTER_REGEX = /(.)\1{4,}/
  def validate_each(record, attribute, value)
    blacklist = YAML.load_file('./config/blacklist.yml')
    record.errors.add(attribute, :contain_blacklist_words) if value.present? && blacklist.any? { |word| value.include?(word) }

    record.errors.add(attribute, :contain_same_words) if value.present? && value.match?(SAME_CHARACTER_REGEX)

    invalid_regex = {
      url_regex: %r{https?://[\w/:%#{Regexp.last_match(0)}?()~.=+\-]+},
      html_regex: /<(".*?"|'.*?'|[^'"])*?>/
    }
    record.errors.add(attribute, :contain_invalid_regex) if value.present? && invalid_regex.any? { |_invalid_key, invalid_value| invalid_value.match?(value) }
  end
end
