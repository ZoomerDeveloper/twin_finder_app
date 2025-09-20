# Проверка конфигурации Apple Sign-In в Firebase

## Текущая ошибка
```
[firebase_auth/invalid-credential] Invalid OAuth response from apple.com
```

## Шаги для проверки и исправления

### 1. Проверка Firebase Console

1. **Откройте Firebase Console**: https://console.firebase.google.com/
2. **Выберите проект**: twin-finder-bb4ac
3. **Перейдите в Authentication > Sign-in method**
4. **Найдите Apple в списке провайдеров**

### 2. Проверка конфигурации Apple

**Если Apple НЕ настроен:**
1. Нажмите "Apple" в списке провайдеров
2. Включите Apple Sign-In
3. Заполните поля:
   - **Service ID**: `app.twin.finder.service` (или создайте новый)
   - **Apple team ID**: найдите в Apple Developer Console
   - **Key ID**: создайте в Apple Developer Console
   - **Private key**: загрузите .p8 файл

**Если Apple уже настроен:**
1. Проверьте Service ID - должен совпадать с Bundle ID
2. Проверьте Apple team ID
3. Проверьте, что ключ не истек

### 3. Создание Service ID в Apple Developer Console

1. **Войдите в Apple Developer Console**: https://developer.apple.com/account/
2. **Перейдите в Certificates, Identifiers & Profiles > Identifiers**
3. **Нажмите "+" для создания нового идентификатора**
4. **Выберите "Services IDs"**
5. **Заполните:**
   - Identifier: `app.twin.finder.service`
   - Description: "TwinFinder Apple Sign-In Service"
6. **Включите "Sign In with Apple"**
7. **Нажмите "Configure" и настройте:**
   - Primary App ID: `app.twin.finder`
   - Domains and Subdomains: `twin-finder-bb4ac.firebaseapp.com`
   - Return URLs: `https://twin-finder-bb4ac.firebaseapp.com/__/auth/handler`

### 4. Создание ключа в Apple Developer Console

1. **Перейдите в Keys**
2. **Нажмите "+" для создания нового ключа**
3. **Заполните:**
   - Key Name: "TwinFinder Apple Sign-In Key"
   - Services: отметьте "Sign In with Apple"
4. **Скачайте .p8 файл** (сохраните его безопасно!)
5. **Скопируйте Key ID**

### 5. Настройка в Firebase Console

1. **Вернитесь в Firebase Console > Authentication > Sign-in method**
2. **Нажмите на Apple провайдер**
3. **Заполните поля:**
   - Service ID: `app.twin.finder.service`
   - Apple team ID: ваш Team ID (10 символов)
   - Key ID: скопированный Key ID
   - Private key: загрузите .p8 файл
4. **Сохраните изменения**

### 6. Проверка Bundle ID

Убедитесь, что Bundle ID везде одинаковый:
- iOS проект: `app.twin.finder`
- Apple Developer Console: `app.twin.finder`
- Firebase Console: `app.twin.finder`
- Service ID: `app.twin.finder.service`

### 7. Тестирование

После настройки:
1. Перезапустите приложение
2. Попробуйте войти через Apple Sign-In
3. Проверьте логи в консоли для детальной диагностики

## Возможные проблемы

1. **Service ID не создан** - создайте в Apple Developer Console
2. **Ключ не загружен** - загрузите .p8 файл в Firebase
3. **Bundle ID не совпадает** - проверьте везде одинаковый ID
4. **Return URL неправильный** - используйте правильный URL из Firebase
5. **Ключ истек** - создайте новый ключ в Apple Developer Console
