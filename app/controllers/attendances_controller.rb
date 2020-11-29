class AttendancesController < ApplicationController
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
end
