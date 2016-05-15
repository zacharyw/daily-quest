class Completion < ApplicationRecord
  belongs_to :quest

  validates_presence_of :quest
end
