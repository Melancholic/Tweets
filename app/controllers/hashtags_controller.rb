class HashtagsController < ApplicationController
  
  def index
  end

  def show()
    @hashtag=Hashtag.find(params[:id]);
    @feed_items= @hashtag.micropost.paginate(page:params[:page]);
    @res="";
  end
private
  def hashtag_params()
    params.require(:hashtag).permit(:text);
  end
end
