module Sluggable
  def self.included(base)

    base.send :include, WorkflowInstanceMethods
    base.send :extend, WorkflowClassMethods
    base.send :before_create, :update_slug
    base.send :before_update, :update_slug
    base.send :before_create, :set_country
  end
  
  module WorkflowClassMethods
  end
  
  module WorkflowInstanceMethods
    def to_param
      self.slug
    end
    
    def set_country
      if respond_to?(:author) && respond_to?(:country_id)
        self.country_id = self.author.country_id
      end
    end
    
  	def update_slug
  		self.slug = computed_slug
  	end

    def recompute_slug(old_slug)
      old_slug = "old_slug#{rand(9)}"
      if old_slug.size > Article::MAX_LENGTH_SLUG
        old_slug = old_slug[1..Article::MAX_LENGTH_SLUG-1]
      end
      old_slug
    end

  	def computed_slug
  	  if respond_to?(:title)
  	    p = title
	    end
  	  if respond_to?(:full_name)
  	    p = full_name
	    end
	    if p.blank?
	      p = name
      end
  	  
  		if self.respond_to?(:author)
    		res = help.shorten_string(p, Article::MAX_LENGTH_SLUG, "").parameterize
    		while self.author.has_article_with_same_slug?(self.id, res) do
    		  res = recompute_slug(res)
    	  end
  	  else
  	    res = p.parameterize
  	  end
  	  res
  	end
  end
end