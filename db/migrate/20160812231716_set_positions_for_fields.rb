class SetPositionsForFields < ActiveRecord::Migration
  def up
    Resource.all.each do |resource|
      resource.fields.each_with_index do |field, index|
        field.update_attribute(:position, index)
      end
    end
  end

  def down
  end
end
