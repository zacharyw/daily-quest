class Quest < ApplicationRecord
  include Defaults
  belongs_to :user
  has_many :completions

  validates_presence_of :user, :description
  validates :goal, numericality: { only_integer: true }
  validates :goal, presence: true, if: "!reward.nil?"

  default :complete, false

  def chain
    prev_date = nil
    chain = 0
    self.completions.order(created_at: :desc).find_each(batch_size: 30) do |completion|
      # If this quest hasn't been completed in the last 24 hours, consider the chain broken
      if completion.created_at < 24.hours.ago
        break
      end

      # Latest completion
      if prev_date.nil?
        chain = chain + 1
        prev_date = completion.created_at.to_date

        next
      end

      # Look back through completions until
      completion_date = completion.to_date
      if prev_date.yesterday == completion_date
        chain = chain + 1
        prev_date = completion_date
      else
        break
      end
    end

    chain
  end
end
