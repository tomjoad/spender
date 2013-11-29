class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.float :value
      t.integer :category_id
      t.text :description

      t.timestamps
    end
  end
end
