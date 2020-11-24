# == Schema Information
#
# Table name: theaters
#
#  id               :integer          not null, primary key
#  seats_in_theater :integer
#  turnover_time    :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_id      :integer
#
class Theater < ApplicationRecord
end
