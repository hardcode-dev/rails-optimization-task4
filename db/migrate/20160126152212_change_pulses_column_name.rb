class ChangePulsesColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :pulse_subscriptions, :pulses, :subscribed_categories
  end
end
