class VolunteersController < ApplicationController
  before_action :set_volunteer, only: %i[ show edit update destroy ]
  before_action :admin_access_only, only: %i[ index ]
  before_action :user_or_admin_access_only, only: %i[ show edit update destroy ]

  # GET /volunteers or /volunteers.json
  def index
    @volunteers = Volunteer.all
    render layout: 'admins'
  end

  # GET /volunteers/1 or /volunteers/1.json
  def show
    if is_admin?
      render layout: 'admins'
    end
  end

  # GET /volunteers/new
  def new
    @volunteer = Volunteer.new
    if is_admin?
      render layout: 'admins'
    end
  end

  # GET /volunteers/1/edit
  def edit
    if is_admin?
      render layout: 'admins'
    end
  end

  # POST /volunteers or /volunteers.json
  def create
    @volunteer = Volunteer.new(volunteer_params)

    respond_to do |format|
      if @volunteer.save
        format.html { redirect_to @volunteer, notice: "Volunteer was successfully created." }
        format.json { render :show, status: :created, location: @volunteer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @volunteer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteers/1 or /volunteers/1.json
  def update
    respond_to do |format|
      if @volunteer.update(volunteer_params)
        format.html { redirect_to @volunteer, notice: "Volunteer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @volunteer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteers/1 or /volunteers/1.json
  def destroy
    @volunteer.destroy!

    respond_to do |format|
      format.html {
        if is_admin?
          redirect_to volunteers_path, notice: "Volunteer was successfully destroyed.", status: :see_other
        else
          reset_session
          redirect_to root_path, notice: "Your account has been deleted"
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer
      @volunteer = Volunteer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def volunteer_params
      params.expect(volunteer: [ :username, :full_name, :email, :phone_number, :address, :skills_interests, :password, :password_confirmation ])
    end

    # checks if access is restricted to current user or admin
    def user_or_admin_access_only
      redirect = false
      if is_admin?.eql?(false)
        if session[:user_id].nil?
          redirect = true
        elsif session[:user_id].eql?(@volunteer.id).eql?(false)
          redirect = true
        end
      end
      if redirect
        redirect_to root_url, alert: "You are not authorized to access that."
      end
    end
end
