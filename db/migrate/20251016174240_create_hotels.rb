class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.string :nome
      t.string :cidade
      t.string :endereco
      t.string :telefone
      t.string :categoria

      t.timestamps
    end

    add_index :hotels, :nome 
    add_index :hotels, :cidade
  end
end
