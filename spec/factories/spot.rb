FactoryGirl.define do
  factory :spot do
    ja_spot_name "成田国際空港"
    ja_address "千葉県成田市三里塚字御料牧場1-1"
    en_spot_name "Narita International Airport Terminal1"
    en_address "1-1  Sanrizuka aza goryobokujo, Narita-shi, Chiba"
    ssid "FreeWiFi-NARITA"
    web_site "http://www.narita-airport.jp/en/index.html"
    lonlat "POINT(140.3882237 35.77348447)"
    business_hours "NoData"
    restriction "unlimited to re-entry"
    procedures "to select the SSID, and to agree to the Terms of Use"
  end
end
