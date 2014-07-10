require 'spec_helper'

describe "MicropostPages" do
  subject { page}
  let(:user){FactoryGirl.create(:user)}
  before{sign_in user}
  describe "CREATE micropost" do
    before  {visit root_path}
    describe "with invalid data" do
      it "should not create a micropost" do
        expect{ click_button "Send!"}.not_to change(Micropost, :count)
      end
      describe "error messages" do
        before { click_button "Send!"}
        it{should have_content('error')}
      end
    end

    describe "with valid data" do
      before  {fill_in 'micropost_content', with:"Tstasa"}
      it"should create a micropost" do
        expect{click_button("Send!")}.to change(Micropost, :count).by(1)
      end
    end
  end
end
