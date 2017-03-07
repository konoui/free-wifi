FactoryGirl.define do
  factory :parameter do
#    jp_spot_name "成田国際空港"
#    jp_address "千葉県成田市三里塚字御料牧場1-1"
#の緯度経度を使用
    lon "140.3882237"
    lat "35.77348447"
    radius nil
    limit nil
    lang nil
    initialize_with { new attributes }
  end
end

