# Relatório de Implementações - Hotel Constantino

## a) Kaminari – Paginação das listagens
- Controladores com paginação ativa:
  - `HotelsController#index` usa `page(params[:page]).per(10)` para segmentar os hotéis filtrados.
  - `RoomTypesController#index`, `QuartosController#index`, `HospedesController#index` e `ReservasController#index` seguem o mesmo padrão de paginação com limites adequados para cada recurso.
- A navegação entre páginas é renderizada pelo componente compartilhado `app/views/shared/_pagination.html.erb`, que gera os links "Anterior/Próxima" e a janela de páginas usando os helpers do Kaminari.
- As views principais (`app/views/hotels/index.html.erb`, `app/views/hospedes/index.html.erb`, `app/views/reservas/index.html.erb` etc.) chamam a parcial de paginação após as tabelas de resultados.

## b) Devise – Autenticação no sistema
- As rotas de autenticação estão configuradas com `devise_for :users`, com redirecionamentos separados para usuários autenticados e visitantes.
- O modelo `User` inclui os módulos padrão do Devise (database_authenticatable, registerable, recoverable, rememberable e validatable) e define perfis `admin` e `hospede`.
- Controladores principais exigem login com `before_action :authenticate_user!`, garantindo que apenas usuários autenticados acessem as áreas administrativas.
- As telas de login/registro do Devise foram personalizadas com Bootstrap na pasta `app/views/devise/`.

## c) Twitter Bootstrap – Layout responsivo
- O layout global (`app/views/layouts/application.html.erb`) importa o CSS do Bootstrap 5.3 via CDN e os ícones oficiais, além de usar classes utilitárias (`container`, `btn`, `row`, `col`, etc.) em toda a navegação.
- As páginas CRUD (`app/views/hotels/index.html.erb`, `app/views/hospedes/index.html.erb`, `app/views/reservas/index.html.erb`) combinam componentes Bootstrap (botões, tabelas responsivas, cards) com estilos próprios para entregar a identidade visual solicitada.
- Componentes compartilhados, como `app/views/shared/_export_controls.html.erb`, utilizam `btn-group`, `form-select` e badges do Bootstrap para manter consistência visual nas ações.

## d) Prawn – Geração de relatórios em PDF
- Cada recurso possui um serviço dedicado em `app/services/pdf/*_report.rb` responsável por montar tabelas e cabeçalhos com Prawn (`Prawn::Document`).
- Os controladores `HotelsController`, `HospedesController` e `ReservasController` respondem ao formato `pdf`, instanciando o serviço correspondente e enviando o arquivo gerado ao usuário.
- O dashboard administrativo orienta o usuário sobre a exportação em PDF ao lado do CSV, permitindo a escolha do formato.

## e) Validações e Associações entre modelos
- `Hotel` relaciona-se com `Reserva`, `Quarto` e `RoomType`, além de exigir presença de nome, cidade, endereço, telefone e categoria.
- `Hospede` garante unicidade de documento e e-mail, valida formato de e-mail e controla o fluxo de verificação telefônica antes de confirmar reservas.
- `Reserva` agrega `Hotel`, `Hospede`, `Quarto`, eventos e consumos, valida datas/status/valor e encapsula transições de estado com callbacks.
- `Quarto` e `RoomType` definem enums de status, relações dependentes e validações numéricas, reforçando a integridade dos cadastros.

## f) Exportação CSV na tela principal
- A "Central de exportação" do dashboard (`app/views/dashboard/index.html.erb`) permite escolher o recurso (Hotéis, Hóspedes, Reservas), o formato (CSV ou PDF) e o escopo (filtros ou todos).
- Cada controlador implementa o endpoint `export` com geração de CSV seguindo a estrutura solicitada, incluindo cabeçalhos e colunas como `ID`, `Nome`, `Cidade` (além de outros campos relevantes).
- A rotina que escreve o CSV acrescenta os registros linha a linha no formato `id, campo1, campo2...`, garantindo ao menos três colunas de dados.
- O componente compartilhado `shared/_export_controls` reaproveita botões Bootstrap para acionar as exportações diretamente das listagens, reforçando a funcionalidade nas telas CRUD.
