class CreateSqueaks < ActiveRecord::Migration[5.2]
  def change
    create_table :squeaks do |t|
      t.string :content
      t.integer :reports, default: 0
      t.integer :nuts, default: 0
      t.boolean :approved
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
