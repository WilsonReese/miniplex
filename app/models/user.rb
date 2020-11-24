# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean
#  city            :string
#  email           :string
#  password_digest :string
#  phone_number    :string
#  street_address  :string
#  zip_code        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:ticket_requests, { :class_name => "TicketRequest", :foreign_key => "user_id", :dependent => :destroy })
  has_many(:groups, { :through => :ticket_requests, :source => :group })
end
