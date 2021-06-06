class AddKeyAndTokenToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :token, :string
    add_column :identities, :secret, :string

  end
end
