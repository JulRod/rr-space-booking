require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }

    # Custom test for scoped uniqueness since shoulda-matchers doesn't play well with our custom message
    it 'is not valid with duplicate email in the same company' do
      company = create(:company)
      create(:user, email: 'test@example.com', company: company)
      duplicate_user = build(:user, email: 'test@example.com', company: company)
      expect(duplicate_user).not_to be_valid
    end

    it 'adds error for duplicate email in the same company' do
      company = create(:company)
      create(:user, email: 'test@example.com', company: company)
      duplicate_user = build(:user, email: 'test@example.com', company: company)
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include('already exists in this company')
    end

    it { is_expected.to validate_length_of(:email).is_at_most(100) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    it { is_expected.to validate_presence_of(:company_id) }

    context 'when validating email format' do
      let(:company) { create(:company) }

      it 'accepts valid emails' do
        valid_emails = %w[test@example.com user.name@example.org user+tag@example.co.uk]
        valid_emails.each do |email|
          user = build(:user, email: email, company: company)
          expect(user).to be_valid, "#{email} should be valid, but got errors: #{user.errors.full_messages}"
        end
      end

      it 'rejects invalid emails' do
        invalid_emails = %w[invalid plainaddress @missingusername.com username@.com]
        invalid_emails.each do |email|
          user = build(:user, email: email, company: company)
          expect(user).not_to be_valid, "#{email} should be invalid"
        end
      end
    end

    context 'when checking unique email per company' do
      let(:company_main) { create(:company) }
      let(:company_other) { create(:company) }

      it 'allows same email in different companies' do
        create(:user, email: 'test@example.com', company: company_main)
        user_other = build(:user, email: 'test@example.com', company: company_other)
        expect(user_other).to be_valid
      end

      it 'prevents duplicate email in same company' do
        create(:user, email: 'test@example.com', company: company_main)
        user_dup = build(:user, email: 'test@example.com', company: company_main)
        expect(user_dup).not_to be_valid
      end

      it 'adds error for duplicate email in same company' do
        create(:user, email: 'test@example.com', company: company_main)
        user_dup = build(:user, email: 'test@example.com', company: company_main)
        user_dup.valid?
        expect(user_dup.errors[:email]).to include('already exists in this company')
      end
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role).with_values(employee: 1, manager: 2, admin: 3) }
  end

  describe 'scopes' do
  let(:company_scope) { create(:company) }
  let!(:active_user) { create(:user, active: true, company: company_scope) }
  let!(:inactive_user) { create(:user, active: false, company: company_scope) }
  let!(:manager_user) { create(:user, role: :manager, company: company_scope) }

    describe '.active' do
      it 'returns only active users' do
        expect(described_class.active).to include(active_user)
      end

      it 'does not return inactive users' do
        expect(described_class.active).not_to include(inactive_user)
      end
    end

    describe '.by_company' do
      it 'returns active user from specified company' do
        expect(described_class.by_company(company_scope)).to include(active_user)
      end

      it 'returns inactive user from specified company' do
        expect(described_class.by_company(company_scope)).to include(inactive_user)
      end

      it 'returns manager user from specified company' do
        expect(described_class.by_company(company_scope)).to include(manager_user)
      end
    end

    describe '.by_role' do
      it 'returns users with specified role' do
        expect(described_class.by_role(:manager)).to include(manager_user)
      end

      it 'does not return users with other roles' do
        expect(described_class.by_role(:manager)).not_to include(active_user)
      end
    end
  end

  describe 'callbacks' do
    it 'normalizes email before validation' do
      user = build(:user, email: '  TEST@EXAMPLE.COM  ')
      user.valid?
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'instance methods' do
    describe '#full_name' do
      it 'returns first and last name' do
        user = create(:user, first_name: 'John', last_name: 'Doe')
        expect(user.full_name).to eq('John Doe')
      end

      it 'handles missing names gracefully' do
        user = create(:user, first_name: nil, last_name: nil)
        expect(user.full_name).to eq('')
      end
    end

    describe '#to_s' do
      it 'returns full name when available' do
        user = create(:user, first_name: 'John', last_name: 'Doe')
        expect(user.to_s).to eq('John Doe')
      end

      it 'returns email when name is not available' do
        user = create(:user, first_name: '', last_name: '')
        expect(user.to_s).to eq(user.email)
      end
    end

    describe '#same_company?' do
      it 'returns true for users in same company' do
        company = create(:company)
        user1 = create(:user, company: company)
        user2 = create(:user, company: company)
        expect(user1.same_company?(user2)).to be true
      end

      it 'returns false for users in different companies' do
        company1 = create(:company)
        company2 = create(:company)
        user1 = create(:user, company: company1)
        user2 = create(:user, company: company2)
        expect(user1.same_company?(user2)).to be false
      end

      it 'returns false for nil user' do
        company = create(:company)
        user1 = create(:user, company: company)
        expect(user1.same_company?(nil)).to be false
      end
    end

    describe '#can_manage_users?' do
      it 'returns true for admin in same company' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(admin.can_manage_users?(employee)).to be true
      end

      it 'returns false for admin in different company' do
        company1 = create(:company)
        company2 = create(:company)
        admin = create(:user, role: :admin, company: company1)
        other_admin = create(:user, role: :admin, company: company2)
        expect(admin.can_manage_users?(other_admin)).to be false
      end

      it 'returns true for admin with no target user' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        expect(admin.can_manage_users?).to be true
      end

      it 'returns false for manager' do
        company = create(:company)
        manager = create(:user, role: :manager, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(manager.can_manage_users?(employee)).to be false
      end

      it 'returns false for employee' do
        company = create(:company)
        manager = create(:user, role: :manager, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(employee.can_manage_users?(manager)).to be false
      end
    end

    describe '#can_manage_company?' do
      it 'returns true for admin for own company' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        expect(admin.can_manage_company?(company)).to be true
      end

      it 'returns false for admin for different company' do
        company1 = create(:company)
        company2 = create(:company)
        admin = create(:user, role: :admin, company: company1)
        expect(admin.can_manage_company?(company2)).to be false
      end

      it 'returns true for admin with no target company' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        expect(admin.can_manage_company?).to be true
      end

      it 'returns false for manager' do
        company = create(:company)
        manager = create(:user, role: :manager, company: company)
        expect(manager.can_manage_company?(company)).to be false
      end

      it 'returns false for employee' do
        company = create(:company)
        employee = create(:user, role: :employee, company: company)
        expect(employee.can_manage_company?(company)).to be false
      end
    end

    describe '#can_book_for_others?' do
      it 'returns true for admin in same company' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(admin.can_book_for_others?(employee)).to be true
      end

      it 'returns true for manager in same company' do
        company = create(:company)
        manager = create(:user, role: :manager, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(manager.can_book_for_others?(employee)).to be true
      end

      it 'returns false for admin in different company' do
        company1 = create(:company)
        company2 = create(:company)
        admin = create(:user, role: :admin, company: company1)
        other_admin = create(:user, role: :admin, company: company2)
        expect(admin.can_book_for_others?(other_admin)).to be false
      end

      it 'returns false for manager in different company' do
        company1 = create(:company)
        company2 = create(:company)
        manager = create(:user, role: :manager, company: company1)
        other_admin = create(:user, role: :admin, company: company2)
        expect(manager.can_book_for_others?(other_admin)).to be false
      end

      it 'returns true for admin with no target user' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        expect(admin.can_book_for_others?).to be true
      end

      it 'returns true for manager with no target user' do
        company = create(:company)
        manager = create(:user, role: :manager, company: company)
        expect(manager.can_book_for_others?).to be true
      end

      it 'returns false for employee' do
        company = create(:company)
        admin = create(:user, role: :admin, company: company)
        employee = create(:user, role: :employee, company: company)
        expect(employee.can_book_for_others?(admin)).to be false
      end
    end
  end
end
