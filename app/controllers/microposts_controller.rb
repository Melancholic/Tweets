class MicropostsController <ApplicationController
  before_action :signed_in_user, only: [:create, :destroy];
  before_action :correct_user,  only: :destroy;
  def create
    @micropost=current_user.microposts.build(micropost_params);
    if (@micropost.save)
        flash[:succes]="Your message has been sended!";
        redirect_to(root_url);
    else
        @feed_items=[];
        flash[:error]="When you send an error occurred!";
        render('static_pages/home');
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
end

