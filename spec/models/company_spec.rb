require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:name)        { '7vals' }
  let(:description) { 'Description' }
  let(:subdomain)   { 'subdomain' }
  let(:owner_id)    { 1 }

  let(:company) do
    Company.new(name: name,
                description: description,
                subdomain: subdomain,
                owner_id: owner_id)
  end

  it 'should be valid' do
    expect(company.valid?).to eq true
  end

  it 'name should be present' do
    company.name = ''
    expect(company.valid?).to eq false
  end

  it 'subdomain should be present' do
    company.subdomain = ''
    expect(company.valid?).to eq false
  end

  it 'subdomain validation should accept valid subdomains' do
    valid_subdomains = %w[a ab a-b a-b_c 7abc a7 a7b-c a-7-c]

    valid_subdomains.each do |valid_subdomain|
      company.subdomain = valid_subdomain
      expect(company.valid?).to eq true
    end
  end

  it 'subdomain validation should reject invalid subdomains' do
    invalid_subdomains = %w[-a -7ab a--b !a-b-c a7# _a7bc &a_-7-c]

    invalid_subdomains.each do |invalid_subdomain|
      company.subdomain = invalid_subdomain
      expect(company.valid?).to eq false
    end
  end

  it 'subdomain should be unique' do
    duplicate_company = company.dup
    duplicate_company.subdomain = company.subdomain.upcase
    company.save
    expect(duplicate_company.valid?).to eq false
  end

  it 'subdomains should be saved as lower-case' do
    mixed_case_subdomain = 'AbCdEf'
    company.subdomain = mixed_case_subdomain
    company.save
    expect(mixed_case_subdomain.downcase).to eq company.reload.subdomain
  end

  it 'associated models should be destroyed' do
    company.save
    company.projects.create!(title: 'Lorem ipsum', description: 'Lorem ipsum')
    Company.current_id = company.id
    expect { company.destroy }.to change { Project.count }.by(-1)
  end

  it 'name should not be too long' do
    company.name = 'a' * 51
    expect(company.valid?).to eq false
  end
  it 'name should not be too short' do
    company.name = 'a' * 1
    expect(company.valid?).to eq false
  end

  it 'subdomain should not be too long' do
    company.subdomain = 'a' * 64
    expect(company.valid?).to eq false
  end
end
