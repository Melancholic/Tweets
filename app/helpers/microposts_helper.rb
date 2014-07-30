module MicropostsHelper
  def make_preprocess(content)
    content=wrap(content);
    content=make_link_to_hashtag(content);
    content=make_link_to_user(content);
  end

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end
  
  def make_link_to_user(content)
    if(!content[User.get_regex].nil?)
      content.gsub(User.get_regex) do |u|
        user=User.find_by(name: u[1..-1]);
        if(!user.nil?)
          link_to(u , user_path(user));
        else
          u
        end
      end
    else
      content;
    end
  end


private
  def wrap_long_string(text, max_width=30)
    end_lines="&#8203;";
    regex=/.{1,#{max_width}}/;
    (text.length<max_width) ? text:text.scan(regex).join(end_lines);
  end

end
