class CreateHospedes < ActiveRecord::Migration[8.0]
  def change
    create_table :hospedes do |t|
      t.string :nome
      t.string :documento
      t.string :email
      t.string :telefone

      t.timestamps
    end
    add_index :hospedes, :email, unique:true 
    add_index :hospedes, :documento, unique:true 
  end
end
