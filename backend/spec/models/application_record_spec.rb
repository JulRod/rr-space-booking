require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe 'inheritance' do
    it 'is an abstract class' do
      expect(described_class).to be < ActiveRecord::Base
    end
  end
end