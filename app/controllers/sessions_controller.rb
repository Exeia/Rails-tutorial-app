class SessionsController < ApplicationController
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
    def sign_in(user)
         remember_token = User.new_remember_token
         cookies.permanent[:remember_token] = remember_token
         user.update_attribute(:remember_token, User.digest(remember_token))
         self.current_user = user
    end

    def signed_in?
        !current_user.nil?
    end

    def sign_out
        current_user.update_attribute(:remember_token,
                                      User.digest(User.new_remember_token))
        cookies.delete(:remember_token)
        self.current_user = nil
    end

     def current_user=(user)
         @current_user = user
     end

     def forget(user)
         user.forget
         cookies.delete(:user_id)
         cookies.delete(:remember_token)
     end

     def current_user?
         user == current_user
     end
     def current_user
         remember_token = User.digest(cookies[:remember_token])
         @current_user ||= User.find_by(remember_token: remember_token)
     end


    def destroy
       sign_out
       redirect_to root_url 
    end

    def redirect_back_to(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
    end

    def store_location
        session[:return_to] = request.url if request.get?
    end
        
end

