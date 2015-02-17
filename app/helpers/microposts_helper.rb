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

  def path_to_post(post)
    user_path(post.author, 
              anchor: "post#{post.id}",
              page: Micropost.page_for_user(post.author, post)
    );
  end

  def link_to_delete(post)
    link_to("\u2718", post, 
            method: :delete, 
            data:{ confirm: "Post \"#{truncate(post.content,length:20)}\" will be removed."+
              "This action is irreversible."+
              " Are you willing to continue?"},
            title:"Delete"
    );
  end

  def link_to_repost(post)
    link_to("\u21B7",
            repost_micropost_path(post.id),  
            method: :post, remote: true, title:"Repost"
    );
  end

private
  def wrap_long_string(text, max_width=30)
    end_lines="&#8203;";
    regex=/.{1,#{max_width}}/;
    (text.length<max_width) ? text:text.scan(regex).join(end_lines);
  end

end
