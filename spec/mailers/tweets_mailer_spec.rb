require "rails_helper"

describe TweetsMailer do
  describe "verification" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { TweetsMailer.verification(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Verification your e-mail")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["tweets@anagorny.com"])
    end

    #it "renders the body" do
    #  mail.body.encoded.should match("Hi")
    #end
  end

  describe "verificated" do
    let(:user){FactoryGirl.create(:user)}
    let(:mail) { TweetsMailer.verificated(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to Tweets Project!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["tweets@anagorny.com"])
    end

    #it "renders the body" do
    #  mail.body.encoded.should match("Dear #{user.name}")
    #end
  end

end
