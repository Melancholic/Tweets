require 'spec_helper'

describe VerificationUser do
    let(:vu){FactoryGirl.create(:VerificationUser);}
    subject {vu}

    it {should respond_to(:user_id)}
    it {should respond_to(:verification_key)}
    it {should respond_to(:verificated)}


end
