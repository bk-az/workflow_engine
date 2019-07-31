# issue_mailer.rb
class IssueMailer < ApplicationMailer
  default from: 'muhammadbasil05@gmail.com'

  # Notifies through email
  def notify(email_address, issue)
    @email_address = email_address
    @issue = issue
    mail(to: @email_address,
         subject: "#{@issue.project.title} | #{@issue.title} | Update ")
  end
end
