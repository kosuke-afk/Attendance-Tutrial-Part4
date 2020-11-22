module ApplicationHelper
  
  # ページごとにタイトルを返す。
  def full_title(page_name="")
    base_title = "AttendanceApp"
    if page_name.empty? # page_nameが空の場合base_titleだけを返す
      base_title
    else      # page_nameに値がある場合は連結した文字列を返す。
      page_name + "|" + base_title
    end
  end
end
