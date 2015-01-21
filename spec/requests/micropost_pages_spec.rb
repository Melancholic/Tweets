require 'spec_helper'

describe "MicropostPages" do
  subject { page}
  let(:user){FactoryGirl.create(:user)}
  before do
    sign_in user 
    verificate user
  end
    describe "CREATE micropost" do
    before  {visit root_path}
    # Тест на отправку неккорректного сообщения
    describe "with invalid data" do
      it "should not create a micropost" do
        expect{ click_button "Send!"}.not_to change(Micropost, :count)
      end
      describe "error messages" do
        before { click_button "Send!"}
        it{should have_content('error')}
      end
    end

    #Тест отправки корректного сообщения
    describe "with valid data" do
      before  {fill_in 'tweets_content_area', with:"Tstasa"}
      it"should create a micropost" do
        expect{click_button("Send!")}.to change(Micropost, :count).by(1)
      end
      describe "with tag" do
        before  {fill_in 'tweets_content_area', with:"test #tag"}
        it"should create a micropost with tag" do
          expect{click_button("Send!")}.to change(Hashtag, :count).by(1)
        end
      end
    end        
    #Тест удаления сообщения
    describe "Micropost dectruction" do
      before {FactoryGirl.create(:micropost, user: user)}
      describe "as correct user" do
        before {visit root_path}
        it{should have_content(user.name)}
        it "should delete a micropost" do
          expect {click_link "Delete"}.to change(Micropost, :count).by(-1)
        end
      end
    end
  end

  describe "test for DELETE-link access " do
    let(:other_u){FactoryGirl.create(:user)}
    let!(:m){FactoryGirl.create(:micropost, user: user)}
    let!(:m1){FactoryGirl.create(:micropost, user:other_u)}
    let!(:m2){FactoryGirl.create(:micropost, user:other_u)}
    let(:admin){FactoryGirl.create(:user, admin: true)}
    before {visit user_path(other_u)}
    describe"should not delete a other micropost" do
      it{should_not have_link('Delete',micropost_path(m1))}
      it{should_not have_content('Delete')}
    end
    
    describe "should delete a self  micropost" do
      before {visit user_path(user)}
      it "should delete a micropost" do
        expect {click_link 'Delete'}.to change(Micropost, :count).by(-1)
      end
    end
    
    describe "with admin" do
      before do
        sign_out(user)
        sign_in admin
        verificate admin
        visit user_path(user)
      end
       it{should have_link('Delete',micropost_path(m2))}
    end 
  end
end
