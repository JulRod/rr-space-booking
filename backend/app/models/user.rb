class User < ApplicationRecord
  include Activatable

  # Include Rails authentication
  has_secure_password

  # Associations
  belongs_to :company

  # Enums for role management
  enum role: {
    employee: 1,
    manager: 2,
    admin: 3
  }

  # Validations
  validates :email, presence: true,
            length: { maximum: 100 },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { scope: :company_id,
                         message: "already exists in this company" }

  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }

  validates :company_id, presence: true

  # Scopes (for querying/filtering records)
  scope :by_company, ->(company) { where(company: company) }
  scope :by_role, ->(role) { where(role: role) }

  # Callbacks
  before_validation :normalize_email

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    full_name.present? ? full_name : email
  end

  # Authorization helpers - all actions scoped to same company
  def can_manage_users?(target_user = nil)
    return false unless admin?
    return true if target_user.nil?

    same_company?(target_user)
  end

  def can_manage_company?(target_company = nil)
    return false unless admin?
    return true if target_company.nil?

    company_id == target_company&.id
  end

  def can_book_for_others?(target_user = nil)
    return false unless admin? || manager?
    return true if target_user.nil?

    same_company?(target_user)
  end

  def same_company?(other_user)
    company_id == other_user&.company_id
  end

  private

  def normalize_email
    self.email = email&.downcase&.strip
  end
end
