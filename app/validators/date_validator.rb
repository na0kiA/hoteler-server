# frozen_string_literal: true
# # frozen_string_literal: true

# class DateValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value)
#     return if value.blank?

#     record.errors.add(attribute, :invalida_date) unless /\A\d{1,4}-\d{1,2}-\d{1,2}\Z/.match?(I18n.l(value))
#   end
# end
