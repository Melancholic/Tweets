require 'spec_helper'

describe "StaticPages" do
  let(:base_title){ "Tweets" }
  subject{ page }
  describe "Home page" do
  before { visit root_path }
    it { should have_content('home page') }
    it { should have_title("#{base_title} | Home")}
  end
  describe "Help page" do
  before { visit help_path }
    it {should have_content("Help") }
    it {should have_title("#{base_title} | Help") }
  end 
  describe "About page" do
  before { visit about_path }
    it {should have_content('About us')}
    it {should have_title("#{base_title} | About") }
  end 
  describe "Contacts page" do
  before { visit contacts_path }
    it {should have_content ("to contact me")}
    it {should have_title("#{base_title} | Contacts")}
  end 



end

