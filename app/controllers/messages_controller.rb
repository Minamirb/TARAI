class MessagesController < ApplicationController
  before_filter :authenticate_user!
  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = 
      if params[:message_id] 
        Message.new(Message.find(params[:message_id]).attributes)
      else
        Message.new(:from_user => current_user, :to_user => User.find(params[:id]))
      end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to(sended_messages_path, :notice => 'Message was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end

  def sended_list
    @messages = current_user.sended_messages.page(params[:page])
  end
  
  def mark_list
    @messages = 
      Message.not_yet_comment_by(current_user).
        joins('LEFT JOIN feedbacks ON messages.id = feedbacks.message_id').
          where(:'feedbacks.user_id' => current_user.followers).
          where(:'feedbacks.good' => true).
          select('DISTINCT messages.*').
          page(params[:page])
  end

  def received_list
    @messages = 
      Message.to(current_user).exclude_bad_marked_by(current_user).
        joins('INNER JOIN feedbacks ON messages.id = feedbacks.message_id').
          where(:'feedbacks.user_id' => current_user.followers).
          where(:'feedbacks.good' => true).
          select('DISTINCT messages.*').
          page(params[:page])
  end

  # POST '/messages/:id/reject
  def reject
    message = Message.find(params[:id])
    Feedback.create(:message => message, :user => current_user,
                    :good => false, :comment => 'rejected by the receiver')
    redirect_to received_messages_path
  end

  def view
    @message = Message.find(params[:id])
    if @message.not_yet_comment_by(current_user)
      Feedback.create(:message => @message, :user => current_user,
                      :good => true, :comment => 'accepted by the receiver')
    end
  end

  def select_user
    # find all user not in current_user
    @users = User.where("id <> ?", current_user.id).page(params[:page])
  end

end
