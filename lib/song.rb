# encoding: utf-8
require 'json'

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
  end
end
