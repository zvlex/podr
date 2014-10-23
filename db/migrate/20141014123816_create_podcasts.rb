class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :title
      t.text :sub_title
      t.string :url
      t.string :itunes_image
      t.text :description, :limit => nil
      t.string :author
      t.string :owners_email
      t.string :atom_link
      t.text :keywords
      t.integer :age
      t.references :category, index: true

      t.timestamps
    end
    add_index :podcasts, :atom_link,  unique: true
  end
end
