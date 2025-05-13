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

    private

    def user_params
      # Strong parameters for user registration.
      params.require(:user).permit(:username, :bio, :avatar_url, :password, :password_confirmation)
    end
end
# This controller handles our user registration and profile display.
