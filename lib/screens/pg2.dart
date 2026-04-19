import 'package:flutter/material.dart';
import 'pg3.dart';

class Pg2 extends StatefulWidget {
  const Pg2({super.key});

  @override
  State<Pg2> createState() => _Pg2State();
}

class _Pg2State extends State<Pg2> {
  int selectedRole = 0;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5A1FA0);
    const teal = Color(0xFF0A8C95);
    const textDark = Color(0xFF2C2C34);
    const lilac = Color(0xFFF1E9FA);

    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 380;

    final logoWidth = isSmall ? 120.0 : 140.0;
    final qrFrameWidth = isSmall ? size.width * 0.78 : 320.0;
    final qrBoxSize = isSmall ? size.width * 0.56 : 230.0;
    final titleSize = isSmall ? 16.0 : 18.0;
    final actionSpacing = isSmall ? 24.0 : 42.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Negocios',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: qrFrameWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 12 : 18,
                            vertical: isSmall ? 10 : 12,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: _cornerMark(
                                  top: true,
                                  left: true,
                                  isSmall: isSmall,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: _cornerMark(
                                  top: true,
                                  left: false,
                                  isSmall: isSmall,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: _cornerMark(
                                  top: false,
                                  left: true,
                                  isSmall: isSmall,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: _cornerMark(
                                  top: false,
                                  left: false,
                                  isSmall: isSmall,
                                ),
                              ),
                              Container(
                                width: qrBoxSize,
                                height: qrBoxSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  children: [
                                    CustomPaint(
                                      size: Size(qrBoxSize, qrBoxSize),
                                      painter: FakeQrPainter(boxSize: qrBoxSize),
                                    ),
                                    Center(
                                      child: Container(
                                        width: isSmall ? 48 : 56,
                                        height: isSmall ? 48 : 56,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'd!',
                                          style: TextStyle(
                                            color: purple,
                                            fontWeight: FontWeight.w900,
                                            fontStyle: FontStyle.italic,
                                            fontSize: isSmall ? 19 : 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Cobra con este QR',
                          style: TextStyle(
                            fontSize: titleSize,
                            color: textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  Container(
                    height: 58,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F2),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFE6E6EA)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _roleButton(
                            label: 'Administrador',
                            selected: selectedRole == 0,
                            onTap: () {
                              setState(() => selectedRole = 0);
                            },
                          ),
                        ),
                        Expanded(
                          child: _roleButton(
                            label: 'Vendedor',
                            selected: selectedRole == 1,
                            onTap: () {
                              setState(() => selectedRole = 1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Verificar un cobro',
                    style: TextStyle(
                      fontSize: isSmall ? 15 : 16,
                      color: textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: actionSpacing,
                    runSpacing: 16,
                    children: [
                      _actionItem(
                        icon: Icons.chat_outlined,
                        label: 'Por whatsapp',
                        bgColor: lilac,
                        iconColor: textDark,
                      ),
                      _actionItem(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Escaneando QR',
                        bgColor: lilac,
                        iconColor: purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Pg3()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    const purple = Color(0xFF5A1FA0);
    const textLight = Color(0xFF8A8A98);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? purple : textLight,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _actionItem({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5F6070),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _cornerMark({
    required bool top,
    required bool left,
    required bool isSmall,
  }) {
    const cornerColor = Color(0xFFD6D8E2);
    final double size = isSmall ? 34 : 42;
    final double thickness = isSmall ? 3 : 4;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CornerPainter(
          color: cornerColor,
          thickness: thickness,
          top: top,
          left: left,
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool top;
  final bool left;

  CornerPainter({
    required this.color,
    required this.thickness,
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final path = Path();

    if (top && left) {
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, 0)
        ..lineTo(0, size.height);
    } else if (top && !left) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height);
    } else if (!top && left) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FakeQrPainter extends CustomPainter {
  final double boxSize;

  FakeQrPainter({required this.boxSize});

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;

    final double cell = boxSize / 23;
    final int rows = (boxSize / cell).floor();
    final int cols = (boxSize / cell).floor();

    bool isFinderArea(int r, int c) {
      bool topLeft = r < 7 && c < 7;
      bool topRight = r < 7 && c > cols - 8;
      bool bottomLeft = r > rows - 8 && c < 7;
      return topLeft || topRight || bottomLeft;
    }

    void drawFinder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 7, cell * 7), blackPaint);
      canvas.drawRect(
        Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
        Paint()..color = Colors.white,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        blackPaint,
      );
    }

    drawFinder(0, 0);
    drawFinder(boxSize - cell * 7, 0);
    drawFinder(0, boxSize - cell * 7);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (isFinderArea(r, c)) continue;

        final bool fill = ((r * 7 + c * 11) % 5 == 0) ||
            ((r + c) % 7 == 0) ||
            ((r * c) % 13 == 0);

        if (fill) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell, cell),
            blackPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}