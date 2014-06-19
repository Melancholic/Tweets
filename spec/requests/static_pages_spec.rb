require 'spec_helper'

describe "StaticPages" do
  let(:base_title){ "Tweets" }
  describe "Home page" do
    it "should have content 'home page'" do
      visit '/static_pages/home';
      expect(page).to have_content('home page');
    end
    it "should have title 'Tweets | Home'" do
      visit '/static_pages/home';
      expect(page).to have_title("#{base_title} | Home");
    end
  end
  describe "Help page" do
    it "should have content 'Help'" do
      visit '/static_pages/help';
      expect(page).to have_content('Help');
    end
    it "should have title 'Tweets | Help'" do
      visit '/static_pages/help';
      expect(page).to have_title("#{base_title} | Help");
    end 
  end 
  describe "About page" do
    it "should have content 'About us'" do
      visit '/static_pages/about';
      expect(page).to have_content('About us');
    end
    it "should have title 'Tweets | About'" do
      visit '/static_pages/about';
      expect(page).to have_title("#{base_title} | About");
    end 
  end 
  describe "Contacts page" do
    it "should have content 'to contact me'" do
      visit '/static_pages/contacts';
      expect(page).to have_content('to contact me');
    end
    it "should have title 'Tweets | Contacts'" do
      visit '/static_pages/contacts';
      expect(page).to have_title("#{base_title} | Contacts");
    end 
  end 



end

