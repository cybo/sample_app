class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  before_action :session_user,   only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
      redirect_to @user # same as show_user_path?
    else
      render 'new'
    end
  end

  # rails uses patch request because Active Record checks @user
  # if @user.new_record? is true it uses POST, if false, PATCH
  def update
    # @user = User.find(params[:id])  # not needed...
    if @user.update_attributes(user_params)
      # handle successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
    # @user = User.find(params[:id]) 
    # not needed since before_action :correct_user defined
  end

  # users_path => GET
  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def session_user
      redirect_to(root_url) if signed_in?
    end

end
