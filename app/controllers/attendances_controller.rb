class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。"
  
  def update
    # どのユーザーなのか判別に必要
    @user = User.find(params[:user_id])
    # どの勤怠データなのかの判別に必要
    @attendance = @user.attendances.find(params[:id])
    # @attendanceのstarted_atに値があるのか確認
    if @attendance.started_at.nil?
      # なければ、今の時間をstarted_atに入れて更新
      if @attendance.update_attributes(started_at: Time.current)
        flash[:success] = "おはようございます。"
      else
        flash[:danger] = "勤怠登録に失敗しました。"
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current)
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    # showページにリダイレクト
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
  end
  
  private
    
    def attendance_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
