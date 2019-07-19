# user_mailer.rb
class UserMailer < Devise::Mailer
  default from: 'muhammad.abdullah@7vals.com'

  def invite(company, recipient)
    @company = company
    @recipient = recipient

    mail(to: recipient.email, subject: 'Invitation')
  end

  def confirmation(recipient)
    @recipient = recipient

    mail(to: recipient.email, subject: 'Account Confirmation')
  end
end
