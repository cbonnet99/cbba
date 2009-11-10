module ApplicationHelper

  def str_to_bool(str)
    if str.is_a?(TrueClass) || str.is_a?(FalseClass)
      return str
    end
    if str.blank?
      return false
    else
      if str.downcase == "true"
        return true
      else
        return false
      end
    end
  end

  def log_bam_user_event(name, destination_url = nil, extra_data = nil, options = {})
    unless request.env["HTTP_USER_AGENT"] =~ /bot/
      log_user_event(name, destination_url, extra_data, options.merge(:browser => request.env["HTTP_USER_AGENT"], :session => session.session_id ))
    end
  end

  def link_articles_subcategories(article)
    article.subcategories.map{|s| link_to s.name, articles_for_subcategory_url(s.slug)}.to_sentence
  end

  def first_sentence(text)
    unless text.nil?
      if text.index("<p")
        index = text.index(/\<\/p\>/)
        offset = 4
      else
        index = text.index(/\\n|\<br\/\>|\<br\>/)
        offset = -1
      end
      if index.nil?
        text
      else
        text[0..index+offset]
      end
    end
  end

  def url_decode(str)
    if str.nil?
      ""
    else
      CGI::unescape(str)
    end
  end

  def failsafe_to_date(date)
    unless date.nil?
      date.to_date
    end
  end

	def undasherize(s)
    unless s.nil?
      s.gsub(/-/, ' ').capitalize
    end
	end
	def undasherize_capitalize(s)
    unless s.nil?
      s.split('-').map(&:capitalize).join(' ')
    end
	end

  def phone_blank?(phone_number_str)
    phone_number_str.blank? || phone_number_str == "()"
  end

  def thumbnail_image(user)
    if user.photo.exists? && (user.user_profile.published? || (logged_in? && current_user == user))
      image_tag user.photo.url(:thumbnail), :width => 50
    else
      image_tag "nophoto.gif", :width => 50
    end
  end

  def medium_image(user)
    if user.photo.exists? && (user.user_profile.published? || (logged_in? && current_user == user))
      image_tag user.photo.url(:medium), :width => 90
    else
      image_tag "nophoto.gif", :width => 90
    end
  end

  def link_to_profile(user, review=false)
    if user.free_listing?
      ""
    else
      if user.user_profile.published?
        link_to "View full profile", user_url_with_context(user, review), {:id => "link-full-profile-content", :class => "button"}
      else
       "<div id='link-profile-coming-soon-content', class='button'>Profile coming soon</div>"
      end
    end
  end

  def link_to_message(user)
    if user.free_listing?
      ""
    else
      link_to "Send message", user_slug_action_url(:protocol => APP_CONFIG[:logged_site_protocol], :slug => user.slug, :action => "message")
    end
  end

  def profile_description(user)
    if user.free_listing?
      ""
    else
      if user.user_profile.published?
        "Full profile available"
      else
       "Full profile coming soon"
      end
    end
  end

  def author_link(user)
    if user.active?
      link_to user.name, user_url_with_context(user)
    else
      user.name
    end
  end

  def use_tinymce
    @content_for_tinymce = ""
    content_for :tinymce do
      #had to specify a non-asset path to prevent caching bug: see http://blog.p.latyp.us/2008/04/tinymce-and-using-rails-asset-hosts.html
      javascript_include_tag "https://#{APP_CONFIG[:site_host]}/javascripts/tiny_mce/tiny_mce"
    end
    @content_for_tinymce_init = ""
    if current_user.admin?
      content_for :tinymce_init do
        javascript_include_tag "https://#{APP_CONFIG[:site_host]}/javascripts/mce_editor_admin1"
      end
    else
      content_for :tinymce_init do
        javascript_include_tag "https://#{APP_CONFIG[:site_host]}/javascripts/mce_editor2"
      end
    end
  end

  def user_profile_url(user_profile)
    user_url(user_profile.user)
  end

  def blank_phone_number?(number_as_string)
    number_as_string.blank? || number_as_string == "-"
  end


  #when the context needs to be recorded (ie when a user profile has been clicked from a particular listing or from an article)
  def user_url_with_context(user, review=false)
    options = {:review => review }
    unless @article.nil?
      options[:article_id] = @article.id
    end
    unless @category.nil?
      options[:category_id] = @category.id
    end
    unless @subcategory.nil?
      options[:subcategory_id] = @subcategory.id
    end
    expanded_user_url(user, options)
  end

  def expanded_user_url(user, options={})
    options.merge!(:main_expertise_slug => user.main_expertise_slug, :region => user.region.slug, :name => user.slug)
    if options.include?(:selected_tab_id) && !options[:selected_tab_id].blank?
      user_tabs_url(options)
    else
      full_user_url(options)
    end
  end

  def expanded_user_tabs_url(user, tab, options={})
    if tab.blank?
      tab = Tab::ARTICLES
    end
    options.merge!(:main_expertise_slug => user.main_expertise_slug, :region => user.region.slug,
      :name => user.slug, :selected_tab_id => tab )
    user_tabs_url(options)
  end

  def convert_amount(amount_integer)
    return amount_integer/100.0
  end

  def amount_view(amount_integer)
    s = amount_integer.to_s

    "$#{s[0..-3]}.#{s.slice(-2, 2)}"
  end

  def paypal_unencrypted_url(payment, payment_type="full_member", return_address="http://#{$hostname}/payments/thank_you?type=full_member")
    decrypted = {
      "cert_id" => "#{CryptoPaypal::Config.paypal_cert_id}",
      "cmd" => "_xclick",
      "business" => "#{CryptoPaypal::Config.paypal_business}",
      "item_name" => payment.title,
      "item_number" => "1",
#      "custom" => payment.comment,
      "amount" => convert_amount(payment.amount),
      "currency_code" => "NZD",
      "country" => "NZ",
      "no_note" => "1",
      "no_shipping" => "1",
      "custom" => payment_type,
#      "invoice" => payment.invoice_number,
      "return" => return_address,
      "rm" => "2"
#      "address1" => current_user.address1,
#      "first_name" => current_user.first_name,
#      "last_name" => current_user.last_name,
#      "city" => current_user.city,
#      "phone" => blank_phone_number?(current_user.phone) ? current_user.mobile : current_user.phone
    }
    return CryptoPaypal::Config.paypal_server+"?"+decrypted.to_query
  end

  def paypal_encrypted(payment, payment_type="full_member", return_address="http://#{$hostname}/payments/thank_you?type=full_member")

    # cert_id is the certificate if we see in paypal when we upload our own
    # certificates cmd _xclick need for buttons item name is what the user will
    # see at the paypal page custom and invoice are passthrough vars which we
    # will get back with the asunchronous notification no_note and no_shipping
    # means the client won't see these extra fields on the paypal payment page
    # return is the url the user will be redirected to by paypal when the
    # transaction is completed.
    decrypted = {
      "cert_id" => "#{CryptoPaypal::Config.paypal_cert_id}",
      "cmd" => "_xclick",
      "business" => "#{CryptoPaypal::Config.paypal_business}",
      "item_name" => payment.title,
      "item_number" => "1",
      "custom" => payment.comment,
      "amount" => convert_amount(payment.amount),
      "currency_code" => "NZD",
      "country" => "NZ",
      "no_note" => "1",
      "no_shipping" => "1",
      "custom" => payment_type,
      "invoice" => payment.invoice_number,
      "return" => return_address,
      "rm" => "2",
      "address1" => current_user.address1,
      "first_name" => current_user.first_name,
      "last_name" => current_user.last_name,
      "city" => current_user.city,
      "phone" => blank_phone_number?(current_user.phone) ? current_user.mobile : current_user.phone
    }
      
    logger.debug("============ decrypted: #{decrypted.inspect}")
    return CryptoPaypal::Button.from_hash(decrypted).get_encrypted_text

  end

  def own_profile?(user)
    logged_in? && current_user == user
  end

	def is_author?(item)
		logged_in? && !item.nil? && current_user.author?(item)
	end

	def is_full_member?
		logged_in? && current_user.full_member?
	end

	def is_reviewer?
		logged_in? && current_user.has_role?('reviewer')
	end

	def is_admin?
		logged_in? && current_user.has_role?('admin')
	end

	def dasherize(s)
		s.downcase.gsub(/ /, '-')
	end

	def describe_search(region, district, category, subcategory)
    res = ""
    unless category.nil? && subcategory.nil?
      res << " for #{subcategory.nil? ? (category.nil? ? "" : category.name) : subcategory.name}"
    end
    unless district.nil? && region.nil?
    	res << " in #{district.nil? ? region.nil? ? "" : region.name : district.name}"
    end
    return res
	end

	def javascript(*files)
		content_for(:js) { javascript_include_tag(*files) }
	end

	def shorten_string(str, max_size, extension="...")
    if str.nil?
			return nil
		else
			if str.size <= max_size
				return str
			else
				words = str.split(" ")
				words.pop
				while words.join(" ").size > max_size do
					words.pop
				end

				return words.join(" ") + extension
			end
		end
	end

  def tag_cloud(tags, classes)
    max, min = 0, 0
    tags.each { |t|
      max = t.count.to_i if t.count.to_i > max
      min = t.count.to_i if t.count.to_i < min
    }

    divisor = ((max - min) / classes.size) + 1

    tags.each { |t|
      yield t.name, classes[(t.count.to_i - min) / divisor]
    }
  end

  # Sets the page title and outputs title if container is passed in. eg. <%=
  # title('Hello World', :h2) %> will return the following: <h2>Hello World</h2>
  # as well as setting the page title.
  def title(str, container = :h2)
    page_title(str) if @page_title.blank?
    content_tag(container, str ) if container
  end

  def page_title(str)
    @page_title = "#{APP_CONFIG[:site_name]} - #{str}"
  end

  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}", :class => "flash" ) unless flash[msg.to_sym].blank?
    end
    messages
  end
  
end
