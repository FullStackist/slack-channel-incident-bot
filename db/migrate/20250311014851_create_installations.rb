class CreateInstallations < ActiveRecord::Migration[8.0]
  def change
    create_table :installations do |t|
      t.string :slack_workspace_id
      t.string :slack_access_token

      t.timestamps
    end
  end
end
