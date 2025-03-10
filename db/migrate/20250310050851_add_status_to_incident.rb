class AddStatusToIncident < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :status, :string
  end
end
