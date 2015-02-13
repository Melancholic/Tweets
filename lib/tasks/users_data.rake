namespace :db do
  desc "Fill database with firsts users"
  task populate: :environment do
     make_users();
     make_tags();
     make_tweets();
     make_relationships();
  end
end

def make_users(size=30)
    File.open(File.join("log/", 'users.log'), 'a+') do |f|
      size.times do |n|
        usr=User.new;
        begin
          usr=User.new;
          tmp=Bazaar.heroku;
          usr.name=Faker::Lorem.sentence(10).split()[0];
          tmp=Bazaar.heroku;
          usr.password_confirmation=usr.password=tmp.split('-')[1]
          usr.email=usr.name+"@mail.com";
          #puts "uncorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        end while (!usr.valid?)
        f.puts("#{usr.name}  #{usr.email}  #{usr.password}");
        puts "\tCorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        usr.save();
        usr.verification_user.update(verification_key:"",verificated:true);
        #usr.verification_user=VerificationUser.create(user_id: usr.id, verificated:true);

      end
    end
end

def make_tweets(size=30)
  users=User.all;
  size.times do
    tag="tag"+Random.rand(5).to_s;
    content=(Faker::Lorem.sentence(10)+" #"+tag).split(" ").shuffle.join(" ");
      users.each do |user| 
        user.microposts.create!(content: content,hashtag:[Hashtag.find_by(text: tag)]);
      end
    end   

end

def make_relationships()
  users=User.all;
  user=users.first;
  followed_usrs= users[2..25];
  followers=users[3..20];
  followed_usrs.delete(User.tweets_user);
  followers.delete(User.tweets_user);
  followed_usrs.each do |followed|
    user.follow!(followed);
  end
  followers.each do |follower|
    follower.follow!(user);
  end
end

##How in make_user in random!
def make_tags(size=5)
  for i in 0..5  do
    Hashtag.create!(text:"tag"+i.to_s);
  end
end
