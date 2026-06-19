# Инструкция по установке и запуску

## 1. Yandex Cloud Setup (PostgreSQL)

### Создать БД
```bash
# 1. Создать аккаунт на cloud.yandex.ru (если нет)
# 2. Создать новый проект
# 3. В разделе "Databases" создать PostgreSQL кластер:
#    - Имя: freelance-db
#    - Версия: 14+
#    - Регион: Москва (ru-central1)
#    - Класс хоста: b1.small (бесплатный tier)

# 4. После создания получите:
#    - FQDN (хост)
#    - Пользователь: postgres
#    - Пароль: [сгенерируется]
#    - База: freelance_db
```

### Применить schema
```bash
# Установить psql (PostgreSQL client)
# macOS
brew install postgresql

# Ubuntu/Debian
sudo apt-get install postgresql-client

# Подключиться к БД и выполнить DATABASE_SCHEMA.sql
psql -h <YANDEX_FQDN> -U postgres -d freelance_db -f DATABASE_SCHEMA.sql
```

---

## 2. Backend Setup (Node.js)

### Установить зависимости
```bash
cd freelance-app/backend
npm install
```

### Создать .env файл
```bash
# .env
DB_USER=postgres
DB_PASSWORD=<your_password>
DB_HOST=<yandex_fqdn>
DB_PORT=5432
DB_NAME=freelance_db

JWT_SECRET=your-super-secret-key-change-this

PORT=3000
```

### Запустить backend (локально для тестирования)
```bash
npm run dev
```

Сервер запустится на http://localhost:3000

### Проверить
```bash
curl http://localhost:3000/health
# Ответ: {"status":"OK"}
```

---

## 3. Yandex Serverless Functions Deploy (после тестирования)

```bash
# Установить Yandex CLI
# https://cloud.yandex.ru/docs/cli/quickstart

# Развернуть функцию
yc serverless function create --name freelance-api

# Загрузить код
yc serverless function version create \
  --function-name freelance-api \
  --runtime nodejs18 \
  --entrypoint index.handler \
  --source-path ./backend

# Публикуем версию
yc serverless function version set-access-binding <version-id> --public-api
```

---

## 4. Flutter Setup (Android/RuStore)

### Требования
- Flutter SDK 3.0+
- Android SDK 21+
- Android Studio или VS Code с Flutter расширением

### Установить зависимости
```bash
cd freelance-app
flutter pub get
```

### Отредактировать API URL
В файле `lib/providers/auth_provider.dart` и `lib/screens/orders_screen.dart` замените:
```dart
static const String _apiUrl = 'https://your-backend-url.com';
```

На реальный URL вашего backend (например, после деплоя на Yandex Functions)

### Запустить приложение (эмулятор)
```bash
flutter run
```

### Собрать APK для RuStore
```bash
flutter build apk --release

# APK будет в: build/app/outputs/flutter-apk/app-release.apk
```

---

## 5. Яндекс.Касса Integration (TODO)

### Получить credentials
1. Перейти на https://kassa.yandex.ru
2. Создать аккаунт
3. Получить:
   - Shop ID
   - Scret Key

### Добавить в backend
В `backend/server.js` добавить обработку платежей:
```javascript
const shopId = process.env.YANDEX_SHOP_ID;
const secretKey = process.env.YANDEX_SECRET_KEY;

app.post('/payment/checkout', async (req, res) => {
  // TODO: Реализовать интеграцию
});
```

---

## 6. Firebase Setup (Уведомления)

### Создать Firebase проект
1. https://console.firebase.google.com
2. Создать проект
3. Добавить Android приложение

### Скачать google-services.json
1. В Firebase console перейти в проект
2. Скачать `google-services.json`
3. Поместить в `flutter_app/android/app/`

### В Flutter коде инициализировать Firebase
```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

---

## Troubleshooting

### "Cannot connect to database"
- Проверьте IP адрес в Yandex Cloud (может быть нужен VPN)
- Убедитесь, что .env переменные правильные

### "Flutter build fails"
```bash
flutter clean
flutter pub get
flutter run
```

### "Module not found"
```bash
# Backend
npm install

# Flutter
flutter pub get
```

---

## Следующие шаги

1. ✅ Развернуть PostgreSQL на Yandex Cloud
2. ✅ Тестировать Backend API локально
3. ✅ Тестировать Flutter приложение
4. 📍 **Добавить чат (WebSocket или Firebase Realtime)**
5. 📍 **Интеграция Яндекс.Касса для платежей**
6. 📍 **Публикация в RuStore**
