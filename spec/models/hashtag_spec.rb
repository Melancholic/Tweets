require 'spec_helper'

describe Hashtag do
  let(:msg){FactoryGirl.create(:micropost)}
  before do
    @tag = msg.hashtag.create(text: "Test_tag")
  end

  subject {@tag}
  #Тест наличия главных полей
  it{should respond_to(:text)}
  #Тест наличие связи с  Micropost
  it{should respond_to(:micropost)}
  # тест валидации данных
  describe "when blank text" do
    before{ @tag.text=' '}
    it{should_not  be_valid}
  end
  describe "when text  that is too long" do
    before{ @tag.text='a'*257}
    it{should_not  be_valid}
  end
  describe "when text that is too short" do
    before{ @tag.text=''}
    it{should_not  be_valid}
  end


end
