class Quest < ApplicationRecord
  belongs_to :user
  has_many :completions

  validates_presence_of :user, :description
  validates :goal, numericality: { only_integer: true }

  default :complete, false
end
