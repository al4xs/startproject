# Start Project - Gerador de Projetos Flask

## Overview
Este é um script bash avançado que gera automaticamente projetos Flask modulares com diversas funcionalidades opcionais. O script foi completamente refatorado, corrigido e melhorado com código clean e estruturado.

## Funcionalidades Implementadas
- ✅ Geração automática de projetos Flask modulares
- ✅ Suporte a múltiplas rotas (-r)
- ✅ Integração com banco de dados SQLAlchemy (-D)
- ✅ Sistema de autenticação Flask-Login (-l)
- ✅ Configuração Tailwind CSS com duas opções:
  - `--tailwind cdn` - Via CDN (rápido para desenvolvimento)
  - `--tailwind build` - Build system completo (produção)
- ✅ Modo API para endpoints JSON (-api)
- ✅ Documentação completa de parâmetros
- ✅ Interface visual limpa (sem códigos ANSI na saída)
- ✅ Código gerado clean (sem comentários desnecessários)
- ✅ Templates HTML bem estruturados
- ✅ Models simplificados (só id e created_at)
- ✅ Imports organizados (sem duplicatas)
- ✅ Geração automática de requirements.txt
- ✅ Configuração de .gitignore

## Project Architecture
```
startproject.sh               # Script principal
teste_app/                   # Projeto de exemplo gerado
├── main.py                 # Aplicação Flask (clean, sem comentários)
├── routes/                 # Módulos de rotas
│   ├── home/              # Rota home
│   │   ├── templates/     # Templates HTML estruturados
│   │   ├── static/css/    # CSS específico da rota
│   │   └── home.py        # Blueprint clean
│   └── login/             # Sistema de login (se habilitado)
├── models.py              # Models simplificados
├── extensions.py          # Extensões Flask (clean)
├── requirements.txt       # Dependências Python
├── .gitignore            # Arquivos ignorados
├── package.json          # Config npm (se --tailwind build)
├── tailwind.config.js    # Config Tailwind (se --tailwind build)
└── src/input.css         # CSS fonte (se --tailwind build)
```

## Como Usar
```bash
./startproject.sh nome_projeto [opções]

Parâmetros:
-r rotas              # Lista de rotas separadas por vírgula
-D Models             # Models do banco de dados
-api                  # Modo API (retorna JSON)
-l login              # Sistema de autenticação
--tailwind cdn        # Tailwind via CDN
--tailwind build      # Tailwind com build system

Exemplos:
./startproject.sh meuapp -r home,about -D Usuario --tailwind cdn
./startproject.sh webapp -r api,auth -D User,Post --tailwind build
```

## Tailwind CSS Options

### --tailwind cdn
- Adiciona `<script src="https://cdn.tailwindcss.com"></script>`
- Pronto para usar imediatamente
- Ideal para desenvolvimento rápido

### --tailwind build  
- Cria package.json com scripts npm
- Configura tailwind.config.js
- Gera src/input.css com @tailwind directives
- Scripts disponíveis:
  - `npm run build` - Gera CSS minificado
  - `npm run dev` - Watch mode para desenvolvimento

## User Preferences
- Linguagem: Português brasileiro
- Framework: Flask com arquitetura modular
- Styling: Tailwind CSS (cdn ou build)
- Database: SQLAlchemy com SQLite
- Code Style: Clean code sem comentários desnecessários
- Deployment: Configurado para Replit autoscale

## Recent Changes
- 2025-09-24: Inicial import e descoberta do script
- 2025-09-24: Correção completa de bugs bash e códigos ANSI
- 2025-09-24: Mudança de -tailwind para --tailwind com opções
- 2025-09-24: Implementação completa do Tailwind build
- 2025-09-24: Refatoração para clean code (sem comentários)
- 2025-09-24: Estruturação do HTML (não mais "tudo junto")
- 2025-09-24: Simplificação dos models (só id + created_at)
- 2025-09-24: Correção dos imports duplicados
- 2025-09-24: Melhoria da interface visual
- 2025-09-24: Teste completo e configuração de deployment
