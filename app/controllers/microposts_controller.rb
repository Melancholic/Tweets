class MicropostsController <ApplicationController
  before_action :signed_in_user, only: [:create, :destroy];
  before_action :correct_user,  only: :destroy;

  def create
    @micropost=current_user.microposts.build(micropost_params);
    if (@micropost.valid?)
      tags=@micropost.content.scan(Hashtag.get_regex);
      if(tags.any?)
        tags=tags.map{|x| x[1..-1]};
        tags.uniq.each do |t|
          t=t.downcase;
          tag=Hashtag.find_by(text: t.downcase);
          tag||=Hashtag.new(text: t);
          if(tag.valid?)
            tag.save();
            @micropost.hashtag.push(tag);
          else
            render_msg(:error,"When you send an error  occurred (incorrect hashcode)!");
           # render('static_pages/home');
            return;
          end
        end
      end
    end
    @micropost.hashtag.uniq{|t| t.text};
    if(@micropost.save)
      render_msg(:succes,"Your message has been sended!");
      redirect_to(root_url);
    else
      #@feed_items=[];
      render_msg(:error,"When you send an error occurred!");
      #render('static_pages/home');    
    end
  end


  def destroy
    user=@micropost.user;
    @micropost.destroy;
    redirect_to user_path(user);
  end

private

  def micropost_params
    params.require(:micropost).permit(:content);
  end

  def correct_user
    @micropost=current_user.microposts.find_by(id: params[:id]);
    if (@micropost.nil?)
      @micropost=Micropost.find(params[:id]);
      if (!current_user.admin? || @micropost.nil?)
        redirect_to(root_url);
      end
    end
  end

  def render_msg (type, text)
     if(type==:error)
       @feed_items=[];
       render('static_pages/home'); 
      end
     flash[type]=text;
  end
end

