class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @user=User.find(params[:relationship][:followed_id]);
    if (@user)
      current_user.follow!(@user);
      respond_to do |format|
        format.html {redirect_to(@user)};
        #view in app/views/relationships/create.js.erb
        format.js;
      end
    end
  end

  def destroy
    @user=Relationship.find(params[:id]).followed;
    if (@user)
      current_user.unfollow!(@user);
      respond_to do |format|
        format.html {redirect_to(@user)};
        #view in app/views/relationships/destroy.js.erb
        format.js
      end
    end
  end
end
