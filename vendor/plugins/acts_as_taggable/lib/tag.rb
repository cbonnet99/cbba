class Tag < ActiveRecord::Base
  has_many :taggings
  belongs_to :company

  MAX_DISPLAYED_TAGS = 20
    
  #lists the blocks related to this tag, ordered by title
  def strategy_items(user_id, company_id, offset=0, limit=MAX_DISPLAYED_TAGS)
    query = "select b.id from strategy_items b, taggings, tags"
    query << " where taggings.taggable_type = 'StrategyItem'"
    query << " and tags.company_id = #{company_id}"
    query << " and tags.id = #{self.id}"
    query << " and (b.private is false or (b.private is true and b.owner_id = #{user_id}))"
    query << " and b.id in (select strategy_item_id from permissions where group_id in (select group_id from memberships where user_id=#{user_id}))"
    query << " and taggings.tag_id = tags.id"
    query << " and taggings.taggable_id = b.id"
    query << " order by b.title"
    query << " limit #{limit} offset #{offset}"
    StrategyItem.find_by_sql(query)
  end
  
  def self.tags(options = {})
    query = "select tags.id, name, count(*) as count"
    query << " from taggings, tags"
    query << " where tags.id = tag_id"
    query << " group by tags.id, name"
    query << " order by count DESC"
    query << " limit #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
  end

  def self.parse(list)
    tag_names = []

    # first, pull out the quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tag_names << $1; "" }

    # then, replace all commas with a space
    list.gsub!(/,/, " ")

    # then, get whatever's left
    tag_names.concat list.split(/\s/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end

  def tagged
    @tagged ||= taggings.collect { |tagging| tagging.taggable }
  end
  
  def on(taggable)
    taggings.create :taggable => taggable
  end
  
  def ==(comparison_object)
    super || name == comparison_object.to_s
  end
  
  def to_s
    name
  end
end