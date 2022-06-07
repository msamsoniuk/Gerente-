//
//  REC_ITENS_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 16/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

var REClist     = [[String]]()

class REC_ITENS_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var tempstring = ""

    var MPvector    = [MP_struct]()
    var EMPvector   = [EMP_struct]()
    var COLvector   = [COL_struct]()
    
    var UNIvector   = [UNIstruc]()
    
    var vector = ["unidade","xícara chá","colher sopa","colher chá","litro","kg","grama"]
    
    struct ITENSstruc {
        let item        : String
        let unidade     : String
        let quantidade  : Double
        let peso        : Double
        let rec_name    : String
    }
    struct UNIstruc {
        let unidade   : String
        let xicara    : Double
        let colherS   : Double
        let colherC   : Double
    }
    
    // TABLE MATERIA PRIMA
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
    let DBcodigo            = Expression<Int>("DBcodigo")
    let DBdataMP            = Expression<String>("DBdataMP")
    
    
    // TABELA COLABORADORES
    let COLtable        = Table("COL")
    let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBemail         = Expression<String>("DBemail")
    //let DBcodigo        = Expression<Int>("DBcodigo")
    let DBcelular       = Expression<String>("DBcelular")
    let DBfixo          = Expression<String>("DBfixo")
    let DBfoto          = Expression<String>("DBfoto")
    let DBdataCOL       = Expression<String>("DBdataCOL")
    let DBsenha         = Expression<String>("DBsenha")
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
    let DBvalor           = Expression<Double>("DBvalor")
    let DBlote            = Expression<String>("DBlote")
    let DBdataValidade    = Expression<String>("DBdataValidade")
    let DBdataEntrada     = Expression<String>("DBdataEntrada")
    let DBbarcode         = Expression<String>("DBbarcode")
    let DBnfeFoto         = Expression<String>("DBnfeFoto")
    let DBcorigemFoto     = Expression<String>("DBcorigemFoto")
    let DBsequencia       = Expression<Int>("DBsequencia")
    //let DBcodigo            = Expression<Int>("DBcodigo") // colaborador
    
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    @IBOutlet weak var TFproduto: UITextField!
    @IBOutlet weak var TFunidade: UITextField!
    @IBOutlet weak var TFquantidade: UITextField!
    @IBOutlet weak var TFpeso: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rec_name.text = tempstring
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        
        thePicker2.delegate  = self
        thePicker2.dataSource = self
        
        // linkar campos ao Picker
        TFproduto.inputView   = thePicker1
        TFunidade.inputView   = thePicker2
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(REC_ITENS_VC.dismissPicker))
        TFproduto.inputAccessoryView      = toolBar
        TFunidade.inputAccessoryView = toolBar
        
        
        TFquantidade.delegate = self
        TFquantidade.addDoneButtonToKeyboard(myAction:  #selector(self.TFquantidade.resignFirstResponder))
        
        TFpeso.delegate = self
        TFpeso.addDoneButtonToKeyboard(myAction:  #selector(self.TFpeso.resignFirstResponder))
        
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for MPtable in try! db!.prepare(MPtable) {
            MPvector.append(MP_struct(AMPproduto        :String(MPtable[DBproduto]),
                                      AMPunidade        :String(MPtable[DBunidade]),
                                      AMPvalidade       :Double(MPtable[DBvalidade]),
                                      AMPval_tipo       :String(MPtable[DBval_tipo]),
                                      AMPPosNeg         :String(MPtable[DBPosNeg]),
                                      AMPtempArmazenagem:Double(MPtable[DBtempArmazenagem]),
                                      AMParmazenagem    :Int(MPtable[DBarmazenagem]),
                                      AMPproducao       :Bool(MPtable[DBproducao]),
                                      AMPorganico       :Bool(MPtable[DBorganico]),
                                      AMPcodigo         :Int(MPtable[DBcodigo]),
                                      AMPdataMP         :String(MPtable[DBdataMP])))
        }
        for COLtable in try! db!.prepare(COLtable) {
            COLvector.append(COL_struct(AMPcolaborador: String(COLtable[DBcolaborador]),
                                        AMPemail:       String(COLtable[DBemail]),
                                        AMPcodigo:      Int(COLtable[DBcodigo]),
                                        AMPcelular:     String(COLtable[DBcelular]),
                                        AMPfixo:        String(COLtable[DBfixo]),
                                        AMPfoto:        String(COLtable[DBfoto]),
                                        AMPdata:        String(COLtable[DBdataCOL]),
                                        AMPsenha:       String(COLtable[DBsenha]),
                                        AMPfotoCDBP:    String(COLtable[DBfotoCDBP]),
                                        AMPdataCDBP:    String(COLtable[DBdataCDBP]),
                                        AMPfotoADS:     String(COLtable[DBfotoADS]),
                                        AMPdataADS:     String(COLtable[DBdataADS]),
                                        AMPpops:        String(COLtable[DBpops])
            ))
        }
        
        
        for EMPtable in try! db!.prepare(EMPtable) {
            EMPvector.append(EMP_struct(EMPproduto          :String(EMPtable[DBproduto]),
                                        EMPquantidade       :Double(EMPtable[DBquantidade]),
                                        EMPunidade          :String(EMPtable[DBunidade]),
                                        EMPvalor            :Double(EMPtable[DBvalor]),
                                        EMPlote             :String(EMPtable[DBlote]),
                                        EMPdataValidade     :String(EMPtable[DBdataValidade]),
                                        EMPdataEntrada      :String(EMPtable[DBdataEntrada]),
                                        EMPbarcode          :String(EMPtable[DBbarcode]),
                                        EMPnfeFoto          :String(EMPtable[DBnfeFoto]),
                                        EMPcorigemFoto      :String(EMPtable[DBcorigemFoto]),
                                        EMPsequencia        :Int(EMPtable[DBsequencia]),
                                        EMPcodigo           :Int(EMPtable[DBcodigo])))
        }

        UNIvector = [
            UNIstruc(unidade:"Açúcar cristal/demerara"  , xicara:180, colherS:10,  colherC:5),
            UNIstruc(unidade:"Açúcar de confeiteiro"    , xicara:140, colherS:9.5, colherC:3),
            UNIstruc(unidade:"Açúcar refinado"          , xicara:180, colherS:12,  colherC:4),
            UNIstruc(unidade:"Amêndoas/castanhas"       , xicara:140, colherS:10,  colherC:3.5),
            UNIstruc(unidade:"Amido de milho"           , xicara:150, colherS:9,   colherC:3),
            UNIstruc(unidade:"Arroz cru"                , xicara:175, colherS:15,  colherC:5),
            UNIstruc(unidade:"Aveia"                    , xicara:115, colherS:5,   colherC:2.5),
            UNIstruc(unidade:"Cebola picada"            , xicara:110, colherS:10,  colherC:5),
            UNIstruc(unidade:"Chocolate em pó/cacau"    , xicara:100, colherS:10,  colherC:5),
            UNIstruc(unidade:"Creme de leite"           , xicara:240, colherS:15,  colherC:5),
            UNIstruc(unidade:"Creme de leite fresco"    , xicara:240, colherS:15,  colherC:5),
            UNIstruc(unidade:"Cocô"                     , xicara:80 , colherS:5,   colherC:1.5),
            UNIstruc(unidade:"Farinha de rosca"         , xicara:140, colherS:5,   colherC:2.5),
            UNIstruc(unidade:"Feijão cru"               , xicara:200, colherS:10,  colherC:5),
            UNIstruc(unidade:"Grão de bico cozido"      , xicara:170, colherS:20,  colherC:10),
            UNIstruc(unidade:"Grão de bico cru"         , xicara:195, colherS:15,  colherC:5),
            UNIstruc(unidade:"Manteiga/margarina"       , xicara:200, colherS:12,  colherC:4),
            UNIstruc(unidade:"Mel"                      , xicara:300, colherS:18,  colherC:6),
            UNIstruc(unidade:"Milho cru"                , xicara:200, colherS:20,  colherC:10),
            UNIstruc(unidade:"Passas"                   , xicara:140, colherS:15,  colherC:5),
            UNIstruc(unidade:"Polvilho doce/azedo"      , xicara:155, colherS:15,  colherC:2.5),
            UNIstruc(unidade:"Queijo ralado"            , xicara:80 , colherS:6,   colherC:1.8),
            UNIstruc(unidade:"Sal"                      , xicara:200, colherS:20,  colherC:5),
            UNIstruc(unidade:"Fermento em pó (químico)" , xicara:180, colherS:14,  colherC:5),
            UNIstruc(unidade:"Bicarbonato de sódio"     , xicara:180, colherS:14,  colherC:5),
            UNIstruc(unidade:"Fermento biológico seco"  , xicara:150, colherS:10,  colherC:3.5),
            UNIstruc(unidade:"fermento biológico fresco", xicara:150, colherS:30,  colherC:10.5),
            UNIstruc(unidade:"Óleos e Azeites"          , xicara:180, colherS:15,  colherC:5),
            UNIstruc(unidade:"Agua"                     , xicara:220, colherS:10,  colherC:1.5),
            UNIstruc(unidade:"Café Preto"               , xicara:240, colherS:15,  colherC:5),
            UNIstruc(unidade:"Leite"                    , xicara:240, colherS:15,  colherC:5),
            UNIstruc(unidade:"Leite condensado"         , xicara:305, colherS:20,  colherC:7)]
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet weak var rec_name: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(REClist.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITENS_REC", for: indexPath) as! REC_itens_TC
        
        cell.item.text       = REClist[indexPath.row][0] //Vlist.item
        cell.unidade.text    = REClist[indexPath.row][1] //Vlist.unidade
        cell.quantidade.text = REClist[indexPath.row][2] // String(Vlist.quantidade)
        cell.peso.text       = REClist[indexPath.row][3] //String(Vlist.peso)
        
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        
        let delete = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "EXCLUIR"){(UITableViewRowAction,NSIndexPath) -> Void in
            let actionSheetController: UIAlertController = UIAlertController(title: "ATENÇÃO", message: "O registro será\n EXCLUIDO DEFINITIVAMENTE", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "CANCELAR", style: .cancel) { action -> Void in
                //self.tableView.reloadData()
                return
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            
            let GoDelete: UIAlertAction = UIAlertAction(title: "Excluir", style: .default) { action -> Void in
                // ROTINA DELETAR
                REClist.remove(at: indexPath.row)
                self.myTableView.reloadData()
                
                self.showItens.text = ""
                for i in 0...(REClist.count - 1) {
                    self.showItens.text = self.showItens.text +  "\u{2714}\u{FE0E} " + REClist[i][2] + " " + REClist[i][1] + " - " + REClist[i][0] + " (" + REClist[i][3] + " g)\n"
                }

            }
            actionSheetController.addAction(GoDelete)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
        }
        return [delete]
    }
    
    // picker
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var viewConverte: UIView!
    
    let thePicker1 = UIPickerView()
    let thePicker2 = UIPickerView()
    @IBOutlet weak var thePicker3: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == thePicker1  { return MPvector.count}
        if pickerView == thePicker2  { return vector.count}
        if pickerView == thePicker3  { return UNIvector.count}
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == thePicker1 {
            let MPVector: MP_struct
            MPVector = MPvector[row]
            return MPVector.AMPproduto
           //return country[row]
        }
        if pickerView == thePicker2{
            return vector[row]
        }
        
        if pickerView == thePicker3{
            let UNIVector: UNIstruc
            UNIVector = UNIvector[row]
            return  UNIVector.unidade
            //return CONVvector[row][0] as? String
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView == thePicker1 {
            let MPVector: MP_struct
            if MPvector.count > 0 {
                MPVector = MPvector[row]
                TFproduto.text = MPVector.AMPproduto
            }
        }
        if pickerView == thePicker2  {
            TFunidade.text = vector[row]
            var peso = 0.0
            let unit = TFunidade.text
            
            switch unit {
            case "kg"?:
                peso = Double((TFquantidade.text?.floatValue)!) * 1000.0
            case "grama"?:
                peso = Double((TFquantidade.text?.floatValue)!)
            default:
                // aviso de unidade nao conforme
                TFpeso.text = ""
                return //true
            }
            
            let qtd = Double((TFquantidade.text?.floatValue)!)
            TFpeso.text = String(peso * qtd)
            
        }
        if pickerView == thePicker3  {
            
            var peso = 0.0
            let UNIVector: UNIstruc
            UNIVector = UNIvector[row]
            
            let unit = TFunidade.text

            switch unit {
            case "xícara chá"?:
                peso = UNIVector.xicara
            case "colher sopa"?:
                peso = UNIVector.colherS
            case "colher chá"?:
                peso = UNIVector.colherC
            case "kg"?:
                peso = Double((TFquantidade.text?.floatValue)!) * 1000.0
            case "grama"?:
                peso = Double((TFquantidade.text?.floatValue)!)
            default:
                TFpeso.text = ""
                // aviso de unidade nao conforme
                return
            }
            
            let qtd = Double((TFquantidade.text?.floatValue)!)
            TFpeso.text = String(peso * qtd)

        }
    
    }
    // end picker
    @IBAction func showPicker3(_ sender: UIButton) {
        if viewConverte.isHidden == true {
            self.view.endEditing(true)
            viewConverte.isHidden = false
            thePicker1.isHidden   = true
            thePicker2.isHidden   = true
            
        } else {
            viewConverte.isHidden = true
            thePicker1.isHidden   = false
            thePicker2.isHidden   = false
        }
    }
    
    @IBOutlet weak var btn_fechar: UIButton!
    
    @IBAction func addIngrediente(_ sender: UIButton) {
        if viewPicker.isHidden {
            self.viewPicker.isHidden = false
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
        } else {
            self.viewPicker.isHidden = true
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == TFquantidade {
            var peso = 0.0
            let unit = TFunidade.text
            var qtd = Double((TFquantidade.text?.floatValue)!)
            
            switch unit {
            case "kg"?:
                peso = Double((TFquantidade.text?.floatValue)!) * 1000.0
                TFpeso.text = String(peso)
                return
            case "grama"?:
                peso = Double((TFquantidade.text?.floatValue)!)
                qtd = 1.0
            default:
                // aviso de unidade nao conforme
                TFpeso.text = ""
                return //true
            }
        
            TFpeso.text = String(peso * qtd)
        }
        return //true
    }
    @IBAction func limpar(_ sender: UIButton) {
        
        self.TFproduto.text         = ""
        self.TFunidade.text         = ""
        self.TFquantidade.text      = ""
        self.TFpeso.text            = ""
        self.viewConverte.isHidden  = true
        self.thePicker1.isHidden    = true
        self.thePicker2.isHidden    = true
        self.thePicker3.isHidden    = true
        
    }
    
    @IBOutlet weak var showItens: UITextView!
    
    @IBAction func incluir(_ sender: UIButton) {
        
        let f1 = self.TFproduto.text
        let f2 = self.TFunidade.text
        let f3 = self.TFquantidade.text
        let f4 = self.TFpeso.text
        let f5 = self.rec_name.text
        
        REClist.append([f1!,f2!,f3!,f4!,f5!])
        
       // list.append(ITENSstruc(item: f1!, unidade: f2!, quantidade: f3, peso: f4, rec_name: f5!))
        myTableView.reloadData()
        
        showItens.text = ""
        for i in 0...(REClist.count - 1) {
            showItens.text = showItens.text +  "\u{2714}\u{FE0E} " + REClist[i][2] + " " + REClist[i][1] + " - " + REClist[i][0] + " (" + REClist[i][3] + " g)\n"
        }

    }
    
    
    
} // endclass


extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
    
}
