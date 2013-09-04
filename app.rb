require 'sinatra/base'
require 'rack'
require './lib/douban'
require 'json'

class MyApp < Sinatra::Base

  douban = Douban.new

  progress = 0

  get '/' do
    erb :fm
  end  

  get '/login' do
    captcha_url = douban.captcha
    puts captcha_url
    erb :login, :locals => {
      :captcha_url => captcha_url
    }
  end

  post '/login' do
    douban.login(params[:username], params[:password], params[:captcha])
    redirect '/'
  end

  # get '/upload' do
  #   erb :upload
  # end

  get '/status' do
    content_type :json
    uploading_song = ''
    if (douban.uploading_song)
      uploading_song = douban.uploading_song.title
    end
    {status:douban.status, progress:uploading_song}.to_json
  end

  # post '/upload' do
  #   p params
  #   sid = params[:sid]
  #   if sid
  #     missing_song = douban.current_songs.select { |song| song.sid == sid }.first
  #     if missing_song
  #       missing_song.upload
  #     end
  #   end
  # end

  get '/heart' do
    content_type :json
    song = douban.get_songs.to_json
    p song
    song
  end

  get '/next' do
    content_type :json
    song = douban.next.to_json
    p song
    song
  end

  get '/prev' do
    content_type :json
    song = douban.prev.to_json
    p song
    song
  end

end