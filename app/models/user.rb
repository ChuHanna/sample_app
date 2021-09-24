class User < ApplicationRecord
  # de chuan hoa su ton tai cho name va email
  VALID_EMAIL_REGEX = Settings.valid

  before_save :downcase_email

  validates :email, presence: true,
    length: {minimum: Settings.min_email, maximum: Settings.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.max_name}
  # if :password chi validate password chi khi password thay doi khi cap nhap
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.min_pass}

  private
  def downcase_email
    self.email = email.downcase
  end
end
