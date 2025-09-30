# Apple Sign-In Debug Checklist

## Проблема
Apple Sign-In получает все данные от Apple, но Firebase возвращает `invalid-credential` ошибку.

## Диагностика

### 1. Apple Developer Console
- [ ] **App ID** настроен с Bundle ID: `app.twin.finder`
- [ ] **Sign In with Apple** capability включен
- [ ] **Service ID** создан: `app.twin.finder.service`
- [ ] **Service ID** связан с App ID
- [ ] **Domains and Subdomains** добавлен: `twin-finder-bb4ac.firebaseapp.com`
- [ ] **Return URLs** добавлен: `https://twin-finder-bb4ac.firebaseapp.com/__/auth/handler`
- [ ] **Apple Sign In Key** создан и скачан (.p8 файл)
- [ ] **Key ID** записан (например: XT5P4Z9W96)
- [ ] **Team ID** записан (например: 6DYQJ8T976)

### 2. Firebase Console
- [ ] **Apple Sign-In** включен в Authentication > Sign-in method
- [ ] **Service ID** указан: `app.twin.finder.service`
- [ ] **Team ID** указан: `6DYQJ8T976`
- [ ] **Key ID** указан: `XT5P4Z9W96`
- [ ] **Private Key** загружен (содержимое .p8 файла)
- [ ] **OAuth redirect URI** указан: `https://twin-finder-bb4ac.firebaseapp.com/__/auth/handler`

### 3. iOS App Configuration
- [ ] **Bundle ID** в Info.plist: `app.twin.finder`
- [ ] **URL Scheme** в Info.plist: `app.twin.finder`
- [ ] **Entitlements** содержит `com.apple.developer.applesignin`
- [ ] **GoogleService-Info.plist** содержит правильный Bundle ID

### 4. Проверка логов
При запуске Apple Sign-In должны появиться логи:
```
🍎 Apple Sign-In: Starting authentication...
🍎 Apple Sign-In available: true
🍎 Apple Sign-In: Creating Firebase OAuth credential...
🍎 Apple Sign-In: Identity Token length: [число]
🍎 Apple Sign-In: Firebase project ID: twin-finder-bb4ac
🍎 Apple Sign-In: Signing in with Firebase...
```

## Возможные причины ошибки

1. **Неправильный Service ID** - должен быть `app.twin.finder.service`
2. **Неправильный Team ID** - должен совпадать с Apple Developer
3. **Неправильный Key ID** - должен совпадать с созданным ключом
4. **Неправильный Private Key** - должен быть содержимое .p8 файла
5. **Неправильный OAuth redirect URI** - должен быть Firebase URL
6. **Неправильный Bundle ID** - должен быть `app.twin.finder`

## Следующие шаги

1. Запустить приложение с новой диагностикой
2. Проверить логи Apple Sign-In
3. Сравнить с чек-листом выше
4. Исправить найденные несоответствия
