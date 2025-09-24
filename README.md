# Start Project - Gerador de Projetos Flask

## Overview
Este é um script bash avançado que gera automaticamente projetos Flask modulares com diversas funcionalidades opcionais. O script foi completamente refatorado, corrigido e melhorado.

## Funcionalidades Implementadas
- ✅ Geração automática de projetos Flask modulares
- ✅ Suporte a múltiplas rotas (-r)
- ✅ Integração com banco de dados SQLAlchemy (-D)
- ✅ Sistema de autenticação Flask-Login (-l)
- ✅ Configuração automática do Tailwind CSS (-tailwind)
- ✅ Modo API para endpoints JSON (-api)
- ✅ Documentação completa de parâmetros
- ✅ Interface visual melhorada com ícones e cores
- ✅ Geração automática de requirements.txt
- ✅ Configuração de .gitignore
- ✅ Templates responsivos com Tailwind CSS

## Project Architecture
```
startproject.sh               # Script principal
teste_app/                   # Projeto de exemplo gerado
├── main.py                 # Aplicação Flask principal
├── routes/                 # Módulos de rotas
│   ├── home/              # Rota home
│   ├── about/             # Rota about  
│   ├── contact/           # Rota contact
│   └── login/             # Rota de login
├── models.py              # Models do banco de dados
├── extensions.py          # Extensões Flask
├── requirements.txt       # Dependências Python
└── .gitignore            # Arquivos ignorados pelo Git
```

## Como Usar
```bash
./startproject.sh nome_projeto [opções]

Opções:
-r rotas           # Rotas separadas por vírgula
-D Models          # Models do banco de dados
-api               # Modo API (JSON)
-l login           # Sistema de autenticação
-tailwind          # Configuração Tailwind CSS

Exemplo:
./startproject.sh meuapp -r home,about -D Usuario -tailwind
```

## User Preferences
- Linguagem: Português brasileiro
- Framework: Flask com arquitetura modular
- Styling: Tailwind CSS para projetos modernos
- Database: SQLAlchemy com SQLite
- Deployment: Configurado para Replit autoscale

## Recent Changes
- 2025-09-24: Inicial import e descoberta do script
- 2025-09-24: Correção completa de bugs de compatibilidade bash
- 2025-09-24: Implementação do parâmetro -tailwind
- 2025-09-24: Refatoração para clean code
- 2025-09-24: Melhoria da interface visual
- 2025-09-24: Teste completo com projeto exemplo
- 2025-09-24: Configuração de workflow e deployment
