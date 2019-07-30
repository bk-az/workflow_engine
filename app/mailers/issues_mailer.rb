# issues_mailer.rb
class IssuesMailer < Devise::Mailer
  default from: 'muhammad.basil@7vals.com'

  # Notifies through email
  def notify(email_address, issue)
    @email_address = email_address
    @issue = issue
    mail(to: @email_address,
         subject: "#{@issue.project.title} | #{@issue.title} | Update ")
  end
end
