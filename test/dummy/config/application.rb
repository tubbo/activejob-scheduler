# frozen_string_literal: true

require File.expand_path('boot', __dir__)

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require 'active_job/scheduler'

module Dummy
  class Application < Rails::Application
  end
end
