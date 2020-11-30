# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  close_time     :time
#  location_name  :string
#  open_time      :time
#  street_address :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Location < ApplicationRecord
  has_many(:theaters, { :class_name => "Theater", :foreign_key => "location_id", :dependent => :destroy })

  validates(:open_time, { :presence => true })
  validates(:close_time, { :presence => true })
end
