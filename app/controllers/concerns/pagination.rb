# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  def resources_with_pagination(records)
    {
      total_count: records.total_count,
      limit_value: records.limit_value,
      total_pages: records.total_pages,
      prev_page: records.prev_page,
      next_page: records.next_page,
      current_page: records.current_page,
      first_page: records.first_page?,
      last_page: records.last_page?,
      out_of_range: records.out_of_range?
    }
  end
end
