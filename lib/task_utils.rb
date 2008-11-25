class TaskUtils
	def self.count_users
		Category.all.each do |c|
			c.update_attribute(:users_counter, User.count_all_by_subcategories(*c.subcategories))
		end
		Subcategory.all.each do |s|
			s.update_attribute(:users_counter, User.count_all_by_subcategories(s))
		end
	end
end