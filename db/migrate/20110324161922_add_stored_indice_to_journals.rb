class AddStoredIndiceToJournals < ActiveRecord::Migration
  def self.up
    add_column :journals, :stored_indice, :integer
  end

  def self.down
    remove_column :journals, :stored_indice
  end
end
