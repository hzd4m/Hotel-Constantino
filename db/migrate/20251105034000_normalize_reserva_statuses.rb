class NormalizeReservaStatuses < ActiveRecord::Migration[8.0]
  class MReserva < ApplicationRecord
    self.table_name = "reservas"
  end

  def up
    change_column_default :reservas, :status, "reservada"

    say_with_time "Normalizando valores existentes de status" do
      MReserva.where(status: nil).update_all(status: "reservada")
      MReserva.where(status: "").update_all(status: "reservada")
      MReserva.where(status: "Confirmada").update_all(status: "confirmada")
      MReserva.where(status: "CONFIRMADA").update_all(status: "confirmada")
      MReserva.where(status: "confirmada").update_all(status: "confirmada")
      MReserva.where(status: "Pendente").update_all(status: "reservada")
      MReserva.where(status: "pendente").update_all(status: "reservada")
      MReserva.where(status: "aguardando_confirmacao").update_all(status: "reservada")
      MReserva.where(status: "Cancelada").update_all(status: "cancelada")
      MReserva.where(status: "CANCELADA").update_all(status: "cancelada")
    end

    change_column_null :reservas, :status, false
  end

  def down
    change_column_null :reservas, :status, true

    say_with_time "Restaurando valores de status" do
      MReserva.where(status: "confirmada").update_all(status: "Confirmada")
      MReserva.where(status: "reservada").update_all(status: "Pendente")
      MReserva.where(status: "cancelada").update_all(status: "Cancelada")
    end

    change_column_default :reservas, :status, nil
  end
end
