class Project < ApplicationRecord
  def count_in_range(start = 0)
    where(stars: start..start + 200).count
  end
end
