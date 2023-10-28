# frozen_string_literal: true

class DropAuthTokensTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :auth_tokens
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
