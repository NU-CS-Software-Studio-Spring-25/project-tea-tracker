class Tea < ApplicationRecord
  belongs_to :user  # Add this line
  has_many :entries
  has_many :users, through: :entries

  # Enhanced validations for all fields
  validates :name, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 1000 }
  validates :vendor, presence: true, length: { maximum: 100 }
  validates :known_for, presence: true, length: { maximum: 200 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1800, less_than_or_equal_to: -> { Date.current.year } }
  validates :region, presence: true, length: { maximum: 100 }
  validates :ship_from, presence: true, length: { maximum: 100 }
  validates :popularity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :shopping_platform, presence: true, length: { maximum: 100 }
  validates :product_url, presence: true, length: { maximum: 500 },
                        format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' },
                        allow_blank: true # Allow blank to prevent double validation errors

  # Define canonical categories as a class constant
  CANONICAL_CATEGORIES = %w[black green white oolong pu-erh herbal matcha rooibos].freeze

  # Normalize category to lowercase before validation
  before_validation :normalize_category

  # Returns true if category is one of the standard types
  def canonical_category?
    CANONICAL_CATEGORIES.include?(category)
  end

  # Suggestion for misspelled category (if within edit distance)
  def category_suggestion
    return nil if category.blank? || canonical_category?

    CANONICAL_CATEGORIES.min_by do |canonical|
      levenshtein_distance(category, canonical)
    end
  end

  private

  def normalize_category
    self.category = category.downcase.strip if category.present?
  end

  # Simple Levenshtein distance implementation for fuzzy matching
  def levenshtein_distance(s1, s2)
    m = s1.length
    n = s2.length

    # Handle edge cases
    return m if n == 0
    return n if m == 0

    # Create matrix
    d = Array.new(m+1) { Array.new(n+1) }

    # Initialize matrix
    (0..m).each { |i| d[i][0] = i }
    (0..n).each { |j| d[0][j] = j }

    # Calculate distances
    (1..n).each do |j|
      (1..m).each do |i|
        cost = (s1[i-1] == s2[j-1]) ? 0 : 1
        d[i][j] = [
          d[i-1][j] + 1,      # deletion
          d[i][j-1] + 1,      # insertion
          d[i-1][j-1] + cost  # substitution
        ].min
      end
    end

    d[m][n]
  end
end
