module MultiAfterFindSystem
  def self.included(base)
		base.send :include, MultiAfterFindSystemInstanceMethods
	end

	module MultiAfterFindSystemInstanceMethods
		def after_find
		  self.public_methods.sort.select{|m| m =~ /^after_find(.)+/}.each do |m|
		    self.send(m.to_sym)
		  end
	  end
	end
end