module QuartosHelper
  def status_chip_for_room(quarto)
    case quarto.status
    when "disponivel" then "status-chip--success"
    when "manutencao" then "status-chip--warning"
    when "ocupado" then "status-chip--danger"
    else "status-chip--default"
    end
  end
end
