class LettersController < ApplicationController
  # GET /letters
  # GET /letters.xml
  def index
    @letters = Letter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end

  # GET /letters/1
  # GET /letters/1.xml
  def show
    @letter = Letter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/new
  # GET /letters/new.xml
  def new
    @letter = Letter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter }
    end
  end

  # GET /letters/1/edit
  def edit
    @letter = Letter.find(params[:id])
  end

  # POST /letters
  # POST /letters.xml
  def create
    @letter = Letter.new(clean(params))

    respond_to do |format|
      if @letter.save
        flash[:notice] = 'Letter was successfully created.'
        format.html { redirect_to(@letter) }
        format.xml  { render :xml => @letter, :status => :created, :location => @letter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /letters/1
  # PUT /letters/1.xml
  def update
    @letter = Letter.find(params[:id])

    respond_to do |format|
      if @letter.update_attributes(params[:letter])
        flash[:notice] = 'Letter was successfully updated.'
        format.html { redirect_to(@letter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /letters/1
  # DELETE /letters/1.xml
  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy

    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def clean(params)
    letter = params[:letter]
    {
      :amount                 => letter["amount"],
      :project_title          => letter["project_title"],
      :fiscal_year            => letter["fiscal_year"],
      :funding_purpose        => letter["funding_purpose"],
      :taxpayer_justification => letter["taxpayer_justification"],
    }
  end
  
end
