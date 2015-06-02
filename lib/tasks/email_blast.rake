namespace :email_blast do

  task :registration_collection => :environment do
    include EmailOrderHelper
    num_to_send = 0
    Spree::Order.where(state: 'complete').each do |order|
      #begin
        greets =  number_of_greetings(order)
        ball_tix = num_ball_tickets(order)
        regs = num_registrations(order)
        reg_url = registration_link(order,regs)

        if (regs > 0 )|| (greets > 0) || (ball_tix > 0)
          #send the email!
          RegistrationMailer.data_collection_email(order,greets,ball_tix,regs,reg_url ).deliver

          #puts "#{order.number} -----------------------"
          #puts "#{regs} num registrations" if regs > 0
          #puts "#{ball_tix} ball tickets" if ball_tix > 0
          #puts "#{greets} greetings" if greets > 0
          num_to_send += 1
        end
      #rescue Exception => e
        #ap "Error!" + e.message
      #end
    end
    puts "Num Emails : #{num_to_send}"
  end

end

