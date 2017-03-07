module Api
  module V1
    class SpotsController < ApplicationController
      def index
      end

      def show
      end

      def json
        status = { "200" => "OK", "400" => "Bad Request" }
        ja_col = "ja_spot_name as spot_name,
                   ja_address as address,"
        en_col = "en_spot_name as spot_name,
                   en_address as address,"
        @results = {}
        #TODO text
        parameter = Parameter.new(
                                   :lon => params[:lon],
                                   :lat => params[:lat],
                                   :radius => params[:radius],
                                   :limit => params[:limit],
                                   :lang => params[:lang], 
                                 )
        if parameter.invalid?
          @results[:results] = []
          @results[:status] = status["400"]
          @results[:errors] = parameter.errors.messages
        else
          lon = parameter.lon
          lat = parameter.lat
          radius = parameter.radius
          limit = parameter.limit
          lang = parameter.lang
          lang_col = lang == 'en' ? en_col : ja_col

          spots = Spot.find_by_sql(["
                 SELECT
                   #{lang_col}
                   ST_X(lonlat::geometry) as longitude,
                   ST_Y(lonlat::geometry) as latitude,
                   ST_Distance('SRID=4326;POINT(? ?)', lonlat) as distance,
                   ssid,
                   business_hours,
                   restriction, 
                   procedures
                 FROM spots
                 WHERE ST_DWithin(lonlat, ST_GeographyFromText('SRID=4326;POINT(? ?)'), ?)
                 ORDER BY distance ASC LIMIT ?" ,
           lon, lat, lon, lat, radius, limit]
          )
          #FIXME JBuilder
          @results[:results] = spots.map{ |obj| obj.attributes.except("id") }
          @results[:status] = status["200"]
        end
        render :json => JSON.pretty_generate(@results)
      end
    end
  end
end
