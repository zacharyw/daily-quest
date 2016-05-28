class Quest < ApplicationRecord
  include Defaults
  belongs_to :user
  has_many :completions

  validates_presence_of :user, :description
  validates :goal, numericality: { only_integer: true }
  validates :reward, presence: true, if: "goal.present?"

  default :complete, false

  def chain(from_date: Date.today)
    prev_date = nil
    chain = 0
    self.completions.where("date_completed <= :from_date", {from_date: from_date}).order(created_at: :desc).find_each(batch_size: 30) do |completion|
      # If this quest hasn't been completed in the last 24 hours, consider the chain broken
      if completion.created_at < 24.hours.ago
        break
      end

      # Latest completion
      if prev_date.nil?
        chain = chain + 1
        prev_date = completion.date_completed

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

  #Look back through completions to determine the longest chain.
  def longest_chain
    max_length = 0
    prev_date = nil

    self.completions.order(created_at: :desc).each do |completion|
      # Skip completions that are part of the same chain.
      if prev_date.nil? || prev_date.yesterday != completion.date_completed
        chain_length = self.chain(from_date: completion.date_completed)

        max_length = chain_length if chain_length > max_length
      end

      prev_date = completion.date_completed
    end

    max_length
  end

  def toggle_completion
    today = Date.today
    completion = self.completions(date_completed: today).first

    if completion.nil?
      self.completions.create(date_completed: today)
      true
    else
      completion.destroy
      false
    end
  end

  def complete_today?
    self.completions.where(date_completed: Date.today).present?
  end
end
