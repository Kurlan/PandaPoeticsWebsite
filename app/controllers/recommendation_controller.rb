class RecommendationController < ApplicationController
  def show
   @recommendation = Recommendation.find(params[:id]);
  end

  def new
    @recommendation = Recommendation.new(params[:recommendation])
    if (@recommendation.save)
      respond_to do |format|
          format.html { redirect_to(recommendation_show_path(@recommendation), :id =>  @recommendation.id) }
      end
    end
  end

  def edit
    @recommendation = Recommendation.find(params[:id]);
  end

  def update
  
  end
end
