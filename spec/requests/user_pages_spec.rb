require 'spec_helper'

describe "UsersPages" do
  subject{ page }
  #Тесты страныцы пользователей User#Index
  
  describe "Index" do
    before do
      sign_in FactoryGirl.create(:user,name: "Vanya", email: "vany@exmpl.dom");
      sign_in FactoryGirl.create(:user, name: "Antosha",email: "antosh@exmpl.com");
      sign_in FactoryGirl.create(:user, name: "Maria",email: "marie@exmpl.com");
      visit users_path
    end

    it{should have_title('Users')}
    it{should have_content(' All users')}
    it 'should list each user' do
      User.all.each do |usr|
        expect(page).to have_selector('li',text: usr.name)
      end
    end
  end

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
        setValidUsersData(user)
      end
      it "should create a user" do
        expect {click_button(submit)}.to change(User, :count).by(1)
      end
      describe "after signup" do
        before {click_button submit}
        let(:usr){User.find_by(email: 'example@mail.com')}
        it{should have_link("Sign Out") }
        it{should have_title(full_title(usr.name))}
        it{should have_content("Welcome to Tweets!")}
        it{should have_selector('div.alert.alert-success')}
      end
    end

# Тесты  обновления пользователей
    describe 'edit profile ' do
      let(:user) {FactoryGirl.create(:user)}
      before do
      sign_in(user)
      visit edit_user_path(user)
      end

      describe 'at page' do 
        it{should have_content('Update your profile')}
        it{should have_title(full_title("Edit profile"))}
        it{should have_link('Change Gravatar',href:'http://gravatar.com/emails')}
      end
      describe 'with invalid data' do
        before do
          setInvalidUsersData(user)
          click_button "Save"
        end
        it { should have_content('error')}
        it {should have_content('Update your profile')}
        it{should have_title(full_title("Edit profile"))}  
        specify {expect(user.name).not_to eq user.reload.name}
        specify {expect(user.email).not_to eq user.reload.email} 
      end
      describe 'with valid data' do
        before do
          setValidUsersData(user)
          click_button "Save"
        end
        it {should have_content('Updating your profile is success')}
        it {should have_selector('div.alert.alert-succes')}
        specify {expect(user.name).to eq user.reload.name}
        specify {expect(user.email).to eq user.reload.email} 
     end
    end
  end
end

