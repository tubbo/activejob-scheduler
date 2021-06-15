# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Mixin for mailers
    module Mailer
      extend ActiveSupport::Concern

      included do
        class_attribute :scheduler_events
      end

      class_methods do
        # Deliver an email on a regular basis in the background.
        #
        # @param [Symbol] mail - Mailer method to deliver
        # @param [String] nat - Natural language text
        # @param [Array] arguments - Args to pass to the mailer method
        def repeat(mail, nat = nil, arguments: [], each: nil, **interval)
          interval = { nat: nat } if nat.present?
          self.scheduler_events ||= []
          self.scheduler_events << {
            name: "#{name}##{mail}",
            class_name: name,
            arguments: arguments,
            interval: interval,
            mail: mail,
            each: each
          }
        end
      end
    end
  end
end
