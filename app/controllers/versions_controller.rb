# coding: utf-8

class VersionsController < ApplicationController
  def revert
    @version = Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? "Отменить последнее действие" : "Вернуть"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
    redirect_to :back, :notice => "#{link}"
  end
end
