//
//  VC_MP.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 27/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class VC_MP: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var MPvector = [MP_struct]()
    // TABLE MATERIA PRIMA
    let MPtable             = Table("MP")
    let DBproduto           = Expression<String>("DBproduto")           // 0
    let DBunidade           = Expression<String>("DBunidade")           // 1
    let DBvalidade          = Expression<Double>("DBvalidade")          // 2
    let DBval_tipo          = Expression<String>("DBval_tipo")          // 3
    let DBPosNeg            = Expression<String>("DBPosNeg")            // 4
    let DBtempArmazenagem   = Expression<Double>("DBtempArmazenagem")   // 5
    let DBarmazenagem       = Expression<Int>("DBarmazenagem")       // 6
    let DBproducao          = Expression<Bool>("DBproducao")          // 7
    let DBorganico          = Expression<Bool>("DBorganico")          // 8
    let DBcodigo            = Expression<Int>("DBcodigo")          // 9
    let DBdataMP            = Expression<String>("DBdataMP")            // 10

    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adicionar botao return ao teclado numerico
        validade.delegate = self
        validade.addDoneButtonToKeyboard(myAction:  #selector(self.validade.resignFirstResponder))
        
        //adicionar botao return ao teclado numerico
        tempArmazenagem.delegate = self
        tempArmazenagem.addDoneButtonToKeyboard(myAction:  #selector(self.tempArmazenagem.resignFirstResponder))
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        thePicker2.delegate  = self
        thePicker2.dataSource = self
        
        thePicker1.tag = 1
        thePicker2.tag = 2;
        
        // linkar campos ao Picker
        unidade.inputView   = thePicker1
        val_tipo.inputView  = thePicker2
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(VC_MP.dismissPicker))
        
        unidade.inputAccessoryView = toolBar
        val_tipo.inputAccessoryView = toolBar
        
        
        // DATABASE
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
        MPvector = MPvector.reversed()
        
        centerView.center.x = view.center.x
        centerView.center.y = view.center.y + 32
        
        if MPvector.count > 0 {
           let defaults = UserDefaults.standard
           materiaPrimaFlag = true
           defaults.set(true, forKey: "materiaPrimaFlag")
        } else {
            let defaults = UserDefaults.standard
            materiaPrimaFlag = false
            defaults.set(false, forKey: "materiaPrimaFlag")
        }
 
    }
    
    @IBOutlet weak var centerView: UIView!

    @objc func dismissPicker() {
        view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(MPvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MP", for: indexPath) as! TC_MP
        
        let MPVector: MP_struct
        MPVector = MPvector[(indexPath as NSIndexPath).row]
        
        cell.produto.text         =  MPVector.AMPproduto
        cell.seq.text              = String(indexPath.row)
        cell.unidade.text          = MPVector.AMPunidade
        cell.validade.text         = NSString(format:"%.00f", MPVector.AMPvalidade) as String
        cell.val_tipo.text         = MPVector.AMPval_tipo
        cell.tempArmazenagem.text  = MPVector.AMPPosNeg + (NSString(format:"%.01f", MPVector.AMPtempArmazenagem) as String) as String

        cell.armazenagem.text      = "A"
        cell.pPropria.text         = "N"
        cell.pOrganico.text        = "N"
        
        if MPVector.AMParmazenagem == 1 {cell.armazenagem.text  = "R"}
        if MPVector.AMPproducao     {cell.pPropria.text         = "S"}
        if MPVector.AMPorganico     {cell.pOrganico.text        = "S"}
    
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        
        cell.data.text = MPVector.AMPdataMP
        cell.colaborador.image = UIImage(named: "AVATAR")
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("MP item: \(indexPath.row)")
        // EDICAO DO PRODUTO
        
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
                let MPVector: MP_struct
                MPVector = self.MPvector[(indexPath as NSIndexPath).row]
                let reference = MPVector.AMPproduto
                
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.MPtable.filter(self.DBproduto == reference)
                do{try db!.run(delrecord.delete())} catch {
                    print("record deleted failed: \(error)")}
                
                self.refresh()
            }
            actionSheetController.addAction(GoDelete)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
        }
        let edit = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "MODIFICAR"){(UITableViewRowAction,NSIndexPath) -> Void in
            // ROTINA MODIFICAR
            self.adicionar(UIButton())

            let MPVector: MP_struct
            MPVector = self.MPvector[(indexPath as NSIndexPath).row]
            
            self.produto.text               = MPVector.AMPproduto
            self.unidade.text               = MPVector.AMPunidade
            self.validade.text              = NSString(format:"%.00f", MPVector.AMPvalidade) as String
            self.val_tipo.text              = MPVector.AMPval_tipo
            self.PosNeg.titleLabel?.text    = MPVector.AMPPosNeg
            self.tempArmazenagem.text        = NSString(format:"%.01f", MPVector.AMPtempArmazenagem) as String
            
            self.armazenagem.selectedSegmentIndex = 0
            self.pPropria.setOn(false, animated: true)
            self.pOrganico.setOn(false, animated: true)
            
            if MPVector.AMParmazenagem  == 1 {self.armazenagem.selectedSegmentIndex = 1}
            if MPVector.AMPproducao {self.pPropria.setOn(true, animated: true)}
            if MPVector.AMPorganico {self.pOrganico.setOn(true, animated: true)}
        }
        
        edit.backgroundColor = UIColor.blue
        return [delete,edit]
    }
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true

            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
           // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }
    @IBOutlet weak var adicionar_view: UIView!
    
    var unidades = ["Unidade(s)", "Dúzia(s)", "Quilograma(s)","Grama(s)" ,"Litro(s)", "Tonelada(s)","Arroba(s)", "Galão(ões)"]
    var tipo     = ["Dia(s)","Não Inf"]

    @IBOutlet weak var produto: UITextField!
    @IBOutlet weak var unidade: UITextField!
    @IBOutlet weak var validade: UITextField!
    @IBOutlet weak var val_tipo: UITextField!
    @IBOutlet weak var pPropria: UISwitch!
    @IBOutlet weak var pOrganico: UISwitch!
    @IBOutlet weak var armazenagem: UISegmentedControl!
    @IBOutlet weak var tempArmazenagem: UITextField!
    @IBOutlet weak var PosNeg: UIButton!
    @IBAction func btnPosNeg(_ sender: UIButton) {
        if PosNeg.titleLabel?.text == "+" { PosNeg.setTitle("-", for: .normal) }
        else { PosNeg.setTitle("+", for: .normal) }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func Salvar(_ sender: UIButton) {
        
        //let f1 = "\(list_MP.count+1)"
        let f1 = produto.text!
        let f2 = unidade.text!
        let f3 = validade.text!
        let f4 = val_tipo.text!
        let f5 = (PosNeg.titleLabel?.text)!
        let f6 = tempArmazenagem.text!
        var f7 = 0
        if armazenagem.selectedSegmentIndex == 1 {f7 = 1}
        var f8 = false
        if pPropria.isOn { f8 = true}
        var f9 = false
        if pOrganico.isOn { f9 = true}
        
        // ****************************************
        let f10 = 1  // COLABORADOR - linkar depois
        // ****************************************
        let f11 = String(describing: Date())
        
        if f1 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: PRODUTO\nnão pode ficar em branco",
                delegate: nil,
                cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        if f2 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: UNIDADE\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        if f3 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: VALIDADE\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        if f4 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: TIPO DE VALIDADE\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }

        if f6 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: TEMPERATURA DE ARMAZENAGEM\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        let insert = MPtable.insert(DBproduto           <- f1,
                                    DBunidade           <- f2,
                                    DBvalidade          <- Double(f3)!,
                                    DBval_tipo          <- f4,
                                    DBPosNeg            <- f5,
                                    DBtempArmazenagem   <- Double(f6)!,
                                    DBarmazenagem       <- Int(f7),
                                    DBproducao          <- f8,
                                    DBorganico          <- f9,
                                    DBcodigo       <- Int(f10),
                                    DBdataMP            <- f11)
        
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        do{
            _ = try db!.run(insert)

            let alertController = UIAlertController(title: "AVISO", message:
                "Item Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.refresh()
            
        } catch {
            print("insertion Principal failed: \(error)")
            
            //Create the AlertController
             let actionSheetController: UIAlertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message: "Produto JÁ CADASTRADO!\nGostaria de atualizar o registro?", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Fechar", style: .cancel) { action -> Void in
                //self.tableView.reloadData()
                return
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let Overwrite: UIAlertAction = UIAlertAction(title: "ATUALIZAR", style: .default) { action -> Void in
                // start
                
                let update = self.MPtable .filter(self.DBproduto == f1).update(
                                            self.DBproduto           <- f1,
                                            self.DBunidade           <- f2,
                                            self.DBvalidade          <- Double(f3)!,
                                            self.DBval_tipo          <- f4,
                                            self.DBPosNeg            <- f5,
                                            self.DBtempArmazenagem   <- Double(f6)!,
                                            self.DBarmazenagem       <- f7,
                                            self.DBproducao          <- f8,
                                            self.DBorganico          <- f9,
                                            self.DBcodigo       <- Int(f10),
                                            self.DBdataMP            <- f11)
                
                do{
                    _ = try db!.run(update)
                    
                    let alertController = UIAlertController(title: "AVISO", message:
                        "Registro atualizado com sucesso!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                
                    self.refresh()
                
                }  catch {
                    print("insertion Principal UPDATE failed: \(error)")
                    
                    let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                        "Erro ao atualizar o registro! \nCODIGO: 001\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
 
            }
            actionSheetController.addAction(Overwrite)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            // alert override
        }
    }
    
    // picker
    let thePicker1 = UIPickerView()
    let thePicker2 = UIPickerView()

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == thePicker1 {
            return unidades.count
            
        } else if pickerView == thePicker2{
            return tipo.count
        }
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == thePicker1 {
            unidade.text = unidades[row]
            return unidades[row]
            
        } else if pickerView == thePicker2 {
            val_tipo.text = tipo[row]
            return tipo[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == thePicker1 {
            unidade.text = unidades[row]
            //self.view.endEditing(false)
        } else if pickerView == thePicker2 {
            val_tipo.text = tipo[row]
            //self.view.endEditing(false)
        }
    }
    
    @IBAction func btnLimpar(_ sender: UIButton) {
        
        produto.text = ""
        unidade.text = ""
        validade.text = ""
        val_tipo.text = ""
        pPropria.isOn = false
        pOrganico.isOn = false
        armazenagem.selectedSegmentIndex = 0
        tempArmazenagem.text = "21"
        PosNeg.setTitle("+", for: .normal)
        
    }
    
    func refresh(){
        self.MPvector.removeAll()
        
        // DATABASE
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
                                      AMPcodigo    :Int(MPtable[DBcodigo]),
                                      AMPdataMP         :String(MPtable[DBdataMP])))
        }
        MPvector = MPvector.reversed()
        myTableView.reloadData()
    }
}

// EXTENSOES PARA CRIAR BOTAO FECHAR NO PICKER E TEXTVIEW
extension UITextField{
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Fechar", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}

extension UIToolbar {
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Fechar", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}


