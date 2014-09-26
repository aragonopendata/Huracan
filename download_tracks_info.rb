require 'json'
require 'open-uri'
require 'debugger'

GPX_FILES_PATH="/home/luisico/devel/jacathon/routes"

Dir["#{GPX_FILES_PATH}/*"].each do |f|
  filename = File.basename(f)
  route_id = filename.split('.')[0]

  open("#{GPX_FILES_PATH}/#{route_id}.json", 'wb') do |file|
    file << open("http://senderos.turismodearagon.com/visorprames/get_info.php?id=#{route_id}").read
  end
end
