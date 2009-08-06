class DocumentsController < ApplicationController

  def index
    @source_doc = SourceDoc.get_random
    @user = User.find_or_create_by_name(params["username"])
    @letter = Letter.new(
      :source_doc_id => @source_doc.id,
      :user_id       => @user.id,
      :task_key      => params["task_key"]
    )
    @letter.entities << Entity.new
    
    setup_index_vars
  end

  def create
    @letter = Letter.new(clean_letter_params(params[:letter]))
    if params["add_new_entity"]
      @letter.entities << Entity.new
      setup_and_render_index
    elsif params["delete_entity"]
      params["delete_entity"].keys.each do |key|
        entity_id = key.to_i
        @letter.entities.delete_at(entity_id)
      end
      setup_and_render_index
    elsif @letter.save
      flash[:notice] = "Thanks for contributing!  We've logged your points in TransparencyCorps. Here's another document so that you can earn more!"
      if url = TransparencyCorps.complete_task_and_reassign(@letter.task_key)
        redirect_to url
      else
        redirect_to :action => :success
      end
    else
      setup_and_render_index
    end
  end

  def success
  end
  
  protected
  
  def setup_and_render_index
    @source_doc = @letter.source_doc
    setup_index_vars
    render :action => :index
  end
  
  # Helper: sets up instance variables for index.html.erb.
  def setup_index_vars
    @username = params["username"]
    @points   = params["points"] || 0
    @has_plain_text = @source_doc.plain_text_length > 10
  end
  
  protected
  
  def clean_letter_params(params)
    clean_params(params, [
      :amount,
      :project_title,
      :fiscal_year,
      :funding_purpose,
      :taxpayer_justification,
      :user_id,
      :source_doc_id,
      :task_key,
      :legislator_id,
      # And finally, because of:
      #   accepts_nested_attributes_for :entities
      :entities_attributes
    ])
  end
  
end
