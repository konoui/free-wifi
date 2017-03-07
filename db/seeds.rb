# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def init_db()
  def initialize_data(a)
    a.each do |key, value|
      if value.blank? || value == '- ' || value == '-'
        # FIXME en_spot_name, en_addressをNoDataにしない
        a[key] = 'NoData'
      end
    end
    return a
  end
  def insert_query(a)
    Spot.create(
                :category => a['カテゴリー'], 
                :ja_spot_name => a['スポット名（日本語）'],
                :ja_address => a['都道府県'] + a['住所（日本語）'],
                :en_spot_name => a['スポット名（英語）'],
                :en_address => a['住所（英語）'],
                :business_hours => a['施設営業時間'], 
                :restriction => a['利用時間・回数等'], 
                :procedures => a['利用手続き'], 
                :ssid => a['SSID名称'],
                :web_site => a['ウェブサイトのURL'],
                :lonlat => "POINT(#{a['経度'].to_f} #{a['緯度'].to_f})"
                )
  end
  require 'csv'
  csv_data = CSV.read("#{Rails.root.to_s}/file/jta_free_wifi.csv", encoding: "UTF-8", headers: true)
  csv_data.each do |row|
    data = {}
    row.each do |col|
      data = data.merge(Hash[*col])
    end
  data = initialize_data(data)
  insert_query(data)
  end
end

init_db()

