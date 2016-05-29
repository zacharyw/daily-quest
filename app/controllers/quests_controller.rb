class QuestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @quests = policy_scope(Quest)
  end

  def new
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.user = current_user
    authorize @quest

    if @quest.save
      redirect_to quests_path
    end
  end

  def edit
    @quest = authorize Quest.find(params[:id])
  end

  def update
    @quest = authorize Quest.find(params[:id])

    if @quest.update(quest_params)
      redirect_to quests_path
    else
      render 'edit'
    end
  end

  def destroy
    @quest = authorize Quest.find(params[:id])
    @quest.destroy

    redirect_to quests_path
  end

  def toggle
    @quest = authorize Quest.find(params[:id]), :update?

    @completed = @quest.toggle_completion
    @quest.reload

    respond_to do |format|
      format.html { redirect_to quests_path, notice: "Quest completed!" }
      format.js
    end
  end

  private
    def quest_params
      params.require(:quest).permit(:description, :goal, :reward)
    end
end
