class AdminsController < ApplicationController
  before_action :admin_access_only, only: %i[ index show edit update ]
  before_action :block_web_access, only: %i[ new create ]

  # GET /admins or /admins.json
  def index
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def admin_params
    params.expect(admin: [ :id, :username, :password, :name, :email ])
  end

  def block_web_access
    # If the process isn't the console, reject the request
    unless defined?(Rails::Console)
      redirect_to root_path, alert: 'Access Denied'
    end
  end
end
