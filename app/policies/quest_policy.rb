class QuestPolicy < ApplicationPolicy
  def update?
    user == record.user
  end

  def create?
    user == record.user
  end

  def destroy?
    user == record.user
  end

  class Scope < Scope
    def resolve
      if user
        user.quests
      else
        Array.new
      end
    end
  end
end