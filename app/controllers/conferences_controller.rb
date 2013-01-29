# coding: utf-8
class ConferencesController < ApplicationController
     	before_filter :check_regular_user
	before_filter :check_secretary_user, :only => ['new', 'edit', 'destroy']	
	
	def index
	 # найти протоколы, у которых состояние заседания будет или идет
	  @protocols = Protocol.where("state = 0 or state = 1").order("state DESC").limit(5)
	end
	
	def new
	  @protocol = Protocol.new
	end
	
	def edit
	  @protocol = Protocol.find(params[:id])
	end
	
	def destroy	  
	   @protocol = Protocol.find(params[:id])
	   if @protocol.state == 1	   	
	       flash[:error] = "Заседание уже идет, его нельзя отменить!"
	       redirect_to conferences_path
	   else
	     @protocol.destroy
	     respond_to do |format|
	         format.html { redirect_to conferences_path, :notice => "Заседание отменено" }
	   	 format.json { head :ok }
	     end
	   end
	end
end
