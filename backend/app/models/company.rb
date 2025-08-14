class Company < ApplicationRecord
  include Activatable

  # Associations
  has_many :users, dependent: :destroy

  # Validations
  validates :subdomain, presence: true, uniqueness: true,
            length: { maximum: 50 },
            format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/,
                     message: "only lowercase letters, numbers, and hyphens allowed" }

  validates :name, presence: true, length: { maximum: 100 }

  # Scopes
  scope :by_subdomain, ->(subdomain) { where(subdomain: subdomain) }

  # Callbacks
  before_validation :normalize_subdomain

  # Instance methods
  def to_s
    name
  end

  # Settings management (stored as JSON)
  def settings
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(super || "{}"))
  rescue JSON::ParserError
    ActiveSupport::HashWithIndifferentAccess.new
  end

  def settings=(value)
    super(value.to_json)
  end

  def update_setting(key, value)
    current_settings = settings
    current_settings[key] = value
    self.settings = current_settings
    save
  end

  private

  def normalize_subdomain
    self.subdomain = subdomain&.downcase&.strip
  end
end
