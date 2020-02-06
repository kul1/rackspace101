class DatacentersController < ApplicationController
  before_action :load_datacenter, only: [:show,]
  before_action :load_edit_datacenter, only: [:edit, :destroy]

	def index
    @datacenters = Datacenter.desc(:created_at).page(params[:page]).per(10)
	end

  def show 
    prepare_meta_tags(title: @datacenter.code,
                      description: @datacenter.code,
                      keywords: @datacenter.code)
  end

  def my
    @datacenters = Datacenter.where(user_id: current_ma_user).desc(:created_at).page(params[:page]).per(10)
    @page_title       = 'My Datacenter'
  end

  def debug
    binding.pry
  end

  def edit
    @page_title       = 'Edit Datacenter'
  end

  def create
    @datacenter = Datacenter.new(
                      code: $xvars["form_datacenter"]["code"],
                      servers_available: $xvars["form_datacenter"]["servers_available"],
                      servers_capacity: $xvars["form_datacenter"]["servers_capacity"],
                      country_id: $xvars["form_datacenter"]["country_id"],
                      user_id: $xvars["user_id"])
    @datacenter.save!
  end

  def update
    # $xvars["select_datacenter"] and $xvars["edit_datacenter"]
		# These are variables with params when called
    # They contain everything that we get their forms select_datacenter and edit_datacenter
  
		datacenter_id = $xvars["select_datacenter"] ? $xvars["select_datacenter"]["title"] : $xvars["p"]["datacenter_id"]
    @datacenter = Datacenter.find(datacenter_id)
    @datacenter.update(
                      code: $xvars["edit_datacenter"]["code"],
                      servers_available: $xvars["edit_datacenter"]["server_available"],
                      servers_capacity: $xvars["edit_datacenter"]["server_capacity"],
                      country: $xvars["edit_datacenter"]["country_id"])
  end

  def delete
    # For Jinda Gem menu
		datacenter_id = $xvars["select_datacenter"] ? $xvars["select_datacenter"]["code"] : $xvars["p"]["datacenter_id"]
    @datacenter = Datacenter.find(datacenter_id)
    @datacenter.destroy
  end

  def destroy
    #
		# duplicated from jinda_controller
		# Expected to use in jinda)controller
    current_ma_user = User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token]

    if Rails.env.test? #Temp solution until fix test of current_ma_user
      current_ma_user = $xvars["current_ma_user"]
      #current_ma_user = @datacenter.user
    end

    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @datacenter.user
      @datacenter.destroy
    end

    redirect_to :action=>'my'
  end

  private

  def load_edit_datacenter
		@datacenter = Datacenter.find(params.require(:datacenter_id))
  end
  
  def load_datacenter
		@datacenter = Datacenter.find(params.permit(:id))
  end

end
