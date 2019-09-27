# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  repeat :daily_status, 'every day'
  def daily_status
    mail to: 'test@example.com', subject: 'Daily Status'
  end
end
