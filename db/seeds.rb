# Limpar dados existentes (opcional)
Reserva.destroy_all
Hospede.destroy_all
Hotel.destroy_all
User.destroy_all

# Criar ~15 hotéis
hotels = Hotel.create!([
  { nome: 'Hotel Central', cidade: 'São Paulo', endereco: 'Rua A, 123', telefone: '11-99999-0001', categoria: 'Luxo' },
  { nome: 'Hotel Praia', cidade: 'Rio de Janeiro', endereco: 'Av. B, 456', telefone: '21-99999-0002', categoria: 'Praia' },
  { nome: 'Hotel Montanha', cidade: 'Gramado', endereco: 'Rua C, 789', telefone: '54-99999-0003', categoria: 'Montanha' },
  { nome: 'Hotel Urbano', cidade: 'Belo Horizonte', endereco: 'Av. D, 101', telefone: '31-99999-0004', categoria: 'Urbano' },
  { nome: 'Hotel Campo', cidade: 'Brasília', endereco: 'Rua E, 202', telefone: '61-99999-0005', categoria: 'Campo' },
  { nome: 'Hotel Sol', cidade: 'Fortaleza', endereco: 'Rua F, 303', telefone: '85-99999-0006', categoria: 'Praia' },
  { nome: 'Hotel Lua', cidade: 'Recife', endereco: 'Av. G, 404', telefone: '81-99999-0007', categoria: 'Luxo' },
  { nome: 'Hotel Estrela', cidade: 'Curitiba', endereco: 'Rua H, 505', telefone: '41-99999-0008', categoria: 'Montanha' },
  { nome: 'Hotel Mar', cidade: 'Natal', endereco: 'Av. I, 606', telefone: '84-99999-0009', categoria: 'Praia' },
  { nome: 'Hotel Jardim', cidade: 'Porto Alegre', endereco: 'Rua J, 707', telefone: '51-99999-0010', categoria: 'Campo' },
  { nome: 'Hotel Horizonte', cidade: 'Florianópolis', endereco: 'Rua K, 808', telefone: '48-99999-0011', categoria: 'Urbano' },
  { nome: 'Hotel Vale', cidade: 'Joinville', endereco: 'Av. L, 909', telefone: '47-99999-0012', categoria: 'Montanha' },
  { nome: 'Hotel Brisa', cidade: 'São Luís', endereco: 'Rua M, 1010', telefone: '98-99999-0013', categoria: 'Praia' },
  { nome: 'Hotel Pico', cidade: 'Campos do Jordão', endereco: 'Rua N, 1111', telefone: '12-99999-0014', categoria: 'Montanha' },
  { nome: 'Hotel Solarium', cidade: 'Búzios', endereco: 'Av. O, 1212', telefone: '22-99999-0015', categoria: 'Praia' }
])

# Criar ~20 hóspedes
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
  { nome: 'Sofia Ferreira', documento: '12345678910', email: 'sofia@example.com', telefone: '61-88888-0010' },
  { nome: 'Thiago Souza', documento: '12345678911', email: 'thiago@example.com', telefone: '11-88888-0011' },
  { nome: 'Camila Rocha', documento: '12345678912', email: 'camila@example.com', telefone: '21-88888-0012' },
  { nome: 'Marcos Lima', documento: '12345678913', email: 'marcos@example.com', telefone: '54-88888-0013' },
  { nome: 'Patrícia Santos', documento: '12345678914', email: 'patricia@example.com', telefone: '31-88888-0014' },
  { nome: 'Rafael Costa', documento: '12345678915', email: 'rafael@example.com', telefone: '61-88888-0015' },
  { nome: 'Aline Pereira', documento: '12345678916', email: 'aline@example.com', telefone: '11-88888-0016' },
  { nome: 'Diego Alves', documento: '12345678917', email: 'diego@example.com', telefone: '21-88888-0017' },
  { nome: 'Vanessa Mendes', documento: '12345678918', email: 'vanessa@example.com', telefone: '54-88888-0018' },
  { nome: 'Felipe Rocha', documento: '12345678919', email: 'felipe@example.com', telefone: '31-88888-0019' },
  { nome: 'Isabela Ferreira', documento: '12345678920', email: 'isabela@example.com', telefone: '61-88888-0020' }
])

# Criar ~20 reservas coerentes
20.times do |i|
  Reserva.create!(
    data_checkin: Date.today + (i+1),
    data_checkout: Date.today + (i+2),
    status: ['Confirmada', 'Pendente', 'Cancelada'].sample,
    valor_total: (300 + i*50).to_f,
    hotel: hotels[i % hotels.size],
    hospede: hospedes[i % hospedes.size]
  )
end

User.create!(email: 'admin@hotelconstantino.com', password: '123456', password_confirmation: '123456', role: :admin)
User.create!(email: 'joao@example.com', password: '123456', password_confirmation: '123456', role: :hospede)

puts "Seeds carregados com sucesso! #{Hotel.count} hotéis, #{Hospede.count} hóspedes, #{Reserva.count} reservas e #{User.count} usuários."
