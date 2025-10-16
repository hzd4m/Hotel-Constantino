# Sprint 5 — Exportações: CSV (Home) e PDF (Prawn)

## Objetivo
Atender requisitos de CSV na tela principal e PDF da listagem.

## Tarefas

- CSV (Home): botão "Exportar CSV" na página inicial (por ex., exportar id, nome, cidade de hotéis ou id, hóspede, idade se preferir hóspedes — garanta "pelo menos 3 campos"). Gerar arquivo via respond_to :csv usando CSV.generate.
- PDF (Prawn): botão "Gerar PDF" em uma listagem (ex.: Reservas). Serviço Pdf::ReservasReport que desenha título, tabela com colunas chaves e totalizações.
- Rotas e testes manuais dos downloads.

## Entrega
Downloads funcionam, com conteúdo correto.

## Critérios de Aceite

- Clique → baixa CSV no formato esperado.
- Clique → baixa PDF legível da listagem de consulta.