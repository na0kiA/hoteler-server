# frozen_string_literal: true

class V1::HealthCheckController < ApplicationController
  def index
    head :ok
  end
end