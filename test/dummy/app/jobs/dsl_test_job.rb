# frozen_string_literal: true

class DslTestJob < ApplicationJob
  repeat every: 1.day

  def perform
    Rails.logger.info 'dsl'
  end
end
