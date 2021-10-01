class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  # tao ra ma xac thuc dong thoi thuc hien luu ca doan ma hoa cua ma xac thuc
  before_create :create_activation_digest
  # de chuan hoa su ton tai cho name va email
  VALID_EMAIL_REGEX = Settings.valid

  PROPERTIES = %i(name email password password_confirmation).freeze
  PASSWORD_PARAMS = %i(password password_confirmation)
  validates :email, presence: true,
    length: {minimum: Settings.min_email, maximum: Settings.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.max_name}
  # if :password chi validate password chi khi password thay doi khi cap nhap
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.min_pass},
            allow_nil: true

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine.min_cost
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  # tao ra doan ma token gan vao reset token
  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.hours_pass_expired.hours.ago
  end

  private
  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
