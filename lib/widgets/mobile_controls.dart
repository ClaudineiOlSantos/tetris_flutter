import 'package:flutter/material.dart';

class MobileControls extends StatelessWidget {
  const MobileControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onRotate,
    required this.onSoftDrop,
    required this.onHardDrop,
  });

  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onRotate;
  final VoidCallback onSoftDrop;
  final VoidCallback onHardDrop;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        _ControlButton(
          icon: Icons.keyboard_arrow_left,
          label: 'Esquerda',
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          onPressed: onLeft,
        ),
        _ControlButton(
          icon: Icons.keyboard_arrow_right,
          label: 'Direita',
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          onPressed: onRight,
        ),
        _ControlButton(
          icon: Icons.rotate_right,
          label: 'Girar',
          backgroundColor: const Color(0xFFFBBF24),
          foregroundColor: const Color(0xFF2F241D),
          onPressed: onRotate,
        ),
        _ControlButton(
          icon: Icons.keyboard_arrow_down,
          label: 'Queda suave',
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          onPressed: onSoftDrop,
        ),
        _ControlButton(
          icon: Icons.vertical_align_bottom,
          label: 'Soltar',
          backgroundColor: const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          onPressed: onHardDrop,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: SizedBox(
        width: 58,
        height: 50,
        child: FilledButton(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 24),
        ),
      ),
    );
  }
}

