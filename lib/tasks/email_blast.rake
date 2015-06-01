namespace :email_blast do
  task :registration_collection => :environment do
    num_to_send = 0
    Spree::Order.where(state: 'complete').each do |order|
      #begin
        greets =  number_of_greetings(order)
        ball_tix = num_ball_tickets(order)
        regs = num_registrations(order)
        reg_url = registration_link(order,regs)

        if (regs > 0 )&& (greets > 0) && (ball_tix > 0)
        #if (regs > 0 )|| (greets > 0) || (ball_tix > 0)
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

  def number_of_greetings(order)
    #"Tervitused kavas - Program Greetings id = 38"
    order.line_items.to_a.inject(0) {|n, li| li.product.id == 38 ? n + li.quantity : n }
  end

  def num_ball_tickets(order)
    #"Kuldne Ball - Golden Ball id = 5"
    order.line_items.to_a.inject(0) {|n, li| li.product.id == 5 ? (n + li.quantity) : n }
  end

  def num_registrations(order)
    #Kuldkaart - Gold Card id =  11
    #Registreerimine - Registration id = 10
    order.line_items.to_a.inject(0) {|n, li| (li.product.id == 10 || li.product.id == 11) ? n + li.quantity : n }
  end

  def registration_link(order, num_regs)
    name =  URI::encode(user_name(order))
    case num_regs
    when 0
      nil
    when 1
      "https://docs.google.com/a/oobik.com/forms/d/1SUgkGDtIGJrIcxhzP0nMeX2nhgcniciPYeZRqtP7iUo/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 2
      "https://docs.google.com/forms/d/1UfdxFhl3nwGr3UcJjNL7MgXdpBHOP1EoqbvgAFEfxCQ/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 3
      "https://docs.google.com/forms/d/1igFZvewPorCS5Jmj9AqsD-LWyYB1gLwzyBe7Vs_b-uU/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 4
      "https://docs.google.com/forms/d/1v9EwUDs0ZUB919j0fn0F_Yip-a0HZYhalzyertC2e_4/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 5
      "https://docs.google.com/forms/d/1qX-uOT-EeRl9Gp56J4r7gqxUdqQ8t4HiIpIhMscjvpY/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 6
      "https://docs.google.com/forms/d/1nFPH89uYGug1QTa5f11m5MeVjVJAw_gYV312KpLLhpo/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"

    when 7
      "https://docs.google.com/forms/d/1SkSCw5RdrMMF9zDxXpXJx2ENIQ33tyhqPDi6c-uxajg/viewform?entry.993763151=#{order.number}&entry.165213453=#{name}"
    end
  end

  def user_name(order)
    address = order.user.present? ? order.user.bill_address : order.bill_address
    address = order.ship_address if address.nil?
    if address.nil?
      raise "No address for order #{order.id}  #{order.number}"
    end
    address.firstname + ' ' + address.lastname
  end
end

