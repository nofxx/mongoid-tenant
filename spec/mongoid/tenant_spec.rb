require 'spec_helper'

describe Mongoid::Tenant do
  it 'should have a tenancy' do
    expect(Journal).to include(Mongoid::Tenancy)
  end

  it 'should not have both modules' do
    expect(Journal).to_not include(Mongoid::Tenant)
  end

  it 'should have a tenant' do
    expect(Article).to include(Mongoid::Tenant)
  end

  it 'should not have both modules' do
    expect(Article).to_not include(Mongoid::Tenancy)
  end

  it 'should not interfer with tenancy' do
    expect {
      Journal.create!(url: 'a_planeta', name: 'Planeta Diário')
    }.to_not raise_error
    expect(Journal.count).to eq 1
  end

  it 'should not interfer other models' do
    expect { City.create!(name: 'Sin City') }.to_not raise_error
  end

  it 'should interfer with tenant w/o tenancy' do
    expect { Article.create!(title: 'A Very Nice Coffeeshop') }
      .to raise_error(NoMethodError)
  end
end
