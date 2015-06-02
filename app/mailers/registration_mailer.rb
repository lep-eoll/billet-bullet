class RegistrationMailer < ActionMailer::Base
  default from: "info@lep2015.com"

  def data_collection_email(order, num_greetings, num_ball_tix, num_regs, registration_url)
    @order = order
    @num_greets = num_greetings
    @num_ball_tix = num_ball_tix
    @num_registrations = num_regs
    @reg_url = registration_url

    mail(to: @order.email,  subject: 'LEP2015 Registration Info Needed for Your Event Tickets!')
  end
end
