# frozen_string_literal: true

require "prawn"
require "prawn/table"

module Pdf
  class HotelsReport
    HEADER_ROW = ["#", "Hotel", "Cidade", "Categoria", "Telefone"].freeze
    TABLE_ROW_COLORS = %w[F9FAFB FFFFFF].freeze

    def initialize(hotels)
      @hotels = Array(hotels)
    end

    def render
      Prawn::Document.new(page_size: "A4", margin: 36) do |pdf|
        build_header(pdf)
        build_table(pdf)
        build_footer(pdf)
      end.render
    end

    private

    attr_reader :hotels

    def build_header(pdf)
      pdf.text "Relatório de Hotéis", size: 20, style: :bold
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
        table.columns(2..4).align = :center
      end
    end

    def build_footer(pdf)
      pdf.move_down 18
      pdf.text "Total de hotéis: #{hotels.count}", style: :bold
    end

    def table_data
      [HEADER_ROW] + hotels.each_with_index.map do |hotel, index|
        [
          index + 1,
          hotel.nome,
          hotel.cidade.presence || "-",
          hotel.categoria.presence || "-",
          hotel.telefone.presence || "-"
        ]
      end
    end
  end
end
