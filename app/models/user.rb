class User < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :teas, through: :entries

  has_secure_password

  # Active Storage attachment
  has_one_attached :avatar

  # Username validations
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-zA-Z0-9_.-]+\z/,
                      message: 'can only contain letters, numbers, and the characters _ . -' }

  # Bio validations
  validates :bio, length: { maximum: 300 }

  # Avatar URL validations – optional but, if present, must be a full http/https URL
  URL_REGEX = /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :avatar_url,
            format: { with: URL_REGEX,
                      message: 'must be a valid URL starting with http:// or https://' },
            allow_blank: true

  # Password validations – at least one lowercase, one uppercase, one digit, min eight chars
  VALID_PASSWORD_REGEX = /\A
    (?=.*[a-z])        # at least one lowercase letter
    (?=.*[A-Z])        # at least one uppercase letter
    (?=.*\d)           # at least one digit
    .{8,}     # only letters and digits, eight or more characters
  \z/x

  validates :password,
            allow_nil: true, # has_secure_password checks presence on create
            format: { with: VALID_PASSWORD_REGEX,
                      message: 'must be at least eight characters and include one uppercase letter, one lowercase letter, and one digit' }

  # Normalize username before validation to handle case sensitivity properly
  before_validation :normalize_username

  # Returns the avatar, choosing Active Storage attachment over remote URL if both exist
  def avatar_image
    if avatar.attached?
      avatar
    elsif avatar_url.present?
      avatar_url
    end
  end

  private

  def normalize_username
    self.username = username.strip.downcase if username.present?
  end
end
