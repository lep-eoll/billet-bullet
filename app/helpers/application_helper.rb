module ApplicationHelper

  def home_link_from_nav
    if ticket_homepage?
      link_to '&larr; LEP2015 Home'.html_safe, 'http://lep2015.com'
    elsif checkout_page?
      '&nbsp;'.html_safe
    else

      link_to '&larr; Pilleti Indeks / Back to Tickets'.html_safe, spree.root_path
    end
  end

  private

  def ticket_homepage?
    request.env['PATH_INFO'] == '/'
  end

  def checkout_page?
    ['/cart', '/checkout'].any? {|path| request.env['PATH_INFO'].downcase.include? path}
  end
end
