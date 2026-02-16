class EventStatusDefault < ActiveRecord::Migration[8.1]
  def up
    # 1. Set the default for the future
    change_column_default :events, :status, 0

    # 2. Update existing NULL records
    # Using update_all avoids running model callbacks/validations
    Event.where(status: nil).update_all(status: 0)
  end

  def down
    change_column_default :events, :status, nil
  end
end