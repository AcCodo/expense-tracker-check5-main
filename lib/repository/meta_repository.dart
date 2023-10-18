import 'package:expense_tracker/models/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetaRepository {
  Future<List<Meta>> listarMetas() async {
    final supabase = Supabase.instance.client;

    var query = supabase.from('metas').select<List<Map<String, dynamic>>>('*');

    var data = await query;

    final list = data.map((map) {
      return Meta.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    final icone = meta.icone == null ? 0 : meta.icone!.codePoint;

    await supabase.from('metas').insert({
      'nome': meta.nome,
      'icone': icone,
      'objetivo': meta.objetivo,
      'atual': meta.atual
    });
  }

  Future alterarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').update(
        {'nome': meta.nome, 'atual': meta.atual}).match({'id': meta.id});
  }

  Future excluirMeta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').delete().match({'id': id});
  }
}
