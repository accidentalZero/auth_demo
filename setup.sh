#!/usr/bin/bash
# Скрипт для настройки рабочего окружения в ОС RosaLinux\МОС


if dnf list installed python3.11 >/dev/null 2>&1; then
    echo "Обнаружена требуемая версия Python"
else
    echo "Не установлен python требуемой версии! Произведите установку:"
    sudo dnf install python3.11
fi

/usr/libexec/python3.11 -m venv env
source ./env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Для того чтобы убрать ошибку 
sed -i 's/version = _bcrypt.__about__.__version__/version = _bcrypt.__version__/g' ./env/lib64/python3.11/site-packages/passlib/handlers/bcrypt.py