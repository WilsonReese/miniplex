# == Schema Information
#
# Table name: movies
#
#  id                :integer          not null, primary key
#  currently_showing :boolean
#  description       :text
#  duration          :float
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Movie < ApplicationRecord
end
