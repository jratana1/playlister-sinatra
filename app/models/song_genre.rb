class SongGenre < ActiveRecord::Base
    # add relationships here
    belongs_to :song 
    belongs_to :genre 
  end