# frozen_string_literal: true

class MultiMailer < ActionMailer::Base
  repeat :testing, 'every day', each: -> { %w[foo bar] }
  def testing(name)
    mail to: "#{name}@example.com", subject: name
  end
end
