class User < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :teas, through: :entries
  has_secure_password

  # Active Storage attachment
  has_one_attached :avatar

  # Username validations
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_.-]+\z/, message: "can only contain letters, numbers, and the characters _ . -" }

  # Bio validations
  validates :bio, length: { maximum: 300 }

  # Avatar URL validations - optional but must be a valid URL if present
  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
                                   message: "must be a valid URL starting with http:// or https://" },
                         allow_blank: true

  # Password validations with regex for at least one uppercase, one lowercase, one number
  validates :password, presence: true,
                       length: { minimum: 8, message: "must be at least 8 characters long" },
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
                                 message: "must include at least one lowercase letter, one uppercase letter, and one number" },
                       allow_nil: true # has_secure_password already checks for presence on create

  # Normalize username before validation to handle case sensitivity properly
  before_validation :normalize_username

  # Method to get avatar image - either from Active Storage or URL
  def avatar_image
    if avatar.attached?
      avatar
    elsif avatar_url.present?
      avatar_url
    else
      nil
    end
  end

  private

  def normalize_username
    self.username = username.strip.downcase if username.present?
  end
end
