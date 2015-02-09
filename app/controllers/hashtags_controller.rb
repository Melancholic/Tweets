class HashtagsController < ApplicationController
  before_action :signed_in_user, only:[:index,:edit,:update, :destroy,:show];
  before_action :verificated_user, only:[:index,:edit,:update, :destroy,:show];
  before_action :admin_user, only: [:create,:destroy];

  def index
    @hashtags=Hashtag.paginate(page: params[:page]);
    @hashtags_array=[];
    Hashtag.take(1000).each do |tag|
      map={};
      map["text"]=tag.text;
      map["weight"]=tag.micropost.count;
      map["link"]=url_for(tag);
      @hashtags_array.push(map);
    end

    respond_to do |format|
      format.html;
      format.js;
    end
  end

  def show()
    @hashtag=Hashtag.find(params[:id]);
    @feed_items= @hashtag.micropost.paginate(page:params[:page]);
  end

  def destroy
    tag= Hashtag.find(params[:id]).text;
    if(Hashtag.find(params[:id]).destroy)
      flash[:success]="Hashtag ##{tag} has been deleted!";
    else
      flash[:error]="Hashtag #{tag} has not been deleted!";
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
