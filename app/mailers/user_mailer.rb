# file thuc hien gui mail
# bien instance khai bao trong file de truyen du lieu qua file view
class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: t("activetion")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("passwordreset")
  end
end
