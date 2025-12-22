class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  def full_name
    [first_name, last_name].compact.join(' ').presence || email.split('@').first
  end

  # Send Devise emails asynchronously via Sidekiq
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
