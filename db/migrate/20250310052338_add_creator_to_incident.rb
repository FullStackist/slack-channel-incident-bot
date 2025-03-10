class AddCreatorToIncident < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :creator, :string
  end
end
