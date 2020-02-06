class CountriesController < ApplicationController
  before_action :load_country, only: [:show,]
  before_action :load_edit_country, only: [:edit, :destroy]

  # @languges = Language.all
	def index
    @countries = Country.desc(:created_at).page(params[:page]).per(10)
	end

  def show 
    prepare_meta_tags(title: @country.name,
                      description: @country.name,
                      keywords: @country.name)
  end

  def edit
    @page_title       = 'Edit Country'
  end

  def create
    @country = Country.new(
                      name: $xvars["form_country"]["name"],
                      language: $xvars["form_country"]["language_id"])
    @country.save!
  end

  def my
    @countries = Country.where(user_id: current_ma_user).desc(:created_at).page(params[:page]).per(10)
    @page_title       = 'Member Login'
  end

  def update
    # $xvars["select_country"] and $xvars["edit_country"]
		# These are variables with params when called
    # They contain everything that we get their forms select_country and edit_country
  
		country_id = $xvars["select_country"] ? $xvars["select_country"]["title"] : $xvars["p"]["country_id"]
    @country = Country.find(country_id)
    @country.update(title: $xvars["edit_country"]["title"],
                    text: $xvars["edit_country"]["text"],
                    keywords: $xvars["edit_country"]["keywords"],
                    body: $xvars["edit_country"]["body"]
										)
  end

  def destroy
    #
		# duplicated from jinda_controller
		# Expected to use in jinda)controller
    current_ma_user = User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]

    if Rails.env.test? #Temp solution until fix test of current_ma_user
      current_ma_user = $xvars["current_ma_user"]
      #current_ma_user = @country.user
    end

    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @country.user
      @country.destroy
    end

    redirect_to :action=>'my'
  end

  private

  def load_edit_country
		@country = Country.find(params.require(:country_id))
  end
  
  def load_country
		@country = Country.find(params.permit(:id))
  end

end
