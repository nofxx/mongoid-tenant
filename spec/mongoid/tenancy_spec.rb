require 'spec_helper'

describe Mongoid::Tenancy do
  def clear_tenancy!
    Thread.current[:tenancy] = nil
  end

  describe 'A Journal' do
    let(:journal) { Journal.create!(url: 'a_casseta_test', name: 'A Casseta') }
    let(:other) { Journal.create!(url: 'a_planeta_test', name: 'O Planeta') }

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

    it 'should switch from tenant to tenant' do
      journal.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop') }.to_not raise_error
      expect(Article.count).to eq 1
      other.tenancy!
      expect(Article.count).to eq 0
    end

    it 'should switch back from tenant' do
      other.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop') }.to_not raise_error
      expect(Article.count).to eq 1
      journal.tenancy!
      expect(Article.count).to eq 0
    end

    it 'should switch another test' do
      journal.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop 1') }.to_not raise_error
      other.tenancy!
      expect { Article.create!(title: 'Nice Coffeeshop 2') }.to_not raise_error
      expect(Article.count).to eq 1
      journal.tenancy!
      expect(Article.count).to eq 1
    end

    it 'should have a multiple helper' do
      journal.tenancy!
      Article.create!(title: 'Nice Coffeeshop')
      clear_tenancy!
      expect(journal.articles.count).to eq 1
    end

    it 'should have a multiple helper' do
      journal.tenancy!
      article = Article.create!(title: 'Nice Coffeeshop')
      clear_tenancy!
      expect(journal.articles.first).to eq article
    end

    it 'should not leak tenancy key' do
      journal && other
      Journal.with_tenants { Article.create!(title: 'Hello') }
      expect(Thread.current[:tenancy]).to be nil
    end

    it 'should have a multiple helper' do
      journal && other
      Journal.with_tenants { Article.create!(title: 'Hello') }
      Journal.with_tenants { Article.create!(title: 'Hello') }
      journal.tenancy!
      expect(Article.count).to eq 2
    end
  end

  describe 'A Blog' do
    let(:blog) { Blog.create!(url: 'b_casseta_test', name: 'A Casseta') }
    let(:other) { Blog.create!(url: 'b_planeta_test', name: 'O Planeta') }

    it 'should not validate key' do
      expect(Blog.create!(name: 'Monty News')).to be_valid
      expect(Blog.count).to eq 1
    end

    it 'should work fine w/o key' do
      Blog.create!(name: 'Monty News')
      expect(Blog.first.name).to eq 'Monty News'
    end

    it 'should not create database if it`s sparse' do
      expect { Blog.create!(name: 'Monty News')  }
        .to_not change(self, :fetch_dbs)
    end

    it 'should create database if it`s sparse' do
      expect { blog && blog.tenancy! && Article.create! }
        .to change(self, :fetch_dbs)
    end

  end
end
