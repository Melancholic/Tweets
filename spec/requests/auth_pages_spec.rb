require "spec_helper"
describe "Authentication" do
subject {page}
  describe "SignIn Page" do
    it {should_not  have_link('Settings') }
    before {visit signin_path }
    
    describe "with invalid data" do
      before {click_button "Sign In"}
      it { should have_content("Sign In")};
      it { should have_title('Sign In')};
      it{ should have_selector('div.alert.alert-error')};
    end
    describe "after visiting another page" do
      before{click_link("Home")}
      it { should_not have_selector('div.alert.alert-error')}
    end
    describe "with valid data" do
      let(:user) {FactoryGirl.create(:user)};
      before{ sign_in(user)}
      it { should have_title(full_title(user.name)) };
      it { should have_link( 'Profile', href: user_path(user)) };
      it { should have_link('Sign Out', href: signout_path)};
      it {should  have_link('Settings', href: edit_user_path(user))}
      it {should  have_link('Users', href: users_path)}
      it { should_not have_link('Sign In', href: signin_path) };
      describe "followed by signout" do
        before{ click_link("Sign Out") }
         it { should have_link("Sign In") }
      end
    end  
  end
# Тесты авторизации
    describe "authorization" do
    # Для незарегистрованных пользователей
      describe "for non-signed-in users" do
        let(:user){FactoryGirl.create(:user)}
        #Тест "умной" авторизации
        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email", with: user.email
            fill_in "Password", with: user.password
            click_button "Sign In"
          end
          describe "after sign in" do
            it "should render the desured protected page" do
              expect(page).to have_title(full_title('Edit profile'))
            end

            describe "when signing in again" do
              before do
                click_link("Sign Out")
                visit signin_path
                fill_in "Email", with: user.email
                fill_in "Password", with: user.password
                click_button "Sign In" 
              end
              it "should render the default page" do
                expect(page).to have_title(full_title(user.name))
              end
            end
          end
          # Тест на доступ к операциям над сообщениями
          describe "In the Microposts controller" do
            describe "send to create action" do
              before{post microposts_path}
               specify{ expect(response).to redirect_to(signin_path)}
            end
            describe "send to destroy  action" do
              before{delete micropost_path(FactoryGirl.create(:micropost))}
              specify{ expect(response).to redirect_to(signin_path)}
            end
          end
        end
        
        describe "in the Users controller" do
          
          describe "visiting the edit page" do
            before{visit edit_user_path(user)}
            it {should have_title(full_title('Sign In'))}
          end

          describe "send to update action" do
            before{patch user_path(user) }
            specify {expect(response).to redirect_to(signin_path) }
          end

        #Тесты на недоступносnь пользовательских ссылок анонимусам
          describe " visiting te Users index page" do
            before{visit users_path}
            it{should have_title(full_title('Sign In'))};
          end

          describe " visit root path " do
            before {visit root_url}
              it{should_not have_link("Profile")}
              it{should_not have_link("Settings")}
              it{should_not have_link("Sign Out", signout_path)}
          end

          #Тесты на недоступность к страницам  полписок/подписчиков

          describe "visiting the following page" do
            before {visit following_user_path(user)}
            it{should have_title(full_title('Sign In'))}
          end
          describe "visiting the followers page" do
            before {visit followers_user_path(user)}
            it{should have_title(full_title('Sign In'))}
          end
        end
      end
    #Для зарегистрированных пользователей
      describe "as wrong user" do
        let(:user){FactoryGirl.create(:user)}
        let(:wrong_usr){FactoryGirl.create(:user,email: "wrong@email.dom")}
        before{ sign_in(user, no_capybara: true)}
        
        describe "send GET request to Users#edit" do
          before{get edit_user_path(wrong_usr)}
          specify{expect(response.body).not_to match(full_title('Edit profile'))}
          specify{expect(response).to redirect_to(root_url)}
        end
        describe "send PATCH request to Users#update" do
           before{patch user_path(wrong_usr)}
           specify{expect(response.body).to redirect_to(root_url)}
        end
      end
      describe "as non-admin user" do
        let(:user) {FactoryGirl.create(:user)}
        let(:non_adm){FactoryGirl.create(:user)}

        before {sign_in(non_adm, no_capybara:true)}
        describe "send a DELETE request to User#destroy" do
          before{delete(user_path(user))}
          specify {expect(response).to redirect_to(root_url) }
        end
      end
    end
end
