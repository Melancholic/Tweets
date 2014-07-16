class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @user=User.find(params[:relationship][:followed_id]);
    if (@user)
     current_user.follow!(@user);
     redirect_to(@user); 
    end
  end

  def destroy
    @user=Relationship.find(params[:id]).followed;
    if (@user)
      current_user.unfollow!(@user);
      redirect_to(@user);
    end
  end
end
