# Настройка Apple Sign-In для TwinFinder

## Проблема
Ошибка: `[firebase_auth/invalid-credential] Invalid OAuth response from apple.com`

## Решение

### 1. Настройка в Apple Developer Console

1. **Войдите в Apple Developer Console**: https://developer.apple.com/account/
2. **Перейдите в Certificates, Identifiers & Profiles**
3. **Найдите App ID**: `app.twin.finder`
4. **Включите Sign In with Apple**:
   - Откройте App ID
   - В разделе "Capabilities" включите "Sign In with Apple"
   - Сохраните изменения

### 2. Создание Service ID

1. **Перейдите в Identifiers**
2. **Создайте новый Service ID**:
   - Identifier: `app.twin.finder.service` (или любой уникальный)
   - Description: "TwinFinder Apple Sign-In Service"
3. **Включите Sign In with Apple**:
   - Отметьте "Sign In with Apple"
   - Нажмите "Configure"
   - Primary App ID: выберите `app.twin.finder`
   - Domains and Subdomains: `twin-finder-bb4ac.firebaseapp.com`
   - Return URLs: добавьте `https://twin-finder-bb4ac.firebaseapp.com/__/auth/handler`
4. **Сохраните Service ID**

### 3. Настройка в Firebase Console

1. **Откройте Firebase Console**: https://console.firebase.google.com/
2. **Выберите проект**: twin-finder-bb4ac
3. **Перейдите в Authentication > Sign-in method**
4. **Включите Apple**:
   - Service ID: `app.twin.finder.service` (из шага 2)
   - OAuth code flow configuration:
     - Apple team ID: ваш Team ID из Apple Developer Console
     - Key ID: создайте новый ключ в Apple Developer Console
     - Private key: скачайте .p8 файл и загрузите в Firebase

### 4. Создание ключа в Apple Developer Console

1. **Перейдите в Keys**
2. **Создайте новый ключ**:
   - Key Name: "TwinFinder Apple Sign-In Key"
   - Services: отметьте "Sign In with Apple"
3. **Скачайте .p8 файл** (сохраните его безопасно)
4. **Загрузите ключ в Firebase** (шаг 3.4)

### 5. Проверка конфигурации

Убедитесь, что в `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>app.twin.finder</string>
</array>
```

И в `ios/Runner/Runner.entitlements`:
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

## Тестирование

После настройки:
1. Пересоберите приложение: `flutter clean && flutter pub get`
2. Запустите на устройстве: `flutter run -d [device_id]`
3. Попробуйте войти через Apple Sign-In

## Возможные проблемы

1. **Bundle ID не совпадает**: убедитесь, что везде используется `app.twin.finder`
2. **Service ID не настроен**: создайте Service ID в Apple Developer Console
3. **Ключ не загружен**: загрузите .p8 ключ в Firebase Console
4. **Return URL неправильный**: используйте правильный URL из Firebase Console
