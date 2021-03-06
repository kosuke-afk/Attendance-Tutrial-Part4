class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  
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

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date # 当日をDate.currentで取得して、beginning_of_monthで当月の初日を取得
    @last_day = @first_day.end_of_month # end_of_monthで当月の末日を取得
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。 orderメソッドは取得したデータを並べ替える
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      # 生成した日付データを正しく@attendancesに代入するため
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end