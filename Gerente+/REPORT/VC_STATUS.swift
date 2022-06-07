//
//  VC_STATUS.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 24/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class VC_STATUS: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    // TABELA STATUS
    let STATtable           = Table("STAT")
    let DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    var HOJE = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        HOJE = dateFormatter.string(from: Date())

        
        for STATtable in try! db!.prepare(STATtable){
            STATvector.append(Status_struct(
                MStatusData: String(STATtable[DBStatusData]),
                MProducao: String(STATtable[DBProducao]),
                MVector: String(STATtable[DBVector]),
                Mflag: String(STATtable[DBflag])))
        }
         self.STATvector = self.STATvector.reversed()
        //STATvector = STATvector.reversed()
        //print(STATvector)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var STATvector = [Status_struct]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(STATvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListStatus", for: indexPath) as! TC_status
        
        let STATVector : Status_struct
        STATVector = STATvector[(indexPath as NSIndexPath).row]
        
        //if STATVector.MStatusData == HOJE {
        //    cell.cellView.tintColor = UIColor.magenta
        //}
        
        cell.data.text          =   "Data: \(STATVector.MStatusData)"
        if STATVector.MProducao == "0" {cell.producao.text = "N"}
        else {cell.producao.text = "S"}
        //cell.producao.text      =   STATVector.MProducao
        //cell.transmitido.text   =   STATVector.Mflag
        //cell.vetor.text         =   STATVector.MVector
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        if !master {
            self.enableSectionAlert()
        }
        if !master { return nil}
        
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
                let STATVector : Status_struct
                STATVector = self.STATvector[(indexPath as NSIndexPath).row]
                let reference = STATVector.MStatusData
                
                if reference == self.HOJE {
                        var alert = UIAlertView(title: "OPS!!!!!",
                                                message: "NAO APAGUE O DIA DE HOJE",
                                                delegate: nil,
                                                cancelButtonTitle: "Fechar")
                        alert.show()
                        return
 
                }
 
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.STATtable.filter(self.DBStatusData == reference)
                
                do{try db!.run(delrecord.delete())} catch {
                    print("record deleted failed: \(error)")
                    return
                }
                self.STATvector.removeAll()
                for STATtable in try! db!.prepare(self.self.STATtable){
                    self.STATvector.append(Status_struct(
                        MStatusData: String(STATtable[self.DBStatusData]),
                        MProducao: String(STATtable[self.DBProducao]),
                        MVector: String(STATtable[self.DBVector]),
                        Mflag: String(STATtable[self.DBflag])))
                }
                self.STATvector = self.STATvector.reversed()
                self.myTableView.reloadData()
            }
            actionSheetController.addAction(GoDelete)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            //text_item = indexPath.row
            
            if let destinationVC = segue.destination as? REPORT_VC {
                destinationVC.HOJE  = STATvector[indexPath.row].MStatusData
            }
        }
    }
    
    
    var master = false
    
    func enableSectionAlert() {
        let alertController = UIAlertController(title: "Senha do Administrador", message: "Favor entrar com a\nsenha do Administrador", preferredStyle: .alert)
        
        let enable = UIAlertAction(title: "OK", style: .default) { (_) in
            let field = alertController.textFields?[0].text
            if let x = UserDefaults.standard.string(forKey: "SenhaMaster"), x == field {
                self.master = true
            }
            else{
                
                let wrongPwd = UIAlertController(title: "Senha Incorreta", message: nil, preferredStyle:UIAlertController.Style.alert)
                wrongPwd.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(wrongPwd, animated: true, completion: nil)
                
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Admin Password"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(enable)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}


