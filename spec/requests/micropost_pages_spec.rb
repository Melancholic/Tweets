require 'spec_helper'

describe "MicropostPages" do
  subject { page}
  let(:user){FactoryGirl.create(:user)}
  before{sign_in user}
    describe "CREATE micropost" do
    before  {visit root_path}
    # Тест на отправку корректного сообщения
    describe "with invalid data" do
      it "should not create a micropost" do
        expect{ click_button "Send!"}.not_to change(Micropost, :count)
      end
      describe "error messages" do
        before { click_button "Send!"}
        it{should have_content('error')}
      end
    end
    #Тест отправки неккоректного сообщения
    describe "with valid data" do
      before  {fill_in 'micropost_content', with:"Tstasa"}
      it"should create a micropost" do
        expect{click_button("Send!")}.to change(Micropost, :count).by(1)
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
end
