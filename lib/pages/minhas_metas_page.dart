import 'package:expense_tracker/components/meta_item.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/repository/meta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'criar_meta_page.dart';

class MinhasMetasPage extends StatefulWidget {
  @override
  _MinhasMetasPageState createState() => _MinhasMetasPageState();
}

class _MinhasMetasPageState extends State<MinhasMetasPage> {
  final metasRepo = MetaRepository();
  late Future<List<Meta>> futureMetas;

  // falta substituir pela lógica de busca dos dados reais
  @override
  void initState() {
    futureMetas = metasRepo.listarMetas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Metas'),
      ),
      body: FutureBuilder<List<Meta>>(
        future: futureMetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as Metas"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma meta cadastrada"),
            );
          } else {
            final metas = snapshot.data!;
            return ListView.separated(
              itemCount: metas.length,
              itemBuilder: (context, index) {
                final meta = metas[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CriarMetaPage(metaParaEdicao: meta),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureMetas = metasRepo.listarMetas();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await metasRepo.excluirMeta(meta.id);

                          setState(() {
                            metas.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'DEL',
                      ),
                    ],
                  ),
                  child: MetaItem(
                    meta: meta,
                    onTap: () {
                      Navigator.pushNamed(context, '/ver-meta',
                          arguments: meta);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "meta-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/criar-meta') as bool?;

          if (result == true) {
            setState(() {
              futureMetas = metasRepo.listarMetas();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
