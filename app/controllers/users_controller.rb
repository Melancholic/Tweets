class UsersController < ApplicationController
  #for not signed users
  before_action :signed_in_user, only:[:index,:edit,:update, :destroy]
  #for signied users
  before_action :correct_user, only:[:edit,:update]
  #for admins
  before_action :admin_user, only: :destroy
  #for signed for NEW and CREATE
  before_action :signed_user_to_new, only:[:new, :create]
  def new
    @user=User.new();
  end
  def show()
    @user = User.find(params[:id]); 
  end

  def index()
    #@users =  User.all.sort_by { |s| s.name };
    @users=User.paginate(page: params[:page]);
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

  def destroy
    uname=User.find(params[:id]).name;
    if(User.find(params[:id]).destroy)
      flash[:success]="User #{uname} has been deleted!";
    else
      flash[:error]="User #{uname} has not been deleted!";
    end
    redirect_to(users_url);
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

  def admin_user
    redirect_to(root_url) unless current_user.admin?;
  end
  
  def signed_user_to_new
    if(!current_user?(@user))
        redirect_to(root_url);
    end
  end
end
