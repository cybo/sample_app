class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      flash[:success] = "Welcome to the Sample App!" 
      # sign in user and redirect to user's show page
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end


end
