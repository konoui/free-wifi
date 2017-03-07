class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :category
      t.string :ja_spot_name, :null => false
      t.string :ja_address, :null => false
      t.string :en_spot_name
      t.string :en_address
      t.string :business_hours
      t.string :restriction
      t.string :procedures
      t.string :ssid
      t.string :web_site
      t.st_point :lonlat, geographic: true, :null => false
    end
  end
end
