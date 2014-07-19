class HashtagsController < ApplicationController
  before_action :signed_in_user, only:[:index,:edit,:update, :destroy,:show]
  before_action :admin_user, only: [:create,:destroy]

  def index
    @hashtags=Hashtag.paginate(page: params[:page]);
  end

  def show()
    @hashtag=Hashtag.find(params[:id]);
    @feed_items= @hashtag.micropost.paginate(page:params[:page]);
  end

  def destroy
    name= Hashtag.find(params[:id]).name;
    if(Hashtag.find(params[:id]).destroy)
      flash[:success]="Hashtag ##{name} has been deleted!";
    else
      flash[:error]="Hashtag #{name} has not been deleted!";
    end
    redirect_to(hashtags_path);
  end
private
  def hashtag_params()
    params.require(:hashtag).permit(:text);
  end
  #Before actions
  def admin_user
    redirect_to(root_url) unless current_user.admin?;
  end
end
