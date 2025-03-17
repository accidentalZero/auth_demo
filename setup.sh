#!/usr/bin/bash
# Скрипт для настройки рабочего окружения в ОС RosaLinux\МОС

distributor_id=$(lsb_release -si)

# В RosaLinux предустановлена старая версия Python, не поддерживающая аннотацию типов
if [ "$distributor_id" = "rosa" ]; then
    if dnf list installed python3.11 >/dev/null 2>&1; then
        echo "Обнаружена требуемая версия Python"
    else
        echo "Не установлен python требуемой версии! Будет произведена установка:"
        sudo dnf install -y python3.11
    fi
    interpret="/usr/libexec/python3.11"    
else
    interpret=python3    
fi

required_version="3.10"
python_version=$("$interpret" --version 2>&1 | awk '{print $2}')

if [ -z "$python_version" ]; then
    echo "Python не установлен или не найден."
    exit 1
fi

if ! printf '%s\n%s\n' "$required_version" "$python_version" | sort -V -C; then
    echo -e "\033[33m Ошибка: \033[37mустановлена версия Python $python_version, для выполнения примера необходима $required_version или новее"
    exit 1
fi

$interpret -m venv env
source ./env/bin/activate
pip install --upgrade pip
requirements="./requirements.txt"
if [ -e "$requirements" ]; then
    pip install -r "$requirements"
    # Убираем ошибку в библиотеке
    sed -i 's/version = _bcrypt.__about__.__version__/version = _bcrypt.__version__/g' ./env/lib64/python3.11/site-packages/passlib/handlers/bcrypt.py
else
    echo -e "\033[33m Ошибка: \033[37mфайл не существует: $requirements, склонируйте репозиторий корректно или поместите этот файл в одну директорию с $(basename "$0")"
fi


