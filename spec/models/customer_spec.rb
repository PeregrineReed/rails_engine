require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe 'Relationships' do
  end

  describe 'Validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'Class Methods' do
  end

  describe 'Instance Methods' do
  end

end
