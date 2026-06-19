# ⚡ Quick Start Guide

Быстрый старт проекта за 5 минут.

---

## 1️⃣ Backend (Node.js)

### Установка
```bash
cd /tasklet/agent/home/freelance-app/backend
npm install
```

### Конфигурация
```bash
# Скопировать .env.example в .env
cp .env.example .env

# Отредактировать .env (добавить Yandex Cloud credentials)
nano .env
```

### Запуск
```bash
npm run dev
```

**Результат:** Сервер на http://localhost:3000 ✅

### Проверка
```bash
curl http://localhost:3000/health
# Ответ: {"status":"OK"}
```

---

## 2️⃣ Flutter (Android)

### Установка зависимостей
```bash
cd /tasklet/agent/home/freelance-app/flutter_app
flutter pub get
```

### Запуск (эмулятор)
```bash
flutter run
```

**Результат:** Приложение запущено на Android эмуляторе ✅

---

## 3️⃣ Database (PostgreSQL)

### Создать на Yandex Cloud
1. https://console.yandex.cloud
2. Create PostgreSQL 14+ cluster in Moscow (ru-central1)
3. Получить FQDN, пользователя, пароль

### Применить схему
```bash
psql -h <YOUR_FQDN> -U postgres -d freelance_db -f /tasklet/agent/home/freelance-app/database/DATABASE_SCHEMA.sql
```

**Результат:** 7 таблиц созданы ✅

---

## 🧪 Тестирование API

### Регистрация
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "full_name": "Test User",
    "user_type": "freelancer"
  }'
```

### Вход
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Получить заказы
```bash
curl http://localhost:3000/orders
```

### Получить профиль
```bash
curl http://localhost:3000/users/1
```

---

## 🔧 Устранение проблем

### "Cannot connect to PostgreSQL"
```bash
# Проверить .env переменные
cat backend/.env

# Проверить подключение (если psql установлен)
psql -h <HOST> -U postgres -d freelance_db
```

### "Flutter command not found"
```bash
# Добавить в PATH
export PATH="$PATH:$HOME/flutter/bin"

# Проверить
flutter --version
```

### "Port 3000 already in use"
```bash
# Использовать другой порт
PORT=3001 npm run dev
```

---

## 📁 Файлы для быстрого старта

| Файл | Для чего |
|------|----------|
| `backend/server.js` | API endpoints |
| `backend/package.json` | Зависимости Node.js |
| `backend/.env.example` | Шаблон конфигурации |
| `flutter_app/lib/main.dart` | Flutter entry point |
| `flutter_app/pubspec.yaml` | Зависимости Flutter |
| `database/DATABASE_SCHEMA.sql` | PostgreSQL схема |

---

## 📚 Полная документация

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Полная техническая архитектура
- **[SETUP.md](docs/SETUP.md)** - Детальная инструкция по установке
- **[DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md)** - 30-дневный план разработки
- **[TODAY_DONE.md](docs/TODAY_DONE.md)** - Что было сделано сегодня
- **[PROJECT_STATUS.md](PROJECT_STATUS.md)** - Статус проекта

---

## ✅ Чек-лист для старта

- [ ] Node.js установлен (`node --version`)
- [ ] Flutter установлен (`flutter --version`)
- [ ] PostgreSQL клиент установлен (`psql --version`)
- [ ] Аккаунт на Yandex Cloud создан
- [ ] `.env` файл заполнен
- [ ] Backend зависимости установлены (`npm install`)
- [ ] Flutter зависимости установлены (`flutter pub get`)
- [ ] Эмулятор Android запущен или устройство подключено

---

## 🚀 Быстрый старт (все сразу)

### Терминал 1: Backend
```bash
cd backend
npm install
cp .env.example .env
# Отредактировать .env с Yandex credentials
npm run dev
# Ждём: "Server running on port 3000"
```

### Терминал 2: Flutter
```bash
cd flutter_app
flutter pub get
flutter run
# Ждём запуска приложения на эмуляторе
```

### Терминал 3: Тестирование
```bash
# Тестировать API в другом терминале
curl http://localhost:3000/health
```

---

## 💡 Следующие шаги после Quick Start

1. ✅ Локальное тестирование (День 2)
2. ✅ Yandex Cloud deployment (День 6)
3. ✅ Добавить чат (День 8-9)
4. ✅ Интеграция платежей (День 11-12)
5. ✅ RuStore публикация (День 19)

---

**Время на Quick Start:** ~5 минут
**Следующее шага:** Запустить оба компонента и протестировать API

Успехов! 🎉
