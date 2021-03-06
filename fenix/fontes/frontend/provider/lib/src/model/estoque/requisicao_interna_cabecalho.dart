/*
Title: T2Ti ERP Fenix                                                                
Description: Model relacionado à tabela [REQUISICAO_INTERNA_CABECALHO] 
                                                                                
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
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:fenix/src/model/model.dart';

class RequisicaoInternaCabecalho {
	int id;
	int idColaborador;
	DateTime dataRequisicao;
	String situacao;
	Colaborador colaborador;
	List<RequisicaoInternaDetalhe> listaRequisicaoInternaDetalhe = [];

	RequisicaoInternaCabecalho({
			this.id,
			this.idColaborador,
			this.dataRequisicao,
			this.situacao,
			this.colaborador,
			this.listaRequisicaoInternaDetalhe,
		});

	static List<String> campos = <String>[
		'ID', 
		'DATA_REQUISICAO', 
		'SITUACAO', 
	];
	
	static List<String> colunas = <String>[
		'Id', 
		'Data da Requisição', 
		'Situação da Requisição', 
	];

	RequisicaoInternaCabecalho.fromJson(Map<String, dynamic> jsonDados) {
		id = jsonDados['id'];
		idColaborador = jsonDados['idColaborador'];
		dataRequisicao = jsonDados['dataRequisicao'] != null ? DateTime.tryParse(jsonDados['dataRequisicao']) : null;
		situacao = getSituacao(jsonDados['situacao']);
		colaborador = jsonDados['colaborador'] == null ? null : new Colaborador.fromJson(jsonDados['colaborador']);
		listaRequisicaoInternaDetalhe = (jsonDados['listaRequisicaoInternaDetalhe'] as Iterable)?.map((m) => RequisicaoInternaDetalhe.fromJson(m))?.toList() ?? [];
	}

	Map<String, dynamic> get toJson {
		Map<String, dynamic> jsonDados = new Map<String, dynamic>();

		jsonDados['id'] = this.id ?? 0;
		jsonDados['idColaborador'] = this.idColaborador ?? 0;
		jsonDados['dataRequisicao'] = this.dataRequisicao != null ? DateFormat('yyyy-MM-ddT00:00:00').format(this.dataRequisicao) : null;
		jsonDados['situacao'] = setSituacao(this.situacao);
		jsonDados['colaborador'] = this.colaborador == null ? null : this.colaborador.toJson;
		

		var listaRequisicaoInternaDetalheLocal = [];
		for (RequisicaoInternaDetalhe objeto in this.listaRequisicaoInternaDetalhe ?? []) {
			listaRequisicaoInternaDetalheLocal.add(objeto.toJson);
		}
		jsonDados['listaRequisicaoInternaDetalhe'] = listaRequisicaoInternaDetalheLocal;
	
		return jsonDados;
	}
	
    getSituacao(String situacao) {
    	switch (situacao) {
    		case 'A':
    			return 'Aberta';
    			break;
    		case 'D':
    			return 'Deferida';
    			break;
    		case 'I':
    			return 'Indeferida';
    			break;
    		default:
    			return null;
    		}
    	}

    setSituacao(String situacao) {
    	switch (situacao) {
    		case 'Aberta':
    			return 'A';
    			break;
    		case 'Deferida':
    			return 'D';
    			break;
    		case 'Indeferida':
    			return 'I';
    			break;
    		default:
    			return null;
    		}
    	}


	String objetoEncodeJson(RequisicaoInternaCabecalho objeto) {
	  final jsonDados = objeto.toJson;
	  return json.encode(jsonDados);
	}
	
}