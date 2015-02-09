class StaticPagesController < ApplicationController
  before_action :verificated_user, only: :home;
  def home
    if(signed_in?)
      @micropost=current_user.microposts.build;
      @feed_items=current_user.feed.paginate(page:params[:page]);
    else
      @feed_items=User.tweets_user.feed.paginate(page:params[:page]) unless User.tweets_user.nil?;
    end
    @feed_items||=[];
    @top_post=Micropost.top_rated(1).first;
  end

  def help
  end

  def about
  end

  def contacts
  end

  def tops
    @title="Tops of Tweets";

  end
end
