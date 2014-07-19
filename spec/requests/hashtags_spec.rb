require 'spec_helper'

describe "Hashtags" do
  subject{page}
  let(:user){FactoryGirl.create(:user)}
  let!(:msg){FactoryGirl.create(:micropost, content:"text #tag",user: user)}
  let!(:tag){FactoryGirl.create(:hashtag, text:"tag",micropost:[msg])}
  before do
    sign_in user
    visit user_path(user)
    puts body
  end
  describe "profile page" do
    it{should have_title(full_title(user.name))}
    it{should have_content('#'+tag.text)}
    it{should have_link('#'+tag.text, href:hashtag_path(tag))}
  end
  describe "at hashtag page #show" do
   before do
    click_link('#'+tag.text)
  end   
  it{should have_title(full_title(tag.full_text))}
    it{should have_content(tag.full_text)}
    it{should have_content("Total tweets: #{tag.micropost.count}")}
    it{should have_link(user.name, user_path(user))}
  end

end
