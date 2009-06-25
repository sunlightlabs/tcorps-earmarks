class RootController < ApplicationController

  def index
    @source_doc = SortingHat.get_source_doc
    @user = User.find_or_create_by_name(params["username"])
    @letter = Letter.new(
      :source_doc_id => @source_doc.id,
      :user_id       => @user.id,
      :task_key      => params["task_key"]
    )
    @letter.entities << Entity.new
    attempt_pattern_match
    setup_index_vars
  end

  def create
    @letter = Letter.new(clean_letter_params(params[:letter]))
    if params["add_new_entity"]
      @letter.entities << Entity.new
      flash.now[:notice] = "Added a new entity."
      setup_and_render_index
    elsif params["delete_entity"]
      params["delete_entity"].keys.each do |key|
        entity_id = key.to_i
        @letter.entities.delete_at(entity_id)
      end
      flash.now[:notice] = "Removed an entity."
      setup_and_render_index
    elsif @letter.save
      report_completion
      redirect_to :action => :success
    else
      flash.now[:error] = "There was an error."
      setup_and_render_index
    end
  end

  def success
  end
  
  protected
  
  def attempt_pattern_match
    if APP_CONFIG['form_prepopulation']
      match = DocParser.best_match(@source_doc.plain_text)
      if match
        @prepopulated = true
        @letter.amount                 = match[:amount]
        @letter.project_title          = match[:project_title]
        @letter.fiscal_year            = match[:fiscal_year]
        @letter.funding_purpose        = match[:funding_purpose]
        @letter.taxpayer_justification = match[:taxpayer_justification]
        entity = @letter.entities[0]
        entity.name    = match[:entity_name]
        entity.address = match[:entity_address]
      end
    end
  end
  
  def setup_and_render_index
    @source_doc = @letter.source_doc
    setup_index_vars
    render :action => :index
  end
  
  def setup_index_vars
    @username = params["username"]
    @points   = params["points"] || 0
  end
  
  def report_completion
    TcorpsUtil.signal_task_completion(@letter.task_key)
    # TODO:
    #   What to do if we get a failure?
    #   Try again?
  end
  
  protected
  
  def clean_letter_params(params)
    ControllerUtil.clean_params(params, [
      :amount,
      :project_title,
      :fiscal_year,
      :funding_purpose,
      :taxpayer_justification,
      :user_id,
      :source_doc_id,
      :task_key,
      # And finally, because of:
      #   accepts_nested_attributes_for :entities
      :entities_attributes
    ])
  end
  
end
