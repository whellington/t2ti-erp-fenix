/*
Title: T2Ti ERP Fenix                                                                
Description: ListaPage relacionada à tabela [VIEW_FIN_MOVIMENTO_CAIXA_BANCO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2020 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (alberteije@gmail.com)                    
@version 1.0.0
*******************************************************************************/
import 'package:backdrop/backdrop.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fenix/src/model/model.dart';
import 'package:fenix/src/view_model/view_model.dart';
import 'package:fenix/src/view/shared/erro_page.dart';
import 'package:fenix/src/view/shared/view_util_lib.dart';
import 'package:fenix/src/infra/constantes.dart';
import 'package:intl/intl.dart';

import '../../page.dart';

class ViewFinMovimentoCaixaBancoListaPage extends StatefulWidget {
  @override
  _ViewFinMovimentoCaixaBancoListaPageState createState() =>
      _ViewFinMovimentoCaixaBancoListaPageState();
}

class _ViewFinMovimentoCaixaBancoListaPageState extends State<ViewFinMovimentoCaixaBancoListaPage> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  String _recebimentos = '';
  String _pagamentos = '';
  String _saldo = '';
  DateTime _mesAno = DateTime.now();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => filtrar());
  }

  @override
  Widget build(BuildContext context) {
    var listaViewFinMovimentoCaixaBanco = Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).listaViewFinMovimentoCaixaBanco;

    final ViewFinMovimentoCaixaBancoDataSource _viewFinMovimentoCaixaBancoDataSource = ViewFinMovimentoCaixaBancoDataSource(listaViewFinMovimentoCaixaBanco, context);

    void _sort<T>(
        Comparable<T> getField(
            ViewFinMovimentoCaixaBanco viewFinMovimentoCaixaBanco),
        int columnIndex,
        bool ascending) {
      _viewFinMovimentoCaixaBancoDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }

    if (Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).objetoJsonErro !=null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Financeiro - Movimento Caixa Banco'),
          actions: <Widget>[],
        ),
        body: ErroPage(
            objetoJsonErro: Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).objetoJsonErro),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Financeiro - Movimento Caixa Banco'),
          actions: <Widget>[],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar:  BottomAppBar(
            color: ViewUtilLib.getBottomAppBarFiltroLocalColor(),
            shape: CircularNotchedRectangle(),
            child: Row(
                  children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: InputDecorator(
                      decoration: ViewUtilLib.getInputDecorationPersistePage(
                        'Mês/Ano para o Filtro',
                        'Selecione um dia dentro do mês desejado',
                        true),
                      isEmpty: _mesAno == null,
                      child: DatePickerItem(
                        mascara: 'MM/yyyy',
                        dateTime: _mesAno,
                        firstDate: DateTime.parse('1900-01-01'),
                        lastDate: DateTime.parse('2050-01-01'),
                        onChanged: (DateTime value) {
                          setState(() {
                            _mesAno = value;
                          });
                        },
                      ),
                    ),
                  ),
                    Expanded(
                      flex: 0,
                      child: IconButton(
                        tooltip: 'Filtrar',
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          await filtrar();
                        },
                      ),
                    ),
                  ],
                ),
          ),
        
        body: RefreshIndicator(
          onRefresh: _refrescarTela,
          child: BackdropScaffold(            

            iconPosition: BackdropIconPosition.leading,
            title: Text("Lançamentos por Período"),
            backLayer: getResumoTotais(context),
            frontLayer: Scrollbar(
              child: listaViewFinMovimentoCaixaBanco == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: <Widget>[
                        PaginatedDataTable(
                          header: Text(''),
                          rowsPerPage: _rowsPerPage,
                          onRowsPerPageChanged: (int value) {
                            setState(() {
                              _rowsPerPage = value;
                            });
                          },
                          sortColumnIndex: _sortColumnIndex,
                          sortAscending: _sortAscending,
                          columns: <DataColumn>[
                            DataColumn(
                              numeric: true,
                              label: const Text('Id'),
                              tooltip: 'Id',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<num>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.id,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text('Id Conta Caixa'),
                              tooltip: 'Id Conta Caixa',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<num>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.idContaCaixa,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Nome Conta Caixa'),
                              tooltip: 'Nome Conta Caixa',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<String>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco
                                              .nomeContaCaixa,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Nome Cliente / Fornecedor'),
                              tooltip: 'Nome Cliente / Fornecedor',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<String>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.nomePessoa,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Data Lancamento'),
                              tooltip: 'Data Lancamento',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<DateTime>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco
                                              .dataLancamento,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Data Pago Recebido'),
                              tooltip: 'Data Pago Recebido',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<DateTime>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco
                                              .dataPagoRecebido,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Historico'),
                              tooltip: 'Historico',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<String>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.historico,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              numeric: true,
                              label: const Text('Valor'),
                              tooltip: 'Valor',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<num>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.valor,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Descricao Documento Origem'),
                              tooltip: 'Descricao Documento Origem',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<String>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco
                                              .descricaoDocumentoOrigem,
                                      columnIndex,
                                      ascending),
                            ),
                            DataColumn(
                              label: const Text('Operacao'),
                              tooltip: 'Operacao',
                              onSort: (int columnIndex, bool ascending) =>
                                  _sort<String>(
                                      (ViewFinMovimentoCaixaBanco
                                              viewFinMovimentoCaixaBanco) =>
                                          viewFinMovimentoCaixaBanco.operacao,
                                      columnIndex,
                                      ascending),
                            ),
                          ],
                          source: _viewFinMovimentoCaixaBancoDataSource,
                        ),
                      ],
                    ),
                  ),
          ),          
        ),
      );
    }
  }

  Future _refrescarTela() async {
    await Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).consultarLista(filtro: ViewUtilLib.filtroGlobal);
    await calcularTotais();
  }

  Future filtrar() async {
    ViewUtilLib.filtroGlobal.condicao = 'eq';
    ViewUtilLib.filtroGlobal.campo = 'MES_ANO';
    ViewUtilLib.filtroGlobal.valor = DateFormat('MM/yyyy').format(_mesAno);
    _refrescarTela();
  }

  Future calcularTotais() async {
    double recebimentos = 0;
    double pagamentos = 0;
    double saldo = 0;
    List<ViewFinMovimentoCaixaBanco> listaLancamentos = Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).listaViewFinMovimentoCaixaBanco;
    try {
      for (ViewFinMovimentoCaixaBanco objeto in listaLancamentos) {
        if (objeto.operacao == 'Saída') {
          pagamentos = pagamentos + objeto.valor;
        }
        else if (objeto.operacao == 'Entrada') {
          recebimentos = recebimentos + objeto.valor;
        }
      }     
      saldo = recebimentos - pagamentos;
      _recebimentos = 'Recebimentos: ' + Constantes.formatoDecimalValor.format(recebimentos);
      _pagamentos = 'Pagamentos: ' + Constantes.formatoDecimalValor.format(pagamentos);
      _saldo = 'Saldo: ' + Constantes.formatoDecimalValor.format(saldo);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget getResumoTotais(BuildContext context) {
    return Scrollbar(
    child: SingleChildScrollView(
      dragStartBehavior: DragStartBehavior.down,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Card(
              color: Colors.blue.shade100,
              elevation: 10,
              child: Container (
                padding: const EdgeInsets.all(8.0),
                height: 35,
                child: Text(
                _recebimentos,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: Constantes.ralewayFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              color: Colors.red.shade100,
              elevation: 10,
              child: Container (
                padding: const EdgeInsets.all(8.0),
                height: 35,
                child: Text(
                _pagamentos,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: Constantes.ralewayFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              color: Colors.green.shade100,
              elevation: 10,
              child: Container (
                padding: const EdgeInsets.all(8.0),
                height: 35,
                child: Text(
                _saldo,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: Constantes.ralewayFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],),
        ),
      ),
    );    
  }  

}

/// codigo referente a fonte de dados
class ViewFinMovimentoCaixaBancoDataSource extends DataTableSource {
  final List<ViewFinMovimentoCaixaBanco> listaViewFinMovimentoCaixaBanco;
  final BuildContext context;

  ViewFinMovimentoCaixaBancoDataSource(
      this.listaViewFinMovimentoCaixaBanco, this.context);

  void _sort<T>(
      Comparable<T> getField(
          ViewFinMovimentoCaixaBanco viewFinMovimentoCaixaBanco),
      bool ascending) {
    listaViewFinMovimentoCaixaBanco
        .sort((ViewFinMovimentoCaixaBanco a, ViewFinMovimentoCaixaBanco b) {
      if (!ascending) {
        final ViewFinMovimentoCaixaBanco c = a;
        a = b;
        b = c;
      }
      Comparable<T> aValue = getField(a);
      Comparable<T> bValue = getField(b);

      if (aValue == null) aValue = '' as Comparable<T>;
      if (bValue == null) bValue = '' as Comparable<T>;

      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= listaViewFinMovimentoCaixaBanco.length) return null;
    final ViewFinMovimentoCaixaBanco viewFinMovimentoCaixaBanco =
        listaViewFinMovimentoCaixaBanco[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${viewFinMovimentoCaixaBanco.id ?? ''}'), onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(Text('${viewFinMovimentoCaixaBanco.idContaCaixa ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(Text('${viewFinMovimentoCaixaBanco.nomeContaCaixa ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(Text('${viewFinMovimentoCaixaBanco.nomePessoa ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(
            Text(
                '${viewFinMovimentoCaixaBanco.dataLancamento != null ? DateFormat('dd/MM/yyyy').format(viewFinMovimentoCaixaBanco.dataLancamento) : ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(
            Text(
                '${viewFinMovimentoCaixaBanco.dataPagoRecebido != null ? DateFormat('dd/MM/yyyy').format(viewFinMovimentoCaixaBanco.dataPagoRecebido) : ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(Text('${viewFinMovimentoCaixaBanco.historico ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(
            Text(
                '${viewFinMovimentoCaixaBanco.valor != null ? Constantes.formatoDecimalValor.format(viewFinMovimentoCaixaBanco.valor) : 0.toStringAsFixed(Constantes.decimaisValor)}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(
            Text(
                '${viewFinMovimentoCaixaBanco.descricaoDocumentoOrigem ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
        DataCell(Text('${viewFinMovimentoCaixaBanco.operacao ?? ''}'),
            onTap: () {
          detalharViewFinMovimentoCaixaBanco(
              viewFinMovimentoCaixaBanco, context);
        }),
      ],
    );
  }

  @override
  int get rowCount => listaViewFinMovimentoCaixaBanco.length ?? 0;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

detalharViewFinMovimentoCaixaBanco(ViewFinMovimentoCaixaBanco viewFinMovimentoCaixaBanco, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ProcessaFechamentoPage(
            viewFinMovimentoCaixaBanco: viewFinMovimentoCaixaBanco,
            mesAno: viewFinMovimentoCaixaBanco.mesAno,
          ))
        ).then((_) async {
            ViewUtilLib.filtroGlobal.condicao = 'eq';
            await Provider.of<ViewFinMovimentoCaixaBancoViewModel>(context).consultarLista(filtro: ViewUtilLib.filtroGlobal);
        });
}
