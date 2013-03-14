class CommentsController < ApplicationController
  before_filter :require_user

  respond_to :js, only: [:create, :load_more_status_comments]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])

    if @comment.valid?
      @comment.save
      @comment_added = true
      @status = @comment.status
    else
      @status = Status.find_by_id(@comment.status_id)
    end

    respond_with do |format|
       format.js {
         render file: "comments/show_comments"
       }
    end
  end

  # GET /statuses/:status_id/comments/:next_page(.:format)
  def load_more_status_comments
    status_id = params[:status_id]
    next_page = params[:next_page]

    if (status_id.present? and next_page.present?)
      @current_page = next_page.to_i
      @status = Status.find_by_id(status_id)
    end

    respond_with do |format|
       format.js {
         render file: "comments/show_more_status_comments"
       }
    end

  end

end
