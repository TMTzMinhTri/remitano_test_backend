class Like < ApplicationRecord
    enum type: [:un_voted, :voted_up, :voted_down]
end
