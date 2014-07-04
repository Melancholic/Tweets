namespace :db do
  desc "Fill database with firsts users"
  task populate: :environment do
    File.open(File.join("log/", 'users.log'), 'a+') do |f|
      1000.times do |n|
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
end
