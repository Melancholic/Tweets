require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example", email:"user@example.com", 
          password: "foobar",password_confirmation:"foobar" )}
  subject {@user}
  #тест наличия
  it{ should respond_to(:name) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password_digest) }
  it{ should respond_to(:password) }
  it{ should respond_to(:password_confirmation) }

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
  describe "password is null" do
    before{@user.password=@user.password_confirmation=" "}
    it {should_not be_valid}
  end
  describe "password is doesnt match confirmation" do
    before{@user.password_confirmation="anotherpass"}
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
                corr-ectqcas.ru
                asdasd@aa..ru]
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
                corr.123@ec12.t12.ru
                corr-ect@qcs.ru
                assdd@asd.af]
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
#тест на успешную аунтефикацию
  it{should respond_to(:authenticate)}
  describe "return user from authenticate" do
    before{@user.save()}
    let(:found_user){User.find_by(email: @user.email)}
    describe "with valid password" do
      it{should eq found_user.authenticate(@user.password)}
    end
    describe "with invalid password" do
      let(:user_for_invalid_passwd){found_user.authenticate("invalid")}
      it { should_not eq user_for_invalid_passwd }
      it {expect(user_for_invalid_passwd).to be_false}
    end
  end

#Тест на длину пароля
   describe "password is too short" do
    before{@user.password = @user.password_confirmation="xx"}
    it { should_not be_valid }
  end

#Тесты для сессии
    describe "remember token is valid" do
      #it {should respond_to (:remember_token)}
      before {@user.save}
        its(:remember_token) {should_not be_blank}
    end
end
