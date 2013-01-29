# coding: utf-8

class AuditoriesController < ApplicationController
  # GET /auditories
  # GET /auditories.json
  def index
    @auditories = Auditory.all
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        q = params[:q]        
        @auditories = Auditory.where("number LIKE ?",
        "%#{q}%").all
        render :json=>@auditories.to_json
      end
    end
  end

  # GET /auditories/1
  # GET /auditories/1.json
  def show
    @auditory = Auditory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @auditory }
    end
  end

  # GET /auditories/new
  # GET /auditories/new.json
  def new
    @auditory = Auditory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @auditory }
    end
  end

  # GET /auditories/1/edit
  def edit
    @auditory = Auditory.find(params[:id])
  end

  # POST /auditories
  # POST /auditories.json
  def create
    @auditory = Auditory.new(params[:auditory])

    respond_to do |format|
      if @auditory.save
        format.html { redirect_to @auditory, :notice => 'Auditory was successfully created.' }
        format.json { render :json => @auditory, :status => :created, :location => @auditory }
      else
        format.html { render :action => "new" }
        format.json { render :json => @auditory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auditories/1
  # PUT /auditories/1.json
  def update
    @auditory = Auditory.find(params[:id])

    respond_to do |format|
      if @auditory.update_attributes(params[:auditory])
        format.html { redirect_to @auditory, :notice => 'Auditory was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @auditory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auditories/1
  # DELETE /auditories/1.json
  def destroy
    @auditory = Auditory.find(params[:id])
    @auditory.destroy

    respond_to do |format|
      format.html { redirect_to auditories_url }
      format.json { head :ok }
    end
  end
end
