require 'json'
require 'open-uri'
require 'debugger'

def parse_comunidad(comunidad_uri)
  m = "#{comunidad_uri}".match(/http:\/\/opendata.aragon.es\/recurso\/territorio\/ComunidadAutonoma\/(.*)/) 
  if m.nil?
    return nil
  else
    return m[1].gsub("_", " ")
  end
end

def parse_comarca(comarca_uri)
  m = "#{comarca_uri}".match(/http:\/\/opendata.aragon.es\/recurso\/territorio\/Comarca\/(.*)/) 
  if m.nil?
    return nil
  else
    return m[1].gsub("_", " ")
  end
end

def parse_establecimiento(establecimiento_uri)
  m = "#{establecimiento_uri}".match(/http:\/\/opendata.aragon.es\/recurso\/economia\/turismo\/(.*)/) 
  if m.nil?
    return nil
  else
    return m[1].gsub("_", " ")
  end
end

def parse_municipio(municipio, id)
  {
    "id" => id,
    "name" => municipio["label"],
    "area" => municipio["areaTotal"],
    "country" => "Spain",
    "major" => municipio["alcalde"],
    "men" => municipio["hombres"],
    "women" => municipio["mujeres"],
    "ine" => municipio["codigoINE"],
    "comunidad" => parse_comunidad(municipio["comunidadAutonoma"]),
    "comarca" => parse_comarca(municipio["comarca"]),
    "stats" => parse_stats(municipio["datoEstadistico"], id)
  }
end

def parse_stats(json_stats, municipio_id)
  stats = {}
  stats["vidrio"] = []
  stats["establecimientos"] = []
  stats["poblacion"] = []
  json_stats.each do |s|
    if s["kilosVidrio"]
      stats["vidrio"] << {
                          'municipio_id' => municipio_id, 
                          'stat_date' => s["fecha"], 
                          'kg' => s["kilosVidrio"], 
                          'containers_count' => s["contenedoresVidrio"]
                         }
    elsif s["establecimientos"]
      if s["establecimientos"].to_i != 0
        stats["establecimientos"] << {
                                      'municipio_id' => municipio_id,
                                      'stat_date' => s["fecha"], 
                                      'type_establecimiento' => parse_establecimiento(s["tipoEstablecimiento"]), 
                                      'count' => s["establecimientos"], 'seats' => s["plazas"]
                                     }
      end
    elsif s["poblacion"]
      stats["poblacion"] << {
                             'municipio_id' => municipio_id,
                             'stat_date' => s["fecha"], 
                             'poblacion' => s["poblacion"]
                            }
    end
  end
  return stats
end

require 'json'

j = JSON.parse(File.read('Municipio.json'))


municipios = []
stats = {}
stats["vidrio"] = []
stats["establecimientos"] = []
stats["poblacion"] = []

j["result"]["items"].each_with_index do |m, i|
  municipio = parse_municipio(m, i)
  %w{ vidrio establecimientos poblacion}.each do |o|
    stats[o].concat(municipio["stats"][o])
  end
  municipio.delete("stats")
  municipios << municipio
end

require 'csv'
CSV.open("municipios.csv", "wb") do |csv| 
  csv << municipios.first.keys
  municipios.each do |elem| 
    csv << elem.values
  end
end

%w{ vidrio establecimientos poblacion}.each do |o|
  CSV.open("municipios_stats_#{o}.csv", "wb") do |csv| 
    csv << stats[o].first.keys
    stats[o].each do |elem| 
      csv << elem.values
    end
  end
end


File.open('municipios_clean.json', 'w') do |f|
  f.write(municipios.to_json)
end
