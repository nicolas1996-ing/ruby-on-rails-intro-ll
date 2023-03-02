module SessionsHelper

    # session: metodo de rails para crear sesiones temporales
    def log_in(user)
        session[:user_id] = user.id
        session[:session_token] = user.session_token
    end

      # Remembers a user in a persistent session.
    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end


      # Returns the user corresponding to the remember token cookie.
    def current_user
        if (user_id = session[:user_id])

            user = User.find_by(id: user_id)
            if user && session[:session_token] == user.session_token
                # user.session_toke es un metodo asociado a la modelo: app/models/user.rb
                @current_user = user
            end

        elsif (user_id = cookies.encrypted[:user_id])
        # raise       # The tests still pass, so this branch is currently untested.
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
            log_in user
            @current_user = user
        end
        end
    end

      # Forgets a persistent session.
    def forget(user)
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        !current_user.nil?
    end

    # Logs out the current user.
    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

    # Returns true if the given user is the current user.
    def current_user?(user)
        user && user == current_user
    end

     # Stores the URL trying to be accessed.
     # solo se ejecuta el metodo si se lanza una peticion TIPO GET
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
end
