require 'spec_helper'

describe "StaticPages" do
  subject{ page }
  describe "Home page" do
  before { visit root_path }
    it { should have_content('home page') }
    it { should have_title(full_title("Home"))}
  end
  describe "Help page" do
  before { visit help_path }
    it {should have_content("Help") }
    it {should have_title(full_title("Help")) }
  end 
  describe "About page" do
  before { visit about_path }
    it {should have_content('About us')}
    it {should have_title(full_title("About")) }
  end 
  describe "Contacts page" do
  before { visit contacts_path }
    it {should have_selector('h1', text: 'to contact me') }
    it {should have_title(full_title("Contacts"))}
  end 

  it "should have the right links on the Layout" do
    visit root_path;
    click_link("About");
    expect(page).to have_title(full_title('About'));
    click_link("Help");
    expect(page).to have_title(full_title('Help'));
    click_link("Home");   
    expect(page).to have_title(full_title('Home'));
    click_link("Sign Up");
    expect(page).to have_title(full_title('Sign Up'));
    click_link("Contacts");
    expect(page).to have_title(full_title('Contacts'));

  end
end

