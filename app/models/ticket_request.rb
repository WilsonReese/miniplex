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
end
