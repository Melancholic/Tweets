require 'spec_helper'

describe "UsersPages" do
  subject{ page }
  #Тесты страныцы пользователей User#Index
  
  describe "Index" do
    let (:user){FactoryGirl.create(:user)}
      let!(:m){ FactoryGirl.create(:micropost, user: user)}
    before do
      sign_in user
      verificate user
      visit users_path

    end

    it{should have_title('Users')}
    it{should have_content(' All users')}
    it{should have_content("Total tweets: #{user.microposts.count}")}


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
      verificate admin
      visit users_path
    end
    it {should have_link('Delete', href: user_path(User.first))}
    it "should be  to delete another user" do
      expect do
        click_link('Delete', match: :first)
      end.to change(User, :count).by(-1)
    end
    it{should_not have_link('Delete',href:user_path(admin))}

    describe "delete self"do
      it "should be  to delete self from DELETE request" do
        expect do
          delete user_path(admin)
        end.to change(User, :count).by(0)
      end
      
     #it{should have_selector('div.alert.alert-success')}
     it {should have_title(full_title('Users'))}
        
    end
  end
  # Тесты регистрации
  describe "Sign Up page" do
  before { visit signup_path }
    it { should have_content('Sign Up') }
    it { should have_title(full_title("Sign Up"))}
  end

  let(:user) {FactoryGirl.create(:user)}
  before do
    visit user_path(user)
  end
  it{should have_selector('div.alert.alert-notice')}
  it{ should have_title(full_title('Sign In'))}

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
       let!(:user_notv){FactoryGirl.create(:user)}

      before do
        visit signup_path
        setValidUsersData(user_notv)
      end
      it "should create a user" do
        expect {click_button(submit)}.to change(User, :count).by(1)
      end
      describe "after signup" do
        before {click_button submit}
        let!(:usr){User.find_by(email: user_notv.email)}
        it{should have_link("Sign Out") }
        it{should have_title(full_title("Verification"))}
        #describe "after verificate" do
        #  before do
        #  fill_in "key", with: usr.verification_user.verification_key;
        #  click_button "Send key"
        #  puts page.body
        #  puts usr.verification_user.verification_key
        #  end
        #  #it{should have_selector('div.alert.alert-success')}
        #  it{should have_title(full_title("Home"))}
        #end
      end
    end
#Подтверждение email

  describe "Test Verificated" do
   let (:notf_u){FactoryGirl.create(:user)}
    before {sign_in notf_u}
    describe"at verificate page" do
      it{should have_title("Verification")}
       describe  "should not acces to /users"do
        before{visit(users_path)}
        it{should have_title("Verification")}
       end 
       describe  "should not acces to user#show"do
        before{visit(user_path(notf_u))}
        it{should have_title("Verification")}
       end
       describe  "should not acces to home"do
          before{visit root_url}
          it{should have_title("Verification")}
        end
       describe  "should not acces to /hashtags"do
        before{visit(hashtags_path())}
        it{should have_title("Verification")}
       end
       describe  "should have acces to user#edit"do
        before{visit(edit_user_path(notf_u))}
        it{should have_title("Edit profile")}
       end
    end
  end 
# Тесты  обновления пользователей
    describe 'edit profile ' do
      let(:user) {FactoryGirl.create(:user)}
      before do
      sign_in(user)
      verificate user
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
     #Тест на запрет установки admin с http запроса
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
    
    # Тест на запрет  к NEW и CREATE  для зарегистрированных пользователей 
    describe "go to create new account page" do
      before { visit(new_user_path)}
      it{should have_title(full_title('Home'))}
      
      let(:wrong_usr){FactoryGirl.create(:user,email: "wrong@email.dom")}
      before{get new_user_path(wrong_usr)}
      specify{expect(response.body).to match(full_title('Home'))}

    end
  end
end

# Тест профиля
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}
    let!(:m1) {FactoryGirl.create(:micropost, user: user, content: "msg1")}
    let!(:m2) {FactoryGirl.create(:micropost, user: user, content: "msg2")}
    before do
      sign_in user
      verificate user
      visit user_path(user)
    end
     it{should have_title(full_title(user.name))}

     describe "microposts" do
      it{should have_content(m1.content)}
      it{should have_content(m2.content)}
      it{should have_content(user.microposts.count)}
     end
  end

  # Тесты страниц продписок

  describe "following/followers" do
    let(:user) {FactoryGirl.create(:user)}
    let(:other_user){FactoryGirl.create(:user)}
    before{user.follow!(other_user)}
    describe "followed users" do
      before do
        sign_in user
        verificate user
        visit following_user_path(user)
      end
      it{should have_title(full_title("Following"))}
      it{should have_selector('h3', text: "Following")}
      it {should have_link(other_user.name, href: user_path(other_user))}
    end 
    describe "for followers" do
      before do
        sign_in other_user
        verificate other_user
        visit followers_user_path(other_user)
      end
        it{should have_title(full_title("Followers"))}
        it{should have_selector('h3', text: "Followers")}
        it {should have_link(user.name, href: user_path(user))}
    end
  end
end

