module Sluggable
  def self.included(base)

    base.send :include, WorkflowInstanceMethods
    base.send :extend, WorkflowClassMethods
    base.send :before_create, :create_slug
    base.send :before_update, :create_slug
  end
  
  module WorkflowClassMethods
  end
  
  module WorkflowInstanceMethods
    def to_param
      self.slug
    end

  	def create_slug
  		self.slug = computed_slug
  	end

  	def computed_slug
  		name.parameterize
  	end    
  end
end