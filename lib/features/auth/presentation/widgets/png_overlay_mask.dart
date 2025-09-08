import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Рисует полупрозрачный overlay и вырезает «окно» по альфе PNG.
// Плюс рисует белое кольцо той же формы (толщину регулирует ringWidth).
class PngMaskOverlay extends StatefulWidget {
  final Rect faceRect; // куда вписывать маску
  final String assetPath; // путь к PNG с прозрачным фоном
  final double overlayOpacity; // 0..1
  final double ringWidth; // px
  final double ringOpacity; // 0..1
  final double maskScale; // 1.0 — ровно в faceRect; >1 — чуть больше
  final EdgeInsets srcInsets; // обрезка исходного PNG, если есть поля

  const PngMaskOverlay({
    super.key,
    required this.faceRect,
    required this.assetPath,
    this.overlayOpacity = 0.45,
    this.ringWidth = 2.0,
    this.ringOpacity = 0.9,
    this.maskScale = 1.0,
    this.srcInsets = EdgeInsets.zero,
  });

  @override
  State<PngMaskOverlay> createState() => _PngMaskOverlayState();
}

class _PngMaskOverlayState extends State<PngMaskOverlay> {
  ui.Image? _img;
  ImageStream? _stream;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PngMaskOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeStream();
      _load();
    }
  }

  void _disposeStream() {
    _stream?.removeListener(ImageStreamListener(_onImage, onError: _onError));
    _stream = null;
  }

  Future<void> _load() async {
    final provider = AssetImage(widget.assetPath);
    final cfg = createLocalImageConfiguration(context);
    final stream = provider.resolve(cfg);
    _stream = stream;
    stream.addListener(ImageStreamListener(_onImage, onError: _onError));
  }

  void _onImage(ImageInfo info, bool _) {
    setState(() => _img = info.image);
  }

  void _onError(Object e, StackTrace? st) {
    // Можно залогировать
  }

  @override
  void dispose() {
    _disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ImageMaskPainter(
        image: _img,
        faceRect: widget.faceRect,
        overlayOpacity: widget.overlayOpacity,
        ringWidth: widget.ringWidth,
        ringOpacity: widget.ringOpacity,
        maskScale: widget.maskScale,
        srcInsets: widget.srcInsets,
      ),
    );
  }
}

class _ImageMaskPainter extends CustomPainter {
  final ui.Image? image;
  final Rect faceRect;
  final double overlayOpacity;
  final double ringWidth;
  final double ringOpacity;
  final double maskScale;
  final EdgeInsets srcInsets;

  _ImageMaskPainter({
    required this.image,
    required this.faceRect,
    required this.overlayOpacity,
    required this.ringWidth,
    required this.ringOpacity,
    required this.maskScale,
    required this.srcInsets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    // Если ещё не загрузилось — просто затемним, без "дырки"
    if (image == null) {
      final p = Paint()
        ..color = const Color(0xFF000000).withOpacity(overlayOpacity);
      canvas.drawRect(bounds, p);
      return;
    }

    // Готовим src-Rect из PNG (обрежем поля, если заданы)
    final imgW = image!.width.toDouble();
    final imgH = image!.height.toDouble();
    final src = Rect.fromLTWH(
      srcInsets.left,
      srcInsets.top,
      imgW - srcInsets.left - srcInsets.right,
      imgH - srcInsets.top - srcInsets.bottom,
    );

    // dst-Rect (куда впишем маску), масштабируем слегка при необходимости
    Rect dst = faceRect;
    if (maskScale != 1.0) {
      final cx = dst.center.dx;
      final cy = dst.center.dy;
      final nw = dst.width * maskScale;
      final nh = dst.height * maskScale;
      dst = Rect.fromCenter(center: Offset(cx, cy), width: nw, height: nh);
    }

    // 1) Слой для смешения
    canvas.saveLayer(bounds, Paint());

    // 2) Полупрозрачный overlay
    final overlayPaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(overlayOpacity);
    canvas.drawRect(bounds, overlayPaint);

    // 3) Вырезаем «окно» по альфе PNG (любой непрозрачный пиксель очищает слой)
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawImageRect(image!, src, dst, clearPaint);

    // 4) Белое кольцо той же формы:
    //    нарисуем маску белым с лёгким расширением, потом внутрь ещё раз "очистим"
    if (ringWidth > 0) {
      final ringOuter = dst.inflate(ringWidth); // чуть больше
      final ringInner = dst.deflate(ringWidth); // и вычистим внутри

      // нарисуем белую форму (цвет берётся по альфе PNG)
      final whitePaint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withOpacity(ringOpacity),
          BlendMode.srcIn,
        );
      canvas.drawImageRect(image!, src, ringOuter, whitePaint);

      // очистим внутренность — останется только кольцо
      canvas.drawImageRect(image!, src, ringInner, clearPaint);
    }

    // 5) Завершаем слой
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ImageMaskPainter old) {
    return old.image != image ||
        old.faceRect != faceRect ||
        old.overlayOpacity != overlayOpacity ||
        old.ringWidth != ringWidth ||
        old.ringOpacity != ringOpacity ||
        old.maskScale != maskScale ||
        old.srcInsets != srcInsets;
  }
}
