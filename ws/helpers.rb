helpers do
  require 'gruff'

  def get_gpx(id)
    gpx_cache = settings.cache_dir + "/gpx"
    gpx_file = gpx_cache + "/#{id}.gpx"

    FileUtils.mkdir_p gpx_cache

    return gpx_file if File.exist?(gpx_file)

    open(gpx_file, 'w') do |f|
      f.puts open("#{settings.base_url}/get_route_GPX.php?id=#{id}").read
    end

    gpx_file
  end

  def x_ticks(data, num = 6)

    ticks = []
    h = {}

    num.times { |n| ticks << (data.last/num).round*n }
    ticks << data[-2].round

    ticks.reverse.each { |t| h[t] = t.to_s }
    h
  end

  def altitude_profile_png(csv, id, size="200x100")
    img_cache = settings.cache_dir + "/img"
    img_file = img_cache + "/#{id}_#{size}.png"

    FileUtils.mkdir_p img_cache

    return img_file if File.exist?(img_file)

    g = Gruff::Line.new(size)

    g.title = 'Altitude Profile'
    g.theme = Gruff::Themes::GREYSCALE
    g.line_width = 3

    distances = []
    altitudes = []

    csv.each_line do |l|
      data = l.split(',').map { |line| line.strip.chomp }

      distances << data[0].to_f
      altitudes << data[1].to_f
    end

    g.dataxy('Altitude/Distance', distances, altitudes)
    g.labels = x_ticks(distances)

    g.write(img_file)

    img_file

  end

end
