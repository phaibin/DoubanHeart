# encoding: utf-8
require 'json'
require 'qiniu-rs'
require 'data_mapper'

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
    include DataMapper::Resource

    property :id, Serial
    property :sid, String
    property :album, String
    property :title, String
    property :artist, String
    property :picture, String, :length=>150
    property :douban_url, String, :length=>150
    property :url, String, :length=>150
    property :company, String
    property :year, Integer

    def initialize(attrs)
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def save_to(path)
      # remove tailling slash
      @save_path = "#{path.chomp("/")}/#{self.title}.mp3"

      res = Douban.connection(@douban_url).get

      File.open(path, "wb") do |f|
        f.write(res.body)
      end
    end

    def upload
      Thread.new do
        puts "Downloading 《#{@title} - #{@artist}》..."
        self.save_to("tmp/song.mp3")

        bucket = 'phaibin'
        key = "#{sid}.mp3"
        upload_token = Qiniu::RS.generate_upload_token :scope              => bucket
        p "uploading"
        begin
          result = Qiniu::RS.upload_file :uptoken            => upload_token,
          :file               => "tmp/song.mp3",
          :bucket             => bucket,
          :key                => key
          File.open('tmp/downloaded_list.txt', 'a') do |f|
            f.puts @sid
          end
          p "done"
          p result
        rescue Exception => e
          puts e.message
          if e.message.include? '614'
            p 'file exists'
            Qiniu::RS.delete(bucket, key)
            self.upload
          end
        end
      end
    end
  end
end
