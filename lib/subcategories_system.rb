module SubcategoriesSystem
  def self.included(base)
		base.send :include, SubcategoriesSystemClassMethods
		base.send :attr_accessor, :subcategory1_id, :subcategory2_id, :subcategory3_id
		base.send :after_create, :save_subcategories
		base.send :after_update, :save_subcategories
	end


	module SubcategoriesSystemClassMethods
		def after_find
				self.subcategory1_id = self.subcategories[0].nil? ? nil : self.subcategories[0].id
				self.subcategory2_id = self.subcategories[1].nil? ? nil : self.subcategories[1].id
				self.subcategory3_id = self.subcategories[2].nil? ? nil : self.subcategories[2].id
		end

		def save_subcategories
			self.subcategories = []
			unless subcategory1_id.blank?
				sub1 = Subcategory.find(self.subcategory1_id)
				self.subcategories << sub1
			end
			unless subcategory2_id.blank?
				sub2 = Subcategory.find(self.subcategory2_id)
				self.subcategories << sub2
			end
			unless subcategory3_id.blank?
				sub3 = Subcategory.find(self.subcategory3_id)
				self.subcategories << sub3
			end
		end
	end
end