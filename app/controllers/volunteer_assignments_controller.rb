class VolunteerAssignmentsController < ApplicationController
  before_action :ensure_dependencies_exist, only: [:new, :create]
  before_action :set_volunteer_assignment, only: %i[ show edit update destroy ]
  before_action :admin_access_only
  before_action :load_collections, only: %i[ new edit create update ]

  # GET /volunteer_assignments or /volunteer_assignments.json
  def index
    # if user_id isn't set this defaults to 0
    @filtered = params[:user_id].to_i
    if params[:user_id]
      @volunteer_assignments = VolunteerAssignment.where(volunteer: params[:user_id]).order(id: :desc).all
      ( @filtered.eql?(0) ? redirect_to(volunteer_assignments_path) : '')
      @hours_logged = VolunteerAssignment.hours_logged(params[:user_id])
    else
      @volunteer_assignments = VolunteerAssignment.order(id: :desc).all
    end
  end

  # GET /volunteer_assignments/1 or /volunteer_assignments/1.json
  def show
  end

  # GET /volunteer_assignments/new
  def new
    @volunteer_assignment = VolunteerAssignment.new
  end

  # GET /volunteer_assignments/1/edit
  def edit
  end

  # POST /volunteer_assignments or /volunteer_assignments.json
  def create
    @volunteer_assignment = VolunteerAssignment.new(volunteer_assignment_params)

    respond_to do |format|
      if @volunteer_assignment.save
        format.html { redirect_to @volunteer_assignment, notice: "Volunteer assignment was successfully created." }
        format.json { render :show, status: :created, location: @volunteer_assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volunteer_assignments/1 or /volunteer_assignments/1.json
  def update
    respond_to do |format|
      if @volunteer_assignment.update(volunteer_assignment_params)
        redirection = ( request.referer.eql?(edit_volunteer_assignment_path) ? @volunteer_assignment : volunteer_assignments_path )
        format.html { redirect_to redirection, notice: "Volunteer assignment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @volunteer_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_assignments/1 or /volunteer_assignments/1.json
  def destroy
    @volunteer_assignment.destroy!

    respond_to do |format|
      format.html { redirect_to volunteer_assignments_path, notice: "Volunteer assignment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end


  def ensure_dependencies_exist
    if Volunteer.count == 0
      redirect_to new_volunteer_path,
                  alert: "You must create a volunteer before creating an assignment."
    elsif Event.count == 0
      redirect_to new_event_path,
                  alert: "You must create an event before creating an assignment."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_assignment
      # todo: when using find with an id that doesn't exist an ActiveRecord::RecordNotFound Exception is thrown
      @volunteer_assignment = VolunteerAssignment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def volunteer_assignment_params
      params.expect(volunteer_assignment: [ :volunteer_id, :event_id, :status, :hours_worked, :date_logged ])
    end

    def load_collections
      @volunteers = Volunteer.all
      @events = Event.all
    end
end
