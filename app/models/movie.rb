# == Schema Information
#
# Table name: movies
#
#  id                :integer          not null, primary key
#  currently_showing :boolean
#  description       :text
#  duration          :float
#  image             :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Movie < ApplicationRecord
  has_many(:group_reservations, { :class_name => "GroupReservation", :foreign_key => "movie_id", :dependent => :nullify })

  has_many(:theaters, { :through => :group_reservations, :source => :theater })
  has_many(:ticket_requests, { :through => :group_reservations, :source => :ticket_requests })

  validates(:title, { :presence => true })
  validates(:duration, { :presence => true })

  # uncomment this when going live
  # mount_uploader :image, ImageUploader
end
