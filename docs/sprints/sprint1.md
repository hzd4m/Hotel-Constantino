# Sprint 1 — Modelagem & Migrations

## Objetivo
Implementar modelos, associações e validações.

## Modelos

- **Hotel** (campos: nome, cidade, endereco, telefone, categoria…)
- **Hospede** (campos: nome, documento, email, telefone…)
- **Reserva** (campos: data_checkin, data_checkout, status, valor_total, hotel_id, hospede_id)

## Associações

- Hotel has_many :reservas
- Hospede has_many :reservas
- Reserva belongs_to :hotel e belongs_to :hospede

## Validações (exemplos)

- Presença: nomes, datas, referências.
- Consistência: data_checkout > data_checkin.
- Formato: e-mail de hóspede, telefone.

## Seeds

db/seeds.rb com ~5 hotéis, ~10 hóspedes e ~10 reservas coerentes.

## Entrega
Migrations + models + seeds executando.

## Critérios de Aceite

- rails db:migrate e rails db:seed sem erros.
- Associação e validações testadas no console (rails console).