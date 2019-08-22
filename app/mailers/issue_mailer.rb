# issue_mailer.rb
class IssueMailer < ApplicationMailer
  default from: 'muhammadbasil05@gmail.com'

  # Notifies through email
  def notify(email_address, issue_sequence_id, company_id)
    Company.current_id = company_id
    @email_address = email_address
    @issue = Issue.find_by(sequence_num: issue_sequence_id)
    mail(to: @email_address, subject: "#{@issue.company.name} | #{@issue.project.title} | #{@issue.title} | Update ")
  end
end
