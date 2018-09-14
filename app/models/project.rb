class Project < ApplicationRecord
  STAR_MAX = 2000

  def self.count_in_ranges
    start = 0
    array_of_counts = []
    loop do
      array_of_counts << {
        min: start,
        max: start + 200,
        count: where(stars: start..start + 200).count
      }
      start += 200
      break if start >= STAR_MAX
    end
    array_of_counts
  end
end
