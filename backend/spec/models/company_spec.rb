require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:company) }

    it { is_expected.to validate_presence_of(:subdomain) }
    it { is_expected.to validate_uniqueness_of(:subdomain).case_insensitive }
    it { is_expected.to validate_length_of(:subdomain).is_at_most(50) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }

    context 'when validating subdomain format' do
      %w[test test-company test123 123test a b].each do |subdomain|
        it "accepts valid subdomain: #{subdomain}" do
          company = build(:company, subdomain: subdomain)
          expect(company).to be_valid, "#{subdomain} should be valid"
        end
      end

      [ 'test_company', 'test.company', 'test company' ].each do |subdomain|
        it "rejects invalid subdomain: #{subdomain}" do
          company = build(:company, subdomain: subdomain)
          expect(company).not_to be_valid, "#{subdomain} should be invalid"
        end
      end

      it 'rejects empty string as subdomain' do
        company = build(:company, subdomain: '')
        expect(company).not_to be_valid, 'empty string should be invalid'
      end

      it 'normalizes uppercase subdomains' do
        company = build(:company, subdomain: 'Test-Company')
        company.valid?
        expect(company.subdomain).to eq('test-company')
      end
    end
  end

  describe 'scopes' do
    let!(:active_company) { create(:company, active: true) }
    let!(:inactive_company) { create(:company, active: false) }

    describe '.active' do
      it 'returns only active companies' do
        expect(described_class.active).to include(active_company)
      end

      it 'does not return inactive companies' do
        expect(described_class.active).not_to include(inactive_company)
      end
    end

    describe '.by_subdomain' do
      it 'finds company by subdomain' do
        expect(described_class.by_subdomain(active_company.subdomain)).to include(active_company)
      end

      it 'returns empty for nonexistent subdomain' do
        expect(described_class.by_subdomain('nonexistent')).to be_empty
      end
    end
  end

  describe 'callbacks' do
    it 'normalizes subdomain before validation' do
      company = build(:company, subdomain: '  TEST-Company  ')
      company.valid?
      expect(company.subdomain).to eq('test-company')
    end
  end

  describe 'instance methods' do
    let(:company) { create(:company, name: 'Test Company') }

    describe '#to_s' do
      it 'returns the company name' do
        expect(company.to_s).to eq('Test Company')
      end
    end

    describe '#activate!' do
      it 'activates the company' do
        company.update!(active: false)
        company.activate!
        expect(company.reload).to be_active
      end
    end

    describe '#deactivate!' do
      it 'deactivates the company' do
        company.deactivate!
        expect(company.reload).not_to be_active
      end
    end

    describe '#settings' do
      it 'returns parsed JSON as hash' do
        company.update_column(:settings, '{"key": "value"}')
        expect(company.settings).to eq({ 'key' => 'value' })
      end

      it 'returns parsed JSON as hash with indifferent access' do
        company.update_column(:settings, '{"key": "value"}')
        expect(company.settings[:key]).to eq('value')
      end

      it 'returns empty hash for invalid JSON' do
        company.update_column(:settings, 'invalid json')
        expect(company.settings).to eq({})
      end

      it 'returns empty hash for nil settings' do
        company.update_column(:settings, nil)
        expect(company.settings).to eq({})
      end
    end

    describe '#update_setting' do
      it 'updates a specific setting' do
        expect(company.update_setting('theme', 'dark')).to be_truthy
      end

      it 'sets the correct value for the updated setting' do
        company.update_setting('theme', 'dark')
        expect(company.settings[:theme]).to eq('dark')
      end

      it 'preserves existing settings (existing)' do
        company.settings = { existing: 'value' }
        company.save!
        company.update_setting('new_key', 'new_value')
        expect(company.settings[:existing]).to eq('value')
      end

      it 'preserves existing settings (new_key)' do
        company.settings = { existing: 'value' }
        company.save!
        company.update_setting('new_key', 'new_value')
        expect(company.settings[:new_key]).to eq('new_value')
      end
    end
  end
end
