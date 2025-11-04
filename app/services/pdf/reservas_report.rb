# frozen_string_literal: true

require "prawn"
require "prawn/table"

module Pdf
  class ReservasReport
    include ActionView::Helpers::NumberHelper

    HEADER_ROW = ["#", "Hóspede", "Hotel", "Check-in", "Check-out", "Status", "Valor"].freeze
    TABLE_ROW_COLORS = %w[F9FAFB FFFFFF].freeze

    def initialize(reservas)
      @reservas = Array(reservas)
    end

    def render
      Prawn::Document.new(page_size: "A4", margin: 36) do |pdf|
        build_header(pdf)
        build_table(pdf)
        build_footer(pdf)
      end.render
    end

    private

    attr_reader :reservas

    def build_header(pdf)
      pdf.text "Relatório de Reservas", size: 20, style: :bold
      pdf.move_down 6
      pdf.text "Emitido em #{I18n.l(Time.current, format: :long)}", size: 10, color: "555555"
      pdf.move_down 18
    end

    def build_table(pdf)
      pdf.table(table_data, header: true, row_colors: TABLE_ROW_COLORS, cell_style: { size: 10, padding: [6, 8, 6, 8] }) do |table|
        table.row(0).font_style = :bold
        table.row(0).background_color = "1F2937"
        table.row(0).text_color = "FFFFFF"
        table.columns(0).align = :center
        table.columns(3..5).align = :center
        table.columns(6).align = :right
      end
    end

    def build_footer(pdf)
      pdf.move_down 18
      pdf.text "Total de reservas: #{reservas.count}", style: :bold
      pdf.text "Valor agregado: #{number_to_currency(total_valor, unit: "R$", separator: ",", delimiter: ".")}", style: :bold
    end

    def table_data
      [HEADER_ROW] + reservas.each_with_index.map do |reserva, index|
        [
          index + 1,
          reserva.hospede&.nome || "-",
          reserva.hotel&.nome || "-",
          format_date(reserva.data_checkin),
          format_date(reserva.data_checkout),
          reserva.status,
          number_to_currency(reserva.valor_total.to_f, unit: "R$", separator: ",", delimiter: ".")
        ]
      end
    end

    def format_date(date)
      return "-" if date.blank?

      I18n.l(date)
    end

    def total_valor
      reservas.sum { |reserva| reserva.valor_total.to_f }
    end
  end
end
