# Sprint 4 — UI/UX com Bootstrap

## Objetivo
Garantir layout profissional e usabilidade.

## Tarefas

- Padronizar formulários (form_with + classes Bootstrap), tabelas responsivas e navbar com rotas.
- Componentizar partials: _form, _table, _pagination.
- Feedbacks de validação (exibir erros nos forms).
- Landing pública da rede (welcome/index) com hero, cards e footer.
- Rotas diferenciadas (root público, authenticated_root para dashboard interno).
- Refinar UI existente: revisar cores, espaçamentos, responsividade e consistência dos componentes.
- Preparar arquitetura para multi-perfil (ex.: admin x hóspede) documentando passos técnicos.

## Passo a Passo Operacional

1. **Fixar Bootstrap no importmap**  
	- `./bin/importmap pin bootstrap@5.3.3`  
	- `./bin/importmap pin @popperjs/core`
2. **Criar stylesheet do Bootstrap**  
	- Criar `app/assets/stylesheets/bootstrap.scss` com `@import "bootstrap/scss/bootstrap";`  
	- (Se necessário) `mkdir app/assets/stylesheets/bootstrap`
3. **Carregar CSS no pipeline**  
	- Em `app/assets/stylesheets/application.bootstrap.scss`, adicionar:  
	  `@import "bootstrap"` e `@import "application"` (quando existir outro stylesheet próprio).
4. **Importar JS do Bootstrap**  
	- Em `app/javascript/application.js`, garantir `import "bootstrap"`  
	- Conferir `config/importmap.rb` para os pins gerados.
5. **Atualizar layout principal (`app/views/layouts/application.html.erb`)**  
	- Envolver conteúdo em `<nav class="navbar navbar-expand-lg navbar-dark bg-dark">` com links condicionais.  
	- Adicionar `<div class="container my-4">` para o `yield`.  
	- Renderizar flash messages com classes `alert alert-success`, `alert alert-danger`, etc.
6. **Refatorar partial `_form` de hotéis (`app/views/hotels/_form.html.erb`)**  
	- `form_with(model: hotel, class: "row g-3")`.  
	- Inputs `class: "form-control"` e selects com `class: "form-select"`.  
	- Exibir erros dentro de `<div class="alert alert-danger">`.
7. **Aplicar o mesmo padrão nos formulários de hóspedes e reservas**  
	- `app/views/hospedes/_form.html.erb` e `app/views/reservas/_form.html.erb` reutilizando classes Bootstrap e feedback de erro.
8. **Estilizar filtros e tabelas nas páginas index**  
	- Filtros em `<div class="row gy-2">` com inputs `form-control`.  
	- Tabelas como `<table class="table table-striped table-hover align-middle">`.  
	- Botões com `btn btn-primary`, `btn btn-outline-secondary`, `btn btn-danger`.
9. **Modificar views show**  
	- Usar estruturas `card`, `list-group` e ações com botões Bootstrap.
10. **Configurar paginação Bootstrap**  
 	 - `rails g kaminari:views bootstrap5`.  
 	 - Criar `app/views/shared/_pagination.html.erb` com:  
		`<% if collection.any? %><nav><%= paginate collection, theme: 'bootstrap-5' %></nav><% end %>`  
 	 - Renderizar nas views, ex.: `<%= render "shared/pagination", collection: @hotels %>`.
11. **Criar landing pública (`app/views/welcome/index.html.erb`)**  
	 - Hero com chamada institucional e CTA para login/reservas.  
	 - Cards destacados por categoria de hotel e seção de serviços.  
	 - Footer com contatos, redes sociais e links úteis.
12. **Ajustar rotas**  
	 - `root to: 'welcome#index'` para visitantes não logados.  
	 - `authenticated :user do ...` definindo `authenticated_root` para dashboard interno.  
	 - Validar redirecionamentos após login/logout.
13. **Preparar suporte a múltiplos perfis**  
	 - `rails g migration AddRoleToUsers role:integer` com default `0` (admin).  
	 - Atualizar `User` (`enum role: { admin: 0, guest: 1 }`).  
	 - Seeds com exemplos (`admin@hotel.com`, `guest@hotel.com`).  
	 - Documentar como criar usuários via console (`User.create!` ...).
14. **Controlar acesso de hóspedes às próprias reservas**  
	 - Criar controller dedicado (`Guests::ReservationsController`) restringindo `current_user.reservas`.  
	 - Ajustar views para leitura amigável (cards/list-group).  
	 - Garantir que hóspedes não vejam CRUD completo.
15. **Refinar UI existente**  
	 - Revisar espaçamentos, cores e tipografia nas páginas internas.  
	 - Certificar comportamento mobile (navbar, tabelas responsivas).  
	 - Atualizar partials compartilhadas se necessário.
16. **Documentar e registrar evidências**  
	 - Registrar comandos executados (`bin/rails g migration ...`, `bin/rails db:migrate`).  
	 - Anotar arquivos modificados e screenshots principais.  
	 - Atualizar Daily com instruções de teste (ex.: "Logar como guest@example.com/password").
11. **Adicionar feedback de validação**  
	 - Em cada campo: `class: "form-control #{'is-invalid' if form.object.errors[:nome].present?}"`.  
	 - Abaixo: `<div class="invalid-feedback"><%= form.object.errors[:nome].first %></div>`.
12. **Revisar mensagens flash**  
	 - Mapear `notice` → `alert-success`, `alert` → `alert-danger`, etc.
17. **Testes manuais**  
	 - `rails server` e navegação em desktop + modo móvel (dev tools).  
	 - Exercitar login/logout (admin/guest), fluxo de reservas para hóspedes, filtros e paginação.  
	 - Validar landing pública sem login.  
	 - Ajustar classes conforme necessidade.
18. **Documentar progresso**  
	 - Atualizar o Daily/Sprint com resultados antes de avançar para Sprint 5.  
	 - Incluir instruções de teste e contas de exemplo para QA.

## Entrega
Telas polidas, responsivas, com navegação clara.

## Critérios de Aceite

- Sem estilos quebrados; mobile OK.
- Erros de validação visíveis ao usuário.