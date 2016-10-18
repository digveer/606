class Movie < ActiveRecord::Base

    def self.all_ratings
        rating_array=Array.new
        self.select("rating").uniq.each{|x| rating_array.push(x.rating)}
        rating_array.sort.uniq
    end
end
