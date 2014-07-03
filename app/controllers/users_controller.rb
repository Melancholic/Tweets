class UsersController < ApplicationController
  #for not signed users
  before_action :signed_in_user, only:[:index,:edit,:update]
  #for signied users
  before_action :correct_user, only:[:edit,:update]


  def new
    @user=User.new();
  end
  def show()
    @user = User.find(params[:id]); 
  end

  def index()
    @users =  User.all.sort_by { |s| s.name };
  end

  def create
    @user = User.new(user_params());
    if(@user.save)
      flash[:success] = "Welcome to Tweets!";
      sign_in @user;
      redirect_to(@user);
    else
      render 'new';
    end
  end

  def edit
    #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
    #@user= User.find(params[:id]);
  end
  
  def update
   #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
   #@user= User.find(params[:id]);
   if  (@user.update_attributes(user_params()))
      flash[:succes] = "Updating your profile is success"
      redirect_to(@user);
    else
        render 'edit';
    end
  end


private

  def user_params
    params.require(:user).permit(:name,:email,:password, :password_confirmation);
  end

  #before-filter
  
  def signed_in_user
    if(!signed_in?)
      save_target_url();
      redirect_to(signin_url, notice:"Please, sign in!");
    end
  end
  def correct_user
    @user=User.find(params[:id]);
    if (!current_user?(@user))
      redirect_to(root_url);
    end
  end
end
