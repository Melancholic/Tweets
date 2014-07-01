class SessionsController < ApplicationController
  def new
  end

  def create
    user= User.find_by(email: params[:session][:email].downcase);
    if(user && user.authenticate(params[:session][:password]))
      #sign user
      sign_in(user);
      flash.now[:succes]="#{user.name}, welcome to Tweets!";
      redirect_to(user);

    else
      #create error msg
      flash.now[:error]='Uncorrect email or password!'
      render('new');
    end
  end
  
  def destroy()
    sign_out();
    redirect_to(root_url);
  end
end
