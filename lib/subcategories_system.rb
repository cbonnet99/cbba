module SubcategoriesSystem
  def self.included(base)
		base.send :include, SubcategoriesSystemInstanceMethods
		base.send :attr_accessor, :subcategory1_id, :subcategory2_id, :subcategory3_id
		base.send :after_create, :save_subcategories
		base.send :after_update, :save_subcategories		
	end


	module SubcategoriesSystemInstanceMethods
		def after_find_subcat
				self.subcategory1_id = self.subcategories[0].nil? ? nil : self.subcategories[0].id
				self.subcategory2_id = self.subcategories[1].nil? ? nil : self.subcategories[1].id
				self.subcategory3_id = self.subcategories[2].nil? ? nil : self.subcategories[2].id
		end

    def describe_subcategories
      self.subcategories.map(&:name).to_sentence
    end

		def save_subcategories
			self.subcategories = []
			self.categories = []
			unless subcategory1_id.blank?
				sub1 = Subcategory.find(self.subcategory1_id)
				self.subcategories << sub1
        self.categories << sub1.category
			end
			unless subcategory2_id.blank?
				sub2 = Subcategory.find(self.subcategory2_id)
				self.subcategories << sub2
        self.categories << sub2.category
			end
			unless subcategory3_id.blank?
				sub3 = Subcategory.find(self.subcategory3_id)
				self.subcategories << sub3
        self.categories << sub3.category
			end
		end
	end
	def main_subcategory
	  self.subcategories.try(:first)
  end
end