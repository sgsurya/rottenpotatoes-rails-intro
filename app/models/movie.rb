class Movie < ActiveRecord::Base
    scope :ratings, -> { uniq.pluck(:rating)}
end
