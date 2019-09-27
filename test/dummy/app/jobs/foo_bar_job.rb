# frozen_string_literal: true

class FooBarJob < ActiveJob::Base
  def perform
    true
  end
end
