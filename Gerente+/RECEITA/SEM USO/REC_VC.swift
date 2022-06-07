//
//  REC_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 05/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class REC_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var list = [[String(), String(), String()]]
    var MPvector  = [MP_struct]()
    
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
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        receita.delegate = self
        itens.delegate   = self
        
        list = [["1", "xicara(s)  ","leite"],
                ["1", "colher chá ","fermento em pó"],
                ["3", "xicara(s)  ","farinha de trigo"],
                ["3", "xicara(s)  ","açucar"],
                ["3", "unidade(s  ","ovos"],
                ["4", "colher sopa","margarina"]]
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        
        // linkar campos ao Picker
        itens.inputView   = thePicker1
        
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
    
    @IBOutlet weak var receita: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var itens: UITextField!
    
    func dismissPicker() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       // if textField == valor {
       //     valor.text = valor.text?.currency
       // }
        return true
    }
    
    // tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
         cell.textLabel?.text = list[indexPath.row]
         */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receita", for: indexPath) as! REC_TC
        
        cell.quantidade.text    = list[indexPath.row][0] as? String
        cell.unidade.text       = list[indexPath.row][1] as? String
        cell.ingrediente.text   = list[indexPath.row][2] as? String

        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    // endtableview
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MPvector.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let MPVector: MP_struct
        MPVector = MPvector[row]
        
        
       itens.text = MPVector.AMPproduto
       // unidade.text = MPVector.AMPunidade
        
        return nil //MPVector.AMPproduto
    }
    
    @IBAction func AddIngredientes(_ sender: UIButton) {
        self.thePicker1.isHidden = false
    }
    

}
