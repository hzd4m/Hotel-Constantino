# Sprint 2 — Autenticação (Devise) & Autorização Enxuta

## Objetivo
Proteger o sistema; permitir login.

## Tarefas

- Instalar Devise e gerar User com campos básicos.
- Restringir CRUD a usuários autenticados (before_action authenticate_user!).
- (Opcional) Roles simples via enum (role: [:admin, :editor]) para travar destruição/edição.

## Entrega
Fluxo de cadastro/login funcional; links de entrar/sair no layout.

## Critérios de Aceite

- Rotas de devise ativas; telas de login/registro funcionam.
- Acesso a rotas de CRUD somente logado.