require 'sinatra/base'
require 'rack'
require './lib/douban'
require 'json'

class MyApp < Sinatra::Base

  douban = Douban.new
  captcha_url = douban.captcha
  puts captcha_url

  progress = 0

  get '/' do
    erb :index, :locals => {
      :captcha_url => captcha_url
    }
  end

  post '/' do
    douban.login(params[:username], params[:password], params[:captcha])
    redirect to('/upload')
  end

  get '/upload' do
    erb :upload
  end

  get '/status' do
    content_type :json
    uploading_song = ''
    if (douban.uploading_song)
      uploading_song = douban.uploading_song.title
    end
    {status:douban.status, progress:uploading_song}.to_json
  end

  post '/upload' do
    douban.upload
    'start upload!'
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
    # p env
    # env.delete("HTTP_REFERER")
    # puts
    # p env
    # p request
    # request.referrer = nil
    # request.env['HTTP_REFERER'] = ''
    # headers['referer'] = ''
    # p request
    # p env
    # env["Content-Type"] = "image/jpg"
    # response.headers["X-Accel-Redirect"] = "http://www.baidu.com"
    # 'asdfasd'
    redirect "http://mr3.douban.com/201308291732/cd343c603995224491f445664419e9c5/view/song/small/p994279.mp3"
  end

  get '/456' do
    p 2
    # env.delete("HTTP_REFERER")
    # status, headers, body = call env.merge("PATH_INFO" => '/123')
    # headers.delete("HTTP_REFERER")
    # headers["HTTP_ACCEPT"] = "audio/mpeg"
    # [status, headers, body.map(&:upcase)]
    redirect to('/123')
  end

  # before do
  #   # puts '*********************************************'
  #   # p request
  #   env["HTTP_REFERER"] = "http://douban.fm"
  #   # puts '*********************************************'
  #   # p request
  #   p 1
  # end
end