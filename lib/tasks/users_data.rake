namespace :db do
  desc "Fill database with firsts users"
  task populate: :environment do
     make_users();
     make_tweets();
     make_relationships();
  end
end

def make_users(size=50)
    File.open(File.join("log/", 'users.log'), 'a+') do |f|
      size.times do |n|
        usr=User.new;
        begin
          usr=User.new;
          tmp=Bazaar.heroku;
          usr.name=tmp.split('-')[0];
          tmp=Bazaar.heroku;
          usr.password_confirmation=usr.password=tmp.split('-')[1]
          usr.email=usr.name+"@mail.com";
          #puts "uncorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        end while (!usr.valid?)
        f.puts("#{usr.name}  #{usr.email}  #{usr.password}");
        puts "\tCorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        usr.save();
      end
    end
end

def make_tweets(size=5)
  users=User.all;
  size.times do
    content=Faker::Lorem.sentence(10);
      users.each do |user| 
        user.microposts.create!(content: content);
      end
    end   

end

def make_relationships(size=50)
  users=User.all;
  user=users.first;
  followed_usrs= users[2..50];
  followers=users[3..40];
  followed_usrs.each do |followed|
    user.follow!(followed);
  end
  followers.each do |follower|
    follower.follow!(user);
  end
end


