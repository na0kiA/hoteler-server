# class FiveStarRateValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value)
#     return if value.blank?

#     record.errors.add(attribute, :only_five_decimal_places) if only_five_decimal_places(value)
#   end

#   private

#   def only_five_decimal_places(value)
#     # only_five_decimal_regex = /\.[1-4,6-9]/
#     only_five_decimal_regex = /[+-]?\d+/
#     # value.match?(only_five_decimal_regex)
#     only_five_decimal_regex =~ value
#   end
# end
