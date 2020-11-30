class Artist < ActiveRecord::Base
    # add relationships here
    include Slugifiable::InstanceMethods
    has_many :songs
    has_many :genres, through: :songs
  end