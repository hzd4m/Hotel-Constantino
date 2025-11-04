# Sprint 5 — Exportações: CSV (Home) e PDF (Prawn)

## Objetivo
Atender requisitos de CSV na tela principal e PDF da listagem.

## Tarefas

- CSV (Dashboard): formulário "Exportar CSV" no painel administrativo onde o administrador escolhe filtros (cidade/categoria) antes de gerar o arquivo — usar respond_to :csv com CSV.generate e garantir pelo menos 3 campos exportados.
- PDF (Prawn): botão "Gerar PDF" em uma listagem (ex.: Reservas). Serviço Pdf::ReservasReport que desenha título, tabela com colunas chaves e totalizações.
- Rotas e testes manuais dos downloads.

## Notas de Implementação (2025-11-03)

- Dashboard (`dashboard#index`) agora responde a `format.csv`, gera arquivo com ID/Nome/Cidade/Categoria dos hotéis e envia como download; card "Exportar hotéis (CSV)" solicita filtros obrigatórios (cidade/categoria) antes da geração.
- Validação front-end e back-end impede exportação sem filtros, garantindo recortes específicos.
- A listagem de reservas (`reservas#index`) ganhou botão "Gerar PDF" que respeita filtros ativos, invocando o serviço `Pdf::ReservasReport` (Prawn) com cabeçalho, tabela detalhada e totalização de valor.
- Rota dedicada `export_pdf_reservas_path` adicionada; controle de acesso garante que apenas administradores baixem os relatórios.
- Dependência `prawn` incluída no Gemfile — necessário executar `bundle install` antes de gerar o PDF pela primeira vez.

## Entrega
Downloads funcionam, com conteúdo correto.

## Critérios de Aceite

- Clique → baixa CSV no formato esperado.
- Clique → baixa PDF legível da listagem de consulta.
- Validação impede exportação CSV sem escolher ao menos um filtro (cidade/categoria).