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
      puts page.title
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
# тесты восстановления пароля
    let(:rst_lnk){"Forgot your password?"}
    describe "have reset password link" do
      it{should have_link(rst_lnk,reset_password_users_path)};
      describe"click reset-password link" do
        before{click_link(rst_lnk);}
          it{should have_title(full_title('Reset Password'))};
          it{should have_content('Please check your e-mail!')};
          it{should have_content('E-mail')};
          it{should have_button('Reset password')};
        describe "send email" do
         before{puts(page.title)}
          it{should have_title(full_title('Reset Password'))};
          describe "non fill" do
            before{click_button('Reset password')}
            it{should have_content("User with e-mail: not found!")};
            it{should have_title(full_title('Reset Password'))};
          end
          describe "uncorrect fill" do
            before{
              fill_in "email", with: "unknowawd";
              click_button('Reset password'); 
            }
            it{should have_content("User with e-mail: unknowawd not found!")};
            it{should have_title(full_title('Reset Password'))};
          end
          describe "correct fill" do
            before{
              puts(page.title)
              fill_in "email", with: user.email;
            }
            
            it "e-mail" do 
              expect {click_button('Reset password')}.to change(ResetPassword, :count); 
              should have_title(full_title('Home'));
              should have_content("Mail with instructions has been sended to e-mail: #{user.email}!");
              should have_selector('div.alert.alert-success')

            end
          end
            describe "in reset_password controller" do
                let(:rp){user.make_reset_password(host:"127.0.0.1")}
              it{
                rp.host.should ==("127.0.0.1")
                user.should eq(ResetPassword.getUser(rp))
                user.should eq(ResetPassword.getUser(user.reset_password_key))
                user.should eq(rp.getUser)
                user.reset_password.password_key.should eq(ResetPassword.getUser(rp).reset_password_key)
                user.reset_password.password_key.should eq(rp.password_key)
              }
            describe "go to reset_password path with key param" do
              describe "in the future" do
                before{
                  Timecop.travel(rp.updated_at+1.day);
                  visit reset_password_users_path(key:rp.password_key)
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_content("The lifetime of this reference completion. Please try the request again.");
                  should have_selector('div.alert.alert-error')
                  should have_content('Please check your e-mail!');
                  should have_content('E-mail');
                  should have_button('Reset password');
                  should have_field('email');
             #     Timecop.return;
                }
                after{Timecop.return;}
              end
              describe "in the now" do
                before{
                  visit reset_password_users_path(key:rp.password_key)
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_button('Reset password');
                  should have_field('user_password');
                  should have_field('user_password_confirmation');
                }
              end
              describe "fill uncorrect data" do
                before{
                  
                  visit reset_password_users_path(key:rp.password_key)
                  fill_in 'user_password', with:"qwe"
                  click_button 'Reset password'
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_button('Reset password');
                  should have_field('user_password');
                  should have_field('user_password_confirmation');
                  should have_selector('div.alert.alert-error');
                  should have_content('Password confirmation doesn\'t match Password');
                  should have_content('Password confirmation can\'t be blank');
                }
              end
              describe "fill correct data" do
                let(:pass){"123456correct_pas"}
                before{
                  visit reset_password_users_path(key:rp.password_key)
                  fill_in 'user_password', with:pass;
                  fill_in 'user_password_confirmation', with:pass;
                  click_button 'Reset password'
                  user.reload;
                }
                it{
                  should have_title(full_title('Home'));
                  should have_selector('div.alert.alert-succes');
                  should have_content('Updating your profile is success');
                  user.should eq(user.authenticate(pass));
                }
              end
            end
          end
      end
        #before{fill_in(user.email,"email")}       
        
      end
    end
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

