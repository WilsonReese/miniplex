# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  location_name  :string
#  street_address :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Location < ApplicationRecord
  has_many(:theaters, { :class_name => "Theater", :foreign_key => "location_id", :dependent => :destroy })
end
