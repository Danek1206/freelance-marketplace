# Архитектура Freelance Marketplace

## Стек технологий

### Backend
- **Runtime:** Node.js
- **Framework:** Express.js
- **БД:** PostgreSQL (Yandex Cloud, Москва)
- **Хостинг:** Yandex Serverless Functions

### Frontend
- **Framework:** Flutter (Dart)
- **Платформа:** Android (RuStore)
- **State Management:** Provider
- **HTTP:** http package

### Платежи & Уведомления
- **Платежи:** Яндекс.Касса
- **Уведомления:** Firebase Cloud Messaging

---

## Архитектура БД

### Таблицы

1. **users** - Пользователи (фрилансеры и заказчики)
2. **orders** - Заказы/проекты
3. **applications** - Заявки на заказы
4. **chats** - Диалоги между пользователями
5. **messages** - Сообщения в чатах
6. **reviews** - Отзывы и рейтинги
7. **subscriptions** - Подписки на премиум

---

## API Endpoints (MVP)

### Auth
- `POST /auth/register` - Регистрация
- `POST /auth/login` - Вход

### Orders
- `GET /orders` - Список заказов (с фильтром)
- `GET /orders/:id` - Детали заказа
- `POST /orders` - Создать заказ

### Applications
- `POST /applications` - Подать заявку
- `GET /orders/:id/applications` - Заявки на заказ

### Users
- `GET /users/:id` - Профиль пользователя

---

## Flutter структура

```
lib/
├── main.dart                  # Entry point
├── providers/
│   └── auth_provider.dart     # Управление авторизацией
├── screens/
│   ├── login_screen.dart      # Вход/регистрация
│   ├── orders_screen.dart     # Каталог заказов
│   ├── order_detail.dart      # Детали заказа
│   ├── profile_screen.dart    # Профиль пользователя
│   ├── chat_screen.dart       # Чат (TODO)
│   └── create_order.dart      # Создание заказа (TODO)
└── models/
    ├── user.dart              # TODO
    ├── order.dart             # TODO
    └── message.dart           # TODO
```

---

## Алгоритм авторизации

1. Пользователь регистрируется/входит
2. Backend возвращает JWT токен
3. Токен сохраняется в SharedPreferences
4. При каждом запросе токен отправляется в заголовке Authorization
5. Backend проверяет токен

---

## Разделение по опыту

- **Beginner** (Новички) - для фрилансеров с 0-5 проектов
- **Intermediate** (Опытные) - 6-20 проектов
- **Expert** (Эксперты) - 20+ проектов

Фильтр позволяет искать по уровню опыта.

---

## Монетизация

1. **Премиум профиль** - Выделение в поиске (500₽/месяц)
2. **Продвижение объявления** - Поднятие в топ (50-200₽)
3. **Pro подписка** - Расширенная аналитика (1000₽/месяц)

---

## Безопасность

- ✅ HTTPS для всех запросов
- ✅ JWT для авторизации
- ✅ Хеширование паролей (bcryptjs)
- ✅ Валидация входных данных
- ✅ CORS настроен на backend

---

## Roadmap (после MVP)

1. **In-app chat с real-time** (WebSocket)
2. **Система отзывов и рейтингов**
3. **Интеграция с соцсетями**
4. **Аналитика для заказчиков**
5. **Прямые переводы между пользователями** (P2P)
6. **Портфолио с загрузкой файлов**
