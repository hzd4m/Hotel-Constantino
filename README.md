# Hotel Constantino

Sistema de Hotelaria em Ruby on Rails para a disciplina de Programação Web III. Desenvolvido por Hzd4m e Alex Soares.

O sistema contempla as entidades Hotel, Reserva e Hóspede, com CRUD completo, validações/associações, autenticação (Devise), paginações (Kaminari), layout com Bootstrap, exportação CSV (na tela principal) e geração de PDF (Prawn).

## Visão Geral

Este projeto implementa um sistema de gestão hoteleira com as seguintes funcionalidades principais:

- **CRUD Completo**: Para Hoteis, Hóspedes e Reservas.
- **Autenticação**: Usando Devise para login e proteção de rotas.
- **Paginação**: Com Kaminari nas listagens.
- **UI/UX**: Layout responsivo com Bootstrap.
- **Exportações**: CSV na página inicial e PDF nas listagens de reservas.
- **Validações e Associações**: Modelos robustos com regras de negócio.

O desenvolvimento é organizado em sprints enxutas, documentadas em `/docs/sprints/`.

## Requisitos

- Ruby 3.0+
- Rails 7.0+
- SQLite (ambiente local)
- PostgreSQL (produção na Render via `DATABASE_URL`)
- Gems principais: devise, kaminari, bootstrap, prawn, csv

## Como Rodar Localmente

1. Clone o repositório e navegue para o diretório do projeto.

2. Instale as dependências:
   ```
   bundle install
   ```

3. Configure o banco de dados:
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Inicie o servidor:
   ```
   rails server
   ```

5. Acesse em `http://localhost:3000`.

## Como Fazer Seed

Para popular o banco com dados de exemplo (~5 hotéis, ~10 hóspedes, ~10 reservas):
```
rails db:seed
```

### Seed em containers

Com o stack Docker ativo:
```
docker compose run --rm web ./bin/rails db:seed
```

## Executar com Docker

1. Copie o arquivo `.env.docker.example` para `.env.docker` e preencha o valor de `RAILS_MASTER_KEY` (use a chave em `config/master.key`).
2. Faça o build da imagem e suba os serviços:
   ```
   docker compose up --build
   ```
3. A aplicação ficará disponível em `http://localhost:3000`.

Os volumes nomeados preservam `storage/`, `db/` e a pasta `tmp/` entre reinicializações. Ajuste `APP_HOST` em `.env.docker` se precisar gerar links externos a partir do container. Se desejar outro banco, sobrescreva o `DATABASE_URL` (por padrão ele aponta para `sqlite3:/rails/db/production.sqlite3`).

## Deploy na Render (Docker)

1. Crie um serviço *Web Service* com ambiente **Docker** apontando para este repositório.
2. Defina as variáveis de ambiente obrigatórias:
   - `RAILS_MASTER_KEY` (obrigatória, disponível em `config/master.key`).
   - `APP_HOST` (ex.: `hotel-constantino.onrender.com`).
   - `FORCE_SSL` (`true` para HTTPS em produção).
3. Crie um banco PostgreSQL na Render e conecte `DATABASE_URL` ao *connection string* do banco.
4. (Opcional) Use o `render.yaml` incluso para provisionar serviço + banco automaticamente.

O Dockerfile já instala as dependências do `pg`, prepara assets e roda migrations via `bin/docker-entrypoint` (`rails db:prepare`) durante o boot do container.

## Credenciais Demo

- Usuário Admin: email: admin@example.com, senha: password (implementado na Sprint 2).
- Para outras sprints, credenciais serão atualizadas conforme implementação.

## Endpoints de Exportação

- **CSV na Home**: Botão "Exportar CSV" na página inicial, exporta dados de hotéis (id, nome, cidade).
- **PDF de Reservas**: Botão "Gerar PDF" na listagem de reservas, gera relatório com título, tabela e totalizações.

## Sprints

O projeto é desenvolvido em sprints:

- [Sprint 1 - Modelagem & Migrations](docs/sprints/sprint1.md)
- [Sprint 2 - Autenticação (Devise) & Autorização](docs/sprints/sprint2.md)
- [Sprint 3 - CRUD Completo](docs/sprints/sprint3.md)
- [Sprint 4 - UI/UX com Bootstrap](docs/sprints/sprint4.md)
- [Sprint 5 - Exportações: CSV e PDF](docs/sprints/sprint5.md)
- [Sprint 7 - Deploy & Documentação](docs/sprints/sprint7.md)
- [Sprint 8 - Ensaio de Apresentação](docs/sprints/sprint8.md)

## Contribuição

Este é um projeto acadêmico. Para dúvidas, consulte os documentos em `/docs/sprints/`.
