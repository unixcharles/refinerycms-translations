class CreateTranslations < ActiveRecord::Migration

  def self.up
    create_table :translations do |t|
      t.string :name
      t.text :value
      t.text :untranslated
      t.string :locale
      t.boolean :fresh
      t.string :freshness_key
      t.boolean :wym

      t.timestamps
    end

    add_index :translations, :id
  end

  def self.down
    UserPlugin.destroy_all({:name => "Translations"})
    drop_table :translations
  end

end
