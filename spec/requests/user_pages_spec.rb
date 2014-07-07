require 'spec_helper'

describe "UsersPages" do
  subject{ page }
  #Тесты страныцы пользователей User#Index
  
  describe "Index" do
    let (:user){FactoryGirl.create(:user)}
    before do
      sign_in user
      visit users_path
    end

    it{should have_title('Users')}
    it{should have_content(' All users')}

  #Тесты пагинации
    describe "pagination" do
      before(:all){50.times{FactoryGirl.create(:user)}}
      after(:all) { User.delete_all}

      it { should have_selector('div.pagination') }
      it{should have_title('Users')}

      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li',text: user.name)
        end
      end
    end
  end

  # Тесты удаления администратором
  describe "as an admin user" do
    let(:admin) {FactoryGirl.create(:admin)}
    before do
      sign_in admin
      visit users_path
    end
    it {should have_link('Delete', href: user_path(User.first))}
    it "should be  to delete another user" do
      expect do
        click_link('Delete', match: :first)
      end.to change(User, :count).by(-1)
    end
    it{should_not have_link('Delete',href:user_path(admin))}
  end
  # Тесты регистрации
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
    describe "forbidden attributes" do 
      let(:params) do
        {user:{admin:true, password: user.password, password_confirmation:user.password} }
      end
      before do
        sign_in(user,no_capybara:true)
        patch(user_path(user),params)
      end
      specify{expect(user.reload() ).not_to be_admin}
    end
    end
  end
end

