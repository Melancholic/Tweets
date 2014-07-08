require 'spec_helper'

describe Micropost do
  let(:user){FactoryGirl.create(:user)}
  before do
    @micropost = user.microposts.build(content: "Test post")
  end

  subject {@micropost}
  #Тест наличия главных полей
  it{should respond_to(:content)}
  it{should respond_to(:user_id)}
  #Тест наличие связи с  Users
  it{should respond_to(:user)}
  its(:user) {should eq user}
  # Тест валидности user_id
  describe "If user id is not valid" do
    before{@micropost.user_id=nil}
    it{should_not be_valid}
  end

end
