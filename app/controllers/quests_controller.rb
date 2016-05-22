class QuestsController < ApplicationController
  def index
    @quests = current_user.active_quests
  end

  def new
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.user = current_user

    if @quest.save
      redirect_to @quest
    end
  end

  def edit
    @quest = Quest.find(params[:id])
  end

  def update
    @quest = Quest.find(params[:id])

    if @quest.update(quest_params)
      redirect_to @quest
    else
      render 'edit'
    end
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def destroy
    @quest = Quest.find(params[:id])
    @quest.destroy

    redirect_to quests_path
  end

  def toggle
    @quest = Quest.find(params[:id])

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
