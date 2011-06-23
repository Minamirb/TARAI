class FeedbacksController < ApplicationController
  # GET /messages/:message_id/feedbacks
  def index
    @message = Message.find(params[:message_id])
    @feedbacks = @message.feedbacks

    respond_to do |format|
      format.html
      format.xml { render :xml => @feedbacks }
    end
  end
  # GET /messages/:message_id/feedbacks/new
  def new
    @message = Message.find(params[:message_id])
    @feedback = @message.feedbacks.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feedback }
    end
  end

  # POST /messages/:message_id/feedbacks
  def create
    @feedback = Feedback.new(params[:feedback])
    @message = Message.find(params[:message_id])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to(mark_messages_path, :notice => 'Feedback was successfully created.') }
        format.xml  { render :xml => @feedback, :status => :created, :location => @feedback }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

end
