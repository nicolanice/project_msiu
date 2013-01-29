# coding: utf-8

class ThemesController < ApplicationController
  before_filter :check_regular_user
  # GET /themes
  # GET /themes.json
  def index    
    @themes = Theme.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @themes }
    end
  end
    
    
  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(params[:theme])

    respond_to do |format|
      if @theme.save
        format.html { redirect_to @theme, :notice => 'Тема создана' }
        format.json { render :json => @theme, :status => :created, :location => @theme }
      else
        format.html { render :action => "new" }
        format.json { render :json => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.json
  def update
    @theme = Theme.find(params[:id])

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        format.html { redirect_to @theme, :notice => 'Тема сохранена' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to themes_url }
      format.json { head :ok }
    end
  end
end
