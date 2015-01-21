require "spec_helper"

describe TweetsMailer do
  describe "verification" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { TweetsMailer.verification(user) }

    it "renders the headers" do
      mail.subject.should eq("Verification your e-mail")
      mail.to.should eq([user.email])
      mail.from.should eq(["tweets@anagorny.com"])
    end

    #it "renders the body" do
    #  mail.body.encoded.should match("Hi")
    #end
  end

  describe "verificated" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { TweetsMailer.verificated(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Tweets Project!")
      mail.to.should eq([user.email])
      mail.from.should eq(["tweets@anagorny.com"])
    end

    #it "renders the body" do
    #  mail.body.encoded.should match("Dear #{user.name}")
    #end
  end

end
