class AddFavoritesColumnToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :is_favorite, :boolean
  end
end
