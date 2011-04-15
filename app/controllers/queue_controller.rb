# _*_ coding: utf-8 _*_
class QueueController < ApplicationController
  layout 'pasokara_player'
  before_filter :no_tag_load, :only => [:list]


  def list
    @queue_list = QueuedFile.paginate(:all, :order => "created_at", :include => :pasokara_file, :page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html {
        if request.xhr?
          if request.smart_phone?
            render :layout => false
          else
            render :update do |page|
              page.replace_html("queue_table", :partial => "list", :object => @queue_list)
            end
          end
        end
      }
      format.xml { render :xml => @queue_list.to_xml }
      format.json { render :json => @queue_list.to_json }
    end
  end

  def play
    @queue = QueuedFile.find(:first, :order => "created_at", :include => :pasokara_file)

    unless @queue
      render :action => "no_movie" and return
    end

    @pasokara = @queue.pasokara_file
    @extname = File.extname(@pasokara.fullpath)
    if @extname =~ /mp4|flv/
      render :layout => false if request.xhr?
    else
      render :text => "Not Flash Movie"
    end
  end

  def remove
    @queue = QueuedFile.find(params[:id])
    @queue.destroy
    redirect_to :action => 'list'
  end

  #jQuery Mobile
  def confirm_remove
    @queue = QueuedFile.find(params[:id])
    if request.xhr?
      render :action => "confirm_remove", :layout => false
    else
      render :action => "confirm_remove"
    end
  end

  def last
    @queue = QueuedFile.find(:first, :order => "id desc")

    if @queue
      respond_to do |format|
        format.xml  { render :xml => @queue.pasokara_file.to_xml }
        format.json { render :json => @queue.pasokara_file.to_json }
      end
    else
      render :text => "No Queue", :status => 404
    end
  end

  def deque
    @queue = QueuedFile.deq
    if @queue

      user = @queue.user
      if user and user.tweeting
        begin
          oauth.authorize_from_access(user.twitter_access_token, user.twitter_access_secret)
          client = Twitter::Base.new(oauth)
          tweet_body = "Singing Now: #{@queue.pasokara_file.name}"
          tweet_body += " http://www.nicovideo.jp/watch/#{@queue.pasokara_file.nico_name}" if @queue.pasokara_file.nico_name
          tweet_body += " #nicokara"
          client.update(tweet_body)
        rescue Exception
          logger.warn "#{@queue.user}'s Tweet Failed"
        end
      end

      respond_to do |format|
        format.html
        format.xml { render :xml => @queue.pasokara_file.to_xml }
        format.json { render :json => @queue.pasokara_file.to_json }
      end
    else
      render :text => "No Queue", :status => 404
    end
  end

end
