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
      t.references :user, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
