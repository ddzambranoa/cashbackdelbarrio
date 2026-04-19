import 'package:flutter/material.dart';
import 'dart:async';
import 'reward_service.dart';

class PremioCanje {
  String nombre;
  int puntos;

  PremioCanje({
    required this.nombre,
    required this.puntos,
  });
}

class PromoItem {
  String nombre;
  String descripcion;
  String puntosPorCompra;
  String compraMinima;
  String tipoBeneficio;
  String vigencia;
  bool activa;
  int usos;
  DateTime fechaCreacion;

  PromoItem({
    required this.nombre,
    required this.descripcion,
    required this.puntosPorCompra,
    required this.compraMinima,
    required this.tipoBeneficio,
    required this.vigencia,
    this.activa = true,
    this.usos = 0,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();
}

class Pg3 extends StatefulWidget {
  const Pg3({super.key});

  @override
  State<Pg3> createState() => _Pg3State();
}

class _Pg3State extends State<Pg3> {
  static const Color purple = Color(0xFF6523A8);
  static const Color softGrey = Color(0xFF8A8A98);
  static const Color borderGrey = Color(0xFFE9E9EE);
  int puntosTotalesClientes = 1260;
  final RewardService rewardService = RewardService();
  Timer? _syncTimer;
  bool syncingRewards = false;

  int bottomIndex = 0;
  int selectedTab = 0;
  int promoTab = 0;

  String amount = '';
  String selectedMethod = 'QR';
  String motivo = '';

  final TextEditingController promoNameController = TextEditingController();
  final TextEditingController promoDescController = TextEditingController();
  final TextEditingController puntosController =
      TextEditingController(text: '10');
  final TextEditingController compraMinController =
      TextEditingController(text: '5');
  final TextEditingController mensajeClienteController = TextEditingController(
    text: 'Gana puntos en cada compra y canjéalos por beneficios.',
  );

  String promoVigencia = '30 días';
  bool promoActiva = true;

  bool cashbackEnabled = false;
  double cashbackPercent = 5;

  bool puntosEnabled = true;
  int puntosMinCanje = 100;
  double valorPunto = 0.01;

  bool notificacionesPromo = true;
  bool mostrarProgresoCliente = true;
  bool permitirAcumulacion = true;

  int? _promoEnEdicion;

  final List<PremioCanje> premiosCanje = [
    PremioCanje(nombre: 'Nivel 1', puntos: 25),
    PremioCanje(nombre: 'Nivel 2', puntos: 50),
    PremioCanje(nombre: 'Nivel 3', puntos: 75),
    PremioCanje(nombre: 'Nivel 4', puntos: 100),
  ];

  final List<PromoItem> promociones = [
    PromoItem(
      nombre: 'Bienvenida Clientes',
      descripcion: 'Acumula puntos en tu primera compra.',
      puntosPorCompra: '15',
      compraMinima: '3',
      tipoBeneficio: 'Puntos',
      vigencia: '30 días',
      activa: true,
      usos: 12,
    ),
  ];
Future<void> _abrirMisBeneficios() async {
  final nuevoTotal = await Navigator.of(context).push<int>(
    MaterialPageRoute(
      builder: (_) => _MisBeneficiosPage(
        puntosTotalesIniciales: puntosTotalesClientes,
      ),
    ),
  );

  if (nuevoTotal != null) {
    setState(() {
      puntosTotalesClientes = nuevoTotal;
    });

    _showImpactNotification(
      title: 'Puntos actualizados',
      message: 'Ahora tienes $puntosTotalesClientes puntos acumulados.',
      icon: Icons.stars_outlined,
      backgroundColor: const Color(0xFF2E7D32),
    );
  }
}

Widget _buildBeneficiosButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      onPressed: _abrirMisBeneficios,
      icon: const Icon(Icons.workspace_premium_outlined),
      label: const Text(
        'Mis beneficios',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF3ECFB),
        foregroundColor: purple,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5D8F6)),
        ),
      ),
    ),
  );
}
  @override
  void initState() {
    super.initState();
    _loadRewardsFromDb();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    promoNameController.dispose();
    promoDescController.dispose();
    puntosController.dispose();
    compraMinController.dispose();
    mensajeClienteController.dispose();
    super.dispose();
  }

  String get displayAmount {
    if (amount.isEmpty) return '0,00';

    if (amount.contains(',')) {
      final parts = amount.split(',');
      final integerPart = parts[0].isEmpty ? '0' : parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '';

      if (decimalPart.isEmpty) return '$integerPart,';
      if (decimalPart.length == 1) return '$integerPart,$decimalPart';
      return '$integerPart,${decimalPart.substring(0, 2)}';
    }

    return amount;
  }

  void _showImpactNotification({
    required String title,
    required String message,
    IconData icon = Icons.notifications_active_outlined,
    Color backgroundColor = purple,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadRewardsFromDb() async {
    try {
      final data = await rewardService.getRewards();

      if (data.isEmpty) {
        await rewardService.replaceAllRewards(
          premiosCanje
              .map((p) => RewardDraft(nombre: p.nombre, puntos: p.puntos))
              .toList(),
        );
        final seeded = await rewardService.getRewards();
        if (!mounted) return;
        setState(() {
          premiosCanje
            ..clear()
            ..addAll(
              seeded.map(
                (item) => PremioCanje(
                  nombre: item['reward_name'] as String,
                  puntos: item['points_required'] as int,
                ),
              ),
            );
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        premiosCanje
          ..clear()
          ..addAll(
            data.map(
              (item) => PremioCanje(
                nombre: item['reward_name'] as String,
                puntos: item['points_required'] as int,
              ),
            ),
          );
      });
    } catch (e) {
      _showImpactNotification(
        title: 'Error al cargar premios',
        message: e.toString(),
        icon: Icons.error_outline,
        backgroundColor: const Color(0xFFD32F2F),
      );
    }
  }

  void _scheduleRewardSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(milliseconds: 700), () {
      _syncPremiosToDb();
    });
  }

  Future<void> _syncPremiosToDb() async {
    try {
      if (mounted) {
        setState(() {
          syncingRewards = true;
        });
      }

      final rewards = premiosCanje
          .map(
            (p) => RewardDraft(
              nombre: p.nombre,
              puntos: p.puntos,
            ),
          )
          .toList();

      await rewardService.replaceAllRewards(rewards);

      _showImpactNotification(
        title: 'Premios sincronizados',
        message: 'La base de datos ya refleja tu lista actual.',
        icon: Icons.sync,
        backgroundColor: const Color(0xFF2E7D32),
      );
    } catch (e) {
      _showImpactNotification(
        title: 'Error al sincronizar',
        message: e.toString(),
        icon: Icons.error_outline,
        backgroundColor: const Color(0xFFD32F2F),
      );
    } finally {
      if (mounted) {
        setState(() {
          syncingRewards = false;
        });
      }
    }
  }

  void _agregarPremioCanje() {
    setState(() {
      final siguienteNivel = premiosCanje.length + 1;
      final puntosBase = siguienteNivel * 25;

      premiosCanje.add(
        PremioCanje(
          nombre: 'Nivel $siguienteNivel',
          puntos: puntosBase,
        ),
      );
    });

    _scheduleRewardSync();

    _showImpactNotification(
      title: 'Nuevo nivel agregado',
      message: 'Tu programa de premios ahora tiene un nuevo escalón.',
      icon: Icons.add_circle_outline,
      backgroundColor: const Color(0xFF2E7D32),
    );
  }

  void _eliminarPremioCanje(int index) {
    if (premiosCanje.length <= 1) {
      _showImpactNotification(
        title: 'Acción bloqueada',
        message: 'Debes mantener al menos un premio activo.',
        icon: Icons.warning_amber_outlined,
        backgroundColor: const Color(0xFFD32F2F),
      );
      return;
    }

    final nombre = premiosCanje[index].nombre;

    setState(() {
      premiosCanje.removeAt(index);
    });

    _scheduleRewardSync();

    _showImpactNotification(
      title: 'Premio eliminado',
      message: '$nombre salió de tu catálogo de canje.',
      icon: Icons.delete_outline,
      backgroundColor: const Color(0xFFD32F2F),
    );
  }

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'delete') {
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
        }
        return;
      }

      if (value == ',') {
        if (amount.isEmpty) {
          amount = '0,';
        } else if (!amount.contains(',')) {
          amount += ',';
        }
        return;
      }

      if (amount == '0') {
        amount = value;
        return;
      }

      if (amount.contains(',')) {
        final parts = amount.split(',');
        if (parts.length > 1 && parts[1].length >= 2) {
          return;
        }
      }

      amount += value;
    });
  }

  Future<void> _editMotivo() async {
    final controller = TextEditingController(text: motivo);

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar motivo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLength: 50,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ej: Venta de producto',
                  filled: true,
                  fillColor: const Color(0xFFF7F7FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, controller.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        motivo = result;
      });
      _showImpactNotification(
        title: 'Motivo actualizado',
        message: 'Tu cobro ahora tiene un contexto más claro.',
        icon: Icons.edit_note_outlined,
      );
    }
  }

  void _changeMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

  void _guardarPromo() {
    final nombre = promoNameController.text.trim().isEmpty
        ? 'Nueva promoción'
        : promoNameController.text.trim();

    final descripcion = promoDescController.text.trim().isEmpty
        ? 'Promoción creada por el comercio'
        : promoDescController.text.trim();

    final bool editando = _promoEnEdicion != null;

    setState(() {
      final nuevaPromo = PromoItem(
        nombre: nombre,
        descripcion: descripcion,
        puntosPorCompra: puntosController.text.trim().isEmpty
            ? '10'
            : puntosController.text.trim(),
        compraMinima: compraMinController.text.trim().isEmpty
            ? '5'
            : compraMinController.text.trim(),
        tipoBeneficio: 'Puntos',
        vigencia: promoVigencia,
        activa: promoActiva,
        usos: editando ? promociones[_promoEnEdicion!].usos : 0,
        fechaCreacion:
            editando ? promociones[_promoEnEdicion!].fechaCreacion : DateTime.now(),
      );

      if (editando) {
        promociones[_promoEnEdicion!] = nuevaPromo;
      } else {
        promociones.add(nuevaPromo);
      }

      promoNameController.clear();
      promoDescController.clear();
      puntosController.text = '10';
      compraMinController.text = '5';
      promoVigencia = '30 días';
      promoActiva = true;
      _promoEnEdicion = null;
      promoTab = 0;
    });

    _showImpactNotification(
      title: editando ? 'Promoción actualizada' : 'Promoción creada',
      message: editando
          ? '$nombre fue mejorada y ya está lista para seguir vendiendo.'
          : '$nombre ya está lista para atraer más clientes.',
      icon: editando ? Icons.auto_fix_high_outlined : Icons.celebration_outlined,
      backgroundColor: editando ? const Color(0xFF3F51B5) : purple,
    );
  }

  void _editarPromo(int index) {
    final promo = promociones[index];

    setState(() {
      promoNameController.text = promo.nombre;
      promoDescController.text = promo.descripcion;
      puntosController.text = promo.puntosPorCompra;
      compraMinController.text = promo.compraMinima;
      promoVigencia = promo.vigencia;
      promoActiva = promo.activa;
      _promoEnEdicion = index;
      promoTab = 1;
      bottomIndex = 1;
    });

    _showImpactNotification(
      title: 'Modo edición',
      message: 'Estás ajustando "${promo.nombre}". Hazla irresistible.',
      icon: Icons.edit_outlined,
      backgroundColor: const Color(0xFF455A64),
    );
  }

  void _togglePausaPromo(int index) {
    setState(() {
      promociones[index].activa = !promociones[index].activa;
    });

    final promo = promociones[index];

    _showImpactNotification(
      title: promo.activa ? 'Promoción reactivada' : 'Promoción pausada',
      message: promo.activa
          ? '${promo.nombre} volvió a competir por tus clientes.'
          : '${promo.nombre} quedó en pausa temporal.',
      icon: promo.activa
          ? Icons.play_circle_outline
          : Icons.pause_circle_outline,
      backgroundColor:
          promo.activa ? const Color(0xFF2E7D32) : const Color(0xFF757575),
    );
  }

  Future<void> _confirmarEliminarPromo(int index) async {
    final promo = promociones[index];

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar promoción'),
          content: Text(
            '¿Seguro que deseas eliminar "${promo.nombre}"? Esta acción no se puede deshacer.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      _eliminarPromo(index);
    }
  }

  void _eliminarPromo(int index) {
    final nombre = promociones[index].nombre;

    setState(() {
      promociones.removeAt(index);
    });

    _showImpactNotification(
      title: 'Promoción eliminada',
      message: '$nombre salió del tablero comercial.',
      icon: Icons.delete_outline,
      backgroundColor: const Color(0xFFD32F2F),
    );
  }

  Widget _promoInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF5A5A67),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPromoActions(int index, PromoItem promo) {
    final buttons = [
      _PromoActionButton(
        icon: Icons.edit_outlined,
        label: 'Editar',
        onPressed: () => _editarPromo(index),
        type: _PromoActionType.outlinePurple,
      ),
      _PromoActionButton(
        icon: promo.activa
            ? Icons.pause_circle_outline
            : Icons.play_circle_outline,
        label: promo.activa ? 'Pausar' : 'Activar',
        onPressed: () => _togglePausaPromo(index),
        type: _PromoActionType.outlineGrey,
      ),
      _PromoActionButton(
        icon: Icons.delete_outline,
        label: 'Eliminar',
        onPressed: () => _confirmarEliminarPromo(index),
        type: _PromoActionType.danger,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 420;

        if (narrow) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: buttons
                .map(
                  (button) => SizedBox(
                    width: (constraints.maxWidth - 10) / 2,
                    child: button,
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 92,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEDEDF2)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomItem(
              icon: Icons.home,
              label: 'Inicio',
              selected: bottomIndex == 0,
              onTap: () {
                setState(() {
                  bottomIndex = 0;
                });
              },
            ),
            _BottomItem(
              icon: Icons.card_giftcard,
              label: 'Mis Ofertas',
              selected: bottomIndex == 1,
              showBadge: true,
              onTap: () {
                setState(() {
                  bottomIndex = 1;
                  promoTab = 1;
                });
              },
            ),
            _BottomItem(
              icon: Icons.storefront_outlined,
              label: 'Mi Caja',
              selected: bottomIndex == 2,
              onTap: () {
                setState(() {
                  bottomIndex = 2;
                });
              },
            ),
            _BottomItem(
              icon: Icons.menu,
              label: 'Menú',
              selected: bottomIndex == 3,
              onTap: () {
                setState(() {
                  bottomIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const Divider(height: 1, color: Color(0xFFEFEFF4)),
            Expanded(
              child: IndexedStack(
                index: bottomIndex,
                children: [
                  IndexedStack(
                    index: selectedTab,
                    children: [
                      SingleChildScrollView(
                        child: _buildCobrarContent(),
                      ),
                      _buildGestionarContent(),
                    ],
                  ),
                  _buildPromocionesContent(),
                  _buildMiCajaContent(),
                  _buildMenuContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: purple.withOpacity(0.15),
                child: const Icon(Icons.store, color: purple, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Row(
                  children: [
                    Text(
                      'Hola! Daniel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 8),
                    _AdminBadge(),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _showImpactNotification(
                    title: 'Escáner listo',
                    message: 'Tu comercio está preparado para verificar pagos.',
                    icon: Icons.qr_code_scanner,
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
              ),
              IconButton(
                onPressed: () {
                  _showImpactNotification(
                    title: 'Novedades de negocio',
                    message:
                        'Hoy puedes activar promociones con puntos y cashback.',
                    icon: Icons.notifications_active_outlined,
                    backgroundColor: const Color(0xFF1976D2),
                  );
                },
                icon: const Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () {
                  _showImpactNotification(
                    title: 'Soporte disponible',
                    message: 'Un buen negocio también sabe cuándo pedir ayuda.',
                    icon: Icons.headset_mic_outlined,
                    backgroundColor: const Color(0xFF00897B),
                  );
                },
                icon: const Icon(Icons.headset_mic_outlined),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 44),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Zambrano Andrade Daniel...',
                style: TextStyle(
                  color: Color(0xFF676774),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (bottomIndex == 0)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = 0);
                    },
                    child: Column(
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            color: selectedTab == 0
                                ? purple
                                : const Color(0xFF6F6F7C),
                            fontSize: 18,
                            fontWeight: selectedTab == 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          child: const Text('Cobrar'),
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          height: 3,
                          color: selectedTab == 0 ? purple : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = 1);
                    },
                    child: Column(
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            color: selectedTab == 1
                                ? purple
                                : const Color(0xFF6F6F7C),
                            fontSize: 18,
                            fontWeight: selectedTab == 1
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          child: const Text('Gestionar'),
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          height: 3,
                          color: selectedTab == 1 ? purple : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else if (bottomIndex == 1)
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ofertas exclusivas para tus clientes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1E24),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildPromoTab('Activas', 0),
                      _buildPromoTab('Crear', 1),
                      _buildPromoTab('Config.', 2),
                    ],
                  ),
                ),
              ],
            )
          else if (bottomIndex == 2)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mi Caja',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E24),
                ),
              ),
            )
          else
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menú',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E24),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCobrarContent() {
    return Column(
      children: [
        const SizedBox(height: 22),
        const Text(
          'Monto',
          style: TextStyle(
            color: softGrey,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '\$$displayAmount',
          style: const TextStyle(
            color: Color(0xFF17171D),
            fontSize: 44,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: 300,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _buildMethodTab('QR'),
              _buildMethodTab('Tarjeta'),
              _buildMethodTab('Man...'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        InkWell(
          onTap: _editMotivo,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderGrey),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    motivo.isEmpty
                        ? 'Agregar motivo (opcional)'
                        : 'Motivo: $motivo',
                    style: TextStyle(
                      color: motivo.isEmpty
                          ? const Color(0xFF666674)
                          : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 28),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: _buildKeypad(),
        ),
        const SizedBox(height: 26),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          child: SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton(
              onPressed: () {
                _showImpactNotification(
                  title: 'Cobro preparado',
                  message:
                      'Monto: \$$displayAmount | Método: $selectedMethod${motivo.isNotEmpty ? ' | Motivo: $motivo' : ''}',
                  icon: Icons.payments_outlined,
                  backgroundColor: const Color(0xFF2E7D32),
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
                'Continuar para Cobrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGestionarContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFECECF2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi Saldo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6F6F7C),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$ ********',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.visibility_off_outlined),
                    Spacer(),
                    Icon(Icons.chevron_right, size: 28),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Accesos rápidos',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickAction(
                icon: Icons.arrow_downward,
                label: 'Recargar\nsaldo',
              ),
              _QuickAction(
                icon: Icons.arrow_upward,
                label: 'Transferir\nsaldo',
              ),
              _QuickAction(
                icon: Icons.attach_money,
                label: 'Venta\nManual',
              ),
              _QuickAction(
                icon: Icons.verified_user_outlined,
                label: 'Verificar\npago',
              ),
            ],
          ),
          const SizedBox(height: 34),
          const Text(
            'Novedades Deuna Negocios',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: _MiniNewsCard(
                  title: 'Agrega\nvendedores\na tu equipo',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MiniNewsCard(
                  title: 'Administra\ntus ventas\ncon tu caja',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MiniNewsCard(
                  title: 'Cashback',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromocionesContent() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: IndexedStack(
        index: promoTab,
        children: [
          _buildPromoActivas(),
          _buildPromoCrear(),
          _buildPromoConfig(),
        ],
      ),
    );
  }

  Widget _buildPromoActivas() {
  return ListView(
    padding: const EdgeInsets.only(bottom: 20),
    children: [
      _buildBeneficiosButton(),
      const SizedBox(height: 14),

      if (promociones.isEmpty)
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'Aún no has creado promociones',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6F6F7C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      else
        ...promociones.asMap().entries.map((entry) {
          final index = entry.key;
          final promo = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECECF2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          promo.nombre,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: promo.activa
                              ? const Color(0xFFE7F7EE)
                              : const Color(0xFFF4F4F7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          promo.activa ? 'Activa' : 'Pausada',
                          style: TextStyle(
                            color: promo.activa
                                ? const Color(0xFF1E8E5A)
                                : const Color(0xFF6F6F7C),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F6F7C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _promoInfoChip('Tipo: ${promo.tipoBeneficio}'),
                      _promoInfoChip('Pts: ${promo.puntosPorCompra}'),
                      _promoInfoChip('Min: \$${promo.compraMinima}'),
                      _promoInfoChip('Vigencia: ${promo.vigencia}'),
                      _promoInfoChip('Usos: ${promo.usos}'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildPromoActions(index, promo),
                ],
              ),
            ),
          );
        }),
    ],
  );
}
Widget _buildPromoCrear() {
  return ListView(
    children: [
      const Text(
        'Crear promoción',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: promoNameController,
        decoration: InputDecoration(
          hintText: 'Nombre de la promoción',
          filled: true,
          fillColor: const Color(0xFFF7F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: promoDescController,
        maxLines: 2,
        decoration: InputDecoration(
          hintText: 'Descripción breve',
          filled: true,
          fillColor: const Color(0xFFF7F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: puntosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Puntos por compra',
                filled: true,
                fillColor: const Color(0xFFF7F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: compraMinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Compra mínima',
                filled: true,
                fillColor: const Color(0xFFF7F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        initialValue: promoVigencia,
        decoration: InputDecoration(
          labelText: 'Duración',
          filled: true,
          fillColor: const Color(0xFFF7F7FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: const [
          DropdownMenuItem(value: '7 días', child: Text('7 días')),
          DropdownMenuItem(value: '15 días', child: Text('15 días')),
          DropdownMenuItem(value: '30 días', child: Text('30 días')),
          DropdownMenuItem(value: '60 días', child: Text('60 días')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              promoVigencia = value;
            });
          }
        },
      ),
      const SizedBox(height: 14),
      SwitchListTile(
        value: promoActiva,
        activeThumbColor: purple,
        title: const Text('Promoción activa'),
        subtitle: const Text('Disponible para clientes desde ahora'),
        onChanged: (value) {
          setState(() {
            promoActiva = value;
          });
        },
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _guardarPromo,
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            _promoEnEdicion == null
                ? 'Guardar promoción'
                : 'Actualizar promoción',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildPromoConfig() {
  return ListView(
    children: [
      const Text(
        'Configuración de fidelización',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sistema de puntos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: puntosEnabled,
              activeThumbColor: purple,
              title: const Text('Habilitar puntos'),
              subtitle: const Text('Premia compras frecuentes'),
              onChanged: (value) {
                setState(() {
                  puntosEnabled = value;
                });
                _showImpactNotification(
                  title: value ? 'Puntos activados' : 'Puntos desactivados',
                  message: value
                      ? 'Tus clientes ya pueden empezar a acumular beneficios.'
                      : 'El sistema de puntos quedó en pausa.',
                  icon: Icons.stars_outlined,
                  backgroundColor:
                      value ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Puntos mínimos para canje',
                      hintText: '$puntosMinCanje',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        puntosMinCanje = int.tryParse(value) ?? puntosMinCanje;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Valor por punto',
                      hintText: valorPunto.toStringAsFixed(2),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        valorPunto = double.tryParse(value) ?? valorPunto;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Premios por puntos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Define cuántos puntos necesita el cliente y qué premio recibe.',
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF6F6F7C),
              ),
            ),
            const SizedBox(height: 14),
            ...List.generate(premiosCanje.length, (index) {
              final premio = premiosCanje[index];
              final nivel = index + 1;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE7E7EF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nivel $nivel',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          if (premiosCanje.length > 1)
                            IconButton(
                              onPressed: () => _eliminarPremioCanje(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: 'Eliminar premio',
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: premio.puntos.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Puntos',
                                filled: true,
                                fillColor: const Color(0xFFF7F7FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  premio.puntos = int.tryParse(value) ?? 0;
                                });
                                _scheduleRewardSync();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: premio.nombre,
                              decoration: InputDecoration(
                                labelText: 'Premio',
                                filled: true,
                                fillColor: const Color(0xFFF7F7FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  premio.nombre = value;
                                });
                                _scheduleRewardSync();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _agregarPremioCanje,
                icon: const Icon(Icons.add),
                label: const Text('Agregar premio'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: purple,
                  side: const BorderSide(color: purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: syncingRewards ? null : _syncPremiosToDb,
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  syncingRewards ? 'Sincronizando...' : 'Guardar cambios',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cashback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: cashbackEnabled,
              activeThumbColor: purple,
              title: const Text('Habilitar cashback'),
              subtitle: const Text('Devuelve un % al cliente'),
              onChanged: (value) {
                setState(() {
                  cashbackEnabled = value;
                });
                _showImpactNotification(
                  title: value ? 'Cashback activado' : 'Cashback desactivado',
                  message: value
                      ? 'Tu negocio ahora devuelve valor y fideliza mejor.'
                      : 'El cashback quedó apagado por ahora.',
                  icon: Icons.savings_outlined,
                  backgroundColor:
                      value ? const Color(0xFF00897B) : const Color(0xFF757575),
                );
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Porcentaje de cashback',
              style: TextStyle(fontSize: 14),
            ),
            Slider(
              value: cashbackPercent,
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: purple,
              label: '${cashbackPercent.toStringAsFixed(0)}%',
              onChanged: cashbackEnabled
                  ? (value) {
                      setState(() {
                        cashbackPercent = value;
                      });
                    }
                  : null,
            ),
            Text(
              '${cashbackPercent.toStringAsFixed(0)}% de devolución',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experiencia del cliente',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mensajeClienteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mensaje visible al cliente',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: mostrarProgresoCliente,
              activeThumbColor: purple,
              title: const Text('Mostrar progreso de puntos'),
              subtitle: const Text('Ej: “Te faltan 20 puntos para canjear”'),
              onChanged: (value) {
                setState(() {
                  mostrarProgresoCliente = value;
                });
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: permitirAcumulacion,
              activeThumbColor: purple,
              title: const Text('Permitir acumulación de beneficios'),
              subtitle: const Text('Más atractivo para clientes frecuentes'),
              onChanged: (value) {
                setState(() {
                  permitirAcumulacion = value;
                });
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: notificacionesPromo,
              activeThumbColor: purple,
              title: const Text('Notificaciones de promociones'),
              subtitle: const Text('Avisos automáticos y recordatorios'),
              onChanged: (value) {
                setState(() {
                  notificacionesPromo = value;
                });
                _showImpactNotification(
                  title: value
                      ? 'Notificaciones activadas'
                      : 'Notificaciones desactivadas',
                  message: value
                      ? 'Tus promociones ahora tendrán más presencia.'
                      : 'Menos ruido, pero también menos impulso.',
                  icon: Icons.campaign_outlined,
                  backgroundColor:
                      value ? const Color(0xFF6A1B9A) : const Color(0xFF757575),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildMiCajaContent() {
    return const Center(
      child: Text(
        'Mi Caja',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return const Center(
      child: Text(
        'Menú',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildMethodTab(String label) {
    final isSelected = selectedMethod == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => _changeMethod(label),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? purple : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : purple,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoTab(String label, int index) {
    final isSelected = promoTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            promoTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? purple : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : purple,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      ',', '0', 'delete',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 18,
          childAspectRatio: 1.9,
        ),
        itemBuilder: (context, index) {
          final key = keys[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => _onKeyTap(key),
              child: Center(
                child: key == 'delete'
                    ? const Icon(
                        Icons.backspace_outlined,
                        color: purple,
                        size: 26,
                      )
                    : Text(
                        key,
                        style: const TextStyle(
                          color: purple,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AdminBadge extends StatelessWidget {
  const _AdminBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE3F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Admin',
        style: TextStyle(
          color: _Pg3State.purple,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7FA),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6F6F7C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MiniNewsCard extends StatelessWidget {
  final String title;

  const _MiniNewsCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.15,
                color: Color(0xFF4A3B68),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF0A8C95),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'd!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _PromoActionType { outlinePurple, outlineGrey, danger }

class _PromoActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final _PromoActionType type;

  const _PromoActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _PromoActionType.outlinePurple:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: _Pg3State.purple,
            side: const BorderSide(color: _Pg3State.purple),
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case _PromoActionType.outlineGrey:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF6F6F7C),
            side: const BorderSide(color: Color(0xFFD9D9E3)),
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      case _PromoActionType.danger:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
    }
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showBadge;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _Pg3State.purple : const Color(0xFF818194);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 78,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (showBadge)
                  Positioned(
                    top: -8,
                    right: -14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Nuevo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11.8,
                height: 1.08,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _MisBeneficiosPage extends StatefulWidget {
  final int puntosTotalesIniciales;

  const _MisBeneficiosPage({
    required this.puntosTotalesIniciales,
  });

  @override
  State<_MisBeneficiosPage> createState() => _MisBeneficiosPageState();
}

class _MisBeneficiosPageState extends State<_MisBeneficiosPage> {
  static const Color purple = Color(0xFF6523A8);

  late int puntosTotalesClientes;

  final List<Map<String, dynamic>> beneficios = [
    {
      'titulo': 'Combo aliado con Coca-Cola',
      'marca': 'Coca-Cola',
      'puntos': 1000,
      'descripcion':
          'Descuento especial en productos aliados para tu negocio.',
    },
    {
      'titulo': 'Publicidad destacada',
      'marca': 'PedidosYa',
      'puntos': 1500,
      'descripcion':
          'Mayor visibilidad para tu local en campañas de marcas aliadas.',
    },
    {
      'titulo': 'Kit premium para tu negocio',
      'marca': 'DeUna Partners',
      'puntos': 2000,
      'descripcion':
          'Material promocional exclusivo para mejorar tu vitrina y ventas.',
    },
  ];

  @override
  void initState() {
    super.initState();
    puntosTotalesClientes = widget.puntosTotalesIniciales;
  }

  void _canjearBeneficio(Map<String, dynamic> beneficio) {
    final int costo = beneficio['puntos'] as int;

    if (puntosTotalesClientes < costo) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(beneficio['titulo'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Marca aliada: ${beneficio['marca']}'),
              const SizedBox(height: 8),
              Text('Costo: $costo puntos'),
              const SizedBox(height: 12),
              Text(
                'Puntos actuales: $puntosTotalesClientes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Te quedarían: ${puntosTotalesClientes - costo} puntos',
                style: const TextStyle(color: Color(0xFF6F6F7C)),
              ),
              const SizedBox(height: 12),
              const Text(
                '¿Deseas canjear este beneficio exclusivo para tu negocio?',
                style: TextStyle(
                  color: Color(0xFF6F6F7C),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  puntosTotalesClientes -= costo;
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Beneficio canjeado. Te quedan $puntosTotalesClientes puntos.',
                    ),
                    backgroundColor: purple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Canjear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, puntosTotalesClientes);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF1E1E24)),
          title: const Text(
            'Mis beneficios',
            style: TextStyle(
              color: Color(0xFF1E1E24),
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, puntosTotalesClientes);
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F1FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Puntos acumulados por compras de todos tus clientes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F6F7C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$puntosTotalesClientes pts',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mientras más compran tus clientes, más beneficios desbloqueas con marcas aliadas a DeUna.',
                    style: TextStyle(
                      color: Color(0xFF5A5A67),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Beneficios exclusivos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...beneficios.map((beneficio) {
              final int puntos = beneficio['puntos'] as int;
              final bool disponible = puntosTotalesClientes >= puntos;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFECECF2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_outlined,
                          color: purple,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            beneficio['titulo'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      beneficio['descripcion'] as String,
                      style: const TextStyle(
                        color: Color(0xFF6F6F7C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _BenefitChip(text: 'Marca: ${beneficio['marca']}'),
                        _BenefitChip(text: 'Costo: $puntos pts'),
                        _BenefitChip(
                          text: disponible
                              ? 'Disponible ahora'
                              : 'Aún no desbloqueado',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: disponible
                            ? () => _canjearBeneficio(beneficio)
                            : null,
                        icon: const Icon(Icons.redeem_outlined),
                        label: Text(
                          disponible ? 'Canjear beneficio' : 'Sigue acumulando',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              disponible ? purple : Colors.grey.shade300,
                          foregroundColor:
                              disponible ? Colors.white : Colors.grey.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
class _BenefitChip extends StatelessWidget {
  final String text;

  const _BenefitChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF5A5A67),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}