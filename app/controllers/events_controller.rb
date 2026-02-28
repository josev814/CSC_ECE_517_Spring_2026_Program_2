class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy volunteer unvolunteer ]
  before_action :admin_access_only, only: %i[ new create edit update destroy ]
  before_action :require_volunteer, only: %i[ volunteer unvolunteer ]

  # GET /events or /events.json
  def index
    @events = Event.includes(:volunteer_assignments).order(event_date: :asc, start_time: :asc)

    if @volunteer.present?
      @volunteer_assignments = @volunteer.volunteer_assignments.where(event_id: @events.select(:id)).index_by(&:event_id)
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new(status: :open)
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  # @note If the request is from the events page we redirect to the events page otherwise we redirect to the event page.
  def update
    respond_to do |format|
      if @event.update(event_params)
        redirection = ( edit_event_path.eql?(request.referer) ? @event : request.referer )
        format.html {
          redirect_to redirection,
          notice: "The event #{@event.title} was successfully updated.",
          status: :see_other
        }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /events/1/volunteer
  def volunteer
    result = @event.volunteer_for(@volunteer)
    redirect_to event_path(@event), notice: result[:notice], alert: result[:alert]
  end

  # POST /events/1/unvolunteer
  def unvolunteer
    result = @event.unvolunteer_for(@volunteer)
    redirect_to event_path(@event), notice: result[:notice], alert: result[:alert]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Ensure the user is logged in as a volunteer before allowing volunteer or unvolunteer
    def require_volunteer
      return if @volunteer.present?

      redirect_to login_path, alert: "You must be logged in as a volunteer to perform this action."
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(
        :title,
        :description,
        :location,
        :event_date,
        :start_time,
        :end_time,
        :required_volunteers,
        :status
      )
    end
end
