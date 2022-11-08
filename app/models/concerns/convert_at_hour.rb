# frozen_string_literal: true
module ConvertAtHour
  extend ActiveSupport::Concern

  class_methods do
    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
  end
end
