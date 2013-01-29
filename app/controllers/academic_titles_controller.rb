class AcademicTitlesController < ApplicationController
  # GET /academic_titles
  # GET /academic_titles.json
  def index
    @academic_titles = AcademicTitle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @academic_titles }
    end
  end

  # GET /academic_titles/1
  # GET /academic_titles/1.json
  def show
    @academic_title = AcademicTitle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @academic_title }
    end
  end

  # GET /academic_titles/new
  # GET /academic_titles/new.json
  def new
    @academic_title = AcademicTitle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @academic_title }
    end
  end

  # GET /academic_titles/1/edit
  def edit
    @academic_title = AcademicTitle.find(params[:id])
  end

  # POST /academic_titles
  # POST /academic_titles.json
  def create
    @academic_title = AcademicTitle.new(params[:academic_title])

    respond_to do |format|
      if @academic_title.save
        format.html { redirect_to @academic_title, :notice => 'Academic title was successfully created.' }
        format.json { render :json => @academic_title, :status => :created, :location => @academic_title }
      else
        format.html { render :action => "new" }
        format.json { render :json => @academic_title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /academic_titles/1
  # PUT /academic_titles/1.json
  def update
    @academic_title = AcademicTitle.find(params[:id])

    respond_to do |format|
      if @academic_title.update_attributes(params[:academic_title])
        format.html { redirect_to @academic_title, :notice => 'Academic title was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @academic_title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /academic_titles/1
  # DELETE /academic_titles/1.json
  def destroy
    @academic_title = AcademicTitle.find(params[:id])
    @academic_title.destroy

    respond_to do |format|
      format.html { redirect_to academic_titles_url }
      format.json { head :ok }
    end
  end
end
