class AppDir
  attr_accessor :base_dir, :name, :configs

  def initialize(base_dir, name)
    @base_dir = base_dir
    @name = name
    Dir.chdir(File.join(base_dir, name))
    @configs = Dir.glob('*.plist').sort.map { |d| d.gsub(/\.plist/, '') }
  end
end