# encoding: utf-8
class Language
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  # jinda begin
  include Mongoid::Timestamps
  field :name, :type => String
  validates :name, presence: true
  # jinda end
end
