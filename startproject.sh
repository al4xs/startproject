#!/usr/bin/env bash

# Cores e símbolos para saída bonita
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
RESET="\033[0m"

# Símbolos Unicode
CHECKMARK="✅"
ROCKET="🚀"                                                 GEAR="⚙️"
DATABASE="🗄️"
LOCK="🔐"
PAINT="🎨"
WARNING="⚠️"
ERROR="❌"

show_help() {
    echo ""
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}${BLUE}║${RESET}  ${ROCKET} ${BOLD}${GREEN}GERADOR DE PROJETOS FLASK MODULAR${RESET}                             ${BOLD}${BLUE}║${RESET}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${BOLD}${CYAN}USO:${RESET}"
    echo -e "  ${YELLOW}./startproject.sh${RESET} ${GREEN}<nome_do_projeto>${RESET} [opções]"
    echo ""
    echo -e "${BOLD}${CYAN}PARÂMETROS:${RESET}"
    echo -e "  ${GREEN}<nome_do_projeto>${RESET}      Nome do diretório do projeto (${BOLD}obrigatório${RESET})"
    echo ""
    echo -e "${BOLD}${CYAN}OPÇÕES:${RESET}"
    echo -e "  ${GREEN}-r${RESET} <rotas>             Lista de rotas separadas por vírgula"
    echo -e "                          ${CYAN}Default: home${RESET}"
    echo -e "                          ${CYAN}Exemplo: -r home,about,contact${RESET}"
    echo ""
    echo -e "  ${GREEN}-D${RESET} <Models>            Ativa banco de dados SQLite com models"
    echo -e "                          ${CYAN}Exemplo: -D User,Post,Comment${RESET}"
    echo ""
    echo -e "  ${GREEN}--api${RESET}                   Cria projeto em modo API (retorna JSON)"
    echo -e "                          ${CYAN}Sem templates HTML, apenas endpoints JSON${RESET}"
    echo ""
    echo -e "  ${GREEN}-l, --login${RESET} <rota>      Adiciona sistema de autenticação Flask-Login"
    echo -e "                          ${CYAN}Requer -D com pelo menos um model${RESET}"
    echo -e "                          ${CYAN}Exemplo: -l login ou --login login${RESET}"
    echo ""
    echo -e "  ${GREEN}--tailwind${RESET} <tipo>      Configura Tailwind CSS"
    echo -e "                          ${CYAN}cdn${RESET}   - Via CDN (desenvolvimento rápido)"
    echo -e "                          ${CYAN}build${RESET} - Com build system (produção)"
    echo ""
    echo -e "  ${GREEN}-h, --help${RESET}              Mostra esta mensagem de ajuda"
    echo ""
    echo -e "${BOLD}${CYAN}EXEMPLOS DE USO:${RESET}"
    echo ""
    echo -e "  ${PAINT} ${YELLOW}Projeto simples:${RESET}"
    echo -e "     ./startproject.sh meuapp"
    echo -e "     ${CYAN}→ Cria projeto com rota home básica${RESET}"
    echo ""
    echo -e "  ${PAINT} ${YELLOW}Site com múltiplas páginas:${RESET}"
    echo -e "     ./startproject.sh meusite -r home,about,contact"
    echo -e "     ${CYAN}→ Cria 3 rotas com templates HTML${RESET}"
    echo ""
    echo -e "  ${DATABASE} ${YELLOW}Projeto com banco de dados:${RESET}"
    echo -e "     ./startproject.sh webapp -r home,produtos -D User,Product"
    echo -e "     ${CYAN}→ Cria projeto com SQLite e 2 models${RESET}"
    echo ""
    echo -e "  ${LOCK} ${YELLOW}App com autenticação:${RESET}"
    echo -e "     ./startproject.sh authapp -r home,dashboard -D User --login login"
    echo -e "     ${CYAN}→ Sistema completo de login/logout${RESET}"
    echo ""
    echo -e "  ${PAINT} ${YELLOW}Site moderno com Tailwind:${RESET}"
    echo -e "     ./startproject.sh modernapp -r home,about -D User --tailwind cdn"
    echo -e "     ${CYAN}→ Design responsivo com Tailwind CSS via CDN${RESET}"
    echo ""
    echo -e "  ${GEAR} ${YELLOW}API REST:${RESET}"
    echo -e "     ./startproject.sh myapi -r api,users -D User,Post --api"
    echo -e "     ${CYAN}→ Endpoints JSON para consumo de API${RESET}"
    echo ""
    echo -e "  ${ROCKET} ${YELLOW}Projeto completo (produção):${RESET}"
    echo -e "     ./startproject.sh fullapp -r home,dashboard,profile -D User,Post --login login --tailwind build"
    echo -e "     ${CYAN}→ App completo com auth, DB e Tailwind otimizado${RESET}"
    echo ""
    echo -e "${BOLD}${CYAN}ESTRUTURA DO PROJETO GERADO:${RESET}"
    echo -e "  projeto/"
    echo -e "  ├── main.py              ${CYAN}# Aplicação Flask principal${RESET}"
    echo -e "  ├── routes/              ${CYAN}# Módulos de rotas (blueprints)${RESET}"
    echo -e "  │   ├── home/            ${CYAN}# Exemplo de rota${RESET}"
    echo -e "  │   │   ├── templates/   ${CYAN}# Templates HTML da rota${RESET}"
    echo -e "  │   │   └── home.py      ${CYAN}# Blueprint da rota${RESET}"
    echo -e "  ├── models.py            ${CYAN}# Models do banco (se -D)${RESET}"
    echo -e "  └── extensions.py        ${CYAN}# Extensões Flask (se -D)${RESET}"
    echo ""
    echo -e "${BOLD}${CYAN}APÓS GERAR O PROJETO:${RESET}"
    echo -e "  ${YELLOW}1.${RESET} cd seu_projeto"
    echo -e "  ${YELLOW}2.${RESET} python3 main.py"
    echo -e "  ${YELLOW}3.${RESET} Acesse: ${GREEN}http://localhost:5000${RESET}"
    echo ""
    exit 0
}

if [ -z "$1" ]; then
    show_help
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

PROJETO=$(realpath "$1")
shift

ROTAS=("home")
MODELS=()
DB=0
API=0
LOGIN=0
LOGIN_NAME=""
TAILWIND=0
TAILWIND_TYPE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -r)
            if [ -n "$2" ]; then
                IFS=',' read -r -a ROTAS <<< "$2"
                for i in "${!ROTAS[@]}"; do
                    ROTAS[$i]=$(echo "${ROTAS[$i]}" | xargs)
                done
                shift 2
            else
                echo -e "${RED}${ERROR} Erro: use -r seguido dos nomes das rotas (ex: -r home,login)${RESET}"
                exit 1
            fi
            ;;
        -D)
            if [ -n "$2" ]; then
                DB=1
                IFS=',' read -r -a MODELS <<< "$2"
                for i in "${!MODELS[@]}"; do
                    MODELS[$i]=$(echo "${MODELS[$i]}" | xargs)
                done
                shift 2
            else
                echo -e "${RED}${ERROR} Erro: use -D seguido do(s) nome(s) das Models (ex: -D Usuario,Post)${RESET}"
                exit 1
            fi
            ;;
        --api)
            API=1
            shift
            ;;
        -l|--login)
            if [ -n "$2" ]; then
                LOGIN=1
                LOGIN_NAME="$2"
                shift 2
            else
                echo -e "${RED}${ERROR} Erro: use -l ou --login seguido do nome da rota (ex: -l login)${RESET}"
                exit 1
            fi
            ;;
        --tailwind)
            if [ -n "$2" ] && [[ "$2" == "cdn" || "$2" == "build" ]]; then
                TAILWIND=1
                TAILWIND_TYPE="$2"
                shift 2
            else
                echo -e "${RED}${ERROR} Erro: use --tailwind cdn ou --tailwind build${RESET}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}${ERROR} Parâmetro desconhecido: $1${RESET}"
            echo -e "${YELLOW}Use -h ou --help para ver os comandos disponíveis${RESET}"
            exit 1
            ;;
    esac
done

echo ""
echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${BLUE}║${RESET}  ${ROCKET} ${BOLD}${GREEN}CRIANDO PROJETO FLASK MODULAR${RESET}                ${BOLD}${BLUE}║${RESET}"
echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${GEAR} ${CYAN}Projeto:${RESET} ${GREEN}$PROJETO${RESET}"
echo -e "${GEAR} ${CYAN}Rotas:${RESET} ${GREEN}${ROTAS[*]}${RESET}"

if [[ $DB -eq 1 ]]; then
    echo -e "${DATABASE} ${CYAN}Banco de dados:${RESET} ${GREEN}Habilitado${RESET} - Models: ${GREEN}${MODELS[*]}${RESET}"
fi
if [[ $API -eq 1 ]]; then
    echo -e "${GEAR} ${CYAN}Modo API:${RESET} ${GREEN}Habilitado${RESET}"
fi
if [[ $LOGIN -eq 1 ]]; then
    echo -e "${LOCK} ${CYAN}Sistema de Login:${RESET} ${GREEN}Habilitado${RESET} - Rota: ${GREEN}${LOGIN_NAME}${RESET}"
fi
if [[ $TAILWIND -eq 1 ]]; then
    echo -e "${PAINT} ${CYAN}Tailwind CSS:${RESET} ${GREEN}Habilitado ($TAILWIND_TYPE)${RESET}"
fi
echo ""

# Estrutura base
mkdir -p "$PROJETO/routes"

#########################################
# main.py
#########################################
cat <<EOF > "$PROJETO/main.py"
from flask import Flask
from routes import blueprints
$([[ $DB -eq 1 && $LOGIN -eq 1 ]] && echo "from extensions import db, login_manager")
$([[ $DB -eq 1 && $LOGIN -eq 0 ]] && echo "from extensions import db")

app = Flask(__name__)

$([[ $DB -eq 1 ]] && echo 'app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///dados.db"')
$([[ $DB -eq 1 ]] && echo 'app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False')
app.secret_key = "altere-sua-secret-key-aqui"

$([[ $DB -eq 1 ]] && echo "db.init_app(app)")
$([[ $LOGIN -eq 1 ]] && echo "login_manager.init_app(app)")
$([[ $LOGIN -eq 1 ]] && echo 'login_manager.login_view = "login.login"')

for bp in blueprints:
    app.register_blueprint(bp)

if __name__ == "__main__":$([[ $DB -eq 1 ]] && echo "
    with app.app_context():
        db.create_all()")
    app.run(host="0.0.0.0", port=5000, debug=True)
EOF

#########################################
# routes/__init__.py
#########################################
echo "" > "$PROJETO/routes/__init__.py"
for ROTA in "${ROTAS[@]}"; do
    echo "from .${ROTA}.${ROTA} import ${ROTA}_bp" >> "$PROJETO/routes/__init__.py"
done
if [[ $LOGIN -eq 1 ]]; then
    echo "from .${LOGIN_NAME}.${LOGIN_NAME} import ${LOGIN_NAME}_bp" >> "$PROJETO/routes/__init__.py"
fi
echo "" >> "$PROJETO/routes/__init__.py"
echo "blueprints = [" >> "$PROJETO/routes/__init__.py"
for ROTA in "${ROTAS[@]}"; do
    echo "    ${ROTA}_bp," >> "$PROJETO/routes/__init__.py"
done
if [[ $LOGIN -eq 1 ]]; then
    echo "    ${LOGIN_NAME}_bp," >> "$PROJETO/routes/__init__.py"
fi
echo "]" >> "$PROJETO/routes/__init__.py"

#########################################
# Criar rotas normais
#########################################
for ROTA in "${ROTAS[@]}"; do
    if [[ $TAILWIND -eq 1 ]]; then
        mkdir -p "$PROJETO/routes/$ROTA/templates"
    else
        mkdir -p "$PROJETO/routes/$ROTA/templates" "$PROJETO/routes/$ROTA/static/css"
    fi
    if [[ $API -eq 1 ]]; then
        cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, jsonify
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && echo "from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')")

${ROTA}_bp = Blueprint("${ROTA}", __name__)

@${ROTA}_bp.route("/${ROTA}")
def ${ROTA}():
    return jsonify({"message": "API da rota ${ROTA} funcionando!"})
EOF
    else
        if [[ $TAILWIND -eq 1 ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, render_template
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && echo "from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')")

${ROTA}_bp = Blueprint("${ROTA}", __name__, template_folder="templates")

@${ROTA}_bp.route("/")
def ${ROTA}():
    return render_template("${ROTA}.html")
EOF
        else
            cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, render_template
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && echo "from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')")

${ROTA}_bp = Blueprint("${ROTA}", __name__, template_folder="templates", static_folder="static", static_url_path="/${ROTA}/static")

@${ROTA}_bp.route("/")
def ${ROTA}():
    return render_template("${ROTA}.html")
EOF
        fi

        if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "cdn" ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Página ${ROTA}</title>
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="text-center">
        <h1 class="text-4xl font-bold text-green-400 mb-4">
            ✨ Rota ${ROTA} criada com sucesso!
        </h1>
        <p class="text-gray-300">
            Powered by Flask + Tailwind CSS
        </p>
    </div>

    <script src="https://cdn.tailwindcss.com" defer></script>
</body>
</html>
EOF
        elif [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Página ${ROTA}</title>

    <link rel="stylesheet" href="{{ url_for('static', filename='css/output.css') }}">
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="text-center">
        <h1 class="text-4xl font-bold text-green-400 mb-4">
            ✨ Rota ${ROTA} criada com sucesso!
        </h1>
        <p class="text-gray-300">
            Powered by Flask + Tailwind CSS (Build)
        </p>
    </div>
</body>
</html>
EOF
        else
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Página ${ROTA}</title>

    <link rel="stylesheet" href="{{ url_for('${ROTA}.static', filename='css/style.css') }}">
</head>

<body>
    <div class="container">
        <h1>Olá, rota ${ROTA} criada com sucesso!</h1>
    </div>
</body>
</html>
EOF
        fi

        if [[ $TAILWIND -eq 0 ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/static/css/style.css"
* {
    margin: 0;
    padding: 0;
}

body {
  font-family: Arial, sans-serif;
  color: #ddd;
  background-color: #121212;
}

h1 {
  color: #4CAF50;
}
EOF
        fi
    fi
done

#########################################
# Criar rota de login (-l)
#########################################
if [[ $LOGIN -eq 1 ]]; then
    if [[ $API -eq 1 ]]; then
        # Login em modo API (retorna JSON)
        mkdir -p "$PROJETO/routes/$LOGIN_NAME"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, jsonify, request
from flask_login import login_user, logout_user, login_required
from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__)

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["POST"])
def ${LOGIN_NAME}():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    
    if username and password:
        user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
        if user:
            login_user(user)
            return jsonify({"success": True, "message": "Login realizado com sucesso", "user": {"id": user.id, "username": user.username}})
    
    return jsonify({"success": False, "message": "Credenciais inválidas"}), 401

@${LOGIN_NAME}_bp.route("/logout", methods=["POST"])
@login_required
def logout():
    logout_user()
    return jsonify({"success": True, "message": "Logout realizado com sucesso"})
EOF
    elif [[ $TAILWIND -eq 1 ]]; then
        mkdir -p "$PROJETO/routes/$LOGIN_NAME/templates"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required
from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__, template_folder="templates")

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["GET", "POST"])
def ${LOGIN_NAME}():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        if username and password:
            user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
            if user:
                login_user(user)
                return redirect(url_for("home.home"))

        flash("Credenciais inválidas")

    return render_template("${LOGIN_NAME}.html")

@${LOGIN_NAME}_bp.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("${LOGIN_NAME}.${LOGIN_NAME}"))
EOF
    else
        mkdir -p "$PROJETO/routes/$LOGIN_NAME/templates" "$PROJETO/routes/$LOGIN_NAME/static/css"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required
from models import $(printf '%s, ' "${MODELS[@]}" | sed 's/, $//')
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__, template_folder="templates", static_folder="static", static_url_path="/${LOGIN_NAME}/static")

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["GET", "POST"])
def ${LOGIN_NAME}():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        if username and password:
            user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
            if user:
                login_user(user)
                return redirect(url_for("home.home"))

        flash("Credenciais inválidas")

    return render_template("${LOGIN_NAME}.html")

@${LOGIN_NAME}_bp.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("${LOGIN_NAME}.${LOGIN_NAME}"))
EOF
    fi

    if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "cdn" ]]; then
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login</title>
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded-lg shadow-lg w-full max-w-md">
        <h1 class="text-3xl font-bold text-green-400 mb-6 text-center">
            🔐 Login
        </h1>

        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="bg-red-600 text-white p-3 rounded mb-4">
                    {{ messages[0] }}
                </div>
            {% endif %}
        {% endwith %}

        <form method="POST" class="space-y-4">
            <input type="text" name="username" placeholder="Usuário" required
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">

            <input type="password" name="password" placeholder="Senha" required
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">

            <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded transition duration-200">
                Entrar
            </button>
        </form>
    </div>
    <script src="https://cdn.tailwindcss.com" defer></script>
</body>
</html>
EOF
    elif [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login</title>

    <link rel="stylesheet" href="{{ url_for('static', filename='css/output.css') }}">
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded-lg shadow-lg w-full max-w-md">
        <h1 class="text-3xl font-bold text-green-400 mb-6 text-center">
            🔐 Login
        </h1>

        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="bg-red-600 text-white p-3 rounded mb-4">
                    {{ messages[0] }}
                </div>
            {% endif %}
        {% endwith %}

        <form method="POST" class="space-y-4">
            <input type="text" name="username" placeholder="Usuário" required
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">

            <input type="password" name="password" placeholder="Senha" required
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">

            <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded transition duration-200">
                Entrar
            </button>
        </form>
    </div>
</body>
</html>
EOF
    else
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Login</title>
    
    <link rel="stylesheet" href="{{ url_for('${LOGIN_NAME}.static', filename='css/style.css') }}">
</head>

<body>
    <div class="container">
        <h1>Página de Login</h1>
    
        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="error">{{ messages[0] }}</div>
            {% endif %}
        {% endwith %}
        
        <form method="POST">
            <input type="text" name="username" placeholder="Usuário" required>
            <input type="password" name="password" placeholder="Senha" required>
            <button type="submit">Entrar</button>
        </form>
    </div>
</body>
</html>
EOF
    fi
fi

#########################################
# Estrutura base
#########################################
mkdir -p "$PROJETO/routes"

#########################################
# main.py
#########################################
cat <<EOF > "$PROJETO/main.py"
from flask import Flask
from routes import blueprints
$([[ $DB -eq 1 && $LOGIN -eq 1 ]] && echo "from extensions import db, login_manager")
$([[ $DB -eq 1 && $LOGIN -eq 0 ]] && echo "from extensions import db")

app = Flask(__name__)

$([[ $DB -eq 1 ]] && echo 'app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///dados.db"')
$([[ $DB -eq 1 ]] && echo 'app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False')
app.secret_key = "altere-sua-secret-key-aqui"

$([[ $DB -eq 1 ]] && echo "db.init_app(app)")
$([[ $LOGIN -eq 1 ]] && echo "login_manager.init_app(app)")
$([[ $LOGIN -eq 1 ]] && echo 'login_manager.login_view = "login.login"')

for bp in blueprints:
    app.register_blueprint(bp)

if __name__ == "__main__":$([[ $DB -eq 1 ]] && echo "
    with app.app_context():
        db.create_all()")
    app.run(host="0.0.0.0", port=5000, debug=True)
EOF

#########################################
# routes/__init__.py
#########################################
echo "" > "$PROJETO/routes/__init__.py"
for ROTA in "${ROTAS[@]}"; do
    echo "from .${ROTA}.${ROTA} import ${ROTA}_bp" >> "$PROJETO/routes/__init__.py"
done
if [[ $LOGIN -eq 1 ]]; then
    echo "from .${LOGIN_NAME}.${LOGIN_NAME} import ${LOGIN_NAME}_bp" >> "$PROJETO/routes/__init__.py"
fi
echo "" >> "$PROJETO/routes/__init__.py"
echo "blueprints = [" >> "$PROJETO/routes/__init__.py"
for ROTA in "${ROTAS[@]}"; do
    echo "    ${ROTA}_bp," >> "$PROJETO/routes/__init__.py"
done
if [[ $LOGIN -eq 1 ]]; then
    echo "    ${LOGIN_NAME}_bp," >> "$PROJETO/routes/__init__.py"
fi
echo "]" >> "$PROJETO/routes/__init__.py"

#########################################
# Criar rotas normais
#########################################
for ROTA in "${ROTAS[@]}"; do
    if [[ $TAILWIND -eq 1 ]]; then
        mkdir -p "$PROJETO/routes/$ROTA/templates"
    else
        mkdir -p "$PROJETO/routes/$ROTA/templates" "$PROJETO/routes/$ROTA/static/css"
    fi
    if [[ $API -eq 1 ]]; then
        cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, jsonify
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && printf "from models import %s" "$(IFS=', '; printf '%s ' "${MODELS[*]}")")

${ROTA}_bp = Blueprint("${ROTA}", __name__)

@${ROTA}_bp.route("/${ROTA}")
def ${ROTA}():
    return jsonify({"message": "API da rota ${ROTA} funcionando!"})
EOF
    else
        if [[ $TAILWIND -eq 1 ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, render_template
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && printf "from models import %s" "$(IFS=', '; printf '%s' "${MODELS[*]}")")

${ROTA}_bp = Blueprint("${ROTA}", __name__, template_folder="templates")

@${ROTA}_bp.route("/")
def ${ROTA}():
    return render_template("${ROTA}.html")
EOF
        else
            cat <<EOF > "$PROJETO/routes/$ROTA/$ROTA.py"
from flask import Blueprint, render_template
$([[ $DB -eq 1 ]] && echo "from extensions import db")
$([[ $DB -eq 1 ]] && printf "from models import %s" "$(IFS=', '; printf '%s' "${MODELS[*]}")")

${ROTA}_bp = Blueprint("${ROTA}", __name__, template_folder="templates", static_folder="static", static_url_path="/${ROTA}/static")

@${ROTA}_bp.route("/")
def ${ROTA}():
    return render_template("${ROTA}.html")
EOF
        fi

        if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "cdn" ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Página ${ROTA}</title>
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="text-center">
        <h1 class="text-4xl font-bold text-green-400 mb-4">
            ✨ Rota ${ROTA} criada com sucesso!
        </h1>
        <p class="text-gray-300">
            Powered by Flask + Tailwind CSS
        </p>
    </div>

    <script src="https://cdn.tailwindcss.com" defer></script>
</body>
</html>
EOF
        elif [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Página ${ROTA}</title>
    
    <link rel="stylesheet" href="{{ url_for('static', filename='css/output.css') }}">
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="text-center">
        <h1 class="text-4xl font-bold text-green-400 mb-4">
            ✨ Rota ${ROTA} criada com sucesso!
        </h1>
        <p class="text-gray-300">
            Powered by Flask + Tailwind CSS (Build)
        </p>
    </div>
</body>
</html>
EOF
        else
            cat <<EOF > "$PROJETO/routes/$ROTA/templates/$ROTA.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Página ${ROTA}</title>
    
    <link rel="stylesheet" href="{{ url_for('${ROTA}.static', filename='css/style.css') }}">
</head>

<body>
    <div class="container">
        <h1>Olá, rota ${ROTA} criada com sucesso!</h1>
    </div>
</body>
</html>
EOF
        fi

        if [[ $TAILWIND -eq 0 ]]; then
            cat <<EOF > "$PROJETO/routes/$ROTA/static/css/style.css"
* {
    margin: 0;
    padding: 0;
}

body { 
  font-family: Arial, sans-serif; 
  color: #ddd; 
  background-color: #121212; 
}

h1 { 
  color: #4CAF50; 
}
EOF
        fi
    fi
done

#########################################
# Criar rota de login (-l)
#########################################
if [[ $LOGIN -eq 1 ]]; then
    if [[ $API -eq 1 ]]; then
        # Login em modo API (retorna JSON)
        mkdir -p "$PROJETO/routes/$LOGIN_NAME"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, jsonify, request
from flask_login import login_user, logout_user, login_required
from models import $(IFS=', '; echo "${MODELS[*]}")
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__)

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["POST"])
def ${LOGIN_NAME}():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    
    if username and password:
        user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
        if user:
            login_user(user)
            return jsonify({"success": True, "message": "Login realizado com sucesso", "user": {"id": user.id, "username": user.username}})
    
    return jsonify({"success": False, "message": "Credenciais inválidas"}), 401

@${LOGIN_NAME}_bp.route("/logout", methods=["POST"])
@login_required
def logout():
    logout_user()
    return jsonify({"success": True, "message": "Logout realizado com sucesso"})
EOF
    elif [[ $TAILWIND -eq 1 ]]; then
        mkdir -p "$PROJETO/routes/$LOGIN_NAME/templates"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required
from models import $(IFS=', '; echo "${MODELS[*]}")
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__, template_folder="templates")

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["GET", "POST"])
def ${LOGIN_NAME}():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        
        if username and password:
            user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
            if user:
                login_user(user)
                return redirect(url_for("home.home"))
        
        flash("Credenciais inválidas")
    
    return render_template("${LOGIN_NAME}.html")

@${LOGIN_NAME}_bp.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("${LOGIN_NAME}.${LOGIN_NAME}"))
EOF
    else
        mkdir -p "$PROJETO/routes/$LOGIN_NAME/templates" "$PROJETO/routes/$LOGIN_NAME/static/css"
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/$LOGIN_NAME.py"
from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, logout_user, login_required
from models import $(IFS=', '; echo "${MODELS[*]}")
from extensions import login_manager

${LOGIN_NAME}_bp = Blueprint("${LOGIN_NAME}", __name__, template_folder="templates", static_folder="static", static_url_path="/${LOGIN_NAME}/static")

@login_manager.user_loader
def load_user(user_id):
    return $(echo "${MODELS[0]}").query.get(int(user_id))

@${LOGIN_NAME}_bp.route("/${LOGIN_NAME}", methods=["GET", "POST"])
def ${LOGIN_NAME}():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        
        if username and password:
            user = $(echo "${MODELS[0]}").query.filter_by(username=username).first()
            if user:
                login_user(user)
                return redirect(url_for("home.home"))
        
        flash("Credenciais inválidas")
    
    return render_template("${LOGIN_NAME}.html")

@${LOGIN_NAME}_bp.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("${LOGIN_NAME}.${LOGIN_NAME}"))
EOF
    fi

    if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "cdn" ]]; then
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Login</title>
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded-lg shadow-lg w-full max-w-md">
        <h1 class="text-3xl font-bold text-green-400 mb-6 text-center">
            🔐 Login
        </h1>
        
        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="bg-red-600 text-white p-3 rounded mb-4">
                    {{ messages[0] }}
                </div>
            {% endif %}
        {% endwith %}
        
        <form method="POST" class="space-y-4">
            <input type="text" name="username" placeholder="Usuário" required 
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">
        
            <input type="password" name="password" placeholder="Senha" required 
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">
            
            <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded transition duration-200">
                Entrar
            </button>
        </form>
    </div>
    <script src="https://cdn.tailwindcss.com" defer></script>
</body>
</html>
EOF
    elif [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Login</title>
    
    <link rel="stylesheet" href="{{ url_for('static', filename='css/output.css') }}">
</head>

<body class="bg-gray-900 text-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-gray-800 p-8 rounded-lg shadow-lg w-full max-w-md">
        <h1 class="text-3xl font-bold text-green-400 mb-6 text-center">
            🔐 Login
        </h1>
        
        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="bg-red-600 text-white p-3 rounded mb-4">
                    {{ messages[0] }}
                </div>
            {% endif %}
        {% endwith %}
        
        <form method="POST" class="space-y-4">
            <input type="text" name="username" placeholder="Usuário" required 
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">
        
            <input type="password" name="password" placeholder="Senha" required 
                   class="w-full p-3 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-400 focus:outline-none">
            
            <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded transition duration-200">
                Entrar
            </button>
        </form>
    </div>
</body>
</html>
EOF
    else
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/templates/$LOGIN_NAME.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Login</title>
    
    <link rel="stylesheet" href="{{ url_for('${LOGIN_NAME}.static', filename='css/style.css') }}">
</head>

<body>
    <div class="container">
        <h1>Página de Login</h1>
    
        {% with messages = get_flashed_messages() %}
            {% if messages %}
                <div class="error">{{ messages[0] }}</div>
            {% endif %}
        {% endwith %}
        
        <form method="POST">
            <input type="text" name="username" placeholder="Usuário" required>
            <input type="password" name="password" placeholder="Senha" required>
            <button type="submit">Entrar</button>
        </form>
    </div>
</body>
</html>
EOF
    fi

    if [[ $TAILWIND -eq 0 ]]; then
        cat <<EOF > "$PROJETO/routes/$LOGIN_NAME/static/css/style.css"
* {
    margin: 0;
    padding: 0;
}

body {   
  color: #ddd;
  background-color: #121212; 
  font-family: Arial, sans-serif;
}

h1 { 
  color: #4CAF50; 
}

form { 
  display: flex; 
  flex-direction: column; 
  max-width: 300px; 
}

input, button { 
  margin: 5px 0; 
  padding: 10px; 
}

button {  
  border: none; 
  cursor: pointer;
  color: white;
  background-color: #4CAF50;
}

button:hover { 
  background: #45a049; 
}
EOF
    fi
fi

#########################################
# Banco de Dados
#########################################
if [[ $DB -eq 1 ]]; then
    cat <<EOF > "$PROJETO/extensions.py"
from flask_sqlalchemy import SQLAlchemy
$([[ $LOGIN -eq 1 ]] && echo "from flask_login import LoginManager")

db = SQLAlchemy()
$([[ $LOGIN -eq 1 ]] && echo "login_manager = LoginManager()")
EOF

    cat <<EOF > "$PROJETO/models.py"
from extensions import db
$([[ $LOGIN -eq 1 ]] && echo "from flask_login import UserMixin")

EOF

    for i in "${!MODELS[@]}"; do
        MODEL="${MODELS[$i]}"
        if [[ $LOGIN -eq 1 && $i -eq 0 ]]; then
            cat <<EOF >> "$PROJETO/models.py"
class ${MODEL}(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    def __repr__(self):
        return f'<${MODEL} {self.username}>'

EOF
        else
            cat <<EOF >> "$PROJETO/models.py"
class ${MODEL}(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp())
    
    def __repr__(self):
        return f'<${MODEL} {self.id}>'

EOF
        fi
    done
fi

# Configurar Tailwind build se necessário
if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
    mkdir -p "$PROJETO/static/css"
    
    # package.json
    cat <<EOF > "$PROJETO/package.json"
{
  "name": "$(basename $PROJETO)",
  "version": "1.0.0",
  "description": "Flask app with Tailwind CSS",
  "scripts": {
    "dev": "npx tailwindcss -i ./src/input.css -o ./static/css/output.css --watch",
    "build": "npx tailwindcss -i ./src/input.css -o ./static/css/output.css --minify"
  },
  "devDependencies": {
    "tailwindcss": "^3.4.0"
  }
}
EOF

    # tailwind.config.js
    cat <<EOF > "$PROJETO/tailwind.config.js"
module.exports = {
  content: ["./routes/**/templates/**/*.html"],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

    # Criar diretório src e input.css
    mkdir -p "$PROJETO/src"
    cat <<EOF > "$PROJETO/src/input.css"
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

    # Criar .gitignore para node_modules
    echo "node_modules/" >> "$PROJETO/.gitignore"
    
    # Gerar CSS inicial
    cat <<EOF > "$PROJETO/static/css/output.css"
/* Tailwind CSS será gerado aqui com: npm run build */
EOF
fi

# Criar requirements.txt
cat <<EOF > "$PROJETO/requirements.txt"
Flask==2.3.3
$([[ $DB -eq 1 ]] && echo "Flask-SQLAlchemy==3.0.5")
$([[ $LOGIN -eq 1 ]] && echo "Flask-Login==0.6.3")
EOF

# Criar .gitignore
cat <<EOF > "$PROJETO/.gitignore"
__pycache__/
node_modules/
src/
tailwind.config.js
package.json
package-lock.json
EOF

echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${GREEN}║${RESET}  ${CHECKMARK} ${BOLD}${GREEN}PROJETO CRIADO COM SUCESSO!${RESET}${BOLD}${GREEN}  ║${RESET}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${ROCKET} ${CYAN}Para rodar o projeto:${RESET}"
echo -e "   ${YELLOW}cd $PROJETO${RESET}"
if [[ $TAILWIND -eq 1 && "$TAILWIND_TYPE" == "build" ]]; then
    echo -e "   ${YELLOW}npm install${RESET}"
    echo -e "   ${YELLOW}npm run build${RESET} ${CYAN}(ou npm run dev para watch)${RESET}"
fi
echo -e "   ${YELLOW}pip install -r requirements.txt${RESET}"
echo -e "   ${YELLOW}python3 main.py${RESET}"
echo ""
echo -e "${GEAR} ${CYAN}Recursos criados:${RESET}"
echo -e "   ${CHECKMARK} ${GREEN}$(echo ${#ROTAS[@]}) rota(s): ${ROTAS[*]}${RESET}"
if [[ $DB -eq 1 ]]; then
    echo -e "   ${DATABASE} ${GREEN}$(echo ${#MODELS[@]}) model(s): ${MODELS[*]}${RESET}"
fi
if [[ $LOGIN -eq 1 ]]; then
    echo -e "   ${LOCK} ${GREEN}Sistema de autenticação${RESET}"
fi
if [[ $API -eq 1 ]]; then
    echo -e "   ${GEAR} ${GREEN}Endpoints API${RESET}"
fi
if [[ $TAILWIND -eq 1 ]]; then
    echo -e "   ${PAINT} ${GREEN}Tailwind CSS ($TAILWIND_TYPE)${RESET}"
fi
echo ""
echo -e "${CYAN}${BOLD}Bom desenvolvimento! 🎉${RESET}"
echo ""
