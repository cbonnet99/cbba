module SubcategorySystem
  def self.included(base)
		base.send :include, SubcategoriesSystemInstanceMethods
	end


	module SubcategoriesSystemInstanceMethods
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
end