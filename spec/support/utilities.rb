include ApplicationHelper
def verificate (user, args={})
  if args[:no_capybara]
    puts  user.verification_user.verification_key;
    user.verification_user.update_attribute(:verification_key,"");
    user.verification_user.update_attribute(:verificated,true);
  else
      visit verification_user_path user;
       fill_in "key", with: user.verification_user.verification_key;
       click_button "Send key"
  end
end


def sign_in (user, args={})
  if args[:no_capybara]
    remember_token=User.new_remember_token();
    cookies[:remember_token]=remember_token;
    user.update_attribute(:remember_token,User.encrypt(remember_token));
  else
      visit signin_path;
        fill_in "Email", with: user.email;
        fill_in "Password", with: user.password;
        click_button "Sign In"
  end
end

def sign_out (user, args={})
  if args[:no_capybara]
    delete(sign_out)
  else
      visit user_path(user);
      click_link("Sign Out");
  end
end

def setValidUsersData(user)
  user.name="Example user";
  user.email="example#{Random.rand(1000)}@mail.com";
  user.password="123456";
  user.password_confirmation=user.password;
  fill_in "Name", with: user.name;
  fill_in "Email", with: user.email;
  fill_in "Password", with: user.password;
  fill_in "Confirmation", with: user.password_confirmation;
  return user;
end
def setInvalidUsersData(user)
  user.name="uncorrect=Name";
  user.email="uncorrectemail";
  user.password="123";
  user.password_confirmation=user.password;
  fill_in "Name", with: user.name;
  fill_in "Email", with: user.email;
  fill_in "Password", with: user.password;
  fill_in "Confirmation", with: user.password_confirmation;
  return user;
  end



