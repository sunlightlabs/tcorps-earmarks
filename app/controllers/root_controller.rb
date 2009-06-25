class RootController < ApplicationController
  
  # Magnetic-Resonance-Imaging-System-Replacement
  # 16661767

  # Town of Grant Infrastructure
  # 16662534

  def index
    @source_doc = SortingHat.get_source_doc
    @user = User.find_or_create_by_name(params["username"])
    @letter = Letter.new(
      :source_doc_id => @source_doc.id,
      :user_id       => @user.id,
      :task_key      => params["task_key"]
    )
    setup_form_vars
  end
  
  def create
    @letter = Letter.new(clean_letter_params(params[:letter]))
    if @letter.save
      report_completion
      redirect_to :action => :success
    else
      @source_doc = @letter.source_doc
      setup_form_vars
      flash.now[:error] = "There was an error."
      render :action => :index
    end
  end
  
  def success
  end
  
  protected
  
  def setup_form_vars
    @username = params["username"]
    @points   = params["points"] || 0
  end
  
  def report_completion
    true
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
      :task_key
    ])
  end
  
end
