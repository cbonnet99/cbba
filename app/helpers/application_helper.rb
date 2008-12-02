module ApplicationHelper
  def user_path_with_context(id)
    options = {}
    unless @article.nil?
      options[:article_id] = @article.id
    end
    unless @category.nil?
      options[:category_id] = @category.id
    end
    unless @subcategory.nil?
      options[:subcategory_id] = @subcategory.id
    end
    user_path(id, options)
  end
  def convert_amount(amount_integer)
    return amount_integer/100.0
  end

  def amount_view(amount_integer)
    s = amount_integer.to_s

    "NZD #{s.pop.pop}.#{s.slice(-2, 2)}"
  end

  def paypal_encrypted(payment, return_address="http://#{$hostname}/payments/thank_you?type=full_membership")

    # cert_id is the certificate if we see in paypal when we upload our own
    # certificates cmd _xclick need for buttons item name is what the user will
    # see at the paypal page custom and invoice are passthrough vars which we
    # will get back with the asunchronous notification no_note and no_shipping
    # means the client won't see these extra fields on the paypal payment page
    # return is the url the user will be redirected to by paypal when the
    # transaction is completed.
    decrypted = {
      "cert_id" => "4YTMA47WBP66S",
      "cmd" => "_xclick",
      "business" => "cbonnet99@gmail.com",
      "item_name" => payment.title,
      "item_number" => "1",
      "custom" => payment.comment,
      "amount" => convert_amount(payment.amount),
      "currency_code" => "NZD",
      "country" => "NZ",
      "no_note" => "1",
      "no_shipping" => "1",
      "invoice" => payment.invoice_number,
      "return" => return_address
    }

    return CryptoPaypal::Button.from_hash(decrypted).get_encrypted_text

  end


	def is_author?(article)
		logged_in? && current_user == article.author		
	end

	def is_reviewer?
		logged_in? && current_user.has_role?('reviewer')
	end
	
	def dasherize(s)
		s.downcase.gsub(/ /, '-')
	end

	def describe_search(region, district, category, subcategory)
		"#{subcategory.nil? ? category.name : subcategory.full_name} in #{district.nil? ? region.name : district.full_name}"
	end

	def javascript(*files)
		content_for(:head) { javascript_include_tag(*files) }
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
    @page_title = "#{APP_CONFIG[:site_name]} - #{str}"
    content_tag(container, str ) if container
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
