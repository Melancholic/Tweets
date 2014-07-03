include ApplicationHelper

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

def setValidUsersData(user)
  user.name="Example user";
  user.email='example@mail.com';
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



