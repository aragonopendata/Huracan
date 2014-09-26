helpers do
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
end
