require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'Relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
  end

  describe 'Validations' do
    it { should validate_presence_of :status }
  end

  describe 'Class Methods' do
  end

  describe 'Instance Methods' do
  end

end
