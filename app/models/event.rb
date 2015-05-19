class Event < ActiveRecord::Base
  validates :name, :payload, presence: true
end
