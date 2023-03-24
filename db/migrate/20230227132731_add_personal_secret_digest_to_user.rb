class AddPersonalSecretDigestToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :personal_secret_digest, :string
  end
end
