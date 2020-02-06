# encoding: utf-8
class Country
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  # jinda begin
  include Mongoid::Timestamps
  field :name, :type => String
  belongs_to :language
  validates :name, :language_id,  presence: true
  # jinda end
end
