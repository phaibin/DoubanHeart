require "./lib/song"

DataMapper.setup(:default, 'postgres://localhost/douban_heart')
DataMapper.finalize.auto_upgrade!
DataMapper::Model.raise_on_save_failure = true

song = Douban::Song.first_or_create(:sid=>'1513752')
song.update(:year=>2000)
song.save
p song