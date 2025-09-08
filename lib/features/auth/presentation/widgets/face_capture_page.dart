import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui; // для blur
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
// import 'package:twin_finder/features/auth/presentation/widgets/png_overlay_mask.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:image/image.dart' as img;

class FaceCapturePage extends StatefulWidget {
  const FaceCapturePage({super.key});

  @override
  State<FaceCapturePage> createState() => _FaceCapturePageState();
}

enum _Phase { live, processing, result }

class _FaceCapturePageState extends State<FaceCapturePage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  late List<CameraDescription> _cameras;
  bool _isBusy = false;

  // Новое: фаза/замороженный кадр
  _Phase _phase = _Phase.live;
  XFile? _shot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initFuture = _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller?.pausePreview();
      _controller?.resumePreview();
    }
  }

  // При смене lifecycle правильно останавливаем/возобновляем камеру (важно для Android)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (Platform.isIOS) {
      if (state == AppLifecycleState.inactive) {
        controller.dispose();
      } else if (state == AppLifecycleState.resumed) {
        _initFuture = _initCamera();
        setState(() {});
      }
    } else {
      // ANDROID
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.detached) {
        controller.dispose();
      } else if (state == AppLifecycleState.resumed) {
        _initFuture = _initCamera();
        setState(() {});
      }
      // На inactive на Android обычно ничего не делаем
    }
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    // Выбираем фронталку по возможности
    final front = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    final controller = CameraController(
      front,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.jpeg
          : ImageFormatGroup.bgra8888,
    );

    _controller = controller;
    await controller.initialize();
    await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    // Для фронталки обычно отключаем вспышку
    await controller.setFlashMode(FlashMode.off);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isBusy || _phase != _Phase.live) return; // не даём снимать повторно
    HapticFeedback.mediumImpact();

    setState(() => _isBusy = true);

    try {
      final file = await _controller!.takePicture();

      // Замораживаем UI на снятом кадре
      setState(() {
        _shot = file;
        _phase = _Phase.processing;
      });

      // При желании можно остановить превью (не обязательно)
      // await _controller?.pausePreview();

      // Подготовим изображение: фиксируем EXIF ориентацию, размораживаем зеркальность фронталки и кодируем JPEG
      final isFront = _controller!.description.lensDirection == CameraLensDirection.front;
      final processedFile = await _preparePhotoForUpload(File(file.path), flipHorizontal: isFront);

      // Загружаем фотографию на сервер (уже корректное JPEG)
      await context.read<AuthCubit>().uploadPhoto(processedFile);

      // После успешной загрузки показываем результат
      if (mounted) {
        setState(() => _phase = _Phase.result);
      }
    } catch (e) {
      if (mounted) {
        // Friendly, specific messages based on backend reason
        String msg = e.toString();
        String title = 'Upload failed';

        if (msg.toLowerCase().contains('face too small')) {
          title = 'Face too small';
          msg = 'Move closer and center your face inside the frame.';
        } else if (msg.toLowerCase().contains('profile not completed')) {
          title = 'Complete profile first';
          msg = 'Please fill in name, birthday, gender, country and city before uploading.';
        } else if (msg.toLowerCase().contains('invalid photo')) {
          title = 'Invalid photo';
          msg = 'Make sure your face is clearly visible and well lit.';
        } else if (msg.toLowerCase().contains('limit')) {
          title = 'Daily limit reached';
          msg = 'You’ve reached today’s upload limit. Please try again later.';
        } else if (msg.toLowerCase().contains('too large')) {
          title = 'File too large';
          msg = 'Please take a closer shot or lower resolution.';
        } else if (msg.toLowerCase().contains('authentication')) {
          title = 'Authentication required';
          msg = 'Please log in again to continue.';
        }

        ErrorHandler.showError(context, msg, title: title);
        
        // Возвращаемся к live режиму при ошибке
        setState(() {
          _phase = _Phase.live;
          _shot = null;
        });
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<File> _preparePhotoForUpload(
    File inputFile, {
    bool flipHorizontal = false,
  }) async {
    final bytes = await inputFile.readAsBytes();

    // Декодируем изображение (поддержка JPEG/HEIC зависит от платформы; camera даёт JPEG)
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      // На всякий случай — если не смогли декодировать, отправим как есть
      return inputFile;
    }

    // Применим EXIF-ориентацию (делает картинку «как видно пользователю»)
    img.Image fixed = img.bakeOrientation(decoded);

    // Для фронтальной камеры уберём зеркальность, если есть
    if (flipHorizontal) {
      fixed = img.flipHorizontal(fixed);
    }

    // Кодируем в JPEG с хорошим качеством
    final jpg = img.encodeJpg(fixed, quality: 92);

    // Пишем рядом с оригиналом, чтобы не тянуть path_provider
    final dirPath = inputFile.parent.path;
    final outPath = dirPath + '/processed_' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final outFile = File(outPath);
    await outFile.writeAsBytes(jpg, flush: true);
    return outFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPhotoUploaded) {
              // Фотография успешно загружена
              if (mounted) {
                setState(() => _phase = _Phase.result);
              }
            } else if (state is AuthFailure) {
              // Ошибка при загрузке фотографии
              if (mounted) {
                ErrorHandler.showError(
                  context,
                  '${L.error(context)}: ${state.message}',
                  title: L.error(context),
                );
                // Возвращаемся к live режиму при ошибке
                setState(() {
                  _phase = _Phase.live;
                  _shot = null;
                });
              }
            }
          },
          child: FutureBuilder<void>(
            future: _initFuture,
            builder: (context, snapshot) {
              final ready =
                  (snapshot.connectionState == ConnectionState.done &&
                      _controller != null &&
                      _controller!.value.isInitialized) ||
                  _phase != _Phase.live;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Back
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).maybePop();
                      },
                    ),
                  ),
                  // Title
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      L.takePhoto(context),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -0.48,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Карточка с камерой + маской + overlay-фазы
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          color: Colors.white.withOpacity(0.85),
                          child: ready
                              ? _CameraWithMask(
                                  controller: _controller!,
                                  phase: _phase,
                                  frozen: _shot,
                                  onCameraTap:
                                      (ready &&
                                          !_isBusy &&
                                          _phase == _Phase.live)
                                      ? _takePicture
                                      : null,
                                  onSeeMatches: () {
                                    HapticFeedback.lightImpact();
                                    // Navigate to main page with matches
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      AppRoutes.main,
                                      (route) => false,
                                    );
                                  },
                                )
                              : const Center(child: CustomCircularProgress()),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Вью с превью камеры (или замороженным снимком) + PNG-маска и overlay фаз
class _CameraWithMask extends StatelessWidget {
  final CameraController controller;
  final Function()? onCameraTap;
  final _Phase phase;
  final XFile? frozen;
  final VoidCallback? onSeeMatches;

  const _CameraWithMask({
    required this.controller,
    required this.onCameraTap,
    required this.phase,
    this.frozen,
    this.onSeeMatches,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        // “окно” под лицо (оставляю расчёт — вдруг вернёшься к кастомной обводке)
        final w = box.maxWidth;
        final h = box.maxHeight;

        final faceWidth = w * 0.58; // ширина “овала”
        final faceHeight = faceWidth * 1.18; // высота (слегка “яйцо”)
        final faceCenter = Offset(w / 2, h * 0.40); // смещение вверх

        final faceRect = Rect.fromCenter(
          center: faceCenter,
          width: faceWidth,
          height: faceHeight,
        );

        final isFront =
            controller.description.lensDirection == CameraLensDirection.front;

        // База: либо живое превью, либо зафиксированный снимок
        final Widget baseLayer = (phase == _Phase.live || frozen == null)
            ? Center(
                child: Transform.scale(
                  scale: 1.1,
                  child: const AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CameraPreviewPlaceholder(), // см. ниже
                  ),
                ),
              )
            : Center(
                child: Transform.scale(
                  scale: 1.1,
                  child: const AspectRatio(
                    aspectRatio: 9 / 16,
                    child: FrozenImagePlaceholder(), // см. ниже
                  ),
                ),
              );

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1) Подложка: либо камера, либо снимок.
            //    Чтобы сохранить твой визуал, делаю их через Inherited, ниже подменю.
            _BaseSwitcher(
              controller: controller,
              frozen: frozen,
              mirrorFrozen: isFront, // ⬅️ зеркалим кадр, если фронталка
              child: baseLayer,
            ),

            // 2) PNG-маска поверх
            AnimatedOpacity(
              opacity: (phase == _Phase.live && onCameraTap != null)
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: Image.asset(
                'assets/images/subtract.png',
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              opacity: (phase == _Phase.live && onCameraTap != null)
                  ? 0.0
                  : 1.0,
              duration: const Duration(milliseconds: 1000),
              child: Container(color: AppColors.white.withOpacity(0.4)),
            ),

            // 3) Кнопка “сфоткать” — только в LIVE
            AnimatedOpacity(
              opacity: (phase == _Phase.live && onCameraTap != null)
                  ? 1.0
                  : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: onCameraTap,
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      // child: const Icon(
                      //   Icons.photo_camera,
                      //   color: Colors.white,
                      //   size: 32,
                      // ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppIcons.camera,
                        color: Colors.white,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 4) Overlay-фазы: блюр + тексты/кнопка
            if (phase == _Phase.processing || phase == _Phase.result)
              _BlurOverlay(
                faceRect:
                    faceRect, // сейчас блюрим всё равномерно (как в макете)
                child: phase == _Phase.processing
                    ? _ProcessingContent()
                    : _ResultContent(onSeeMatches: onSeeMatches),
              ),
          ],
        );
      },
    );
  }
}

/// Блюр поверх контента карты (равномерный по всей области), с лёгким затемнением
class _BlurOverlay extends StatelessWidget {
  final Widget child;
  final Rect faceRect; // на будущее, если решишь блюрить только окно
  const _BlurOverlay({required this.child, required this.faceRect});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          color: Colors.white.withOpacity(0.08), // лёгкая вуаль
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Контент фазы "ожидание"
class _ProcessingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 33.5,
      ).copyWith(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Можно поставить свою иконку/анимацию
          CircularAvatarProgress(), // маленький кастом ниже
          SizedBox(height: 24),
          Text(
            L.photoProcessing(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontFamily: 'Bricolage Grotesque',
            ),
          ),
          SizedBox(height: 8),
          Text(
            L.lookingForMatches(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.3,
              color: Colors.black54,
              fontFamily: 'Bricolage Grotesque',
            ),
          ),
        ],
      ),
    );
  }
}

/// Контент фазы "результат"
class _ResultContent extends StatelessWidget {
  final VoidCallback? onSeeMatches;
  const _ResultContent({this.onSeeMatches});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(33.5, 0, 33.5, 16),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 128,
                  height: 128,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        // сюда можно положить эмоджи/иконку
                        child: Center(
                          child: Image.asset(AppImages.awesome, height: 64),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  L.matchFound(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  L.matchesDescription(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.3,
                    color: Colors.black54,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
                // const SizedBox(height: 24),

                // Кнопка See the Matches
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: onSeeMatches,
              child: Container(
                height: 56,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  L.startConversation(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Маленький круговой индикатор «в фирменном стиле»
class CircularAvatarProgress extends StatefulWidget {
  const CircularAvatarProgress({super.key});

  @override
  State<CircularAvatarProgress> createState() => _CircularAvatarProgressState();
}

class _CircularAvatarProgressState extends State<CircularAvatarProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return SizedBox(
          width: 128,
          height: 128,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                // сюда можно положить эмоджи/иконку
                child: Center(child: Image.asset(AppImages.space, height: 64)),
              ),
              Container(
                height: 112,
                width: 112,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 8,
                    color: AppColors.text.withOpacity(0.03),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Transform.rotate(
                angle: _c.value * 6.283185, // 2*pi
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child: CustomPaint(painter: _ArcPainter()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomCircularProgress extends StatefulWidget {
  const CustomCircularProgress({super.key});

  @override
  State<CustomCircularProgress> createState() => _CustomCircularProgressState();
}

class _CustomCircularProgressState extends State<CustomCircularProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return SizedBox(
          width: 68,
          height: 68,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 8,
                    color: AppColors.text.withOpacity(0.03),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Transform.rotate(
                angle: _c.value * 6.283185, // 2*pi
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: CustomPaint(painter: _ArcPainter()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFFF7A00)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Offset.zero & size;
    canvas.drawArc(rect.deflate(6), -1.2, 1.6, false, p);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) => false;
}

/// Хелпер: подменяем CameraPreview или Frozen Image, но **не трогаем** твою компоновку
class _BaseSwitcher extends InheritedWidget {
  final CameraController controller;
  final XFile? frozen;
  final bool mirrorFrozen; // ⬅️ новое

  const _BaseSwitcher({
    required this.controller,
    required this.frozen,
    required this.mirrorFrozen,
    required super.child,
  });

  static _BaseSwitcher? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BaseSwitcher>();

  @override
  bool updateShouldNotify(covariant _BaseSwitcher old) {
    return old.controller != controller ||
        old.frozen?.path != frozen?.path ||
        old.mirrorFrozen != mirrorFrozen;
  }
}

/// Плейсхолдер, который реальным виджетом CameraPreview заполняет родителя
class CameraPreviewPlaceholder extends StatelessWidget {
  const CameraPreviewPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    final data = _BaseSwitcher.of(context)!;
    return CameraPreview(data.controller);
  }
}

/// Плейсхолдер для зафиксированного снимка (Image.file с cover)
class FrozenImagePlaceholder extends StatelessWidget {
  const FrozenImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final data = _BaseSwitcher.of(context)!;
    final file = data.frozen!;

    Widget img = Image.file(File(file.path), fit: BoxFit.cover);

    if (data.mirrorFrozen) {
      img = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        child: img,
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: 720, height: 1280, child: img),
    );
  }
}
