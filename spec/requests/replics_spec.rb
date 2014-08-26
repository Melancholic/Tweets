require 'spec_helper'

describe "Replics" do
  subject{page}
   describe "at " do
   let(:user){FactoryGirl.create(:user)}
  let(:u1){FactoryGirl.create(:user)}
  let(:u2){FactoryGirl.create(:user)}
  let(:u3){FactoryGirl.create(:user)}

  let!(:msg1){FactoryGirl.create(:micropost, content:"text @#{u1.name} and @#{u2.name}",user: user,replics_to:[u1,u2])}
  let!(:msg2){FactoryGirl.create(:micropost, content:"text @ #{u3.name} and @#{u3.name}12e @#{u3.name}_us",user: user)}

  describe " main user" do
    before do
      sign_in user
      verificate user
    end
    describe "at profile page" do
      before do
        visit user_path(user)
        
      end
      it{should have_title(full_title(user.name))}
      it{should have_content(msg1.content)}
      it{should have_content(msg2.content)}
      it{should have_link("@#{u1.name}", user_path(u1))}
      it{should have_link("@#{u2.name}", user_path(u2))}
      it{should_not have_link("@#{u3.name}", user_path(u3))}
    end
    describe "at home page" do
      before{visit root_path}
      it{should have_title(full_title('Home'))}
      it{should have_content(msg1.content)}
      it{should have_content(msg2.content)}
      it{should have_link("@#{u1.name}", user_path(u1))}
      it{should have_link("@#{u2.name}", user_path(u2))}
      it{should_not have_link("@#{u3.name}", user_path(u3))}
    end
  end
  describe "at another user (correct)" do
    before do
      sign_in u1
      verificate u1
    end  
    describe "at home page" do
      before do
        visit root_path
      end
      it{should have_title(full_title('Home'))}
      it{should have_content(msg1.content)}
      it{should_not have_content(msg2.content)}
      it{should have_link("@#{u1.name}", user_path(u1))}
      it{should have_link(user.name, user_path(user))}
    end
  end
    describe "at another user (incorrect)" do
    before do
      sign_in u3
      verificate u3
    end
    describe "at profile page" do
      before{visit user_path(u3)}
      it{should have_title(full_title(u3.name))}
      it{should_not have_content(msg1.content)}
      it{should_not have_content(msg2.content)}
      it{should_not have_link("@#{u3.name}", user_path(u3))}
      it{should_not have_link(user.name, user_path(user))}
    end
    describe "at home page" do
      before{visit root_path}
      it{should have_title(full_title('Home'))}
      it{should_not have_content(msg1.content)}
      it{should_not have_content(msg2.content)}
      it{should_not have_link(user.name, user_path(user))}
    end
  end
  end
end
