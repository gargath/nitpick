class AddValidations < ActiveRecord::Migration
  def up
    create_table :user_validations do |t|
      t.string :token
      t.integer :user_id
      t.datetime :created_at
      t.datetime :completed_at
    end
  end

  def down
    drop_table :user_validations
  end
end
