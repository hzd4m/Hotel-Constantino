# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ruby
# filepath: db/seeds.rb

# Limpar dados existentes (opcional, para re-executar seeds)
Hotel.destroy_all
Hospede.destroy_all
Reserva.destroy_all

# Criar ~5 hotéis
hotels = Hotel.create!([
  { nome: 'Hotel Central', cidade: 'São Paulo', endereco: 'Rua A, 123', telefone: '11-99999-0001', categoria: 'Luxo' },
  { nome: 'Hotel Praia', cidade: 'Rio de Janeiro', endereco: 'Av. B, 456', telefone: '21-99999-0002', categoria: 'Praia' },
  { nome: 'Hotel Montanha', cidade: 'Gramado', endereco: 'Rua C, 789', telefone: '54-99999-0003', categoria: 'Montanha' },
  { nome: 'Hotel Urbano', cidade: 'Belo Horizonte', endereco: 'Av. D, 101', telefone: '31-99999-0004', categoria: 'Urbano' },
  { nome: 'Hotel Campo', cidade: 'Brasília', endereco: 'Rua E, 202', telefone: '61-99999-0005', categoria: 'Campo' }
])

# Criar ~10 hóspedes
hospedes = Hospede.create!([
  { nome: 'João Silva', documento: '12345678901', email: 'joao@example.com', telefone: '11-88888-0001' },
  { nome: 'Maria Oliveira', documento: '12345678902', email: 'maria@example.com', telefone: '21-88888-0002' },
  { nome: 'Pedro Santos', documento: '12345678903', email: 'pedro@example.com', telefone: '54-88888-0003' },
  { nome: 'Ana Costa', documento: '12345678904', email: 'ana@example.com', telefone: '31-88888-0004' },
  { nome: 'Carlos Lima', documento: '12345678905', email: 'carlos@example.com', telefone: '61-88888-0005' },
  { nome: 'Fernanda Rocha', documento: '12345678906', email: 'fernanda@example.com', telefone: '11-88888-0006' },
  { nome: 'Lucas Pereira', documento: '12345678907', email: 'lucas@example.com', telefone: '21-88888-0007' },
  { nome: 'Juliana Alves', documento: '12345678908', email: 'juliana@example.com', telefone: '54-88888-0008' },
  { nome: 'Roberto Mendes', documento: '12345678909', email: 'roberto@example.com', telefone: '31-88888-0009' },
  { nome: 'Sofia Ferreira', documento: '12345678910', email: 'sofia@example.com', telefone: '61-88888-0010' }
])

# Criar ~10 reservas coerentes (associando a hotéis e hóspedes existentes)
Reserva.create!([
  { data_checkin: Date.today + 1, data_checkout: Date.today + 3, status: 'Confirmada', valor_total: 300.00, hotel: hotels[0], hospede: hospedes[0] },
  { data_checkin: Date.today + 2, data_checkout: Date.today + 5, status: 'Pendente', valor_total: 500.00, hotel: hotels[1], hospede: hospedes[1] },
  { data_checkin: Date.today + 3, data_checkout: Date.today + 7, status: 'Confirmada', valor_total: 700.00, hotel: hotels[2], hospede: hospedes[2] },
  { data_checkin: Date.today + 4, data_checkout: Date.today + 6, status: 'Cancelada', valor_total: 400.00, hotel: hotels[3], hospede: hospedes[3] },
  { data_checkin: Date.today + 5, data_checkout: Date.today + 8, status: 'Confirmada', valor_total: 600.00, hotel: hotels[4], hospede: hospedes[4] },
  { data_checkin: Date.today + 6, data_checkout: Date.today + 9, status: 'Pendente', valor_total: 450.00, hotel: hotels[0], hospede: hospedes[5] },
  { data_checkin: Date.today + 7, data_checkout: Date.today + 10, status: 'Confirmada', valor_total: 550.00, hotel: hotels[1], hospede: hospedes[6] },
  { data_checkin: Date.today + 8, data_checkout: Date.today + 11, status: 'Cancelada', valor_total: 350.00, hotel: hotels[2], hospede: hospedes[7] },
  { data_checkin: Date.today + 9, data_checkout: Date.today + 12, status: 'Confirmada', valor_total: 800.00, hotel: hotels[3], hospede: hospedes[8] },
  { data_checkin: Date.today + 10, data_checkout: Date.today + 13, status: 'Pendente', valor_total: 650.00, hotel: hotels[4], hospede: hospedes[9] }
])

puts "Seeds carregados com sucesso! #{Hotel.count} hotéis, #{Hospede.count} hóspedes, #{Reserva.count} reservas."