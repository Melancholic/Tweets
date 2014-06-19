require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have content 'Tweets'" do
      visit '/static_pages/home';
      expect(page).to have_content('Tweets');
    end
    it "should have title 'Tweets | Home'" do
      visit '/static_pages/home';
      expect(page).to have_title('Tweets | Home');
    end
  end
  describe "Help page" do
    it "should have content 'Help'" do
      visit '/static_pages/help';
      expect(page).to have_content('Help');
    end
    it "should have title 'Tweets | Help'" do
      visit '/static_pages/help';
      expect(page).to have_title('Tweets | Help');
    end 
  end 
  describe "About page" do
    it "should have content 'About us'" do
      visit '/static_pages/about';
      expect(page).to have_content('About us');
    end
    it "should have title 'Tweets | About'" do
      visit '/static_pages/about';
      expect(page).to have_title('Tweets | About');
    end 
  end 


end

