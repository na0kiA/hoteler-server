class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: "email", index: { unique: true }
      t.string :uid, null: false, default: "", index: { unique: true }

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token, index: { unique: true }
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmables
      t.string   :confirmation_token, index: { unique: true }
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## User Info
      t.string :name
      t.string :nickname
      t.string :image
      t.string :email

      ## Tokens
      t.text :tokens

      t.timestamps
    end
  end
end
