# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
require 'securerandom'
def secure_token()
    token_file = Rails.root.join('.secret');
    if (File.exist?(token_file))
        File.read(token_file).chomp;
    else
        token=SecureRandom.hex(64);
        File.write(token_file, token);
        token
    end
end

Tweets::Application.config.secret_key_base = secure_token();
#Tweets::Application.config.secret_key_base = '35fb763ea9290bb563e8effe45077d33129714213ca46c74049aff46a4eb2309f3bc74c8cc58352fb5af0fe51e7b4f3ee39fd8b1182a0b7bf3eed4616e6dd6c0'
