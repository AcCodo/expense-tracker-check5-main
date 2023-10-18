import 'package:expense_tracker/components/icone_select.dart';
import 'package:expense_tracker/models/icones_meta.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/pages/icone_select_page.dart';
import 'package:expense_tracker/repository/meta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class CriarMetaPage extends StatefulWidget {
  final Meta? metaParaEdicao;

  const CriarMetaPage({super.key, this.metaParaEdicao});

  @override
  _CriarMetaPageState createState() => _CriarMetaPageState();
}

class _CriarMetaPageState extends State<CriarMetaPage> {
  final metaRepo = MetaRepository();

  final _nomeController = TextEditingController();
  final _valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final _atualController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final _formKey = GlobalKey<FormState>();

  IconeMeta? _iconeSelecionado;

  @override
  void initState() {
    super.initState();

    final meta = widget.metaParaEdicao;

    if (meta != null) {
      _nomeController.text = meta.nome;

      _valorController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.objetivo);

      _atualController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.atual);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Meta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNome(),
                const SizedBox(height: 30),
                _buildSelectIcone() ??
                    const SizedBox(
                      height: 0,
                    ),
                const SizedBox(height: 30),
                _buildObjetivo(),
                const SizedBox(height: 30),
                _buildAtual(),
                const SizedBox(height: 30),
                _buildProgressBar(),
                const SizedBox(height: 30),
                _buildSalvar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    if (_valorController.numberValue > 0) {
      return LinearProgressIndicator(
        value: _atualController.numberValue / _valorController.numberValue,
        minHeight: 20,
      );
    }
    return const SizedBox(
      height: 5,
    );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: _nomeController,
      decoration: const InputDecoration(
          hintText: 'Informe o nome da Meta',
          labelText: 'Meta',
          prefixIcon: Icon(Ionicons.cash_outline),
          border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Nome para a Meta';
        }

        return null;
      },
    );
  }

  IconeSelect? _buildSelectIcone() {
    if (widget.metaParaEdicao != null) {
      return null;
    }

    return IconeSelect(
      icone: _iconeSelecionado,
      onTap: () async {
        final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const IconeSelectPage())) as IconeMeta?;

        if (result != null) {
          setState(() {
            _iconeSelecionado = result;
          });
        }
      },
    );
  }

  TextFormField _buildObjetivo() {
    return TextFormField(
      readOnly: widget.metaParaEdicao != null,
      controller: _valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          hintText: 'Informe o Valor Objetivo',
          labelText: 'Objetivo',
          border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(_valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  TextFormField _buildAtual() {
    return TextFormField(
      controller: _atualController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          hintText: 'Informe o Valor já arrecadado',
          labelText: 'Atual',
          border: OutlineInputBorder()),
    );
  }

  SizedBox _buildSalvar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final nome = _nomeController.text;
            final objetivo = NumberFormat.currency(locale: 'pt_BR')
                .parse(_valorController.text.replaceAll('R\$', ''));
            final atual = NumberFormat.currency(locale: 'pt_BR')
                .parse(_atualController.text.replaceAll('R\$', ''));

            final meta = Meta(
                id: 0,
                nome: nome,
                icone: _iconeSelecionado == null
                    ? Icons.wallet
                    : _iconeSelecionado!.icone,
                objetivo: objetivo,
                atual: atual);

            if (widget.metaParaEdicao == null) {
              await _cadastrarMeta(meta);
            } else {
              meta.id = widget.metaParaEdicao!.id;
              await _alterarMeta(meta);
            }
          }
        },
        child: const Text('Salvar Meta'),
      ),
    );
  }

  Future<void> _cadastrarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metaRepo.cadastrarMeta(meta).then((_) {
      scaffold.showSnackBar(const SnackBar(
          content: Text(
        'Meta cadastrada com Sucesso',
      )));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      scaffold.showSnackBar(SnackBar(
          content: Text(
        error.toString(),
      )));
    });
  }

  Future<void> _alterarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metaRepo.alterarMeta(meta).then((_) {
      scaffold.showSnackBar(const SnackBar(
          content: Text(
        'Meta alterada com Sucesso',
      )));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      scaffold.showSnackBar(const SnackBar(
          content: Text(
        'Erro ao alterar Meta',
      )));
    });
  }
}
