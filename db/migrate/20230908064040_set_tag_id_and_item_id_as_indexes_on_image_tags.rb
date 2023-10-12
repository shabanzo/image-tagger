class SetTagIdAndItemIdAsIndexesOnImageTags < ActiveRecord::Migration[6.1]
  def change
    add_index :image_tags, %i[image_id tag_id], unique: true
  end
end
