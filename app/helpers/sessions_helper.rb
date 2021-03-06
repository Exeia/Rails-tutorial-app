module SessionsHelper

    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user 
        @current_user ||= User.find_by(id: session[:user_id])
    end


    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            raise
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user 
                @curren_user = user
            end
        end
        
    end
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
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


    def current_user
        remember_token = User.digest(cookies[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
        
    end

    def current_user?(user)
        user==current_user
        
    end    
    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        session.delete(:return_to)
        
    end

    def store_location
        session[:return_to] = request.url if request.get?
        
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenicate(params[:session][:password])
            sign_in user
            redirect_back_or user 
        else
            flash.now[:error] = 'Invalid email/password combination'
            render 'new'
            
        end
    end
end
