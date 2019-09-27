# frozen_string_literal: true

class YamlTestJob < ActiveJob::Base
  def perform
    Rails.logger.info 'scheduled a job from yaml config'
  end
end
