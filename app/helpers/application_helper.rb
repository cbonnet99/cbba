module ApplicationHelper

	def javascript(*files)
		content_for(:head) { javascript_include_tag(*files) }
	end

	def shorten_string(str, max_size, extension="...")
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
  def title(str, container = nil)
    @page_title = str
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
