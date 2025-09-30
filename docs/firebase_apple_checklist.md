# Чек-лист настройки Apple Sign-In в Firebase

## ❌ Текущая ошибка
```
[firebase_auth/invalid-credential] Invalid OAuth response from apple.com
```

## ✅ Проверьте настройки в Firebase Console

### 1. Откройте Firebase Console
- URL: https://console.firebase.google.com/
- Проект: `twin-finder-bb4ac`

### 2. Перейдите в Authentication
- Authentication → Sign-in method
- Найдите Apple в списке провайдеров

### 3. Проверьте настройки Apple провайдера

**Если Apple НЕ включен:**
1. Нажмите на Apple
2. Включите Apple Sign-In
3. Заполните поля (см. ниже)

**Если Apple уже включен:**
1. Нажмите на Apple для редактирования
2. Проверьте все поля

### 4. Обязательные поля

**Service ID:**
```
app.twin.finder.service
```

**Apple team ID:**
```
Ваш Team ID (10 символов, например: ABC123DEF4)
```

**Key ID:**
```
XT5P4Z9W96
```

**Private key:**
```
Загрузите .p8 файл, скачанный из Apple Developer Console
```

### 5. Проверьте Bundle ID в Firebase

**В Firebase Console → Project Settings → General:**
- Bundle ID должен быть: `app.twin.finder`

## 🔍 Возможные проблемы

### 1. Неправильный Service ID
- Убедитесь, что Service ID точно `app.twin.finder.service`
- Без пробелов, с правильным регистром

### 2. Неправильный Team ID
- Team ID должен быть 10 символов
- Найдите в Apple Developer Console → Membership

### 3. Неправильный Key ID
- Должен быть `XT5P4Z9W96`
- Без пробелов, точное совпадение

### 4. Проблема с приватным ключом
- Убедитесь, что загрузили .p8 файл
- Ключ не должен быть поврежден
- Ключ должен быть создан для Apple Sign-In

### 5. Bundle ID не совпадает
- В Firebase: `app.twin.finder`
- В Apple Developer Console: `app.twin.finder`
- В iOS проекте: `app.twin.finder`

## 🚀 После исправления

1. Сохраните изменения в Firebase Console
2. Перезапустите приложение
3. Попробуйте Apple Sign-In
4. Проверьте логи в консоли

## 📱 Тестирование

После настройки в логах должно появиться:
```
Apple Sign-In success:
  - User ID: [ID]
  - Email: [email]
  - Identity Token length: [число]
Creating Firebase OAuth credential...
Signing in with Firebase...
Firebase sign-in successful:
  - Firebase UID: [UID]
```
