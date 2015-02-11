require 'rails_helper'

describe "Hashtags" do
  subject{page}
  let(:user){FactoryGirl.create(:user)}
  let!(:msg){FactoryGirl.create(:micropost, content:"text #tag",user: user)}
  let!(:tag){FactoryGirl.create(:hashtag, text:"tag",micropost:[msg])}
  before do
    sign_in user
    verificate user
    visit user_path(user)
  end
  describe "profile page" do
    it{should have_title(full_title(user.name))}
    it{should have_content('#'+tag.text)}
    it{should have_link('#'+tag.text, href:hashtag_path(tag))}
  end
  describe "at hashtag page #show" do
   let!(:not_any_tag){FactoryGirl.create(:hashtag, text:"23tag")}
   before do
    click_link('#'+tag.text)
    end   
    it{should have_title(full_title(tag.full_text))}
    it{should have_content(tag.full_text)}
    it{should have_content("Total tweets: #{tag.micropost.count}")}
    it{should have_link(user.name, user_path(user))}
    it{should have_link("Hashtag",hashtags_path)}
    it {should have_content("Total tweets: #{tag.micropost.count}")}
    it {should have_content("Most used by user: "+user.name)}
    it {should have_content("Least used by user:")}
    it {should have_content("First tweet by user: "+user.name)}
    it {should have_content("Last tweet by user: "+user.name)}
    it {should have_content("Tweets per day:")}
    
    describe " at not any hashtag" do
      before {visit hashtag_path(not_any_tag)}
    it{should have_title(full_title(not_any_tag.full_text))}
    it{should have_content(not_any_tag.full_text)}
    it{should have_content("Total tweets: 0")}
    it{should have_content("Created: #{not_any_tag.created_at.strftime("%m.%d.%y")}")}
    it{should_not have_link(user.name, user_path(user))}
    it{should have_link("Hashtag",hashtags_path)}
    end



  end
  describe "at home page" do
    before{visit root_path}
    it{should have_title(full_title('Home'))}
    it{should have_content(tag.full_text)}
    it{should have_link(tag.full_text, hashtag_path(tag))}
    it{should have_link("#Hashtags", hashtags_path)}
  end

  describe "at hashtags (#index) page" do
    before{click_link('#Hashtags')}
    it{should have_title(full_title('#Hashtags'))}
    it{should have_link('List')}
    it{should have_link('Cloud')}
    describe "at List" do
      before{click_link('List')}
        it{should have_content('#Hashtags')}
        it{should have_content(tag.full_text)}
        it{should have_link(tag.full_text, hashtag_path(tag))}
    end
    describe " at Cloud" do
      before do
        FactoryGirl.create(:hashtag, text:"tag12")
        click_link('Cloud')
        puts body
      end
# JQuery not works in IT!
#        it{should have_content('#Hashtags')}
#        it{should have_content(tag.full_text)}
#        it{should have_link(tag.full_text, hashtag_path(tag))}
#        it{should have_content(Hashtag.all.first.text)}
#        it{should have_link(Hashtag.all.first.text, hashtag_path(Hashtag.all.first))}
#        it{should have_content(Hashtag.all.last.text)}
#        it{should have_link(Hashtag.all.last.text, hashtag_path(Hashtag.all.last))}
        
    end
  end

end
