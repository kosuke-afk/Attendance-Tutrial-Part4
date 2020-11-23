module SessionsHelper
  
  def log_in(user)
    session[:user_id] = user.id # 引数に渡されたuserでログインする。 一時的にブラウザーのcookiesにuser.idを保存している。
  end
  
  # セッションと@current_userを放棄します。
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  def current_user 
    if session[:user_id]  # session[:user_id]に値があれば、
      @current_user ||= User.find_by(id: session[:user_id]) # @current_userの中に値があればそのまま
    end                                                     # なければ、session[:user_id]の値から探したユーザーオブジェクトを代入
  end
  
  # ログイン中ならtrue,ログインしていなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
end
