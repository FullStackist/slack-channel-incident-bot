class AddEidToIncident < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :eid, :string
  end
end
