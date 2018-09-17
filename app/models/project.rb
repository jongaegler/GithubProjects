class Project < ApplicationRecord
  STAR_MAX = 2000

  def self.count_in_ranges
    mins = Array.new(10) { |n| n * 200 + 1 }
    mins.map do |min|
      max = min + 199
      {
        min: min,
        max: max,
        count: where(stars: min..max).count
      }
    end
  end
end
