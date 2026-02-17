class Event < ApplicationRecord
  enum :status, { open: 0, full: 1, completed: 2 }

  # Associations
  has_many :volunteer_assignments, dependent: :destroy
  has_many :volunteers, through: :volunteer_assignments

  # Validations
  validates :title, presence: true, length: { minimum: 4, maximum: 32 }
  validates :description, presence: true
  validates :location, presence: true, length: { minimum: 4, maximum: 32 }
  validates :event_date, presence: true, comparison: { greater_than_or_equal_to: -> { Date.today } }
  validates :start_time, :status, presence: true
  validates :required_volunteers, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :end_time, presence: true,
            comparison: { greater_than: :start_time,
            message: ->(record, data) { "must be set after the selected start time of #{record.start_time.strftime("%I:%M %p")}" },
            unless: -> { start_time.nil? || end_time.nil? } }
  # Prevent duplicate events with same event details
  validates :title, uniqueness: {
    scope: [ :title, :event_date, :start_time, :end_time, :location ],
    message: "An event with the same title, date, time, and location already exists."
  }

  after_initialize :set_default_status, if: :new_record?
  after_commit :update_status!, on: [ :create, :update ], if: :saved_change_to_required_volunteers?

  def open_for_signup?
    return false if completed?
    open? && volunteer_slots_available?
  end

  def volunteer_slots_available?
    approved_volunteers < required_volunteers.to_i
  end

  def volunteer_assignment_for(volunteer)
    return false if volunteer.nil?
    volunteer.volunteer_assignments.find_by(event: self)
  end

  def volunteer_for(volunteer)
    return { ok: false, alert: "Volunteer not found." } if volunteer.nil?
    volunteer_assignment_for(volunteer)
    unless open_for_signup?
      return { ok: false, alert: "Signups are closed for this event." }
    end

    assignment = volunteer.volunteer_assignments.find_or_initialize_by(event: self)

    if assignment.new_record?
      assignment.status = "pending"
      assignment.save!
      { ok: true, notice: "You have signed up for this event (pending approval).", assignment: assignment }
    elsif assignment.status == "cancelled"
      assignment.update!(status: "pending", hours_worked: nil, date_logged: nil)
      { ok: true, notice: "You have re-signed up for this event (pending approval).", assignment: assignment }
    else
      { ok: false, alert: "You have already volunteered for this event." }
    end
  end

  # This method cancels the volunteer assignment for the given volunteer and event
  def unvolunteer_for(volunteer)
    if volunteer.nil?
      return { ok: false, alert: "Volunteer not found." }
    end

    assignment = volunteer.volunteer_assignments.find_by(event: self)
    if assignment.nil? || assignment.status == "cancelled"
      return { ok: false, alert: "You are not signed up for this event." }
    end

    assignment.update!(status: "cancelled", hours_worked: nil, date_logged: nil)
    { ok: true, notice: "You have been removed from this event." }
  end

  def approved_volunteers
    volunteer_assignments.where(status: [ "approved", "completed" ]).count
  end

  def event_time
    "#{start_time.strftime("%I:%M %p")} to #{end_time.strftime("%I:%M %p")}"
  end

  def update_status!
    return if completed?
    next_status = approved_volunteers >= required_volunteers.to_i ? :full : :open
    update!(status: next_status) if status.to_sym != next_status
  end

  private

  def set_default_status
    self.status ||= :open
  end
end
