# frozen_string_literal: true

class MultiJob < ActiveJob::Base
  repeat 'every day', each: -> { %w[foo bar] }

  def perform
    true
  end
end
