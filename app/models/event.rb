class Event < ApplicationRecord
  enum :status, { open: 0, full: 1, completed: 2 }

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

  def event_time
    "#{start_time.strftime("%I:%M %p")} to #{end_time.strftime("%I:%M %p")}"
  end

  private

  def set_default_status
    self.status ||= :open
  end
end
