class UsersController < ApplicationController
    before_action :authenticate_user!, only: [ :profile, :update_profile, :update_password, :destroy_account ]

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

    def profile
      # User profile page with forms for editing
      @user = current_user
    end

    def update_profile
      @user = current_user
      if @user.update(profile_params)
        redirect_to profile_path, notice: 'Your profile has been updated successfully!'
      else
        # Add error message
        flash.now[:alert] = 'There was a problem updating your profile.'
        render :profile
      end
    end

    def update_password
      @user = current_user
      if !@user.authenticate(params[:user][:current_password])
        flash.now[:alert] = 'Current password is incorrect'
        render :profile
      elsif params[:user][:password].blank?
        flash.now[:alert] = "New password can't be blank"
        render :profile
      elsif @user.update(password_params)
        redirect_to profile_path, notice: 'Your password has been updated successfully!'
      else
        # Return to profile page with errors
        flash.now[:alert] = "There was a problem updating your password: #{@user.errors.full_messages.join(', ')}"
        render :profile
      end
    end

    def destroy_account
      @user = current_user
      if params[:confirm_delete] == 'DELETE' && @user.authenticate(params[:user][:password])
        @user.destroy
        session.delete(:user_id)
        redirect_to root_path, notice: 'Your account has been successfully deleted.'
      else
        flash.now[:alert] = "Account deletion failed. Please make sure you typed 'DELETE' and entered your password correctly."
        render :profile
      end
    end

    def check_username
      # Check if a username is already taken
      username = params[:username].to_s.strip.downcase

      # Validate format
      if username.length < 3 || username.length > 30
        render json: { valid: false, message: 'Username must be 3-30 characters' }
        return
      end

      # Check if the username contains invalid characters
      unless username =~ /\A[a-zA-Z0-9_.-]+\z/
        render json: { valid: false, message: 'Username can only contain letters, numbers, and the characters _ . -' }
        return
      end

      # Check if the username is already taken
      user_exists = User.where('lower(username) = ?', username).exists?

      if user_exists
        render json: { valid: false, message: 'Username is already taken' }
      else
        render json: { valid: true, message: 'Username is available' }
      end
    end

    private

    def authenticate_user!
      redirect_to login_path, alert: 'Please log in to access this page' unless current_user
    end

    def user_params
      # Strong parameters for user registration.
      params.require(:user).permit(:username, :bio, :avatar_url, :password, :password_confirmation, :avatar)
    end

    def profile_params
      # Strong parameters for profile updates
      params.require(:user).permit(:bio, :avatar_url, :avatar)
    end

    def password_params
      # Strong parameters for password updates
      params.require(:user).permit(:password, :password_confirmation)
    end
end
# This controller handles our user registration and profile display.
