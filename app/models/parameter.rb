class Parameter
  include ActiveModel::Model
  #TODO : textフィールドの追加
  MAX_LIMIT = 20
  DEFAULT_LIMIT = 5
  MAX_RADIUS = 10000
  DEFAULT_RADIUS = 500
  DEFAULT_LANG = "ja"
  ERROR = nil
  attr_reader :lon, :lat, :radius, :limit, :lang
  validates :lon, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :radius, numericality: { greater_than: 0, less_than_or_equal_to: MAX_RADIUS }
  validates :limit, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAX_LIMIT }
  validates :lang, inclusion: { in: ["ja", "en"] }

  def initialize(attrs = {})
    attrs.assert_valid_keys( :lon, :lat, :radius, :limit, :lang )
    # String.to_f.nonzero? => false? nil.to_f.nonzero? => false
    @lon = attrs[:lon].to_f.nonzero? ? attrs[:lon].to_f : ERROR
    @lat = attrs[:lat].to_f.nonzero? ? attrs[:lat].to_f : ERROR
    @radius = attrs[:radius].to_f.nonzero? ? attrs[:radius].to_f : DEFAULT_RADIUS
    @limit = attrs[:limit].to_i.nonzero? ? attrs[:limit].to_i : DEFAULT_LIMIT
    @lang = attrs[:lang].blank? ? DEFAULT_LANG : attrs[:lang]
  end
end

