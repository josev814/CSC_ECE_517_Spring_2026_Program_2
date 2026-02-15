class VolunteerAssignment < ApplicationRecord

# Associations
  belongs_to :volunteer
  belongs_to :event


# Custom Validation for Event Completion
  validate :event_completion

  def event_completion
    if status == "completed" && event.status != "completed"
      errors.add(:status, "cannot be completed unless event is completed")
    end
  end


# Custom Validation for Hours Worked
  validate :hours_valid

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


  validates :hours_worked, numericality: {greater_than_or_equal_to: 0}, allow_nil: true


# Uniqueness Validation
  validates :volunteer_id, uniqueness: { scope: :event_id, message: "has already been assigned to this event" }


# Volunteer Status
  STATUSES = ["pending", "approved", "completed", "cancelled"].freeze

  after_initialize do self.status ||= "pending" end

  validates :status, inclusion: { in: STATUSES }


  scope :pending,   -> { where(status: "pending") }
  scope :approved,  -> { where(status: "approved") }
  scope :completed, -> { where(status: "completed") }
  scope :cancelled, -> { where(status: "cancelled") }


end
