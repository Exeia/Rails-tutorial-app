class SessionsController < ApplicationController
<<<<<<< HEAD
  protect_from_forgery with: :exception 
  include SessionsHelper 

  def new
  end
  def create 
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
          log_in user
          remember user
          redirect_to user 
      else
        flash[:danger] = 'Invalid email/password combination' 
        render 'new'
      end
  end

  def destroy
      log_out if logged_in? 
      redirect_to root_url
  end 
=======
include SessionsHelper
    def new

        
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
           if user && user.authenticate(params[:session][:password])
               sign_in user
               redirect_to user
           else
                flash[:error] = 'Invalid email/password combination' # Not quite right!
                render 'new'
           end 
    end
    
    def destroy
       sign_out
       redirect_to root_url 
    end
>>>>>>> sign-up
end
