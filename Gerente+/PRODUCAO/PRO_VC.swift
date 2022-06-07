//
//  PRO_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 18/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class PRO_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var RECvector = [REC_struct]()
    // TABELA RECEITAS
    let RECtable            = Table("REC")
    let DBreceita           = Expression<String>("DBreceita")
    let DBingredientes      = Expression<String>("DBingredientes")
    let DBmodoPreparo       = Expression<String>("DBmodoPreparo")
    let DBfotoRec           = Expression<String>("DBfotoRec")
    let DBseqRec            = Expression<Int>("DBseqRec")
    let DBdataRec           = Expression<String>("DBdataRec")
    let DBRendimento        = Expression<Double>("DBRendimento")
    let DBcodigo            = Expression<Int>("DBcodigo")        //colaborador
    
    var STATvector = [Status_struct]()
    // TABELA STATUS
    let STATtable           = Table("STAT")
    var DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")

    var PRODvector = [PRO_struct]()
    // TABELE PRODUCAO
    var PRODtable       = Table("PROD")
    //let DBreceita       = Expression<String>("DBreceita")
    let DBlote          = Expression<String>("DBlote")
    let DBdata          = Expression<String>("DBdata")
    let DBdataValidade      = Expression<String>("DBdataValidade")
    let DBquantidade    = Expression<Double>("DBquantidade")
    let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBrefrigeracao  = Expression<String>("DBrefrigeracao")
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    var HOJE = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for RECtable in try! db!.prepare(RECtable) {
            RECvector.append(
                REC_struct(RECreceita: String(RECtable[DBreceita]),
                RECingredientes: String(RECtable[DBingredientes]),
                RECmodoPreparo: String(RECtable[DBmodoPreparo]),
                RECfotoRec: String(RECtable[DBfotoRec]),
                RECseqRec: Int(RECtable[DBseqRec]),
                RECdataRec: String(RECtable[DBdataRec]),
                RECRendimento: Double(RECtable[DBRendimento]),
                RECcodigo: Int(RECtable[DBcodigo])))
        }
        
        for PRODtable in try! db!.prepare(PRODtable) {
            PRODvector.append(
                PRO_struct(Mreceita: String(PRODtable[DBreceita]),
                           Mlote: String(PRODtable[DBlote]),
                           Mdata: String(PRODtable[DBdata]),
                           Mvalidade: String(PRODtable[DBdataValidade]),
                           Mquantidade: Double(PRODtable[DBquantidade]),
                           Mcolaborador: String(PRODtable[DBcolaborador]),
                           Mrefrigeracao: String(PRODtable[DBrefrigeracao])))
        }
        
        PRODvector = PRODvector.reversed()
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        
        //thePicker2.delegate  = self
        //thePicker2.dataSource = self
        
        // linkar campos ao Picker
        receita.inputView           = thePicker1
        //validade.inputView          = thePicker2
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(REC_ITENS_VC.dismissPicker))
        receita.inputAccessoryView     = toolBar
        validade.inputAccessoryView    = toolBar
        
        quantidade.delegate = self
        quantidade.addDoneButtonToKeyboard(myAction:  #selector(self.quantidade.resignFirstResponder))
        
        adicionar_view.isHidden = true
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var myTableView: UITableView!

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(PRODvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PRODUCAO", for: indexPath) as! PRO_TC
        let PRODVector: PRO_struct
        PRODVector =  PRODvector[(indexPath as NSIndexPath).row]
    
        cell.receita.text       =  PRODVector.Mreceita
        cell.lote.text          =  PRODVector.Mlote
        cell.data.text          =  PRODVector.Mdata
        cell.validade.text      =  PRODVector.Mvalidade
        cell.refrigeracao.text  =  PRODVector.Mrefrigeracao
        cell.quantidade.text    =  String(PRODVector.Mquantidade)
        
        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //print(list[indexPath.row])
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //unchecked
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBOutlet weak var adicionar_view: UIView!
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm"
            let dateInFormat = dateFormatter.string(from: Date())
            data.text = dateInFormat
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
            
            if PRODvector.count > 0 {
               lote.text = PRODvector[PRODvector.count - 1].Mlote
            } else {
               lote.text = "1"
            }
            
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }
    
    @IBOutlet weak var receita: UITextField!
    @IBOutlet weak var quantidade: UITextField!
    @IBOutlet weak var validade: UITextField!
    @IBOutlet weak var refrigeracao: UISegmentedControl!
    @IBOutlet weak var lote: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var statusGravar: UIImageView!
    
    @IBAction func limpar(_ sender: UIButton) {
    
        receita.text                        = ""
        quantidade.text                     = ""
        validade.text                       = ""
        refrigeracao.selectedSegmentIndex   = 0
        lote.text                           = ""
        data.text                           = ""
        statusGravar.image                  = UIImage(named: "sign_orange")
        
    }
    @IBAction func gravar(_ sender: UIButton) {
        
        self.statusGravar.image = UIImage(named: "sign_orange")
        let db = try? Connection("\(path)/gerente.sqlite3")
        var seq = 0
        
        for PROD in try! db!.prepare(PRODtable) {
            print("id: \(PROD[DBlote])")
            seq = Int(PROD[DBlote])! + 1
        }
        lote.text = String(seq)
        let col = 1 // colaborador logado
        
        let f1  = lote.text
        let f2  = receita.text
        let f3  = Double(quantidade.text!)
        let f4  = validade.text
        let f5  = String(refrigeracao.selectedSegmentIndex)
        let f6  = data.text
        let f7  = String(col)
        
        if f2 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: RECEITA\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        let insert = PRODtable.insert(DBlote         <- f1!,
                                     DBreceita       <- f2!,
                                     DBquantidade    <- f3!,
                                     DBdataValidade  <- f4!,
                                     DBrefrigeracao  <- f5,
                                     DBdata          <- f6!,
                                     DBcolaborador   <- f7)
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "PRODUÇÃO Cadastrada com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.statusGravar.image = UIImage(named: "sign_green")
            
             // ATUALIZAR O STATUS PARA NC
            for index in 0...Matrix.count-1 {
                if Matrix[index].mP == 1 {
                    print(Matrix[index].mC, Matrix[index].mD, Matrix[index].mU, Matrix[index].mS)
                    if Matrix[index].mS == 0 { Matrix[index].mS = 1}
                }
            }
            
            let db = try? Connection("\(path)/gerente.sqlite3")
            // GRAVA NO DB DE TAREFAS DO DIA MATRIX ATUALIZADA
            // JSON
            var jsonString = ""
            do {
                //encode
                let jsonData = try JSONEncoder().encode(Matrix)
                jsonString = String(data: jsonData, encoding: .utf8)!
                //decode
                //let OldMatrix = try JSONDecoder().decode([line].self, from: string)//jsonData)
            } catch { print(error) }
 
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            HOJE = dateFormatter.string(from: Date())

            let update = self.STATtable .filter(self.DBStatusData == HOJE).update(
                self.DBProducao  <- "1",
                self.DBflag      <- jsonString)
            do{
                _ = try db!.run(update)
                print("matrix gravada no status")
                
            }  catch {
                print("matrix gravada no status ERRO: \(error)")
            }
            // status ---
            producao = true
            self.refresh()
        } catch {
            print("erro na inclusao do PRODUCAO")
            self.refresh()
        }
    }
    
    func dismissPicker() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // END FUNCOES
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RECvector.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let RECVector: REC_struct
        RECVector = RECvector[row]
        receita.text = RECVector.RECreceita

        return RECVector.RECreceita
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    // end picker
    
    
    // DATE PICKER
    var valid = Double(0) // NUMERO DE DIAS PARA VALIDADE
    
    @IBAction func G0Valid(_ sender: UITextField) {
        //view.endEditing(true)
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        validade.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(PRO_VC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        validade.text = dateFormatter.string(from: sender.date)
        
    }
    // END DATE PICKER
    
    func refresh(){

        // ATUALIZA A TABELA DAS PRODUCOES
        self.PRODvector.removeAll()
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        for PRODtable in try! db!.prepare(PRODtable) {
            PRODvector.append(
                PRO_struct(Mreceita: String(PRODtable[DBreceita]),
                           Mlote: String(PRODtable[DBlote]),
                           Mdata: String(PRODtable[DBdata]),
                           Mvalidade: String(PRODtable[DBdataValidade]),
                           Mquantidade: Double(PRODtable[DBquantidade]),
                           Mcolaborador: String(PRODtable[DBcolaborador]),
                           Mrefrigeracao: String(PRODtable[DBrefrigeracao])))
        }
        
        PRODvector = PRODvector.reversed()
        myTableView.reloadData()
    }
}

