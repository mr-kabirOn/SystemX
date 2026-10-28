import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/sx_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../platform/platform.dart';
import '../../../ui/sx_icons.dart';
import '../test_catalog.dart';
import '../test_frame.dart';
import '../test_results.dart';

/// Preview, tap to focus, take a photo, then judge it. The photo is deleted
/// when the test ends; nothing is saved to the gallery.
class CameraTest extends StatefulWidget {
  const CameraTest({super.key, required this.test, required this.done})
      : assert(test == HwTest.rearCamera || test == HwTest.frontCamera);
  final HwTest test;
  final TestDone done;

  @override
  State<CameraTest> createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  CameraController? _controller;
  XFile? _photo;
  String? _error;
  bool _busy = false;
  AppLifecycleListener? _lifecycle;

  bool get _rear => widget.test == HwTest.rearCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
    // Android takes the camera away while the app is in the background; the
    // plugin doesn't reopen it, so release it on leaving and reopen on return.
    _lifecycle = AppLifecycleListener(
      onInactive: _release,
      onResume: () {
        if (_controller == null && _photo == null && _error == null) _open();
      },
    );
  }

  void _release() {
    final c = _controller;
    if (c == null || _photo != null) return;
    _controller = null;
    if (mounted) setState(() {});
    c.dispose();
  }

  Future<void> _open() async {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    try {
      final cams = await availableCameras();
      final want = _rear ? CameraLensDirection.back : CameraLensDirection.front;
      final desc = cams.where((c) => c.lensDirection == want).firstOrNull;
      if (desc == null) {
        widget.done(TestStatus.skipped, _rear ? l.nNoRearCamera : l.nNoFrontCamera);
        return;
      }
      final c = CameraController(desc, ResolutionPreset.high, enableAudio: false);
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (e) {
      if (mounted) setState(() => _error = l.nCameraError);
    }
  }

  Future<void> _capture() async {
    final c = _controller;
    if (c == null || _busy) return;
    setState(() => _busy = true);
    try {
      final photo = await c.takePicture();
      if (mounted) setState(() => _photo = photo);
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).nCameraError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _deletePhoto() {
    final p = _photo;
    if (p != null) {
      try {
        File(p.path).deleteSync();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    _controller?.dispose();
    _deletePhoto();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sx = context.sx;
    final c = _controller;
    final photo = _photo;

    Widget body;
    if (_error != null) {
      body = WaitingFor(icon: Icons.error_outline_rounded, text: _error!, color: sx.bad);
    } else if (photo != null) {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(File(photo.path), fit: BoxFit.contain),
      );
    } else if (c == null || !c.value.isInitialized) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(builder: (context, box) {
          return GestureDetector(
            onTapUp: (d) {
              final p = Offset(d.localPosition.dx / box.maxWidth,
                  d.localPosition.dy / box.maxHeight);
              c.setFocusPoint(p).catchError((_) {});
              c.setExposurePoint(p).catchError((_) {});
            },
            child: Center(child: CameraPreview(c)),
          );
        }),
      );
    }

    return TestFrame(
      test: widget.test,
      done: widget.done,
      instructions: _rear ? l.iRearCamera : l.iFrontCamera,
      bottom: _error != null
          ? FilledButton(
              onPressed: () => widget.done(TestStatus.failed, _error),
              child: Text(l.done),
            )
          : photo != null
              ? AskResult(
                  question: l.qPhotoClear,
                  done: widget.done,
                  passNote: l.nPhotoOk,
                  failNote: l.nPhotoBad,
                  extra: TextButton(
                    onPressed: () {
                      _deletePhoto();
                      setState(() => _photo = null);
                    },
                    child: Text(l.retake),
                  ),
                )
              : FilledButton.icon(
                  onPressed: c == null || _busy ? null : _capture,
                  icon: const Icon(Icons.camera_rounded),
                  label: Text(l.takePhoto),
                ),
      child: body,
    );
  }
}

class FlashlightTest extends ConsumerStatefulWidget {
  const FlashlightTest({super.key, required this.done});
  final TestDone done;

  @override
  ConsumerState<FlashlightTest> createState() => _FlashlightTestState();
}

class _FlashlightTestState extends ConsumerState<FlashlightTest> {
  // Read up front: dispose() needs it and may run before first use.
  late final HardwareTestApi _hw;
  bool _on = false;

  @override
  void initState() {
    super.initState();
    _hw = ref.read(hardwareTestApiProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final has = await _hw.hasTorch();
      if (!mounted) return;
      if (!has) {
        widget.done(TestStatus.skipped, AppLocalizations.of(context).nNoFlash);
        return;
      }
      final ok = await _hw.setTorch(true);
      if (mounted) setState(() => _on = ok);
    });
  }

  @override
  void dispose() {
    _hw.setTorch(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    void finish(TestStatus s, [String? n]) {
      _hw.setTorch(false);
      widget.done(s, n);
    }

    return TestFrame(
      test: HwTest.flashlight,
      done: finish,
      instructions: l.iFlashlight,
      bottom: AskResult(
        question: l.qFlashOn,
        done: finish,
        passNote: l.nFlashOk,
        failNote: l.nFlashBad,
      ),
      child: WaitingFor(
        icon: SxIcons.flashlight,
        text: _on ? l.flashOn : l.flashTurningOn,
        color: _on ? context.sx.warn : null,
      ),
    );
  }
}
