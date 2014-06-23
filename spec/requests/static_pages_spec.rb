require 'spec_helper'

describe "StaticPages" do
  let(:base_title){ "Tweets" }
  describe "Home page" do
    it "should have content 'home page'" do
      visit root_path;
      expect(page).to have_content('home page');
    end
    it "should have title 'Tweets | Home'" do
      visit root_path;
      expect(page).to have_title("#{base_title} | Home");
    end
  end
  describe "Help page" do
    it "should have content 'Help'" do
      visit help_path;
      expect(page).to have_content('Help');
    end
    it "should have title 'Tweets | Help'" do
      visit help_path;
      expect(page).to have_title("#{base_title} | Help");
    end 
  end 
  describe "About page" do
    it "should have content 'About us'" do
      visit about_path;
      expect(page).to have_content('About us');
    end
    it "should have title 'Tweets | About'" do
      visit about_path;
      expect(page).to have_title("#{base_title} | About");
    end 
  end 
  describe "Contacts page" do
    it "should have content 'to contact me'" do
      visit contacts_path;
      expect(page).to have_content('to contact me');
    end
    it "should have title 'Tweets | Contacts'" do
      visit contacts_path;
      expect(page).to have_title("#{base_title} | Contacts");
    end 
  end 



end

