class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def new
    @user = User.new
  end
  
  def show
  end
  
  def index
    @users = User.paginate(page: params[:page])
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
  end
  
  def update
    if @user.update_attributes(params_user) # @userに入っている情報をupdate_attributesメソッドに引数としてparams_userを渡して更新
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  private
    
    def params_user
      params.require(:user).permit( :name, :email, :department, :password, :password_confirmation )
    end
    
    def set_user
      @user = User.find(params[:id]) # どのユーザーかの識別に必要 edit, show, updateで使う
    end
    # ログインしているユーザーのみ使えるようにする。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # ログインしているユーザーとアクセスしたユーザーが同じ場合のみ使えるようにする
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者権限を持っていないと使えないようにする
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
