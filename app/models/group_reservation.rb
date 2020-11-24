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
end
