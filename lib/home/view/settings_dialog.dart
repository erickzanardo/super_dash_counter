import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return NesDialog.show(
      context: context,
      builder: (_) {
        return const SettingsDialog();
      },
      frame: NesWindowDialogFrame(
        leftIcon: NesIcons.wrench,
        title: 'Settings',
      ),
    );
  }

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final shorebirdCodePush = ShorebirdCodePush();

  Future<bool>? _isUpdateAvailable;
  Future<void>? _installUpdateFuture;

  Future<bool> _checkForUpdate() async {
    final isNewPatchAvailableForDownload =
        await shorebirdCodePush.isNewPatchAvailableForDownload();
    final isNewPatchAvailableForInstall =
        await shorebirdCodePush.isNewPatchReadyToInstall();

    return isNewPatchAvailableForInstall || isNewPatchAvailableForDownload;
  }

  Future<void> _installUpdate() async {
    await shorebirdCodePush.downloadUpdateIfAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 140,
      child: Column(
        children: [
          if (_isUpdateAvailable == null)
            NesButton(
              type: NesButtonType.normal,
              onPressed: () {
                setState(() {
                  _isUpdateAvailable = _checkForUpdate();
                });
              },
              child: const Text('Check for update!'),
            ),
          if (_isUpdateAvailable != null && _installUpdateFuture == null)
            FutureBuilder<bool>(
              future: _isUpdateAvailable,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NesTerminalLoadingIndicator();
                }

                if (snapshot.data == true) {
                  return NesButton(
                    type: NesButtonType.primary,
                    onPressed: () {
                      setState(() {
                        _installUpdateFuture = _installUpdate();
                      });
                    },
                    child: const Text('Install update!'),
                  );
                }

                return const Text('No update available!');
              },
            ),
          if (_installUpdateFuture != null)
            FutureBuilder<bool>(
              future: _isUpdateAvailable,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NesTerminalLoadingIndicator();
                }

                if (snapshot.data == true) {
                  return const Text(
                    'Updated installed! Restart the app to apply changes.',
                  );
                }

                return const Text('No update available!');
              },
            ),
        ],
      ),
    );
  }
}
