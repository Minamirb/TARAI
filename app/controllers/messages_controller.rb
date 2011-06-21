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
    @message = Message.new

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
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
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
    @messages = current_user.sended_messages
  end

  def mark_list
    followers_messages = 
      current_user.followers.
      map { |follower| follower.sended_messages }.flatten

    followers_marked_messages =
      current_user.followers.
      map { |follower| follower.feedbacks }.flatten.
      select { |feedback| feedback.good }.
      map { |feedback| feedback.message }.flatten

    @messages = (followers_messages + followers_marked_messages).
      select { |message| message.from_user != current_user && 
                         message.not_yet_comment_by(current_user) }
  end

  def received_list
    @messages = Message.where('to_user_id = ?', current_user).select do |message|
      !message.bad_marked_by(current_user) and 
      current_user.followers.any? do |follower| 
        message.from_user == follower or 
        message.good_marked_by(follower) 
      end
    end

  end

end
