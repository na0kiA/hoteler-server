# frozen_string_literal: true

module RequestSpecHelper
  def symbolized_body(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
