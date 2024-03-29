require 'gpx'
require 'haversine'
require 'ruby-units'

class GPXInfo

  # distance, elevation
  attr_reader :altitude_profile

  def initialize(gpx_file, units = "m")
    @gpx_file = GPX::GPXFile.new(gpx_file: gpx_file)
    @total_distance   = 0
    @ascent_distance  = 0
    @descent_distance = 0
    @ascent           = 0
    @descent          = 0
    @flat_distance    = 0
    @units            = units
    @altitude_profile = []
    @max_elevation    = 0

    calculate
  end

  def calculate
    prev_lat = 0
    prev_lon = 0
    prev_elevation = 0
    prev_time = 0

    @gpx_file.tracks.each do |t|
      t.points.each do |p|
        # Skip calculations for the first point since there's no previous data
        if prev_lat > 0
          # Get distance between current and previous point and convert to miles
          d = Haversine.distance(p.lat, p.lon, prev_lat, prev_lon).to_meters
          @total_distance += d
          @altitude_profile << [@total_distance, p.elevation]
          @max_elevation = p.elevation if p.elevation > @max_elevation
          if p.elevation > prev_elevation
            @ascent += (p.elevation - prev_elevation)
            @ascent_distance += d
          elsif p.elevation < prev_elevation
            @descent += (prev_elevation - p.elevation)
            @descent_distance += d
          else
            @flat_distance += d
          end
        end
        prev_lat, prev_lon, prev_elevation, prev_time = [p.lat, p.lon, p.elevation, p.time]
      end
    end
  end

  def distances
    h = {
      total_distance: @total_distance,
      flat_distance: @flat_distance,
      ascent: @ascent,
      ascent_distance: @ascent_distance,
      descent: @descent,
      descent_distance: @descent_distance,
      max_elevation: @max_elevation
    }

    h.each { |k,v| h[k] = '%.2f' % Unit("#{v} m").to_s(@units).split()[0].strip }

    h
  end

end
