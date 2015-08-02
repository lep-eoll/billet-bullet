require 'fileutils'
require 'csv'

class EventReporter

  EVENTS_TO_REPORT = [
    2, # Avatseremoonia - Opening Gala
    3, # Kaneeli Karu Pubi Salakõrts - Cinnamon Bear Pub Speakeasy
    4, # Laulupidu - Song Festival
    5, # Kuldne Ball - Golden Ball
    6, # Tantsupeo järelpidu - Folk Dance After Party
    7, # Noorte õhtu - Youth Meet & Greet
    9, # PEAK 2 PEAK mäepilet - PEAK 2 PEAK Alpine Experience Lift Pass
    10, # Registreerimine - Registration
    11, # Kuldkaart - Gold Card
    13, # EKN-ERKÜ Kongress - EKN-ERKÜ Congress
    14, # Tutvumispidu - Welcome Party
    15, # Lastenurk - Kids Corner
    17, # Seminar (2) - Eesti Idufirmad - Estonian Start ups
    18, # Seminar (1) - EL ja Eesti - EU and Estonia
    19, # (1/4) Kammerkoor Unistus - Unistus Chamber Choir
    20, # (2/4) Noored külalisesinejad - Youth guest performances
    21, # (3/4) Eesti helid, värvid ja traditsioonid - Colours, Sounds & Traditions of Estonia
    22, # (4/4) Rahvusooper "Estonia" - National Opera of Estonia
    23, # Rahva-ja grillipidu - Folk Picnic BBQ
    24, # Lastenurk - Kids Corner
    27, # Noorte ronimine keskuses 'The Core' - Youth Climb at the Core
    28, # Lastenurk - Kids Corner
    29, # EOLL koosolek - EOLL Meeting
    30, # Kirikukontsert  - Church Concert
    31, # Akadeemiline Lõuna - Academic Luncheon
    32, # Tantsupidu - Folk Dance Celebration
    33, # Tantsupeo transport - Folkdance Transportation
    34, # Vanemuise Balletiteatri etendus - Vanemuine Ballet Performance
    35, # Noorte kinoõhtu - Youth movie night
    36, # Lõpupidu - Festival Closing Party
    37, # Festivali Pildi Album - Festival Album
    38, # Tervitused kavas - Program Greetings
    39, # Chan Center koorilaulukontsert - Chan Centre Choral Concert
    40, # Kontsert Peetri Kirikus - Concert in St. Peter's Church
    41, # Seminar (3) - Rahvusooper Estonia ajalugu - History of the Estonian National Opera House
    42, # Seminar (4) Linda kivi kandmine - Carrying Linda’s Stones
    43, # Ballile Hilinejad - Crash the Ball
    45, # Suvehooaja matkapääse - Summer Season Hiking Pass
    46, # Seminar (5) - Eesti laulupidude pärandi uurimine - Explore the heritage of song festivals in Estonia.
    47 # Seminar (6) - Eesti taas eesliinil - Estonia Again on the Front Lines
  ]


  def do_it(dest_dir = 'event_reports')
    FileUtils::mkdir_p dest_dir
    sorted_event_orders = add_orders(new_event_hash)
    sorted_event_orders.keys.each do |event_id|
       process_event(event_id, sorted_event_orders.delete( event_id ), dest_dir)
    end
  end

  def process_event(product_id, orders, dest_dir)
    event = Spree::Product.find product_id
    CSV.open("#{dest_dir}/#{event.name.strip.gsub('.','_').gsub(' ','_').gsub(/[^0-9a-z_]/i, '').squeeze('_')}.csv", 'w',
             write_headers: true, :headers => ["Last Name","First Name","Sale Date", "Quantity", "Ticket Type"]) do |csv_object|
      orders.sort{ |a,b| a.billing_address.lastname.upcase.strip <=> b.billing_address.lastname.upcase.strip}.each do |o|
        o.line_items.reject {|li| li.product.id != product_id}.each do |li|
          csv_object << [o.billing_address.lastname,
                         o.billing_address.firstname,
                         o.completed_at.strftime('%b %d'),
                         li.quantity,
                         li.sku
                        ]
        end
      end
    end
  end

private

  def add_orders(event_hash)
    Spree::Order.includes(:line_items).where(state: :complete).find_each do |order|
      order.line_items.each do |li|
        product_id = li.product.id
        if event_hash.keys.include? product_id
          event_hash[li.product.id] = event_hash[li.product.id] << order unless event_hash[li.product.id].include? order
        end
      end
    end
    event_hash
  end

  def new_event_hash
    Hash[EVENTS_TO_REPORT.collect { |e_id| [e_id, []] }]
  end
end
