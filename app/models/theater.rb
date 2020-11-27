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
  has_many(:group_reservations, { :class_name => "GroupReservation", :foreign_key => "theater_id", :dependent => :destroy })
  belongs_to(:location, { :required => false, :class_name => "Location", :foreign_key => "location_id" })

  has_many(:movies, { :through => :group_reservations, :source => :movie })
  # has_many(:group_reservations, { :through => :group_reservations, :source => :ticket_requests })

  def available
    
  end 

end
