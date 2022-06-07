//
//  modelo.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 23/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

struct equip : Codable {
    var cod   : Int
    var ativo : Int
    var item  : String
}

var tools = [equip(cod: 1, ativo: 1, item:"Mesa"),
              equip(cod: 2, ativo: 0, item:"Masseira"),
              equip(cod: 3, ativo: 0, item:"Cilindro"),
              equip(cod: 4, ativo: 0, item:"Panela"),
              equip(cod: 5, ativo: 0, item:"Batederia"),
              equip(cod: 6, ativo: 0, item:"Forno"),
              equip(cod: 7, ativo: 0, item:"op1"),
              equip(cod: 8, ativo: 0, item:"op2")]

//var list_limp   = [""]
//var list_title  = ""
var statuslist  = [Int]()
var status      = [[Int]]()
var itemindex   = 0
var text_item   = 0
var C = 0
var D = 0
var U = 0

var producao = false

var bluetoooth      = false
var BLEprinter      = ""
var StayDaysFile    = 30
var compressFotos   = Float(0.4)


struct line   : Codable {
    var mC    : Int         // 0  CENTENA
    var mD    : Int         // 1  DEZENA
    var mU    : Int         // 2  UNIDADE
    var mS    : Int         // 3  STATUS
    var mP    : Int         // 4  PERIODO   D P S Q M 6 A .
    var use   : Int         // 9  ATIVO
    var NCF   : Int         // 10 NC FOTO  (ativo/nao ativo)
    var NCT   : Int         // 11 NC TEXT  (ativo/nao ativo)
    var CF    : Int         // 12 C  FOTO  (ativo/nao ativo)
    var CT    : Int         // 13 C  TEXTO (ativo/nao ativo)
    var foto  : String      // 5  NOME FOTO
    var txt   : String      // 6  TEXTO JUST
    var dF    : String      // 7  DATA FOTO
    var dT    : String      // 8  DATA TEXTO
}

var Matrix = [line(mC: 1, mD: 1, mU: 1, mS: 1, mP: 3, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 1, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 1, mU: 3, mS: 1, mP: 2, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 1, mU: 4, mS: 1, mP: 4, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 1, mU: 5, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 1, mU: 6, mS: 1, mP: 2, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 1, mD: 2, mU: 1, mS: 1, mP: 2, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 2, mU: 2, mS: 1, mP: 4, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 1, mD: 2, mU: 3, mS: 1, mP: 5, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 1, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 1, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 1, mU: 3, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 1, mU: 4, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 1, mU: 5, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 2, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 3, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 3, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 3, mU: 3, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 4, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 4, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 5, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 5, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 6, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 2, mD: 7, mU: 1, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 2, mD: 7, mU: 2, mS: 1, mP: 0, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 3, mD: 1, mU: 1, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 1, mU: 2, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 1, mU: 3, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 1, mU: 4, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 1, mU: 5, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 1, mU: 6, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 3, mD: 2, mU: 1, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 2, mU: 2, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 2, mU: 3, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               
               line(mC: 3, mD: 3, mU: 1, mS: 0, mP: 1, use: 1, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 2, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 3, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 4, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 5, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 6, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 7, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: ""),
               line(mC: 3, mD: 3, mU: 8, mS: 0, mP: 1, use: 0, NCF: 1, NCT: 1, CF: 1, CT: 0, foto: "", txt: "", dF: "", dT: "")]





struct itens : Codable {
    var mC    : Int         // 0  CENTENA
    var mD    : Int         // 1  DEZENA
    var mU    : Int         // 2  UNIDADE
    var ativo : Int
    var item  : String
}

struct cliente        : Codable {
    var cfpCNPJ       : String
    var nome          : String
    var empresa       : String
    var cadastroProd  : String
    var endereco      : String
    var cidade        : String
    var CEP           : String
    var area          : String
    var UF            : String
    var email         : String
    var tipoNegocio   : String
    var ProdOrg       : Int
}


var tarefas = [// Pragas e vetores
               itens(mC: 1, mD: 1, mU: 0, ativo: 1, item: "Pragas e vetores" ),
               itens(mC: 1, mD: 1, mU: 1, ativo: 1, item: "Uso de produto químico \"veneno\"" ),
               itens(mC: 1, mD: 1, mU: 2, ativo: 1, item: "Avistamento de insetos ou ratos" ),
               itens(mC: 1, mD: 1, mU: 3, ativo: 1, item: "Telas nas portas e janelas" ),
               itens(mC: 1, mD: 1, mU: 4, ativo: 1, item: "Telas estão bem conservadas" ),
               itens(mC: 1, mD: 1, mU: 5, ativo: 1, item: "Lixo foi retirado para um local adequado" ),
               itens(mC: 1, mD: 1, mU: 6, ativo: 1, item: "Sistema alternativo de CP&V funcionando" ),
               // Qualidade da Água
               itens(mC: 1, mD: 2, mU: 0, ativo: 1, item: "Qualidade da Água" ),
               itens(mC: 1, mD: 2, mU: 1, ativo: 1, item: "Cloração de H2O" ),
               itens(mC: 1, mD: 2, mU: 2, ativo: 1, item: "Analise de H2O" ),
               itens(mC: 1, mD: 2, mU: 3, ativo: 1, item: "Limpeza da caixa d´água" ),
               // Área externa
               itens(mC: 2, mD: 1, mU: 0, ativo: 1, item: "Área externa" ),
               itens(mC: 2, mD: 1, mU: 1, ativo: 1, item: "Livre de objetos em desuso" ),
               itens(mC: 2, mD: 1, mU: 2, ativo: 1, item: "Local cercado e livre de animais" ),
               itens(mC: 2, mD: 1, mU: 3, ativo: 1, item: "Piso, paredes e teto" ),
               itens(mC: 2, mD: 1, mU: 4, ativo: 1, item: "Papel toalha, sabonete e papel higienico" ),
               itens(mC: 2, mD: 1, mU: 5, ativo: 1, item: "Banheiro limpo" ),
               // Deposito MAT limpeza
               itens(mC: 2, mD: 2, mU: 0, ativo: 1, item: "Deposito MAT limpeza" ),
               itens(mC: 2, mD: 2, mU: 1, ativo: 1, item: "Organizado e limpo" ),
               // Depósito MAT Prima
               itens(mC: 2, mD: 3, mU: 0, ativo: 1, item: "Depósito MAT Prima" ),
               itens(mC: 2, mD: 3, mU: 1, ativo: 1, item: "Piso, paredes e teto" ),
               itens(mC: 2, mD: 3, mU: 2, ativo: 1, item: "Depósito limpo e organizado" ),
               itens(mC: 2, mD: 3, mU: 3, ativo: 1, item: "Depósito iluminado e ventilado" ),
               // Área de produção
               itens(mC: 2, mD: 4, mU: 0, ativo: 1, item: "Área de produção" ),
               itens(mC: 2, mD: 4, mU: 1, ativo: 1, item: "Piso, paredes, teto e pia" ),
               itens(mC: 2, mD: 4, mU: 2, ativo: 1, item: "Organizada e limpa" ),
               // Área de expedição
               itens(mC: 2, mD: 5, mU: 0, ativo: 1, item: "Área de expedição" ),
               itens(mC: 2, mD: 5, mU: 1, ativo: 1, item: "Piso, paredes e teto" ),
               itens(mC: 2, mD: 5, mU: 2, ativo: 1, item: "Limpa e organizada" ),
               // Veículo
               itens(mC: 2, mD: 6, mU: 0, ativo: 1, item: "Veículo" ),
               itens(mC: 2, mD: 6, mU: 1, ativo: 1, item: "Limpo e organizado" ),
               // Controle de pragas
               itens(mC: 2, mD: 7, mU: 0, ativo: 1, item: "Controle de pragas" ),
               itens(mC: 2, mD: 7, mU: 1, ativo: 1, item: "Avistamento de vestígios de insetos ou ratos" ),
               itens(mC: 2, mD: 7, mU: 2, ativo: 1, item: "Local cercado e livre de animais" ),
               // Controle de resíduos
               itens(mC: 3, mD: 1, mU: 0, ativo: 1, item: "Controle de resíduos" ),
               itens(mC: 3, mD: 1, mU: 1, ativo: 1, item: "Lixo retirado" ),
               itens(mC: 3, mD: 1, mU: 2, ativo: 1, item: "Lixo separado (orgânico & reciclado)" ),
               itens(mC: 3, mD: 1, mU: 3, ativo: 1, item: "Lixeira limpa e organizada" ),
               itens(mC: 3, mD: 1, mU: 4, ativo: 1, item: "Destino adequado (composteira ou coleta de reciclado)" ),
               itens(mC: 3, mD: 1, mU: 5, ativo: 1, item: "Caixa de gordura limpa" ),
               itens(mC: 3, mD: 1, mU: 6, ativo: 1, item: "Sistema de tratamento de água funcionando" ),
               // Apresentação Colaboradores
               itens(mC: 3, mD: 2, mU: 0, ativo: 1, item: "Apresentação Colaboradores" ),
               itens(mC: 3, mD: 2, mU: 1, ativo: 1, item: "Devidamento uniformizados" ),
               itens(mC: 3, mD: 2, mU: 2, ativo: 1, item: "Sem anel ou pulseira" ),
               itens(mC: 3, mD: 2, mU: 3, ativo: 1, item: "com touca" ),
               // Limpeza dos Equipamentos
               itens(mC: 3, mD: 3, mU: 0, ativo: 1, item: "Limpeza dos Equipamentos" ),
               itens(mC: 3, mD: 3, mU: 1, ativo: 0, item: "Mesa" ),
               itens(mC: 3, mD: 3, mU: 2, ativo: 1, item: "Masseira" ),
               itens(mC: 3, mD: 3, mU: 3, ativo: 0, item: "Cilindro" ),
               itens(mC: 3, mD: 3, mU: 4, ativo: 1, item: "Panela" ),
               itens(mC: 3, mD: 3, mU: 5, ativo: 0, item: "Batedeira" ),
               itens(mC: 3, mD: 3, mU: 6, ativo: 0, item: "Forno" ),
               itens(mC: 3, mD: 3, mU: 7, ativo: 0, item: "opcional 1" ),
               itens(mC: 3, mD: 3, mU: 8, ativo: 1, item: "opcional 2" )]



