require 'spec_helper'

describe Mongoid::Tenancy do
  def clear_tenancy
    Thread.current[:tenancy] = nil
  end

  describe 'A Journal' do
    let(:journal) { Journal.create!(url: 'a_casseta_test', name: 'A Casseta') }

    it 'should work' do
      journal.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop') }.to_not raise_error
      expect(Article.count).to eq 1
    end

    it 'should not interfer with mongoid' do
      journal.tenancy!
      expect(Journal.count).to eq 1
      expect(Journal.all.to_a).to eq [journal]
    end

    it 'should work multiple' do
      journal2 =  Journal.create!(url: 'a_planeta_test', name: 'O Planeta')
      journal.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop') }.to_not raise_error
      expect(Article.count).to eq 1
      journal2.tenancy!
      expect(Article.count).to eq 0
    end

    it 'should work multiple' do
      journal2 =  Journal.create!(url: 'a_planeta_test', name: 'O Planeta')
      journal2.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop') }.to_not raise_error
      expect(Article.count).to eq 1
      journal.tenancy!
      expect(Article.count).to eq 0
    end

    it 'should work multiple' do
      journal.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop 1') }.to_not raise_error
      journal2 =  Journal.create!(url: 'a_planeta_test', name: 'O Planeta')
      journal2.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop 2') }.to_not raise_error
      expect(Article.count).to eq 1
      journal.tenancy!
      expect(Article.count).to eq 1
    end

    it 'should have a multiple helper' do
      journal.tenancy!
      Article.create!(title: 'Nice Coffeeshop')
      clear_tenancy
      expect(journal.articles.count).to eq 1
    end

    it 'should have a multiple helper' do
      journal.tenancy!
      article = Article.create!(title: 'Nice Coffeeshop')
      clear_tenancy
      expect(journal.articles.first).to eq article
    end

    it 'should have a multiple helper' do
      journal.tenancy!
      Article.create!(title: 'Nice Coffeeshop 1')
      journal2 =  Journal.create!(url: 'a_planeta_test', name: 'O Planeta')
      journal2.tenancy!
      Article.create!(title: 'Nice Coffeeshop 2')
      titles = journal.tenants { |t| Article.first.title }
      expect(titles).to eq(1)
    end
  end
end
