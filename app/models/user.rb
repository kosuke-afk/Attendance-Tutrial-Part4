class User < ApplicationRecord  # この継承がActiveRecordのメソッドを使えるようにしている。

  before_save { self.email = email.downcase }  # 右側の式はself.email.downcaseと書くことができるが、modelファイルの中では省略可能

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
