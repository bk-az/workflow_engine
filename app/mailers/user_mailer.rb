# user_mailer.rb
class UserMailer < Devise::Mailer
  default from: 'muhammad.abdullah@7vals.com'

  def invite(company, recipient, role)
    @company = company
    @recipient = recipient
    @role = role

    mail(to: recipient.email, subject: "Invitation | #{@company.name} | #{@role.name}" )
  end

  def confirmation(recipient)
    @recipient = recipient

    mail(to: recipient.email, subject: 'Account Confirmation')
  end
end
