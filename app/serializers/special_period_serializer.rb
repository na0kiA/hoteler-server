# frozen_string_literal: true

class SpecialPeriodSerializer < ActiveModel::Serializer
  attribute :id
  attribute :period
  attribute :start_date
  attribute :end_date
  attribute :day_id
  attribute :service_id do
    object.id
  end

  def period
    return "お盆" if object.period == "obon"
    return "年末年始" if object.period == "the_new_years_holiday"
    return "GW" if object.period == "golden_week"
  end

  def start_date
    convert_at_hour(date: object.start_date)
  end

  def end_date
    convert_at_hour(date: object.end_date)
  end

  private

    def convert_at_hour(date:)
      (I18n.l date, format: :long)
    end
end
