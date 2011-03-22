class CreateJournalNotes < ActiveRecord::Migration
  def self.up
    create_table :journal_notes do |t|
      t.boolean :read, :default => false
      t.boolean :important, :default => false
      t.boolean :deleted, :default => false

      t.references :journal
      t.references :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :journal_notes
  end
end
