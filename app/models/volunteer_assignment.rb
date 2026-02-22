class VolunteerAssignment < ApplicationRecord
  # Associations
  belongs_to :volunteer
  belongs_to :event

  STATUSES = [ "pending", "approved", "completed", "cancelled" ].freeze

  # Custom Validation for Event Completion
  validate :event_completion
  validate :event_capacity
  # Custom Validation for Hours Worked
  validate :hours_valid
  validates :hours_worked, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :event_id, presence: true
  # Uniqueness Validation
  validates :volunteer_id, presence: true, uniqueness: { scope: :event_id, message: "has already been assigned to this event" }
  # Volunteer Status
  validates :status, inclusion: { in: STATUSES }

  def event_completion
    if status == "completed" && event.status != "completed"
      errors.add(:status, "cannot be completed unless event is completed")
    end
  end

  def self.hours_logged(user_id)
    {
      pending_hours: VolunteerAssignment.all.where(volunteer_id: user_id, status: "approved").sum(:hours_worked),
      completed_hours: VolunteerAssignment.all.where(volunteer_id: user_id, status: "completed").sum(:hours_worked)
    }
  end

  def hours_valid
    return if hours_worked.blank?

    errors.add(:hours_worked, "cannot be negative") if hours_worked < 0

    if event && hours_worked > event_duration
      errors.add(:hours_worked, "cannot exceed event duration")
    end
  end

  def event_duration
    ((event.end_time - event.start_time) / 3600.0).round(2)
  end

  def event_capacity
    return if event.nil?
    return unless [ "approved", "completed" ].include?(status)

    approved_count = event.volunteer_assignments.where(status: [ "approved", "completed" ])
                               .where.not(id: id)
                               .count

    return unless approved_count >= event.required_volunteers.to_i

    errors.add(:status, "Event has reached its required volunteer capacity")
  end

  after_initialize do
    self.status ||= "pending"
  end

  after_commit :sync_event_status, on: [ :create, :update, :destroy ]

  scope :pending, -> { where(status: "pending") }
  scope :approved, -> { where(status: "approved") }
  scope :completed, -> { where(status: "completed") }
  scope :cancelled, -> { where(status: "cancelled") }

  private

  # If the volunteer assignment is created, updated, or destroyed, we need to check if the event status needs to be updated
  # based on the number of approved volunteers and the required volunteers
  def sync_event_status
    return if event.nil?
    return unless destroyed? || saved_change_to_status? || saved_change_to_event_id?

    event.update_status!
  end

  def entering_approved_state?
    return true if new_record?
    return false unless will_save_change_to_status?
    previous_status = status_in_database
    [ "approved", "completed" ].exclude?(previous_status)
  end
end
