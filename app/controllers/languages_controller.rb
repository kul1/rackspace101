class LanguagesController < ApplicationController
  before_action :load_language, only: [:show,]
  before_action :load_edit_language, only: [:edit, :destroy]

	def index
    @languages = Language.desc(:created_at).page(params[:page]).per(10)
	end

  def show 
    prepare_meta_tags(title: @language.name,
                      description: @language.name,
                      keywords: @language.name)
  end

  def edit
    @page_title       = 'Edit Language'
  end

  def create
    @language = Language.new(
                      name: $xvars["form_language"]["name"])
    @language.save!
  end

  def my
    @languages = Language.where(user_id: current_ma_user).desc(:created_at).page(params[:page]).per(10)
    @page_title       = 'Member Login'
  end

  def update
    # $xvars["select_language"] and $xvars["edit_language"]
		# These are variables with params when called
    # They contain everything that we get their forms select_language and edit_language
  
		language_id = $xvars["select_language"] ? $xvars["select_language"]["title"] : $xvars["p"]["language_id"]
    @language = Language.find(language_id)
    @language.update(title: $xvars["edit_language"]["title"],
                    text: $xvars["edit_language"]["text"],
                    keywords: $xvars["edit_language"]["keywords"],
                    body: $xvars["edit_language"]["body"]
										)
  end

  def destroy
    #
		# duplicated from jinda_controller
		# Expected to use in jinda)controller
    current_ma_user = User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]

    if Rails.env.test? #Temp solution until fix test of current_ma_user
      current_ma_user = $xvars["current_ma_user"]
      #current_ma_user = @language.user
    end

    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @language.user
      @language.destroy
    end

    redirect_to :action=>'my'
  end

  private

  def load_edit_language
		@language = Language.find(params.require(:language_id))
  end
  
  def load_language
		@language = Language.find(params.permit(:id))
  end

end
