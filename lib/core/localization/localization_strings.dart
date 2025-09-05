class LocalizationStrings {
  final String languageCode;

  LocalizationStrings(this.languageCode);

  String getString(String key) {
    switch (languageCode) {
      case 'es':
        return _spanishStrings[key] ?? _englishStrings[key] ?? key;
      case 'zh':
        return _chineseStrings[key] ?? _englishStrings[key] ?? key;
      case 'ru':
        return _russianStrings[key] ?? _englishStrings[key] ?? key;
      case 'en':
      default:
        return _englishStrings[key] ?? key;
    }
  }

  // English strings (default)
  static const Map<String, String> _englishStrings = {
    // App general
    'app_name': 'TwinFinder',
    'find_your_twin': 'Find Your Twin. Start a New Connection.',

    // Auth page
    'continue_with_google': 'Continue with Google',
    'connect_with_apple': 'Connect with Apple',
    'sign_up_with_email': 'Sign up with Email',
    'terms_of_service': 'Terms of Service',
    'privacy_policy': 'Privacy Policy',
    'cookie_policy': 'Cookie Policy',
    'by_signing_up': 'By signing up, you accept TwinFinder\'s',
    'and_acknowledge': 'and acknowledge that you have read our',
    'and': 'and',

    // Language selection
    'select_language': 'Select Language',
    'language': 'Language',
    'english': 'English',
    'spanish': 'Spanish',
    'chinese': 'Chinese',
    'russian': 'Russian',

    // Profile setup
    'your_name': 'Your Name',
    'enter_your_name': 'Enter your name',
    'birthday': 'Birthday',
    'select_your_birthday': 'Select your birthday',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'country': 'Country',
    'select_country': 'Select country',
    'city': 'City',
    'select_city': 'Select city',
    'next': 'Next',
    'continue': 'Continue',

    // Profile page
    'change_profile_details': 'Change Profile Details',
    'change_photo': 'Change Photo',
    'logout': 'Logout',
    'logout_confirmation': 'Are you sure you want to logout?',
    'no': 'No',
    'yes': 'Yes',

    // Change Profile Details
    'update_profile': 'Update Profile',
    'please_select_city': 'Please select a city',
    'profile_settings': 'Profile Settings',
    'your_country': 'Your Country',
    'your_city': 'Your City',
    'save_profile': 'Save Profile',

    // Navigation
    'profile': 'Profile',
    'twin_finder': 'Twin Finder',
    'chat': 'Chat',

    // Errors
    'error': 'Error',
    'network_error': 'Network error',
    'try_again': 'Try again',
    'something_went_wrong': 'Something went wrong',

    // Maintenance page
    'maintenance_title': 'Technical Works',
    'maintenance_description':
        'We are currently performing technical maintenance. Please try again later.',
    'maintenance_retry': 'Try Again',

    // Success
    'success': 'Success',
    'profile_saved': 'Profile saved successfully',

    // Loading
    'loading': 'Loading...',
    'please_wait': 'Please wait...',

    // Common
    'cancel': 'Cancel',
    'done': 'Done',

    // Email pages
    'email': 'Email',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'enter_email': 'Enter your email',
    'enter_password': 'Enter your password',
    'confirm_your_password': 'Confirm your password',
    'sign_up': 'Sign Up',
    'sign_in': 'Sign In',
    'sign_in_with_email': 'Sign in with email',
    'already_have_account': 'Already have an account?',
    'dont_have_account': 'Don\'t have an account?',
    'verification_code': 'Verification Code',
    'enter_verification_code': 'Enter the verification code sent to your email',
    'resend_code': 'Resend Code',
    'verify': 'Verify',
    'code_sent': 'Code sent to your email',
    'invalid_code': 'Invalid verification code',
    'password_mismatch': 'Passwords do not match',
    'email_already_exists': 'Email already exists',
    'invalid_email': 'Invalid email address',
    'weak_password': 'Password is too weak',
    'enter_email_and_password': 'Enter your email and password to sign in.',

    // Input placeholders (English)
    'email_placeholder': 'Enter your email',
    'password_placeholder': 'Enter your password',
    'confirm_password_placeholder': 'Confirm your password',
    'verification_code_placeholder': 'Enter verification code',

    // Profile setup pages
    'what_is_your_name': 'What is your name?',
    'this_will_appear_on_your_profile':
        'This is how it\'ll appear on your profile.',
    'failed_to_update_name': 'Failed to update name',
    'name': 'Name',
    'name_required': 'Name is required',
    'age': 'Age',
    'location': 'Location',
    'your_age': 'Your Age',
    'your_gender': 'Your Gender',
    'when_were_you_born': 'When\'s your birthday?',
    'what_is_your_gender': 'What is your gender?',
    'where_are_you_from': 'Where are you from?',
    'select_country_first': 'Select country first',
    'search_country': 'Search country',
    'search_city': 'Search city',
    'no_countries_found': 'No countries found',
    'no_cities_found': 'No cities found',
    'popular_cities': 'Popular cities',
    'age_requirement': 'You must be at least 18 years old',
    'invalid_birth_date': 'Invalid birth date',
    'please_select_gender': 'Please select your gender',
    'please_select_country': 'Please select your country',

    // Face capture
    'take_photo': 'Take Photo',
    'retake_photo': 'Retake Photo',
    'photo_captured': 'Photo captured successfully',
    'camera_permission_required': 'Camera permission is required',
    'please_grant_camera_permission':
        'Please grant camera permission to continue',
    'camera_error': 'Camera error occurred',
    'photo_processing': 'Processing photo...',
    'looking_for_matches': 'We\'re looking for people\nwho look like you.',

    // Main app
    'welcome': 'Welcome',
    'settings': 'Settings',
    'edit_profile': 'Edit Profile',
    'delete_account': 'Delete Account',
    'about': 'About',
    'version': 'Version',
    'support': 'Support',
    'feedback': 'Feedback',
    'rate_app': 'Rate App',
    'share_app': 'Share App',

    // Twin finder
    'find_matches': 'Find Matches',
    'no_matches_found': 'No matches found',
    'swipe_right': 'Swipe right to like',
    'swipe_left': 'Swipe left to pass',
    'match_found': 'It\'s a match!',
    'start_conversation': 'Start a conversation',
    'matches_description':
        '152 people look more than 41% like you. Ready to meet your clones?',

    // Chat
    'messages': 'Messages',
    'new_message': 'New Message',
    'type_message': 'Type a message...',
    'send': 'Send',
    'online': 'Online',
    'last_seen': 'Last seen',
    'no_messages': 'No messages yet',
    'start_chatting': 'Start chatting with your matches',
    'coming_soon': 'Coming Soon',
    'chats_not_available':
        'The chats are not available yet, but we are working to ensure that you can access them first',
  };

  // Spanish strings
  static const Map<String, String> _spanishStrings = {
    // App general
    'app_name': 'TwinFinder',
    'find_your_twin': 'Encuentra tu Gemelo. Inicia una Nueva Conexión.',

    // Auth page
    'continue_with_google': 'Continuar con Google',
    'connect_with_apple': 'Conectar con Apple',
    'sign_up_with_email': 'Registrarse con Email',
    'terms_of_service': 'Términos de Servicio',
    'privacy_policy': 'Política de Privacidad',
    'cookie_policy': 'Política de Cookies',
    'by_signing_up': 'Al registrarte, aceptas los',
    'and_acknowledge': 'y reconoces que has leído nuestra',
    'and': 'y',

    // Language selection
    'select_language': 'Seleccionar Idioma',
    'language': 'Idioma',
    'english': 'Inglés',
    'spanish': 'Español',
    'chinese': 'Chino',
    'russian': 'Ruso',

    // Profile setup
    'your_name': 'Tu Nombre',
    'enter_your_name': 'Ingresa tu nombre',
    'birthday': 'Cumpleaños',
    'select_your_birthday': 'Selecciona tu cumpleaños',
    'gender': 'Género',
    'male': 'Masculino',
    'female': 'Femenino',
    'country': 'País',
    'select_country': 'Seleccionar país',
    'city': 'Ciudad',
    'select_city': 'Seleccionar ciudad',
    'next': 'Siguiente',
    'continue': 'Continuar',

    // Profile page
    'change_profile_details': 'Cambiar Detalles del Perfil',
    'change_photo': 'Cambiar Foto',
    'logout': 'Cerrar Sesión',
    'logout_confirmation': '¿Estás seguro de que quieres cerrar sesión?',
    'yes': 'Sí',
    'no': 'No',

    // Change profile details
    'update_profile': 'Actualizar Perfil',
    'please_select_city': 'Por favor selecciona una ciudad',
    'profile_settings': 'Configuración del Perfil',
    'your_country': 'Tu País',
    'your_city': 'Tu Ciudad',
    'save_profile': 'Guardar Perfil',

    // Navigation
    'profile': 'Perfil',
    'twin_finder': 'Buscador de Gemelos',
    'chat': 'Chat',

    // Errors
    'error': 'Error',
    'network_error': 'Error de red',
    'try_again': 'Intentar de nuevo',
    'something_went_wrong': 'Algo salió mal',

    // Maintenance page
    'maintenance_title': 'Trabajos Técnicos',
    'maintenance_description':
        'Actualmente estamos realizando mantenimiento técnico. Por favor, inténtalo más tarde.',
    'maintenance_retry': 'Intentar de Nuevo',

    // Success
    'success': 'Éxito',
    'profile_saved': 'Perfil guardado exitosamente',

    // Loading
    'loading': 'Cargando...',
    'please_wait': 'Por favor espera...',

    // Common
    'cancel': 'Cancelar',
    'done': 'Hecho',

    // Email pages
    'email': 'Email',
    'password': 'Contraseña',
    'confirm_password': 'Confirmar Contraseña',
    'enter_email': 'Ingresa tu email',
    'enter_password': 'Ingresa tu contraseña',
    'confirm_your_password': 'Confirma tu contraseña',
    'sign_up': 'Registrarse',
    'sign_in': 'Iniciar Sesión',
    'sign_in_with_email': 'Iniciar sesión con email',
    'already_have_account': '¿Ya tienes una cuenta?',
    'dont_have_account': '¿No tienes una cuenta?',
    'verification_code': 'Código de Verificación',
    'enter_verification_code':
        'Ingresa el código de verificación enviado a tu email',
    'resend_code': 'Reenviar Código',
    'verify': 'Verificar',
    'code_sent': 'Código enviado a tu email',
    'invalid_code': 'Código de verificación inválido',
    'password_mismatch': 'Las contraseñas no coinciden',
    'email_already_exists': 'El email ya existe',
    'invalid_email': 'Dirección de email inválida',
    'weak_password': 'La contraseña es muy débil',
    'enter_email_and_password':
        'Ingresa tu email y contraseña para iniciar sesión.',

    // Input placeholders (Spanish)
    'email_placeholder': 'Ingresa tu email',
    'password_placeholder': 'Ingresa tu contraseña',
    'confirm_password_placeholder': 'Confirma tu contraseña',
    'verification_code_placeholder': 'Ingresa código de verificación',

    // Profile setup pages
    'what_is_your_name': '¿Cuál es tu nombre?',
    'this_will_appear_on_your_profile': '¿Cómo aparecerá en tu perfil?',
    'failed_to_update_name': 'No se pudo actualizar el nombre',
    'name': 'Nombre',
    'name_required': 'Nombre es requerido',
    'age': 'Edad',
    'location': 'Ubicación',
    'your_age': 'Tu Edad',
    'your_gender': 'Tu Género',
    'when_were_you_born': '¿Cuándo naciste?',
    'what_is_your_gender': '¿Cuál es tu género?',
    'where_are_you_from': '¿De dónde eres?',
    'select_country_first': 'Selecciona un país primero',
    'search_country': 'Buscar país',
    'search_city': 'Buscar ciudad',
    'no_countries_found': 'No se encontraron países',
    'no_cities_found': 'No se encontraron ciudades',
    'popular_cities': 'Ciudades populares',
    'age_requirement': 'Debes tener al menos 18 años',
    'invalid_birth_date': 'Fecha de nacimiento inválida',
    'please_select_gender': 'Por favor selecciona tu género',
    'please_select_country': 'Por favor selecciona tu país',

    // Face capture
    'take_photo': 'Tomar Foto',
    'retake_photo': 'Volver a Tomar Foto',
    'photo_captured': 'Foto capturada exitosamente',
    'camera_permission_required': 'Se requiere permiso de cámara',
    'please_grant_camera_permission':
        'Por favor, otorga el permiso de cámara para continuar',
    'camera_error': 'Ocurrió un error de cámara',
    'photo_processing': 'Procesando foto...',
    'looking_for_matches': 'Estamos buscando personas\nque se parezcan a ti.',

    // Main app
    'welcome': 'Bienvenido',
    'settings': 'Ajustes',
    'edit_profile': 'Editar Perfil',
    'delete_account': 'Eliminar Cuenta',
    'about': 'Acerca de',
    'version': 'Versión',
    'support': 'Soporte',
    'feedback': 'Comentarios',
    'rate_app': 'Calificar Aplicación',
    'share_app': 'Compartir Aplicación',

    // Twin finder
    'find_matches': 'Encontrar Matches',
    'no_matches_found': 'No se encontraron matches',
    'swipe_right': 'Desliza a la derecha para gustar',
    'swipe_left': 'Desliza a la izquierda para pasar',
    'match_found': '¡Es un match!',
    'start_conversation': 'Iniciar una conversación',
    'matches_description':
        '152 personas parecen más del 41% como tú. ¿Listo para conocer a tus clones?',

    // Chat
    'messages': 'Mensajes',
    'new_message': 'Nuevo Mensaje',
    'type_message': 'Escribe un mensaje...',
    'send': 'Enviar',
    'online': 'En Línea',
    'last_seen': 'Último visto',
    'no_messages': 'Aún no hay mensajes',
    'start_chatting': 'Comienza a chatear con tus matches',
    'coming_soon': 'Próximamente',
    'chats_not_available':
        'Los chats aún no están disponibles, pero estamos trabajando para asegurar que puedas acceder a ellos primero',
  };

  // Chinese strings
  static const Map<String, String> _chineseStrings = {
    // App general
    'app_name': 'TwinFinder',
    'find_your_twin': '找到你的双胞胎。开始新的联系。',

    // Auth page
    'continue_with_google': '使用谷歌继续',
    'connect_with_apple': '连接苹果',
    'sign_up_with_email': '使用邮箱注册',
    'terms_of_service': '服务条款',
    'privacy_policy': '隐私政策',
    'cookie_policy': 'Cookie政策',
    'by_signing_up': '注册即表示您接受TwinFinder的',
    'and_acknowledge': '并确认您已阅读我们的',
    'and': '和',

    // Language selection
    'select_language': '选择语言',
    'language': '语言',
    'english': '英语',
    'spanish': '西班牙语',
    'chinese': '中文',
    'russian': '俄语',

    // Profile setup
    'your_name': '您的姓名',
    'enter_your_name': '输入您的姓名',
    'birthday': '生日',
    'select_your_birthday': '选择您的生日',
    'gender': '性别',
    'male': '男性',
    'female': '女性',
    'country': '国家',
    'select_country': '选择国家',
    'city': '城市',
    'select_city': '选择城市',
    'next': '下一步',
    'continue': '继续',

    // Profile page
    'change_profile_details': '更改个人资料详情',
    'change_photo': '更改照片',
    'logout': '退出登录',
    'logout_confirmation': '您确定要退出登录吗？',
    'yes': '是',
    'no': '否',

    // Change profile details
    'update_profile': '更新个人资料',
    'profile_updated': '个人资料更新成功',
    'please_select_city': '请选择您的城市',
    'profile_settings': '个人资料设置',
    'your_country': '您的国家',
    'your_city': '您的城市',
    'save_profile': '保存个人资料',

    // Navigation
    'profile': '个人资料',
    'twin_finder': '双胞胎查找器',
    'chat': '聊天',

    // Errors
    'error': '错误',
    'network_error': '网络错误',
    'try_again': '重试',
    'something_went_wrong': '出现错误',

    // Maintenance page
    'maintenance_title': '技术维护',
    'maintenance_description': '我们正在进行技术维护。请稍后再试。',
    'maintenance_retry': '重试',

    // Success
    'success': '成功',
    'profile_saved': '个人资料保存成功',

    // Loading
    'loading': '加载中...',
    'please_wait': '请稍候...',

    // Common
    'cancel': '取消',
    'done': '完成',

    // Email pages
    'email': '邮箱',
    'password': '密码',
    'confirm_password': '确认密码',
    'enter_email': '请输入您的邮箱',
    'enter_password': '请输入您的密码',
    'confirm_your_password': '请确认您的密码',
    'sign_up': '注册',
    'sign_in': '登录',
    'sign_in_with_email': '使用邮箱登录',
    'already_have_account': '已有账户？',
    'dont_have_account': '没有账户？',
    'verification_code': '验证码',
    'enter_verification_code': '请输入发送到您邮箱的验证码',
    'resend_code': '重新发送',
    'verify': '验证',
    'code_sent': '验证码已发送到您的邮箱',
    'invalid_code': '验证码无效',
    'password_mismatch': '密码不匹配',
    'email_already_exists': '邮箱已存在',
    'invalid_email': '邮箱地址无效',
    'weak_password': '密码太弱',
    'enter_email_and_password': '请输入您的邮箱和密码进行登录。',

    // Profile setup pages
    'what_is_your_name': '您的姓名是什么？',
    'this_will_appear_on_your_profile': '您的个人资料上将显示为',
    'failed_to_update_name': '更新姓名失败',
    'name': '姓名',
    'name_required': '姓名是必需的',
    'age': '年龄',
    'location': '位置',
    'your_age': '您的年龄',
    'your_gender': '您的性别',
    'when_were_you_born': '您几岁？',
    'what_is_your_gender': '您的性别是什么？',
    'where_are_you_from': '您来自哪里？',
    'select_country_first': '请先选择国家',
    'search_country': '搜索国家',
    'search_city': '搜索城市',
    'no_countries_found': '未找到国家',
    'no_cities_found': '未找到城市',
    'popular_cities': '热门城市',
    'age_requirement': '您必须至少18岁',
    'invalid_birth_date': '无效的出生日期',
    'please_select_gender': '请选择您的性别',
    'please_select_country': '请选择您的国家',

    // Face capture
    'take_photo': '拍照',
    'retake_photo': '重拍',
    'photo_captured': '照片拍摄成功',
    'camera_permission_required': '需要相机权限',
    'please_grant_camera_permission': '请授予相机权限以继续',
    'camera_error': '相机发生错误',
    'photo_processing': '正在处理照片...',
    'looking_for_matches': '我们正在寻找与您相似的人。',

    // Main app
    'welcome': '欢迎',
    'settings': '设置',
    'edit_profile': '编辑个人资料',
    'delete_account': '删除账号',
    'about': '关于',
    'version': '版本',
    'support': '支持',
    'feedback': '反馈',
    'rate_app': '评分应用',
    'share_app': '分享应用',

    // Twin finder
    'find_matches': '查找匹配',
    'no_matches_found': '未找到匹配',
    'swipe_right': '向右滑动以喜欢',
    'swipe_left': '向左滑动以跳过',
    'match_found': '是匹配！',
    'start_conversation': '开始对话',
    'matches_description': '152人看起来比您多41%相似。准备好与您的克隆人见面了吗？',

    // Chat
    'messages': '消息',
    'new_message': '新消息',
    'type_message': '输入消息...',
    'send': '发送',
    'online': '在线',
    'last_seen': '最后在线',
    'no_messages': '暂无消息',
    'start_chatting': '开始与您的匹配聊天',
    'coming_soon': '即将推出',
    'chats_not_available': '聊天功能尚未开放，但我们正在努力确保您能优先访问',
  };

  // Russian strings
  static const Map<String, String> _russianStrings = {
    // App general
    'app_name': 'TwinFinder',
    'find_your_twin': 'Найди своего близнеца. Начни новое знакомство.',

    // Auth page
    'continue_with_google': 'Продолжить с Google',
    'connect_with_apple': 'Подключиться через Apple',
    'sign_up_with_email': 'Зарегистрироваться по email',
    'terms_of_service': 'Условия использования',
    'privacy_policy': 'Политика конфиденциальности',
    'cookie_policy': 'Политика cookies',
    'by_signing_up': 'Регистрируясь, вы принимаете',
    'and_acknowledge': 'и подтверждаете, что прочитали нашу',
    'and': 'и',

    // Language selection
    'select_language': 'Выбрать язык',
    'language': 'Язык',
    'english': 'Английский',
    'spanish': 'Испанский',
    'chinese': 'Китайский',
    'russian': 'Русский',

    // Profile setup
    'your_name': 'Ваше имя',
    'enter_your_name': 'Введите ваше имя',
    'birthday': 'День рождения',
    'select_your_birthday': 'Выберите ваш день рождения',
    'gender': 'Пол',
    'male': 'Мужской',
    'female': 'Женский',
    'country': 'Страна',
    'select_country': 'Выберите страну',
    'city': 'Город',
    'select_city': 'Выберите город',
    'next': 'Далее',
    'continue': 'Продолжить',

    // Profile page
    'change_profile_details': 'Изменить детали профиля',
    'change_photo': 'Изменить фото',
    'logout': 'Выйти',
    'logout_confirmation': 'Вы уверены, что хотите выйти?',
    'yes': 'Да',
    'no': 'Нет',

    // Change profile details
    'update_profile': 'Изменить',
    'profile_updated': 'Профиль успешно обновлен',
    'please_select_city': 'Пожалуйста, выберите ваш город',
    'profile_settings': 'Настройки профиля',
    'your_country': 'Ваша страна',
    'your_city': 'Ваш город',
    'save_profile': 'Сохранить профиль',

    // Navigation
    'profile': 'Профиль',
    'twin_finder': 'Поиск близнеца',
    'chat': 'Чат',

    // Errors
    'error': 'Ошибка',
    'network_error': 'Ошибка сети',
    'try_again': 'Попробовать снова',
    'something_went_wrong': 'Что-то пошло не так',

    // Maintenance page
    'maintenance_title': 'Технические работы',
    'maintenance_description':
        'В настоящее время проводятся технические работы. Пожалуйста, попробуйте позже.',
    'maintenance_retry': 'Попробовать снова',

    // Success
    'success': 'Успех',
    'profile_saved': 'Профиль успешно сохранен',

    // Loading
    'loading': 'Загрузка...',
    'please_wait': 'Пожалуйста, подождите...',

    // Common
    'cancel': 'Отмена',
    'done': 'Готово',

    // Email pages
    'email': 'Email',
    'password': 'Пароль',
    'confirm_password': 'Подтвердите пароль',
    'enter_email': 'Введите ваш email',
    'enter_password': 'Введите ваш пароль',
    'confirm_your_password': 'Подтвердите ваш пароль',
    'sign_up': 'Зарегистрироваться',
    'sign_in': 'Войти',
    'sign_in_with_email': 'Войти по email',
    'already_have_account': 'Уже есть аккаунт?',
    'dont_have_account': 'Нет аккаунта?',
    'verification_code': 'Код подтверждения',
    'enter_verification_code':
        'Введите код подтверждения, отправленный на ваш email',
    'resend_code': 'Отправить код повторно',
    'verify': 'Подтвердить',
    'code_sent': 'Код отправлен на ваш email',
    'invalid_code': 'Неверный код подтверждения',
    'password_mismatch': 'Пароли не совпадают',
    'email_already_exists': 'Email уже существует',
    'invalid_email': 'Неверный адрес email',
    'weak_password': 'Пароль слишком слабый',
    'enter_email_and_password': 'Введите ваш email и пароль для входа.',

    // Profile setup pages
    'what_is_your_name': 'Как вас зовут?',
    'this_will_appear_on_your_profile':
        'Как это будет выглядеть на вашем профиле.',
    'failed_to_update_name': 'Не удалось обновить имя',
    'name': 'Имя',
    'name_required': 'Имя обязательно',
    'age': 'Возраст',
    'location': 'Местоположение',
    'your_age': 'Ваш возраст',
    'your_gender': 'Ваш пол',
    'when_were_you_born': 'Когда вы родились?',
    'what_is_your_gender': 'Какой у вас пол?',
    'where_are_you_from': 'Откуда вы?',
    'select_country_first': 'Сначала выберите страну',
    'search_country': 'Поиск страны',
    'search_city': 'Поиск города',
    'no_countries_found': 'Страны не найдены',
    'no_cities_found': 'Города не найдены',
    'popular_cities': 'Популярные города',
    'age_requirement': 'Вам должно быть не менее 18 лет',
    'invalid_birth_date': 'Неверная дата рождения',
    'please_select_gender': 'Пожалуйста, выберите ваш пол',
    'please_select_country': 'Пожалуйста, выберите вашу страну',

    // Face capture
    'take_photo': 'Сделать фото',
    'retake_photo': 'Сделать еще одно фото',
    'photo_captured': 'Фотография успешно сделана',
    'camera_permission_required':
        'Требуется разрешение на использование камеры',
    'please_grant_camera_permission':
        'Пожалуйста, предоставьте разрешение на использование камеры для продолжения',
    'camera_error': 'Произошла ошибка камеры',
    'photo_processing': 'Обработка фотографии...',
    'looking_for_matches': 'Мы ищем людей,\nкоторые похожи на вас.',

    // Main app
    'welcome': 'Добро пожаловать',
    'settings': 'Настройки',
    'edit_profile': 'Редактировать профиль',
    'delete_account': 'Удалить аккаунт',
    'about': 'О приложении',
    'version': 'Версия',
    'support': 'Поддержка',
    'feedback': 'Отзывы',
    'rate_app': 'Оценить приложение',
    'share_app': 'Поделиться приложением',

    // Twin finder
    'find_matches': 'Найти совпадения',
    'no_matches_found': 'Совпадения не найдены',
    'swipe_right': 'Пожалуйста, свайпните вправо, чтобы понравиться',
    'swipe_left': 'Пожалуйста, свайпните влево, чтобы пропустить',
    'match_found': 'Это совпадение!',
    'start_conversation': 'Начать разговор',
    'matches_description':
        '152 человека выглядят более чем на 41% похожи на вас. Готовы встретить своих клонов?',

    // Chat
    'messages': 'Сообщения',
    'new_message': 'Новое сообщение',
    'type_message': 'Введите сообщение...',
    'send': 'Отправить',
    'online': 'Онлайн',
    'last_seen': 'Последний раз в сети',
    'no_messages': 'Еще нет сообщений',
    'start_chatting': 'Начните общение с вашими совпадениями',
    'coming_soon': 'Скоро',
    'chats_not_available':
        'Чаты еще не доступны, но мы работаем над тем, чтобы вы могли их первыми получить доступ',
  };
}
