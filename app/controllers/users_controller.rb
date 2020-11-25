class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params_user)
    if @user.save
      log_in @user  # 保存成功後ログイン
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  private
    
    def params_user
      params.require(:user).permit( :name, :email, :password, :password_confirmation )
    end
end
