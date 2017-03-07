module LonLat
  def dist(x1, y1, x2, y2, a = 6378137.0, b = 6356752.314140)
    y1 = y1.to_f
    x1 = x1.to_f
    y2 = y2.to_f
    x2 = x2.to_f
    dy = (y1 - y2) * Math::PI / 180
    dx = (x1 - x2) * Math::PI / 180
    my = (((y1 + y2) * Math::PI / 180) / 2)
    e2 = (a**2 - b**2) / a**2
    mnum = a * (1 - e2)
    w = Math::sqrt(1 - e2 * Math::sin(my)**2)
    m = mnum / w**3
    n = a / w
    d = Math::sqrt((dy * m)**2 + (dx * n * Math::cos(my))**2)
    return d
  end
  module_function :dist
end

