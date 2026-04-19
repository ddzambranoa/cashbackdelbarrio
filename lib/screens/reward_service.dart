import 'package:supabase_flutter/supabase_flutter.dart';

class RewardDraft {
  String nombre;
  int puntos;

  RewardDraft({
    required this.nombre,
    required this.puntos,
  });
}

class RewardService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 Obtener premios
  Future<List<Map<String, dynamic>>> getRewards() async {
    final data = await _supabase
        .from('reward_rules')
        .select()
        .order('points_required');

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> replaceAllRewards(List<RewardDraft> rewards) async {
    final cleaned = _cleanRewards(rewards);

    // 🔥 Borra todo (sin UUID error)
    await _supabase.from('reward_rules').delete().gt('points_required', -1);

    // 🔹 Inserta solo si hay datos válidos
    if (cleaned.isNotEmpty) {
      await _supabase.from('reward_rules').insert(
            cleaned
                .map(
                  (r) => {
                    'reward_name': r.nombre,
                    'points_required': r.puntos,
                    'active': true,
                  },
                )
                .toList(),
          );
    }
  }

  /// 🔥 LIMPIEZA CORREGIDA (YA NO BORRA NIVELES)
  List<RewardDraft> _cleanRewards(List<RewardDraft> rewards) {
    final seen = <String>{};
    final result = <RewardDraft>[];

    for (final reward in rewards) {
      final nombre = reward.nombre.trim();
      final puntos = reward.puntos;

      // ❌ ignorar inválidos
      if (nombre.isEmpty) continue;
      if (puntos <= 0) continue;

      // 🔑 clave única REAL (nombre + puntos)
      final key = '$nombre-$puntos';

      if (!seen.contains(key)) {
        seen.add(key);
        result.add(
          RewardDraft(
            nombre: nombre,
            puntos: puntos,
          ),
        );
      }
    }

    // 🔽 ordenar siempre
    result.sort((a, b) => a.puntos.compareTo(b.puntos));

    return result;
  }
}