# frozen_string_literal: true

class YamlTestJob < ApplicationJob
  def perform
    Rails.logger.info 'scheduled a job from yaml config'
  end
end
