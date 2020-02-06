# encoding: utf-8
class Datacenter
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  # jinda begin
  include Mongoid::Timestamps
  field :code, :type => String
  field :servers_available, :type => Boolean
  field :servers_capacity, :type => String
  belongs_to :country
  belongs_to :user, :class_name => "User"
  index({code: 1}, { unique: true, name: "code_index"})
  validates :code, presence: true, uniqueness: true
  # jinda end
end
