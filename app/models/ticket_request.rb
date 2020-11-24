# == Schema Information
#
# Table name: ticket_requests
#
#  id            :integer          not null, primary key
#  ticket        :string
#  ticket_status :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_id      :integer
#  user_id       :integer
#
class TicketRequest < ApplicationRecord
  belongs_to(:user, { :required => false, :class_name => "User", :foreign_key => "user_id" })
  belongs_to(:group, { :required => false, :class_name => "GroupReservation", :foreign_key => "group_id" })

  has_one(:theater, { :through => :group, :source => :theater })
  has_one(:movie, { :through => :group, :source => :movie })

  validates(:group_id, { :presence => true })
end
