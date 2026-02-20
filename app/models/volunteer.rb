class Volunteer < ApplicationRecord
    # Associations
    has_secure_password
    attr_readonly :username
    has_many :volunteer_assignments, dependent: :destroy
    has_many :events, through: :volunteer_assignments

    # Validations
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, on: [ :create ], length: { minimum: 6 }
    validates :full_name, presence: true


    # Calculation of Total Volunteer Hours
    def total_hours
        volunteer_assignments.completed.sum(:hours)
    end
end
