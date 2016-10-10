class Completion < ApplicationRecord
  belongs_to :quest

  validates :quest, presence: true
  validates :date_completed, uniqueness: {scope: :quest_id}
end
