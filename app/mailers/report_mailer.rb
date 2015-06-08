class ReportMailer < ActionMailer::Base
  default from: "ivar@oobik.com"
  ADMINS = %w[ivar@oobik.com liligo@shaw.ca olev@lep2015.com hjaako@discoverycapital.com karin@lep2015.com]

  def daily_report(report_zip_filename)
    attachments[report_zip_filename] = File.read(report_zip_filename)
    mail(to: ADMINS, subject: "LEP Sales Reports #{Time.current.strftime('%a %b %d')}")
  end

end
