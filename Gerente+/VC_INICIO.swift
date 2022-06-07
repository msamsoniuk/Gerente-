//
//  VC_INICIO.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 01/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

var statusGeralTarefas = true
var firstTime = true

class VC_INICIO: UIViewController {
    
     // TABELA DADOS DO CLIENTE
     let CLItable        = Table("Cliente")
     let DBcfpCNPJ       = Expression<String>("DBcfpCNPJ")
     let DBnome          = Expression<String>("DBnome")
     let DBempresa       = Expression<String>("DBempresa")
     let DBcadastroProd  = Expression<String>("DBcadastroProd")
     let DBendereco      = Expression<String>("DBendereco")
     let DBcidade        = Expression<String>("DBcidade")
     let DBCEP           = Expression<String>("DBCEP")
     let DBarea          = Expression<String>("DBarea")
     let DBUF            = Expression<String>("DBUF")
     //let DBemail         = Expression<String>("DBemail")
     let DBtipoNegocio   = Expression<String>("DBtipoNegocio")
     let DBProdOrg       = Expression<Int>("DBProdOrg")
    
    // TABELE PRODUCAO
    let PRODtable           = Table("PROD")
    //let DBreceita         = Expression<String>("DBreceita")
    //let DBlote            = Expression<String>("DBlote")
    let DBdata              = Expression<String>("DBdata")
    //let DBdataValidade    = Expression<String>("DBdataValidade")
    //let DBquantidade      = Expression<Double>("DBquantidade")
    //let DBcolaborador     = Expression<String>("DBcolaborador")
    let DBrefrigeracao      = Expression<String>("DBrefrigeracao")
    
    
    // TABLE MP ->MATERIA PRIMA
    let MPtable             = Table("MP")
    let DBproduto           = Expression<String>("DBproduto")
    let DBunidade           = Expression<String>("DBunidade")
    let DBvalidade          = Expression<Double>("DBvalidade")
    let DBval_tipo          = Expression<String>("DBval_tipo")
    let DBPosNeg            = Expression<String>("DBPosNeg")
    let DBtempArmazenagem   = Expression<Double>("DBtempArmazenagem")
    let DBarmazenagem       = Expression<Int>("DBarmazenagem")
    let DBproducao          = Expression<Bool>("DBproducao")
    let DBorganico          = Expression<Bool>("DBorganico")
    let DBcodigo       = Expression<Int>("DBcodigo")
    let DBdataMP            = Expression<String>("DBdataMP")
    

    // TABLE COLABORADOR
    let COLtable         = Table("COL")
    let DBcolaborador    = Expression<String>("DBcolaborador")
    let DBemail          = Expression<String>("DBemail")
    //let DBcodigo         = Expression<Int>("DBcodigo")
    let DBcelular        = Expression<String>("DBcelular")
    let DBfixo           = Expression<String>("DBfixo")
    let DBfoto           = Expression<String>("DBfoto")
    let DBdataCOL        = Expression<String>("DBdataCOL")
    let DBsenha          = Expression<String>("DBsenha")
    let DBfotoCDBP       = Expression<String>("DBfotoCDBP")
    let DBdataCDBP       = Expression<String>("DBdataCDBP")
    let DBfotoADS        = Expression<String>("DBfotoADS")
    let DBdataADS        = Expression<String>("DBdataADS")
    let DBpops           = Expression<String>("DBpops")
    
    // TABELA ENTRADA DE MP
    let EMPtable        = Table("EMP")
    // let DBproduto         = Expression<String>("DBproduto")
    let DBquantidade      = Expression<Double>("DBquantidade")
    // let DBunidade         = Expression<String>("DBunidade")
   // let DBvalor           = Expression<Double>("DBvalor")
    let DBlote            = Expression<String>("DBlote")
    let DBdataValidade    = Expression<String>("DBdataValidade")
    let DBdataEntrada     = Expression<String>("DBdataEntrada")
    let DBbarcode         = Expression<String>("DBbarcode")
    let DBnfeFoto         = Expression<String>("DBnfeFoto")
    let DBcorigemFoto     = Expression<String>("DBcorigemFoto")
    let DBsequencia       = Expression<Int>("DBsequencia")
    //let DBcodigo            = Expression<Int>("DBcodigo") // colaborador
    
    // TABELA RECEITAS
    let RECtable            = Table("REC")
    let DBreceita           = Expression<String>("DBreceita")
    let DBingredientes      = Expression<String>("DBingredientes")
    let DBmodoPreparo       = Expression<String>("DBmodoPreparo")
    let DBfotoRec           = Expression<String>("DBfotoRec")
    let DBseqRec            = Expression<Int>("DBseqRec")
    let DBdataRec           = Expression<String>("DBdataRec")
    let DBRendimento        = Expression<Double>("DBRendimento")
   // let DBcodigo            = Expression<String>("DBcodigo")
    
    
    // TABELA STATUS
    let STATtable           = Table("STAT")
    let DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")
    

    // TABELA DOCUMENTOS
    let DOCStable           = Table("DOCS")
    let DBdocIndex          = Expression<Int>("DBdocIndex")
    let DBdocFoto           = Expression<String>("DBdocFoto")
    let DBdocVenc           = Expression<String>("DBdocVenc")
    let DBdocData           = Expression<String>("DBdocData")
    //let DBcolaborador     = Expression<String>("DBcolaborador")
    
    // TABELE EXPEDICAO
    let EXPtable        = Table("EXP")
    //let DBreceita       = Expression<String>("DBreceita")
    //let DBlote          = Expression<String>("DBlote")
    //let DBdata          = Expression<String>("DBdata")
   // let DBdataValidade  = Expression<String>("DBdataValidade")
   // let DBquantidade    = Expression<Double>("DBquantidade")
   // let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBnfe           = Expression<String>("DBnfe")
    let DBvalor         = Expression<Double>("DBvalor")
    let DBquebra        = Expression<Int>("DBquebra")
    
    // TABELE RECOLHIMENTO
    let RECOLtable         = Table("RECOL")
    let DBReclamIndex          = Expression<Int>("DBReclamIndex")
    let DBreclamante       = Expression<String>("DBreclamante")
    let DBemailReclam      = Expression<String>("DBemailReclam")
    let DBdataReclam       = Expression<String>("DBdataReclam")
    let DBdataFab          = Expression<String>("DBdataFab")
    //let DBproduto          = Expression<String>("DBproduto")
    let DBamostraData      = Expression<String>("DBamostraData")
    let DBamostraFoto      = Expression<String>("DBamostraFoto")
    let DBamostraTexto     = Expression<String>("DBamostraTexto")
    let DBcontaminado      = Expression<Int>("DBcontaminado")
   // let DBcolaborador      = Expression<String>("DBcolaborador")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    var resetDay        = false

    @IBOutlet weak var statusProducao: UIImageView!
    @IBOutlet weak var statusTarefas: UIImageView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var myView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        if producao { statusProducao.image = UIImage(named: "sign_run") } else { statusProducao.image = UIImage(named: "sign_orange") }
        
        if statusGeralTarefas { statusTarefas.image = UIImage(named: "sign_run") } else { statusTarefas
            .image = UIImage(named: "sign_green") }
         //statusGeralTarefas
    }
    

    @IBAction func fecharFV(_ sender: UIButton) {
        //firstView.isHidden = true
    }
    
    @IBOutlet weak var noFirstTimeStatus: UIImageView!
    @IBAction func noFirstTime(_ sender: UIButton) {
        noFirstTimeStatus.image = UIImage(named: "sign_green")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let mem = defaults.string(forKey: "negocioFlag")
        if mem == nil { firstTime = true} else {firstTime = false }
        
       // if firstTime {
       //     firstView.isHidden = false
       //     myView.isHidden    = true
       // } else {
            firstView.isHidden = true
            myView.isHidden    = false
       // }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "SenhaMaster") == nil {
            UserDefaults.standard.set("12345", forKey: "SenhaMaster")
        }
    

        
        // CRIA BD MP CASO NAO EXISTA

        let db = try? Connection("\(path)/gerente.sqlite3")
        do{try db!.run(MPtable.create(ifNotExists: true) { t in
            t.column(DBproduto, primaryKey: true)
            t.column(DBunidade)
            t.column(DBvalidade)
            t.column(DBval_tipo)
            t.column(DBPosNeg)
            t.column(DBtempArmazenagem)
            t.column(DBarmazenagem)
            t.column(DBproducao)
            t.column(DBorganico)
            t.column(DBcodigo)
            t.column(DBdataMP)
        })
        } catch {
            print("MP - FALHA AO CRIAR: \(error)")
        }

        do{try db!.run(EMPtable.create(ifNotExists: true) { t in
            t.column(DBsequencia, primaryKey: true)
            t.column(DBproduto)
            t.column(DBquantidade)
            t.column(DBunidade)
            t.column(DBvalor)
            t.column(DBlote)
            t.column(DBdataValidade)
            t.column(DBdataEntrada)
            t.column(DBbarcode)
            t.column(DBnfeFoto)
            t.column(DBcorigemFoto)
            t.column(DBcodigo)
        })
        } catch {
            print("EMP - FALHA AO CRIAR: \(error)")
        }

        do{try db!.run(COLtable.create(ifNotExists: true) { t in
            t.column(DBcolaborador, primaryKey: true)
            t.column(DBemail)
            t.column(DBcodigo)
            t.column(DBcelular)
            t.column(DBfixo)
            t.column(DBfoto)
            t.column(DBdataCOL)
            t.column(DBsenha)
            t.column(DBfotoCDBP)
            t.column(DBdataCDBP)
            t.column(DBfotoADS)
            t.column(DBdataADS)
            t.column(DBpops)
        })
        } catch {
            print("COL - FALHA AO CRIAR: \(error)")
        }
        
        do{try db!.run(COLtable.addColumn(DBfotoCDBP, defaultValue: ""))} catch {print("add col failed: \(error)")}
        do{try db!.run(COLtable.addColumn(DBdataCDBP, defaultValue: ""))} catch {print("add col failed: \(error)")}
        do{try db!.run(COLtable.addColumn(DBfotoADS, defaultValue: ""))} catch {print("add col failed: \(error)")}
        do{try db!.run(COLtable.addColumn(DBdataADS, defaultValue: ""))} catch {print("add col failed: \(error)")}
        do{try db!.run(COLtable.addColumn(DBpops, defaultValue: "0 0 0 0 0 0 0 0 0"))} catch {print("add col failed: \(error)")}
    
        
        do{try db!.run(RECtable.create(ifNotExists: true) { t in
            t.column(DBreceita, primaryKey: true)
            t.column(DBingredientes)
            t.column(DBmodoPreparo)
            t.column(DBfotoRec)
            t.column(DBseqRec)
            t.column(DBdataRec)
            t.column(DBRendimento)
            t.column(DBcodigo)
        })
        } catch {
            print("COL - FALHA AO CRIAR: \(error)")
        }
        
        
        do{try db!.run(STATtable.create(ifNotExists: true) { t in
            t.column(DBStatusData, primaryKey: true)
            t.column(DBProducao)
            t.column(DBVector)
            t.column(DBflag)
        })
        } catch {
            print("COL - FALHA AO CRIAR: \(error)")
        }
        
        do{try db!.run(PRODtable.create(ifNotExists: true) { t in
            t.column(DBlote, primaryKey: true)
            t.column(DBreceita)
            t.column(DBdata)
            t.column(DBdataValidade)
            t.column(DBquantidade)
            t.column(DBcolaborador)
            t.column(DBrefrigeracao)
        })
        } catch {
            print("COL - FALHA AO CRIAR: \(error)")
        }
        
        do{try db!.run(DOCStable.create(ifNotExists: true) { t in
            t.column(DBdocIndex, primaryKey: true)
            t.column(DBdocFoto)
            t.column(DBdocVenc)
            t.column(DBdocData)
            t.column(DBcolaborador)
        })
        } catch {
            print("COL - FALHA AO CRIAR: \(error)")
        }

       // ROTINA PARA ZERAR DB
       // do{ try db!.run(EXPtable.delete())} catch {
       //     print("EXP - FALHA AO eliminar: \(error)")
       // }

        do{try db!.run(EXPtable.create(ifNotExists: true) { t in
            t.column(DBlote, primaryKey: true)
            t.column(DBreceita)
            t.column(DBdata)
            t.column(DBdataValidade)
            t.column(DBquantidade)
            t.column(DBcolaborador)
            t.column(DBnfe)
            t.column(DBvalor)
            t.column(DBquebra)
        })
        } catch {
            print("EXP - FALHA AO CRIAR: \(error)")
        }
        
        do{try db!.run(CLItable.create(ifNotExists: true) { t in
            t.column(DBcfpCNPJ, primaryKey: true)
            t.column(DBnome)
            t.column(DBempresa)
            t.column(DBcadastroProd)
            t.column(DBendereco)
            t.column(DBcidade)
            t.column(DBCEP)
            t.column(DBarea)
            t.column(DBUF)
            t.column(DBemail)
            t.column(DBtipoNegocio)
            t.column(DBProdOrg)
        })
        } catch {
            print("EXP - FALHA AO CRIAR: \(error)")
        }
        
        do{try db!.run(CLItable.addColumn(DBUF, defaultValue: "PR"))} catch {
            print("add column drop  failed: \(error)")
        }
        
        
        do{try db!.run(RECOLtable.create(ifNotExists: true) { t in
            t.column(DBReclamIndex, primaryKey: true)
            t.column(DBreclamante)
            t.column(DBemailReclam)
            t.column(DBdataReclam)
            t.column(DBdataFab)
            t.column(DBproduto)
            t.column(DBamostraData)
            t.column(DBamostraFoto)
            t.column(DBamostraTexto)
            t.column(DBcontaminado)
            t.column(DBcolaborador)
        })
        } catch {
            print("EXP - FALHA AO CRIAR: \(error)")
        }

        print("\n========\n\(path)\n========\n")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let HOJE = dateFormatter.string(from: Date())
        
        self.retrive()
        var oldMatrix = [line]() // cria copia Matrix vazia
        
        for _ in try! db!.prepare(STATtable.filter(DBStatusData == HOJE && !resetDay)) {
             print("existe HOJE - carregando valores")
            
            // CARREGANDO MATRIX DO DIA
            // ***********************************************
            // GRAVAR NO DB NOVA MATRIX
            // CARREGANDO MATRIX DO DIA CORRENTE PELO DB

            for STATtable in try! db!.prepare(STATtable){
                STATvector.append(Status_struct(
                    MStatusData: String(STATtable[DBStatusData]),
                    MProducao: String(STATtable[DBProducao]),
                    MVector: String(STATtable[DBVector]),
                    Mflag: String(STATtable[DBflag])))
            }

            var STATVector : Status_struct
            for i in 0...STATvector.count - 1 {
                STATVector = STATvector[i]
                if STATVector.MStatusData == HOJE {
                    //print("buscado valores na Matrix HOJE")
                    //json
                    if STATVector.Mflag != "" {
                        if STATVector.MProducao == "1" {producao = true}
                        
                        let string = (STATVector.Mflag).data(using: .utf8)!
                        do {
                            //ENCODE JSON
                            //let jsonData = try JSONEncoder().encode(Matrix)
                            //let jsonString = String(data: jsonData, encoding: .utf8)!
                            //print(jsonString)
        
                            //DECODE JSON
                            Matrix = try JSONDecoder().decode([line].self, from: string)
                        } catch { print(error) }
                    }
                }
            }

            var days = 0
            for k in 0...Matrix.count - 1 {
                if Matrix[k].mC == 1 {
                    let HStatus = Matrix[k].mP
                    switch HStatus {
                    case 0:
                        days = 0 // " [D]"
                    case 1:
                        days = 0 // " [P]"
                    case 2:
                        days = 7 // " [S]"
                    case 3:
                        days = 15 // " [Q]"
                    case 4:
                        days = 30 // " [M]"
                    case 5:
                        days = 180 // " [6]"
                    case 6:
                        days = 365 // " [A]"
                    default:
                        break
                    }

                    // CORRECAO PARA PROCEDIMENTOS COM DATA VENCIDA
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    
                    let secondDate = formatter.date(from: Matrix[k].dF)
                    if secondDate != nil {
                        let components = Calendar.current.dateComponents([.day], from: secondDate!, to: Date())
                        var totalDias = 0
                        print("components: \(components)")
                        if components.day != nil {totalDias = days - components.day!}
                        
                        if totalDias < 0 {
                            Matrix[k].mS = 1
                        }
                    }
                }
            }
            self.upMemory()
    
            //if Matrix.index(where: {
            //    $0.mP == 1 && $0.mS != 0}) != nil { producao = false }
        
            return // NAO EXECUTA O DIA ANTERIOR
        }

        // TROCA DE DIA
        // CASO INICIE OUTRO DIA
        print("iniciar novo dia")
        
        var ONTEM = ""
        do{
            for record in (try db?.prepare(STATtable))! {
                //print("id: \(record[DBStatusData])")
                ONTEM = record[DBStatusData]
            }
        } catch {
            print("run fail: \(error)")
        }

        for _ in try! db!.prepare(STATtable.filter(DBStatusData == ONTEM)) {
            print("carregando dados de ONTEM \(ONTEM)")
            
            // CARREGANDO MATRIX DO DIA ANTERIOR
            // ***********************************************
            // GRAVAR NO DB NOVA MATRIX
            // CARREGANDO MATRIX DO DIA CORRENTE PELO DB

            for STATtable in try! db!.prepare(STATtable){
                STATvector.append(Status_struct(
                    MStatusData: String(STATtable[DBStatusData]),
                    MProducao: String(STATtable[DBProducao]),
                    MVector: String(STATtable[DBVector]),
                    Mflag: String(STATtable[DBflag])))
            }
            
            var STATVector : Status_struct
            for i in 0...STATvector.count - 1 {
                STATVector = STATvector[i]
                if STATVector.MStatusData == ONTEM {
                    
                    //json
                    if STATVector.Mflag != "" {
                        let string = (STATVector.Mflag).data(using: .utf8)!
                        do {
                            // ENCODE JSON
                            //let jsonData = try JSONEncoder().encode(Matrix)
                            //let jsonString = String(data: jsonData, encoding: .utf8)!
                            //print(jsonString)
                            
                            // DECODE JSON
                            oldMatrix = try JSONDecoder().decode([line].self, from: string)
                        } catch { print(error) }
                    }
                }
            }

            // // REPASSA OS CONTROLE DO DIA ANTERIOR PARA O ATUAL
            var days = 0
            for k in 0...Matrix.count - 1 {
                if Matrix[k].mC == 1 {
                    let HStatus = Matrix[k].mP
                    switch HStatus {
                    case 0:
                        days = 0 // " [D]"
                    case 1:
                        days = 0 // " [P]"
                    case 2:
                        days = 7 // " [S]"
                    case 3:
                        days = 15 // " [Q]"
                    case 4:
                        days = 30 // " [M]"
                    case 5:
                        days = 180 // " [6]"
                    case 6:
                        days = 365 // " [A]"
                    default:
                        break
                    }
                    
                    Matrix[k].mS   = oldMatrix[k].mS
                    Matrix[k].foto = oldMatrix[k].foto
                    Matrix[k].txt  = oldMatrix[k].txt
                    Matrix[k].dF   = oldMatrix[k].dF
                    Matrix[k].dT   = oldMatrix[k].dT
                    
                    Matrix[k].use  = oldMatrix[k].use
                    Matrix[k].NCF  = oldMatrix[k].NCF
                    Matrix[k].NCT  = oldMatrix[k].NCT
                    Matrix[k].CF   = oldMatrix[k].CF
                    Matrix[k].CT   = oldMatrix[k].CT
                    
                    
                    // CORRECAO PARA PROCEDIMENTOS COM DATA VENCIDA
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"

                    let secondDate = formatter.date(from: Matrix[k].dF)
                    if secondDate != nil {
                        let components = Calendar.current.dateComponents([.day], from: secondDate!, to: Date())
                        var totalDias = 0
                        print("components: \(components)")
                        if components.day != nil {totalDias = days - components.day!}
                        
                        if totalDias < 0 {
                            Matrix[k].mS = 1
                        }
                    }
                }
            }
        }
        // GUARDAR DADOS NO DB
        //return
        
       // if Matrix.index(where: {
       //     $0.mP == 1 && $0.mS != 0}) != nil { producao = true }
        
        self.upMemory()
        
        var jsonString = ""
        do {
            // ENCODE JSON
            let jsonData = try JSONEncoder().encode(Matrix)
            jsonString = String(data: jsonData, encoding: .utf8)!
            
            // DECODE JSON
            //let OldMatrix = try JSONDecoder().decode([line].self, from: string)//jsonData)
        } catch { print(error) }
        
        
        
        //var flagprod = "0"
        //if producao { flagprod = "1"}
        
        let insert = STATtable.insert(DBStatusData <- HOJE,
                                      DBProducao   <- "0",
                                      DBVector     <- "", //String(describing: Matrix),
                                      DBflag       <- jsonString)
        
        do{
            _ = try db!.run(insert)
            print("insertion Principal OK - COM DADOS DE ONTEM")
            
        } catch {
            print("insertion Principal failed ONTEM: \(error)")
        }
    }

    var STATvector = [Status_struct]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func retrive() {
        // retrive memory
        let defaults = UserDefaults.standard
        
        var mem = defaults.string(forKey: "TextEqui1")
        if mem != nil { tools[0].item = mem!}
        mem = defaults.string(forKey: "equi1")
        if mem != nil  { tools[0].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui2")
        if mem != nil { tools[1].item = mem!}
        mem = defaults.string(forKey: "equi2")
        if mem != nil  { tools[1].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui3")
        if mem != nil { tools[2].item = mem!}
        mem = defaults.string(forKey: "equi3")
        if mem != nil  { tools[2].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui4")
        if mem != nil { tools[3].item = mem!}
        mem = defaults.string(forKey: "equi4")
        if mem != nil  { tools[3].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui5")
        if mem != nil { tools[4].item = mem!}
        mem = defaults.string(forKey: "equi5")
        if mem != nil  { tools[4].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui6")
        if mem != nil { tools[5].item = mem!}
        mem = defaults.string(forKey: "equi6")
        if mem != nil  { tools[5].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui7")
        if mem != nil { tools[6].item = mem!}
        mem = defaults.string(forKey: "equi7")
        if mem != nil  { tools[6].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "TextEqui8")
        if mem != nil { tools[7].item = mem!}
        mem = defaults.string(forKey: "equi8")
        if mem != nil  { tools[7].ativo = Int(mem!)! }
        
        mem = defaults.string(forKey: "Textbluet")
        if mem != nil { BLEprinter = mem!}
        mem = defaults.string(forKey: "bluet")
        if mem != nil  { if mem == "1" {bluetoooth = true} else {bluetoooth = false}}
        
        mem = defaults.string(forKey: "DiasArq")
        if mem != nil { StayDaysFile = Int(mem!)!}
        
        mem = defaults.string(forKey: "compressao")
        if mem != nil  { compressFotos = Float(mem!)! }
        
        mem = defaults.string(forKey: "resetDay")
        if mem != nil  {
            if mem == "1" {resetDay = true
                defaults.set(false, forKey: "resetDay")
            } else {resetDay = false}
        }
        // atualiza os status da matrix de tarefas
        // com equipamentos ativos ou nao

    }
    func upMemory() {
        for i in 0...tools.count-1 {
            if let index = Matrix.firstIndex(where: {
                $0.mC == 3
                    && $0.mD == 3
                    && $0.mU == i+1}) {
                Matrix[index].use = tools[i].ativo
            }
            if let index = tarefas.firstIndex(where: {
                $0.mC == 3
                    && $0.mD == 3
                    && $0.mU == i+1}) {
                tarefas[index].ativo = tools[i].ativo
                tarefas[index].item  = tools[i].item
            }
        }
        
    }
}

//var bluetoooth = false
//var BLEprinter = ""


extension String {
    var currency: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: ".", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        
        if let result = NumberFormatter().number(from: stringWithoutComma) {
            
            let valor = String(Double(result ) / 10.0)
            
            return valor
        }
        
        return self
    }
}



