class AdminsController < ApplicationController
  before_action :admin_access_only, only: %i[ index show edit update ]

  # GET /admins or /admins.json
  def index
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    # @admin = Admin.new
    redirect_to admins_path, alert: 'Access Denied'
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
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
end
