class LikesController < ApplicationController
  before_filter :require_user

  respond_to :js, only: [:create, :destroy]

  # POST /statuses/:status_id/like(.:format)
  def create
    @like = Like.create(status_id: params[:status_id], user_id: current_user.id)
    respond_with do |format|
      format.js {
        render file: "likes/update_like_status"
      }
    end
  end

  # DELETE /statuses/:status_id/like(.:format)
  def destroy
    @like = Like.where(status_id: params[:status_id], user_id: current_user.id).first.delete
    respond_with do |format|
      format.js {
        render file: "likes/update_like_status"
      }
    end
  end

end
