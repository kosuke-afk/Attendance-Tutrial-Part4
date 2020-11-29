module AttendancesHelper
  
  def attendance_state(attendance)
    # 受け取ったattendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return "出勤" if attendance.started_at.nil?
      return "退勤" if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなければfalseを返す。
    false
  end
end