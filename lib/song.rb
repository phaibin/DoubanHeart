# encoding: utf-8
require 'json'
require 'qiniu-rs'

Qiniu::RS.establish_connection! :access_key => '9JuX5BIaZO4QyxU5YAotD6tn5tSEH3Yk1RhqLg5h',
:secret_key => 'TAp6SEFpzdoQ3ZNxeke3u60rY3H-GTqZliwXyWKL'

class JSONable
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.delete '@'] = self.instance_variable_get var
    end
    hash.to_json
  end
  def from_json! string
    JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end
end

class Douban
  class Song < JSONable
    attr_accessor :sid, :album, :title, :artist, :url, :picture
    attr_reader :save_path, :year

    def initialize(attrs)
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def year=(year)
      @year = year.to_i
    end

    def save_to(path)
      # remove tailling slash
      @save_path = "#{path.chomp("/")}/#{self.title}.mp3"

      res = Douban.connection(@url).get

      File.open(path, "wb") do |f|
        f.write(res.body)
      end
    end

    def upload
      bucket = 'phaibin'
      upload_token = Qiniu::RS.generate_upload_token :scope              => bucket
      p "uploading"
      result = Qiniu::RS.upload_file :uptoken            => upload_token,
      :file               => "tmp/song.mp3",
      :bucket             => bucket,
      :key                => "#{sid}.mp3"
      File.open('tmp/downloaded_list.txt', 'a') do |f|
        f.puts @sid
      end
      p "done"
      p result
    end
  end
end
