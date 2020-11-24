# == Schema Information
#
# Table name: group_reservations
#
#  id                   :integer          not null, primary key
#  number_of_tickets    :integer
#  reservation_date     :date
#  reservation_duration :float
#  reservation_status   :string
#  reservation_time     :time
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  movie_id             :integer
#  theater_id           :integer
#
class GroupReservation < ApplicationRecord
  belongs_to(:theater, { :required => false, :class_name => "Theater", :foreign_key => "theater_id" })
  belongs_to(:movie, { :required => false, :class_name => "Movie", :foreign_key => "movie_id" })
  has_many(:ticket_requests, { :class_name => "TicketRequest", :foreign_key => "group_id", :dependent => :destroy })

  has_many(:users, { :through => :ticket_requests, :source => :user })

  validates(:theater_id, { :presence => true })
  validates(:reservation_time, { :presence => true })
  validates(:reservation_date, { :presence => true })
  validates(:number_of_tickets, { :presence => true })
  validates(:movie_id, { :presence => true })
end
