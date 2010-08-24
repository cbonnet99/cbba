module BlogSubcategoriesSystem
  def self.included(base)
		base.send :include, BlogSubcategoriesSystemInstanceMethods
		base.send :attr_accessor, :blog_subcategory1_id, :blog_subcategory2_id, :blog_subcategory3_id
		base.send :after_create, :save_blog_subcategories
		base.send :after_update, :save_blog_subcategories
	end


	module BlogSubcategoriesSystemInstanceMethods
		def after_find_blog_subcat
        self.blog_subcategory1_id = self.blog_subcategories[0].nil? ? nil : self.blog_subcategories[0].id
        self.blog_subcategory2_id = self.blog_subcategories[1].nil? ? nil : self.blog_subcategories[1].id
        self.blog_subcategory3_id = self.blog_subcategories[2].nil? ? nil : self.blog_subcategories[2].id
    end

    def describe_blog_subcategories
      self.blog_subcategories.map(&:name).to_sentence
    end

		def save_blog_subcategories
			self.blog_subcategories = []
			self.blog_categories = []
			unless blog_subcategory1_id.blank?
				sub1 = BlogSubcategory.find(self.blog_subcategory1_id)
				self.blog_subcategories << sub1
        self.blog_categories << sub1.blog_category
			end
			unless blog_subcategory2_id.blank?
				sub2 = BlogSubcategory.find(self.blog_subcategory2_id)
				self.blog_subcategories << sub2
        self.blog_categories << sub2.blog_category
			end
			unless blog_subcategory3_id.blank?
				sub3 = BlogSubcategory.find(self.blog_subcategory3_id)
				self.blog_subcategories << sub3
        self.blog_categories << sub3.blog_category
			end
		end
	end
	def main_blog_subcategory
	  self.blog_subcategories.try(:first)
  end
end