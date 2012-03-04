class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end 
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenido a Sample Tweet!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario destruido."
    redirect_to users_path
  end
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
       flash[:success] = "Perfil actualizado"
       sign_in @user
       redirect_to @user
     else
       render 'edit'
    end
  end
  
  private
  
    #def signed_in_user
    #  redirect_to signin_path, notice: "Por favor autentiquese." unless signed_in?      
    #end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
