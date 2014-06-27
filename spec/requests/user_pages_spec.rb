require 'spec_helper'

describe "UsersPages" do
  subject{ page }
  describe "Sign Up page" do
  before { visit signup_path }
    it { should have_content('Sign Up') }
    it { should have_title(full_title("Sign Up"))}
  end

  let(:user) {FactoryGirl.create(:user)}
  before{visit user_path(user)}
  it{ should have_content(user.name)}
  it{ should have_title(full_title(user.name))}

#Тесты регистрации
#невалидные данные
  describe "Signup page" do
    before {visit signup_path}
    let (:submit) {"Create"}
    describe "with invalid data" do
      it "should not create a user" do
        expect {click_button(submit)}.not_to change(User, :count)
      end
      describe "after submission" do
        before {click_button submit}
        it{should have_title(full_title('Sign Up'))};
        it{should have_content('Name can\'t be blank')};
        it{should have_content('Email can\'t be blank')};
        it{should have_content('Password can\'t be blank')};
        it{should have_content("Password confirmation doesn't match Password")};
        end
    end
#проверка ошибок
    
#валидные данные
    describe "with valid data" do
      before do
        fill_in "Name", with: "Example user";
        fill_in "Email", with: "examle@mail.com";
        fill_in "Password", with: "123456";
        fill_in "Confirmation", with: "123456";
      end
      it "should create a user" do
        expect {click_button(submit)}.to change(User, :count).by(1)
      end
      describe "after signup" do
        before {click_button submit}
        it{should have_title(full_title("Example user"))};
        it{should have_content("Welcome to Tweets!")};
        it{should have_selector('div.alert.alert-success')};
      end
    end
  end
end

