class DocumentsController < ApplicationController

  def index
    @document = Document.next
    @letter = @document.letters.new :task_key => params[:task_key]
    @letter.entities << Entity.new
  end

  def create
    @letter = Letter.new params[:letter]
    @document = @letter.document
    
    if params[:add_new_entity]
      @letter.entities << Entity.new
      render :index
    
    elsif params[:delete_entity]
      params[:delete_entity].keys.each do |key|
        entity_id = key.to_i
        @letter.entities.delete_at(entity_id)
      end
      render :index
      
    elsif @letter.save
      if !@letter.task_key.blank? and url = TransparencyCorps.complete_task_and_reassign(@letter.task_key)
        flash[:notice] = "Thanks for contributing!  We've logged your points in TransparencyCorps. Here's another document so that you can earn more!"
        redirect_to url
      else
        flash[:notice] = "Awesome, thanks for contributing! But believe me, we have plenty more work to do -- so here's another!"
        redirect_to documents_path
      end
    else
      render :index
    end
  end
  
end