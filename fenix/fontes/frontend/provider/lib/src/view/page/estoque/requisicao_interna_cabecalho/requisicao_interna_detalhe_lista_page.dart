/*
Title: T2Ti ERP Fenix                                                                
Description: AbaDetalhe ListaPage relacionada à tabela [REQUISICAO_INTERNA_DETALHE] 
                                                                                
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
import 'package:flutter/material.dart';

import 'package:fenix/src/model/model.dart';
import 'package:fenix/src/view/shared/view_util_lib.dart';
import 'package:fenix/src/infra/constantes.dart';
import 'requisicao_interna_detalhe_detalhe_page.dart';
import 'requisicao_interna_detalhe_persiste_page.dart';

class RequisicaoInternaDetalheListaPage extends StatefulWidget {
  final RequisicaoInternaCabecalho requisicaoInternaCabecalho;

  const RequisicaoInternaDetalheListaPage({Key key, this.requisicaoInternaCabecalho}) : super(key: key);

  @override
  _RequisicaoInternaDetalheListaPageState createState() => _RequisicaoInternaDetalheListaPageState();
}

class _RequisicaoInternaDetalheListaPageState extends State<RequisicaoInternaDetalheListaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: ViewUtilLib.getBackgroundColorBotaoInserir(),
          child: ViewUtilLib.getIconBotaoInserir(),
          onPressed: () {
            var requisicaoInternaDetalhe = new RequisicaoInternaDetalhe();
            widget.requisicaoInternaCabecalho.listaRequisicaoInternaDetalhe.add(requisicaoInternaDetalhe);
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RequisicaoInternaDetalhePersistePage(
                            requisicaoInternaCabecalho: widget.requisicaoInternaCabecalho,
                            requisicaoInternaDetalhe: requisicaoInternaDetalhe,
                            title: 'Requisicao Interna Detalhe - Inserindo',
                            operacao: 'I')))
                .then((_) {
              setState(() {
                if (requisicaoInternaDetalhe.quantidade == null || requisicaoInternaDetalhe.quantidade.toString() == "") { // se esse atributo estiver vazio, o objeto será removido
                  widget.requisicaoInternaCabecalho.listaRequisicaoInternaDetalhe.remove(requisicaoInternaDetalhe);
                }
                getRows();
              });
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(2.0),
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: DataTable(columns: getColumns(), rows: getRows()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getColumns() {
    List<DataColumn> lista = [];
	lista.add(DataColumn(numeric: true, label: Text('Id')));
	lista.add(DataColumn(label: Text('Produto')));
	lista.add(DataColumn(numeric: true, label: Text('Quantidade')));
    return lista;
  }

  List<DataRow> getRows() {
    if (widget.requisicaoInternaCabecalho.listaRequisicaoInternaDetalhe == null) {
      widget.requisicaoInternaCabecalho.listaRequisicaoInternaDetalhe = [];
    }
    List<DataRow> lista = [];
    for (var requisicaoInternaDetalhe in widget.requisicaoInternaCabecalho.listaRequisicaoInternaDetalhe) {
      List<DataCell> celulas = new List<DataCell>();

      celulas = [
        DataCell(Text('${ requisicaoInternaDetalhe.id ?? ''}'), onTap: () {
          detalharRequisicaoInternaDetalhe(widget.requisicaoInternaCabecalho, requisicaoInternaDetalhe, context);
        }),
		DataCell(Text('${requisicaoInternaDetalhe.produto?.nome ?? ''}'), onTap: () {
			detalharRequisicaoInternaDetalhe(widget.requisicaoInternaCabecalho, requisicaoInternaDetalhe, context);
		}),
		DataCell(Text('${requisicaoInternaDetalhe.quantidade != null ? Constantes.formatoDecimalQuantidade.format(requisicaoInternaDetalhe.quantidade) : 0.toStringAsFixed(Constantes.decimaisQuantidade)}'), onTap: () {
			detalharRequisicaoInternaDetalhe(widget.requisicaoInternaCabecalho, requisicaoInternaDetalhe, context);
		}),
      ];

      lista.add(DataRow(cells: celulas));
    }
    return lista;
  }

  detalharRequisicaoInternaDetalhe(
      RequisicaoInternaCabecalho requisicaoInternaCabecalho, RequisicaoInternaDetalhe requisicaoInternaDetalhe, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => RequisicaoInternaDetalheDetalhePage(
                  requisicaoInternaCabecalho: requisicaoInternaCabecalho,
                  requisicaoInternaDetalhe: requisicaoInternaDetalhe,
                ))).then((_) {
				  setState(() {
					getRows();
				  });
				});
  }
}