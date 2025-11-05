puts "Resetting Hotel Constantino data..."

ActiveRecord::Base.transaction do
  puts "Limpando base de dados..."
  [ReservationRoom, Consumption, ReservationEvent, Reserva, Quarto, RoomType, Hospede, Hotel, User].each(&:destroy_all)

  admin_user = User.create!(
    email: "admin@hotelconstantino.com",
    password: "Password123!",
    password_confirmation: "Password123!",
    role: :admin
  )

  hotels_data = [
    { nome: "Hotel Downtown", cidade: "Sao Paulo", endereco: "Avenida Paulista, 1000", telefone: "11987654321", categoria: "Urbano" },
    { nome: "Hotel Seaside", cidade: "Rio de Janeiro", endereco: "Avenida Atlantica, 500", telefone: "21976543210", categoria: "Praia" },
    { nome: "Hotel Mountain", cidade: "Gramado", endereco: "Rua das Hortensias, 88", telefone: "54985431200", categoria: "Montanha" }
  ]

  hotels = hotels_data.map { |attrs| Hotel.create!(attrs) }
  hotels_by_name = hotels.index_by(&:nome)

  rooms_by_key = {}

  room_type_specs = {
    "Hotel Downtown" => [
      {
        key: :downtown_suite,
        nome: "Suite Master",
        descricao: "Suite espacosa com sala integrada",
        price_cents: 52000,
        amenities: ["Wi-Fi", "Cafe da manha", "Espaco coworking"],
        rooms: [
          { key: :downtown_suite_101, numero: "101", andar: "10", capacidade: 2, descricao: "Vista para a cidade", status: "disponivel", price_cents: 52000 },
          { key: :downtown_suite_102, numero: "102", andar: "10", capacidade: 2, descricao: "Layout twin", status: "disponivel", price_cents: 52000 }
        ]
      },
      {
        key: :downtown_executive,
        nome: "Executivo",
        descricao: "Quarto compacto com escritorio",
        price_cents: 32000,
        amenities: ["Wi-Fi", "Mesa de trabalho", "Cafeteira"],
        rooms: [
          { key: :downtown_executive_103, numero: "103", andar: "08", capacidade: 2, descricao: "Andar executivo", status: "disponivel", price_cents: 32000 },
          { key: :downtown_executive_104, numero: "104", andar: "08", capacidade: 1, descricao: "Studio executivo", status: "disponivel", price_cents: 30000 }
        ]
      }
    ],
    "Hotel Seaside" => [
      {
        key: :seaside_deluxe,
        nome: "Deluxe Vista Mar",
        descricao: "Quartos com varanda frente mar",
        price_cents: 48000,
        amenities: ["Wi-Fi", "Piscina aquecida", "Room service"],
        rooms: [
          { key: :seaside_deluxe_201, numero: "201", andar: "12", capacidade: 3, descricao: "Cama king com sofa cama", status: "ocupado", price_cents: 50000 },
          { key: :seaside_deluxe_202, numero: "202", andar: "12", capacidade: 2, descricao: "Vista direta para o mar", status: "disponivel", price_cents: 48000 }
        ]
      },
      {
        key: :seaside_bungalow,
        nome: "Bungalow Premium",
        descricao: "Unidades externas com jardim privativo",
        price_cents: 54000,
        amenities: ["Wi-Fi", "Banheira", "Espaco gourmet"],
        rooms: [
          { key: :seaside_bungalow_203, numero: "203", andar: "Ground", capacidade: 2, descricao: "Bungalow com rede", status: "disponivel", price_cents: 54000 },
          { key: :seaside_bungalow_204, numero: "204", andar: "Ground", capacidade: 4, descricao: "Bungalow familiar", status: "manutencao", price_cents: 56000 }
        ]
      }
    ],
    "Hotel Mountain" => [
      {
        key: :mountain_chalet,
        nome: "Chale Premium",
        descricao: "Chales com lareira e vista para o vale",
        price_cents: 50000,
        amenities: ["Lareira", "Wi-Fi", "Banheira"],
        rooms: [
          { key: :mountain_chalet_301, numero: "301", andar: "03", capacidade: 2, descricao: "Chale com deck", status: "disponivel", price_cents: 52000 },
          { key: :mountain_chalet_302, numero: "302", andar: "03", capacidade: 2, descricao: "Chale com escritorio", status: "disponivel", price_cents: 50000 }
        ]
      },
      {
        key: :mountain_family,
        nome: "Apartamento Familiar",
        descricao: "Unidades com dois dormitorios",
        price_cents: 36000,
        amenities: ["Cozinha", "Wi-Fi", "Area kids"],
        rooms: [
          { key: :mountain_family_303, numero: "303", andar: "02", capacidade: 4, descricao: "Apartamento com beliche", status: "disponivel", price_cents: 36000 },
          { key: :mountain_family_304, numero: "304", andar: "02", capacidade: 5, descricao: "Apartamento com suite", status: "disponivel", price_cents: 38000 }
        ]
      }
    ]
  }

  room_type_specs.each do |hotel_name, specs|
    hotel = hotels_by_name.fetch(hotel_name)

    specs.each do |spec|
      rooms = spec.delete(:rooms)
      spec.delete(:key)
      room_type = hotel.room_types.create!(spec)

      rooms.each do |room_spec|
        room_key = room_spec.delete(:key)
        quarto = room_type.quartos.create!(room_spec.merge(hotel: hotel))
        rooms_by_key[room_key] = quarto
      end
    end
  end

  hospedes_specs = [
    {
      key: :paulo,
      nome: "Paulo Rezende",
      documento: "11111111111",
      email: "paulo@example.com",
      telefone: "+5511990000001",
      phone_verification_code: "0000",
      phone_verification_sent_at: 3.days.ago,
      phone_verified_at: 2.days.ago
    },
    {
      key: :vera,
      nome: "Vera Martins",
      documento: "22222222222",
      email: "vera@example.com",
      telefone: "+5521980000002",
      phone_verification_code: "0000",
      phone_verification_sent_at: 2.days.ago,
      phone_verified_at: 1.day.ago
    },
    {
      key: :carlos,
      nome: "Carlos Nogueira",
      documento: "33333333333",
      email: "carlos@example.com",
      telefone: "+5554990000003",
      phone_verification_code: "0000",
      phone_verification_sent_at: 5.days.ago,
      phone_verified_at: 4.days.ago
    },
    {
      key: :lucia,
      nome: "Lucia Andrade",
      documento: "44444444444",
      email: "lucia@example.com",
      telefone: "+5521990000004",
      phone_verification_code: "0000",
      phone_verification_sent_at: 1.day.ago
    },
    {
      key: :amanda,
      nome: "Amanda Costa",
      documento: "55555555555",
      email: "amanda@example.com",
      telefone: "+5511980000005",
      phone_verification_code: "0000",
      phone_verification_sent_at: 6.days.ago,
      phone_verified_at: 5.days.ago
    },
    {
      key: :renato,
      nome: "Renato Barros",
      documento: "66666666666",
      email: "renato@example.com",
      telefone: "+5521980000006",
      phone_verification_code: "0000",
      phone_verification_sent_at: 18.hours.ago,
      phone_verified_at: 12.hours.ago
    },
    {
      key: :marina,
      nome: "Marina Albuquerque",
      documento: "77777777777",
      email: "marina@example.com",
      telefone: "+5551990000007",
      phone_verification_code: "0000",
      phone_verification_sent_at: 12.hours.ago
    },
    {
      key: :thiago,
      nome: "Thiago Moreira",
      documento: "88888888888",
      email: "thiago@example.com",
      telefone: "+5511990000008",
      phone_verification_code: "0000",
      phone_verification_sent_at: 4.days.ago,
      phone_verified_at: 3.days.ago
    },
    {
      key: :juliana,
      nome: "Juliana Prado",
      documento: "99999999999",
      email: "juliana@example.com",
      telefone: "+5521990000009",
      phone_verification_code: "0000",
      phone_verification_sent_at: 2.days.ago,
      phone_verified_at: 36.hours.ago
    }
  ]

  hospedes_by_key = hospedes_specs.to_h do |spec|
    key = spec.delete(:key)
    [key, Hospede.create!(spec)]
  end

  guest_users = hospedes_by_key.values.map do |hospede|
    User.create!(
      email: hospede.email,
      password: "Password123!",
      password_confirmation: "Password123!",
      role: :hospede
    )
  end

  reservas_specs = [
    {
      key: :corporate_suite,
      hospede: hospedes_by_key[:paulo],
      hotel: hotels_by_name["Hotel Downtown"],
      data_checkin: Date.current + 3,
      data_checkout: Date.current + 6,
      status: "reservada",
      valor_total: 1560.0,
      quartos: [:downtown_suite_101]
    },
    {
      key: :family_beach,
      hospede: hospedes_by_key[:vera],
      hotel: hotels_by_name["Hotel Seaside"],
      data_checkin: Date.current,
      data_checkout: Date.current + 4,
      status: "checked_in",
      check_in_at: Time.current - 6.hours,
      valor_total: 2180.0,
      quartos: [:seaside_deluxe_201, :seaside_deluxe_202]
    },
    {
      key: :honeymoon,
      hospede: hospedes_by_key[:carlos],
      hotel: hotels_by_name["Hotel Mountain"],
      data_checkin: Date.current - 7,
      data_checkout: Date.current - 3,
      status: "checked_out",
      check_in_at: Time.current - 8.days,
      check_out_at: Time.current - 3.days,
      valor_total: 2890.0,
      quartos: [:mountain_chalet_301]
    },
    {
      key: :pending_confirmation,
      hospede: hospedes_by_key[:lucia],
      hotel: hotels_by_name["Hotel Seaside"],
      data_checkin: Date.current + 10,
      data_checkout: Date.current + 12,
      status: "reservada",
      valor_total: 960.0,
      quartos: [:seaside_bungalow_203]
    },
    {
      key: :executive_confirmed,
      hospede: hospedes_by_key[:paulo],
      hotel: hotels_by_name["Hotel Downtown"],
      data_checkin: Date.current + 1,
      data_checkout: Date.current + 3,
      status: "confirmada",
      confirmed_at: Time.current - 1.day,
      confirmed_by: admin_user,
      valor_total: 980.0,
      quartos: [:downtown_executive_104]
    },
    {
      key: :creative_retreat,
      hospede: hospedes_by_key[:juliana],
      hotel: hotels_by_name["Hotel Downtown"],
      data_checkin: Date.current - 1,
      data_checkout: Date.current + 2,
      status: "checked_in",
      check_in_at: Time.current - 12.hours,
      valor_total: 1780.0,
      quartos: [:downtown_executive_103]
    },
    {
      key: :vip_city_retreat,
      hospede: hospedes_by_key[:amanda],
      hotel: hotels_by_name["Hotel Downtown"],
      data_checkin: Date.current + 7,
      data_checkout: Date.current + 10,
      status: "confirmada",
      confirmed_at: Time.current - 2.days,
      confirmed_by: admin_user,
      valor_total: 2450.0,
      quartos: [:downtown_suite_102]
    },
    {
      key: :beach_anniversary,
      hospede: hospedes_by_key[:renato],
      hotel: hotels_by_name["Hotel Seaside"],
      data_checkin: Date.current + 2,
      data_checkout: Date.current + 5,
      status: "confirmada",
      confirmed_at: Time.current - 6.hours,
      confirmed_by: admin_user,
      valor_total: 2680.0,
      quartos: [:seaside_bungalow_203]
    },
    {
      key: :wellness_retreat,
      hospede: hospedes_by_key[:marina],
      hotel: hotels_by_name["Hotel Mountain"],
      data_checkin: Date.current + 14,
      data_checkout: Date.current + 18,
      status: "reservada",
      valor_total: 1920.0,
      quartos: [:mountain_chalet_302]
    },
    {
      key: :longstay_suite,
      hospede: hospedes_by_key[:thiago],
      hotel: hotels_by_name["Hotel Mountain"],
      data_checkin: Date.current + 21,
      data_checkout: Date.current + 45,
      status: "reservada",
      valor_total: 6120.0,
      quartos: [:mountain_family_304]
    }
  ]

  reservas_by_key = {}

  reservas_specs.each do |spec|
    key = spec.delete(:key)
    quarto_keys = spec.delete(:quartos) || []
    reserva = Reserva.create!(spec)
    quarto_keys.each do |q_key|
      reserva.quartos << rooms_by_key.fetch(q_key)
    end
    reservas_by_key[key] = reserva
  end

  reservas_by_key.each_value do |reserva|
    next unless reserva.checked_in?

    reserva.quartos.update_all(status: "ocupado")
  end

  reservas_by_key.each_value do |reserva|
    next unless reserva.checked_out?

    reserva.quartos.update_all(status: "disponivel")
  end

  Consumption.create!(
    reserva: reservas_by_key[:family_beach],
    title: "Room service jantar",
    notes: "Pedido de massa e sucos naturais",
    requested_by: "guest",
    status: "solicitado",
    amount: 145.0
  )

  Consumption.create!(
    reserva: reservas_by_key[:family_beach],
    title: "Toalhas extras",
    notes: "Entrega realizada pela governanca",
    requested_by: "staff",
    status: "concluido",
    amount: 0
  )

  Consumption.create!(
    reserva: reservas_by_key[:executive_confirmed],
    title: "Traslado aeroporto",
    notes: "Sedan reservado para chegada",
    requested_by: "guest",
    status: "em_atendimento",
    amount: 220.0
  )

  Consumption.create!(
    reserva: reservas_by_key[:creative_retreat],
    title: "Kit boas vindas autoral",
    notes: "Entrega realizada antes do check-in",
    requested_by: "staff",
    status: "concluido",
    amount: 0
  )

  Consumption.create!(
    reserva: reservas_by_key[:beach_anniversary],
    title: "Setup romantico",
    notes: "Petalas, espumante e velas",
    requested_by: "staff",
    status: "concluido",
    amount: 320.0
  )

  Consumption.create!(
    reserva: reservas_by_key[:vip_city_retreat],
    title: "Reserva rooftop",
    notes: "Mesa para duas pessoas as 20h",
    requested_by: "guest",
    status: "solicitado",
    amount: 0
  )

  now = Time.current

  reservas_by_key[:corporate_suite].log_event(
    "corporate_follow_up",
    metadata: {
      "title" => "Email de follow up enviado",
      "status" => "Em andamento",
      "timestamp" => (now - 10.hours).iso8601
    },
    actor: admin_user
  )

  reservas_by_key[:family_beach].log_event(
    "upsell_offer",
    metadata: {
      "title" => "Upgrade para bungalow",
      "status" => "Enviado",
      "timestamp" => (now - 1.day).iso8601
    }
  )

  reservas_by_key[:family_beach].log_event(
    "vip_host_greeting",
    metadata: {
      "title" => "Recepcao com espumante deluxe",
      "status" => "Realizado",
      "timestamp" => (now - 4.hours).iso8601
    }
  )

  reservas_by_key[:honeymoon].log_event(
    "welcome_note",
    metadata: {
      "title" => "Carta de boas vindas",
      "status" => "Entregue",
      "timestamp" => (reservas_by_key[:honeymoon].check_in_at + 2.hours).iso8601
    }
  )

  reservas_by_key[:pending_confirmation].log_event(
    "awaiting_phone_validation",
    metadata: {
      "title" => "Verificacao de telefone pendente",
      "status" => "Aguardando hospede",
      "timestamp" => (now - 2.hours).iso8601
    }
  )

  reservas_by_key[:executive_confirmed].log_event(
    "pre_arrival_email",
    metadata: {
      "title" => "Email de boas vindas enviado",
      "status" => "Completo",
      "timestamp" => (now - 8.hours).iso8601
    },
    actor: admin_user
  )

  reservas_by_key[:creative_retreat].log_event(
    "studio_setup",
    metadata: {
      "title" => "Setup de materiais criativos pronto",
      "status" => "Concluido",
      "timestamp" => (now - 10.hours).iso8601
    },
    actor: admin_user
  )

  reservas_by_key[:creative_retreat].log_event(
    "evening_turndown",
    metadata: {
      "title" => "Turndown com infusao relaxante",
      "status" => "Agendado",
      "timestamp" => (now - 1.hour).iso8601
    }
  )

  reservas_by_key[:vip_city_retreat].log_event(
    "prearrival_form",
    metadata: {
      "title" => "Preferencias de travesseiro registradas",
      "status" => "Concluido",
      "timestamp" => (now - 1.day).iso8601
    }
  )

  reservas_by_key[:beach_anniversary].log_event(
    "celebration_setup",
    metadata: {
      "title" => "Decoracao romantica confirmada",
      "status" => "Confirmado",
      "timestamp" => (now - 3.hours).iso8601
    },
    actor: admin_user
  )

  reservas_by_key[:wellness_retreat].log_event(
    "spa_itinerary_shared",
    metadata: {
      "title" => "Roteiro de spa enviado",
      "status" => "Compartilhado",
      "timestamp" => (now - 30.minutes).iso8601
    }
  )

  reservas_by_key[:longstay_suite].log_event(
    "crm_follow_up",
    metadata: {
      "title" => "Contato comercial sobre long stay",
      "status" => "Agendado",
      "timestamp" => (now - 6.hours).iso8601
    },
    actor: admin_user
  )

  puts "Seeds carregados com sucesso!"
  puts "Hospedes: #{Hospede.count}"
  puts "Hoteis: #{Hotel.count}"
  puts "Tipos de quarto: #{RoomType.count}"
  puts "Quartos: #{Quarto.count}"
  puts "Quartos ocupados: #{Quarto.where(status: 'ocupado').count}"
  puts "Quartos em manutencao: #{Quarto.where(status: 'manutencao').count}"
  puts "Reservas: #{Reserva.count}"
  puts "Reservas em andamento: #{Reserva.checked_in.count}"
  puts "Eventos de CRM: #{ReservationEvent.count}"
  puts "Consumos registrados: #{Consumption.count}"
end
