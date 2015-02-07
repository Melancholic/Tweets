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
  #тесты репостов
  
describe "Repost tests" do
  subject { page}
  let(:user) {FactoryGirl.create(:user)}
  let(:other_user) {FactoryGirl.create(:user)}
  let(:follow_user) {FactoryGirl.create(:user)}
  let!(:my_post1) {FactoryGirl.create(:micropost, user: user, content: "my post1")}
  let!(:my_post2) {FactoryGirl.create(:micropost, user: user, content: "my post2")}
  let!(:my_post3) {FactoryGirl.create(:micropost, user: user, content: "my post3")}
  let!(:other_post) {FactoryGirl.create(:micropost, user: other_user, content: "others post")}
  let!(:other_post_notr) {FactoryGirl.create(:micropost, user: other_user, content: "others post not repost me")}
  let!(:other_post_repostf) {FactoryGirl.create(:micropost, user: other_user, content: "others post reposted follow")}
  let!(:follow_post) {FactoryGirl.create(:micropost, user: follow_user, content: "follow post")}
  let!(:follow_post_notr) {FactoryGirl.create(:micropost, user: follow_user, content: "follow post not reposted me")}
  let!(:my_repost_other) {other_post.makeRepost(user)}
  let!(:my_repost_follow) {follow_post.makeRepost(user)}
  let!(:other_my_repost) {my_post1.makeRepost(other_user)}
  let!(:other_follow_repost) {follow_post_notr.makeRepost(other_user)}
  let!(:follow_my_repost) {my_post2.makeRepost(follow_user)}
  let!(:follow_other_repost) {other_post.makeRepost(follow_user)}
  let!(:follow_other_repost2) {other_post_repostf.makeRepost(follow_user)}

  before do
    sign_in user
    verificate user
    user.follow!(follow_user)
  end
    describe " on root page" do
      before{visit root_path}
      it "test posts viewing " do
        should have_title(full_title("Home"))
        should have_content(my_post1.content)
        should have_content(my_post2.content)
        should have_content(my_post3.content)
        should have_content(my_repost_other.content)
        should have_content(my_repost_follow.content)
        should_not have_content(other_post_notr.content)
        should have_content(follow_post.content)
        should have_content(follow_post_notr.content)
        should have_content(follow_my_repost.content)
        should have_content(follow_other_repost.content)
        should have_content(user.microposts.count)
        my_post1.repostedCount ==(1)
      end
#Link NOPE:
#мой пост
      it" for my posts" do
        should_not have_link("repost", href: repost_micropost_path(my_post1), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post1.id}", text:my_post1.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_post2), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post2.id}", text:my_post2.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_post3), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post3.id}", text:my_post3.repostedCount)    
      end
#мой репост

      it " for my reposts" do
        should_not have_link("repost", href: repost_micropost_path(my_repost_follow), count: 1, text:"\u21B7" )
        should have_selector("span##{my_repost_follow.id}", text:my_repost_follow.getOriginal.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_repost_other), count: 1, text:"\u21B7" )
        should have_selector("span##{my_repost_other.id}", text:other_post.repostedCount)    
      end
#чужой пост, с моим репостом
      it " for  others post with my repost " do
        should_not have_link("repost", href: repost_micropost_path(my_repost_other), count: 1, text:"\u21B7" )
        should have_selector("span##{my_repost_other.id}", text:other_post.repostedCount)    
      end
#чужой репост, с моим репостом оригинала
      it " for  others repost with me reposted original" do
        should_not have_link("repost", href: repost_micropost_path(follow_other_repost), count: 1, text:"\u21B7" )
        should have_selector("span##{follow_other_repost.id}", text:follow_other_repost.getOriginal.repostedCount)    
      end
#чужой репостмоего собщения
      it " for  others repost with me`s  original" do
        should_not have_link("repost", href: repost_micropost_path(follow_my_repost), count: 1, text:"\u21B7" )
        should have_selector("span##{follow_my_repost.id}", text:my_post2.repostedCount)    
      end


#Link EXIST:
#пост чужого  пользователя, без моего репоста
      it "for other post without my repost" do
        should have_link("repost", href: repost_micropost_path(follow_post_notr), count: 1, text:"\u21B7" )
        should have_content("reposted by #{follow_user.name}")
        should have_selector("span##{follow_post_notr.id}", text:follow_post_notr.repostedCount)
      end
#репост чужого  пользователя, без моего репоста оригинала
      it "for other repost without my repost original" do
        should have_link("repost", href: repost_micropost_path(follow_other_repost2), count: 1, text:"\u21B7" )
        should have_content("reposted by #{other_user.name}")
        should have_selector("span##{follow_other_repost2.id}", text:follow_other_repost2.getOriginal.repostedCount)
      end

    it "should repost a micropost" do
      #find(:linkhref, repost_micropost_path(follow_other_repost2)).click
      should have_link("repost", href: repost_micropost_path(follow_other_repost2), count: 1, text:"\u21B7" )
      expect{find(:linkhref, repost_micropost_path(follow_other_repost2)).click}.to change(Micropost, :count).by(1) # find it spec/support/utilities.rb 
      should_not have_link("repost", href: repost_micropost_path(follow_other_repost2),  text:"\u21B7" )
      should have_selector("span##{follow_other_repost2.id}", text:follow_other_repost2.getOriginal.repostedCount)
    end
  end
   describe "on profile page" do
    before{visit user_path(user)}
      it "test posts viewing " do
        should have_title(full_title(user.name))
        should have_content(my_post1.content)
        should have_content(my_post2.content)
        should have_content(my_post3.content)
        should have_content(my_repost_other.content)
        should have_content(my_repost_follow.content)
        should have_content(user.microposts.count)
        my_post1.repostedCount ==(1)
      end
#Link NOPE:
#мой пост
      it" for my posts" do
        should_not have_link("repost", href: repost_micropost_path(my_post1), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post1.id}", text:my_post1.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_post2), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post2.id}", text:my_post2.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_post3), count: 1, text:"\u21B7" )
        should have_selector("span##{my_post3.id}", text:my_post3.repostedCount)    
      end
#мой репост

      it " for my reposts" do
        should_not have_link("repost", href: repost_micropost_path(my_repost_follow), count: 1, text:"\u21B7" )
        should have_selector("span##{my_repost_follow.id}", text:my_repost_follow.getOriginal.repostedCount)    
        should_not have_link("repost", href: repost_micropost_path(my_repost_other), count: 1, text:"\u21B7" )
        should have_selector("span##{my_repost_other.id}", text:my_repost_other.getOriginal.repostedCount)    
      end

   end
end
