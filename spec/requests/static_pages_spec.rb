require 'spec_helper'

describe "StaticPages" do
  subject{ page }
    describe "Home page" do
      before { visit root_path }
      it { should have_content('home page') }
      it { should have_title(full_title("Home"))}
      describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do  
        FactoryGirl.create(:micropost, user: user, content: "Text msg 1 first_tag")
        FactoryGirl.create(:micropost, user:user, content: "Txt msg 2 second_tag")
#       FactoryGirl.create(:hashtag,text: "first_tag")
        sign_in user
        visit user_path(user)
      end 
      
 #     it{should have_link('#first_tag', hashtag_path(Hashtag.find_by(text:"first_tag")))}
 #     it{should have_content('#first_tag')}
      before do
        visit root_path
      end
      it "should render the users feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      describe "follower/following counts" do
        let(:other_user){FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          user.follow!(other_user)
          visit root_path
         end
         
         it {should have_link("1 following", href: following_user_path(user))}
         it {should have_link("1 followers", href: followers_user_path(user))}


      end
    end
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
    click_link("Home");   
    expect(page).to have_title(full_title('Home'));
    click_link("Sign Up");
    expect(page).to have_title(full_title('Sign Up'));
    click_link("Contacts");
    expect(page).to have_title(full_title('Contacts'));

  end
end

