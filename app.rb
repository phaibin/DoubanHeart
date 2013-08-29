require 'sinatra/base'
require 'rack'
require './lib/douban'
require 'json'

class MyApp < Sinatra::Base

  douban = Douban.new
  captcha_url = douban.captcha
  puts captcha_url

  get '/' do
    erb :index, :locals => {
      :captcha_url => captcha_url
    }
  end

  post '/' do
    douban.login(params[:username], params[:password], params[:captcha])
    douban.get_songs
    redirect to('/heart')
  end

  get '/heart' do
    erb :heart, :locals => {
      :songs => douban.songs
    }
  end

  get '/next' do
    content_type :json
    song = douban.songs.sample.to_json
    p song
    song
  end

  get '/fm' do
    erb :fm
  end  

  get '/fm4' do
    # content_type 'audio/mpeg'
    erb :fm4
  end

  get '/123' do
    p request
    # request.referrer = nil
    request.env['HTTP_REFERER'] = ''
    # headers['referer'] = ''
    p request
    redirect "http://mr3.douban.com/201308291732/cd343c603995224491f445664419e9c5/view/song/small/p994279.mp3"
  end
end