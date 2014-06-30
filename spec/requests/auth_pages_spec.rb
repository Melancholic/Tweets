require "spec_helper"
describe "Authentication" do
subject {page}
  describe "SignIn Page" do
    before {visit signin_path }
    
    describe "with invalid data" do
      before {click_button "Sign in"}
      it { should have_content("Sign In")};
      it { should have_title('Sign In')};
      it{ should have_selector('div.alert.alert-error')};
    end
    describe "after visiting another page" do
      before{click_link("Home")}
      it { should_not have_selector('div.alert.alert-error')}
    end
    describe "with valid data" do
      let(:usr) {FactoryGirl.create(:usr)};
      before do
        fill_in "Email", with: usr.email;
        fill_in "Password", with: usr.password;
        click_button "Sign In"
      end
      it { should have_title(full_title(usr.name)) };
      it { should have_link( 'Profile', href: user_path(user)) };
      it { should have_link('Sign out', href: signout_path)};
      it { should_not have_link('Sign In', href: signin_path) };
      end

    end
end
