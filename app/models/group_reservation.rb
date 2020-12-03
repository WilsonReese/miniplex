# == Schema Information
#
# Table name: group_reservations
#
#  id                   :integer          not null, primary key
#  host                 :integer
#  number_of_tickets    :integer
#  reservation_date     :date
#  reservation_duration :float
#  reservation_end_time :time
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
  validates_presence_of :reservation_end_time
  # validates :starts_at, :ends_at, :overlap => true

  def overlaps?(other)
    self.reservation_time < other.reservation_end_time && other.reservation_time < self.reservation_end_time
  end

  # scope :overlapping, -> { group_reservation
  #   where("id <> ? AND reservation_time <= ? AND ? <= reservation_end_time", group_reservation.id, group_reservation.reservation_end_time, group_reservation.reservation_time)
  # }

end
