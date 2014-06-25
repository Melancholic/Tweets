require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email:"user@example.com") }
  subject {@user}
  #тест наличия
  it{ should respond_to(:name) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password_digest) }
  
  #тест валидности
  it { should be_valid }
  describe "name is null: " do
    before{@user.name=" "}
    it {should_not be_valid}
  end
  describe "email is null" do
    before{@user.email=" "}
    it {should_not be_valid}
  end
  #тест длины
  describe "name is too long" do
    before{@user.name='x'*16}
    it {should_not be_valid}
  end
  describe "name is too short" do
    before{@user.name="xx"}
    it { should_not be_valid }
  end  
  describe "email is too long" do
    before{@user.email='x'*51}
    it {should_not be_valid}
  end
  describe "email is too short" do
    before{@user.email="xx"}
    it { should_not be_valid }
  end
  #тест валидности email
  describe "email is INVALID" do
    it "should be invalid" do
      emails = %w[corr-ect@cs.ru.
                cor*.ra+ect@cs.ru
                corrA.ect@c&&sa.ru
                corr/ect@cs.ru
                corr-ect|76cs.ru
                corr-ectqcs.ru]
      emails.each do |inv_ems|
        @user.email = inv_ems;
        expect(@user).not_to be_valid
      end
    end
  end
  describe "email is VALID" do
    it "should be valid" do
      emails = %w[Cpq-ect@cs.ru
                corr.ect@cs.ru
                cAF_fwe-qwet@cs.ru
                cor+r_ect@cs.ru
                corr.12@ect.76cs.ru
                corr-ect@qcs.ru]
      emails.each do |inv_ems|
        @user.email = inv_ems;
        expect(@user).to be_valid
      end
    end
  end

  #тест валидности name
  describe "name is INVALID" do
    it "should be invalid" do
      emails = %w[corr712*
                  &7&sq7
                  ??qaq?
                  @@@qwe
                  !!q"'
                  122123]
      emails.each do |inv_ems|
        @user.name = inv_ems;
        expect(@user).not_to be_valid
      end
    end
  end
  describe "name is VALID" do
    it "should be valid" do
      emails = %w[12aa
                  NanasHs
                  HHUU
                  YAGs-as
                  sfggy_Fty]
      emails.each do |inv_ems|
        @user.name = inv_ems;
        expect(@user).to be_valid
      end
    end
  end
  #тест на уникальность email
  describe "email is already taken" do
    before do
      user_dupUP=@user.dup;
      user_dupUP.email=@user.email.upcase;
      user_dupUP.save;
    end
    it {should_not be_valid}
  end

end
