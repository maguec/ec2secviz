require File.join(File.dirname(__FILE__), '..', "conf", "environment")
require 'sinatra'
require 'sinatra/base'
require 'sinatra/respond_to'
require 'json'

class Viz < Sinatra::Base
  register Sinatra::RespondTo
  set :public_folder, File.join(File.dirname(__FILE__) , '..' , '/static')
  set :views, File.join(File.dirname(__FILE__), '..', '/views')


  get '/:hostname/:port/graph' do
    respond_to do |wants|
      wants.html {  erb :graph_example,
        :locals => { :hostname => params[:hostname],
                     :port => params[:port]},
        :layout => :base_layout }
    end
  end

  get '/open_ports_data/:hostname/:port/list' do
    port_filter=[]
    q=Secviz::Portsearch.new
    unless params[:port] == "all"
      params[:port].split(',').each { |port| port_filter << port }
    end
    q.ports2d3(params[:hostname], port_filter).to_json
  end

end
