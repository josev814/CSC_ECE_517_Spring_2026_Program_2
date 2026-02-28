require 'faker'
require './test/rails_helper'
require './test/features/shared_tasks.rb'

describe 'Try to access deleted event', :type => :feature do
  # create the event before the test
  before do
    lang = Faker::ProgrammingLanguage.name
    event_date = Faker::Date.forward(days: 90)
    start_time = Faker::Time.between_dates(from: event_date, to: event_date, period: :morning)
    end_time = Faker::Time.between_dates(from: event_date, to: event_date, period: :afternoon)
    @event_data = {
      title: "Tutoring for #{lang}",
      description: "Tutor individuals in the #{lang} programming language",
      location: Faker::University.name,
      event_date: event_date,
      start_time: start_time,
      end_time: end_time,
      required_volunteers: Faker::Number.within(range: 2..5)
    }
    saved_event = Event.create @event_data
    @event_data[:id] = saved_event.id
  end

  it 'access deleted event' do
    # we first destroy it
    Event.destroy(@event_data[:id])

    visit event_path @event_data[:id]
    expect(page).to have_current_path events_path
    expect(page).to have_content 'Event not found.'
  end
end
