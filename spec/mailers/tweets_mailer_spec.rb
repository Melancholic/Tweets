require "spec_helper"

describe TweetsMailer do
  describe "verification" do
    let(:mail) { TweetsMailer.verification }

    it "renders the headers" do
      mail.subject.should eq("Verification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "verificated" do
    let(:mail) { TweetsMailer.verificated }

    it "renders the headers" do
      mail.subject.should eq("Verificated")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
