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
      before do
        sign_in(user)
        verificate(user)
      end
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
                verificate user
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

        # Тест на доступ к операциям над связями между пользователями
          describe "In the Relationships controller"do
            describe "send to  the create action" do
              before {post relationships_path}
              specify{expect(response).to redirect_to(signin_path)}
            end
            describe "send to  the destroy action" do
              before {delete relationship_path(1)}
              specify{expect(response).to redirect_to(signin_path)}
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
          describe "send to Users index action" do
            before{get users_path }
            specify {expect(response).to redirect_to(signin_path) }
          end
          
          describe "test access to another Users pages" do
            let(:new_user){FactoryGirl.create(:user)}
            let!(:p1){new_user.microposts.create(content: "some txt1")}
            let!(:p2){new_user.microposts.create(content: "some txt2")}
            let!(:p3){new_user.microposts.create(content: "some txt3")}
            before do
              new_user.follow!(User.tweets_user);
              User.tweets_user.follow!(new_user);

              visit user_path(new_user)
            end
            it "test users content" do
              new_user.microposts.each do |item|
                expect(page).to have_selector("li##{item.id}", text: item.content)
                expect(page).to have_link("#",href:user_path(item.author,anchor: item.id, page: Micropost.page_for_user(item.author, item)))
              end
              should have_link(new_user.name,href:user_path(new_user))
              should have_content(p1.content)
              should have_content(p2.content)
              should have_content(p3.content)
            end
            describe "test users link" do
                it{should have_content(new_user.name)}
                it{should have_content("#{new_user.microposts.count} microposts")}
                it{should have_link("#{new_user.followed_users.count} following",href: following_user_path(new_user))}
                it{should have_link("#{new_user.followers.count} followers", href: followers_user_path(new_user))}
              it " test following page"do
                find(:linkhref, following_user_path(new_user)).click
                expect(page).to have_title(full_title('Following'));
                expect(page).to have_content('Following');
                new_user.followed_users.each do |item|
                  expect(page).to have_selector("ul.users")
                  expect(page).to have_link(item.name,href:user_path(item))
                end
              end
              it " test followers page"do
                visit user_path(new_user)
                find(:linkhref, followers_user_path(new_user)).click
                expect(page).to have_title(full_title('Followers'));
                expect(page).to have_content('Followers');
                new_user.followers.each do |item|
                  expect(page).to have_selector("ul.users")
                  expect(page).to have_link(item.name,href:user_path(item))
                end
              end
            end
          end

          describe " visit root path " do
            before {visit root_url}
              it{should_not have_link("Profile")}
              it{should_not have_link("Settings")}
              it{should_not have_link("Sign Out", signout_path)}
          end
          #Тесты на недоступность тегов анонимуса
          let!(:post){FactoryGirl.create(:micropost,content:"tetx #some_tag", user: user) }
          let!(:tag){FactoryGirl.create(:hashtag,micropost:[post],text:"some_tag")}

           describe " visiting te Hashtags index page" do
            before{visit hashtags_path}
            it{should have_title(full_title('Sign In'))};
          end

          describe " visit root path " do
            before {visit root_url}
              it{should_not have_link("#Hashtags")}
              it{should_not have_link("Settings")}
              
          end
         describe "send GET request to Hashtags#index" do
          before{get hashtags_path()}
          specify{expect(response.body).not_to match(full_title('#Hashtags'))}
          specify{expect(response).to redirect_to(signin_path)}
        end
        describe "send GET request to Hashtags#show" do
          before{get hashtag_path(tag)}
          specify{expect(response.body).not_to match(full_title(tag.full_text))}
          specify{expect(response).to redirect_to(signin_path)}
        end
        describe "send DELETE request to Hashtags" do
          before{delete hashtag_path(tag)}
          specify{expect(response).to redirect_to(signin_path)}
        end

          #Тесты на доступность к страницам  подписок/подписчиков

          describe "visiting the following page" do
            before {visit following_user_path(user)}
            it{should have_title(full_title('Following'))}
            it{should have_content(user.name)}
            it{should have_content(user.microposts.count)}

          end
          describe "visiting the followers page" do
            before {visit followers_user_path(user)}
            it{should have_title(full_title('Followers'))}
            it{should have_content(user.name)}
            it{should have_content(user.microposts.count)}
          end
        end
      end
    #Для зарегистрированных пользователей
      describe "as wrong user" do
        let(:user){FactoryGirl.create(:user)}
        let(:wrong_usr){FactoryGirl.create(:user,email: "wrong@email.dom")}
        before do
         sign_in(user, no_capybara: true)
          verificate(user, no_capybara: true)

         end
        
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

        before do
          sign_in(non_adm,no_capybara: true)
          verificate(non_adm, no_capybara: true)
        end
        #Для доступа к пользователям
        describe "send a DELETE request to User#destroy" do
          before do
            delete(user_path(user))
          end
          
          specify {expect(response).to redirect_to(root_url) }
        end
        #Для доступа к тегам
          describe "for hashtags" do
          let!(:usr){FactoryGirl.create(:user)}
          let!(:post){FactoryGirl.create(:micropost,content:"tetx #some1_tag", user:usr) }
          let!(:tag){FactoryGirl.create(:hashtag,micropost:[post],text:"some1_tag")}
           before do
              sign_in usr
              verificate usr
              visit hashtags_path
            end
           describe " visiting te Hashtags index page" do
            
           
            it{should have_title(full_title('#Hashtags'))};
          end
          describe " visit root path " do
            before do
              visit root_path
            end
              it{should have_link("#Hashtags")}
              it{should have_link("Settings")}
              
          end
         describe "send GET request to Hashtags#index" do
          before{get hashtags_path()}
          specify{expect(response.body).to match(full_title('#Hashtags'))}
        end
        describe "send GET request to Hashtags#show" do
          before{get hashtag_path(tag)}
          specify{expect(response.body).to match(full_title(tag.full_text))}
        end
        describe "send DELETE request to Hashtags" do
          before{delete hashtag_path(tag)}
          specify{expect(response).to redirect_to(root_url)}
        end
      end

      end
    end
end
