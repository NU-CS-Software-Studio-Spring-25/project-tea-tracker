class UsersController < ApplicationController
    def new
      # New user object for the registration form.
      @user = User.new
    end

    def create
      # Create a new user with the provided parameters.
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Welcome, #{@user.username}!"
      else
        render :new
      end
    end

    def show
      # Find the user by ID and load their teas.
      @user = User.find(params[:id])
      @teas = @user.teas
    end
    
    def check_username
      # Check if a username is already taken
      username = params[:username].to_s.strip.downcase
      
      # Validate format
      if username.length < 3 || username.length > 30
        render json: { valid: false, message: "Username must be 3-30 characters" }
        return
      end
      
      # Check if the username contains invalid characters
      unless username =~ /\A[a-zA-Z0-9_.-]+\z/
        render json: { valid: false, message: "Username can only contain letters, numbers, and the characters _ . -" }
        return
      end
      
      # Check if the username is already taken
      user_exists = User.where("lower(username) = ?", username).exists?
      
      if user_exists
        render json: { valid: false, message: "Username is already taken" }
      else
        render json: { valid: true, message: "Username is available" }
      end
    end

    private

    def user_params
      # Strong parameters for user registration.
      params.require(:user).permit(:username, :bio, :avatar_url, :password, :password_confirmation)
    end
end
# This controller handles our user registration and profile display.
