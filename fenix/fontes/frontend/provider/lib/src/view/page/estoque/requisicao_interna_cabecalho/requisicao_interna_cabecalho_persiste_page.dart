/*
Title: T2Ti ERP Fenix                                                                
Description: AbaMestre PersistePage relacionada à tabela [REQUISICAO_INTERNA_CABECALHO] 
                                                                                
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
import 'package:flutter/gestures.dart';

import 'package:fenix/src/model/model.dart';
import 'package:fenix/src/view/shared/view_util_lib.dart';

import 'package:fenix/src/view/shared/lookup_page.dart';
import 'package:fenix/src/view/shared/valida_campo_formulario.dart';

class RequisicaoInternaCabecalhoPersistePage extends StatefulWidget {
  final RequisicaoInternaCabecalho requisicaoInternaCabecalho;
  final GlobalKey<FormState> formKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function atualizaRequisicaoInternaCabecalhoCallBack;

  const RequisicaoInternaCabecalhoPersistePage(
      {Key key, this.formKey, this.scaffoldKey, this.requisicaoInternaCabecalho, this.atualizaRequisicaoInternaCabecalhoCallBack})
      : super(key: key);

  @override
  RequisicaoInternaCabecalhoPersistePageState createState() => RequisicaoInternaCabecalhoPersistePageState();
}

class RequisicaoInternaCabecalhoPersistePageState extends State<RequisicaoInternaCabecalhoPersistePage> {
  @override
  Widget build(BuildContext context) {
	var importaColaboradorController = TextEditingController();
	importaColaboradorController.text = widget.requisicaoInternaCabecalho?.colaborador?.pessoa?.nome ?? '';

    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      key: widget.scaffoldKey,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: widget.formKey,
          autovalidate: true,
          child: Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
				  const SizedBox(height: 24.0),
				  Row(
				  	children: <Widget>[
				  		Expanded(
				  			flex: 1,
				  			child: Container(
				  				child: TextFormField(
				  					controller: importaColaboradorController,
				  					readOnly: true,
				  					decoration: ViewUtilLib.getInputDecorationPersistePage(
				  						'Importe o Colaborador Vinculado',
				  						'Colaborador *',
				  						false),
				  					onSaved: (String value) {
				  					},
				  					validator: ValidaCampoFormulario.validarObrigatorioAlfanumerico,
				  					onChanged: (text) {
				  						widget.requisicaoInternaCabecalho?.colaborador?.pessoa?.nome = text;
				  						ViewUtilLib.paginaMestreDetalheFoiAlterada = true;
				  					},
				  				),
				  			),
				  		),
				  		Expanded(
				  			flex: 0,
				  			child: IconButton(
				  				tooltip: 'Importar Colaborador',
				  				icon: const Icon(Icons.search),
				  				onPressed: () async {
				  					///chamando o lookup
				  					Map<String, dynamic> objetoJsonRetorno =
				  						await Navigator.push(
				  							context,
				  							MaterialPageRoute(
				  								builder: (BuildContext context) =>
				  									LookupPage(
				  										title: 'Importar Colaborador',
				  										colunas: ViewPessoaColaborador.colunas,
				  										campos: ViewPessoaColaborador.campos,
				  										rota: '/view-pessoa-colaborador/',
				  										campoPesquisaPadrao: 'nome',
				  									),
				  									fullscreenDialog: true,
				  								));
				  				if (objetoJsonRetorno != null) {
				  					if (objetoJsonRetorno['nome'] != null) {
				  						importaColaboradorController.text = objetoJsonRetorno['nome'];
				  						widget.requisicaoInternaCabecalho.idColaborador = objetoJsonRetorno['id'];
				  						widget.requisicaoInternaCabecalho.colaborador = new Colaborador.fromJson(objetoJsonRetorno);
				  					}
				  				}
				  			},
				  		),
				  		),
				  	],
				  ),
				  const SizedBox(height: 24.0),
				  InputDecorator(
				  	decoration: ViewUtilLib.getInputDecorationPersistePage(
				  		'Informe a Data da Requisição',
				  		'Data da Requisição',
				  		true),
				  	isEmpty: widget.requisicaoInternaCabecalho.dataRequisicao == null,
				  	child: DatePickerItem(
				  		dateTime: widget.requisicaoInternaCabecalho.dataRequisicao,
				  		firstDate: DateTime.parse('1900-01-01'),
				  		lastDate: DateTime.now(),
				  		onChanged: (DateTime value) {
				  			ViewUtilLib.paginaMestreDetalheFoiAlterada = true;
				  			setState(() {
				  				widget.requisicaoInternaCabecalho.dataRequisicao = value;
				  			});
				  		},
				  	),
				  ),
				  // const SizedBox(height: 24.0),
				  // InputDecorator(
				  // 	decoration: ViewUtilLib.getInputDecorationPersistePage(
				  // 		'Informe o Situação da Requisição',
				  // 		'Situação da Requisição',
				  // 		true),
				  // 	isEmpty: widget.requisicaoInternaCabecalho.situacao == null,
				  // 	child: ViewUtilLib.getDropDownButton(widget.requisicaoInternaCabecalho.situacao,
				  // 		(String newValue) {
				  // 		ViewUtilLib.paginaMestreDetalheFoiAlterada = true;
				  // 	setState(() {
				  // 		widget.requisicaoInternaCabecalho.situacao = newValue;
				  // 	});
				  // 	}, <String>[
				  // 		'Aberta',
				  // 		'Deferida',
				  // 		'Indeferida',
				  // ])),
                  const SizedBox(height: 24.0),
                  Text(
                    '* indica que o campo é obrigatório',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
