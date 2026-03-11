#!/usr/bin/env ruby
# File: main.rb
# Proy: get-info

# Proy: get-info

require 'sinatra'
require 'yaml'
require 'fileutils'

# Configuración: Crear carpeta si no existe
FileUtils.mkdir_p('output')

# Ruta para mostrar el formulario
get '/target' do
  erb :form
end

# Ruta para procesar el envío
post '/submit' do
  name   = params[:name]
  choice = params[:choice]
  ip     = request.ip

  data = {
    "name" => name,
    "choice" => choice,
    "ip" => ip,
    "timestamp" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
  }

  File.write("output/target-#{ip}.yaml", data.to_yaml)

  # Redirigir directamente a la lista tras guardar
  redirect '/list'
end

# Ruta para listar los archivos
get '/list' do
  @records = []
  Dir.glob("output/target-*.yaml").each do |file|
    @records << YAML.load_file(file)
  end
  erb :list
end
