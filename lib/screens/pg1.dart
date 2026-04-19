import 'package:flutter/material.dart';
import 'pg2.dart';

class Pg1 extends StatelessWidget {
  const Pg1({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF5C239B);
    const bg = Color(0xFFF1EAF6);
    const cardWhite = Colors.white;
    const textDark = Color(0xFF24232A);
    const textSoft = Color(0xFF64616E);
    const lilacCard = Color(0xFFE7DDF1);

    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = screenWidth < 380 ? 120.0 : 140.0;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 28),

              // Logo superior
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Text(
                        'Negocios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              // Card principal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: cardWhite,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    _FeatureRow(
                      emoji: '📱',
                      boldText: 'Cobra con un QR',
                      normalText: ' y recibe el\ndinero al instante.',
                    ),
                    SizedBox(height: 18),
                    _FeatureRow(
                      emoji: '💸',
                      boldText: 'Gana comisiones',
                      normalText:
                          ' realizando\ndepósitos y retiros en tu negocio.',
                      soon: false,
                    ),
                    SizedBox(height: 18),
                    _FeatureRow(
                      emoji: '📊',
                      boldText: 'Controla tus ventas,',
                      normalText: ' gestiona\nvendedores, cajas y sucursales.',
                    ),
                    SizedBox(height: 18),
                    _FeatureRow(
                      emoji: '💳',
                      boldText: 'Cobra con tarjeta',
                      normalText: ' y atrae a nuevos clientes.',
                      soon: false,
                    ),
                    SizedBox(height: 18),
                    _FeatureRow(
                      emoji: '🎁',
                      boldText: 'Gana más ',
                      normalText: 'con tu código promocional.',
                      soon: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Verificar pagos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: lilacCard,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verificar pagos',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Usa el verificador de pagos\naquí',
                            style: TextStyle(
                              color: textSoft,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFFD46AF8),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: textDark,
                      size: 30,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Botón Registrarme
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Registrarme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón Ingresar
              SizedBox(
                width: double.infinity,
                height: 62,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Pg2()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: purple,
                    side: const BorderSide(color: purple, width: 2),
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

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String boldText;
  final String normalText;
  final bool soon;

  const _FeatureRow({
    required this.emoji,
    required this.boldText,
    required this.normalText,
    this.soon = false,
  });

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF24232A);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    color: textDark,
                  ),
                  children: [
                    TextSpan(
                      text: boldText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: normalText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (soon)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Muy pronto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}