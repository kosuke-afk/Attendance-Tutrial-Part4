class User < ApplicationRecord  # この継承がActiveRecordのメソッドを使えるようにしている。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }  # 右側の式はself.email.downcaseと書くことができるが、modelファイルの中では省略可能

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続化セッションのためにハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token  # userオブジェクトの仮想属性のremember_tokenにランダムな文字列を代入している 仮想属性のremember_tokenにその値を入れている
    update_attribute(:remember_digest, User.digest(remember_token)) # update_attributeメソッドを使って:remember_digestを更新している。
  end                                                               # update_attributeはupdate_attributesとは違いvalidationを素通りさせる。
  
    # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
end
