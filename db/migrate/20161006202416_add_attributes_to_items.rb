class AddAttributesToItems < ActiveRecord::Migration
  def change
    add_column :items, :link, :string
    add_column :items, :description, :text
  end
end
