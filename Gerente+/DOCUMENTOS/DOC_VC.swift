//
//  DOC_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 18/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class DOC_VC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    // TABELA DOCUMENTOS
    let DOCStable           = Table("DOCS")
    let DBdocIndex          = Expression<Int>("DBdocIndex")
    let DBdocFoto           = Expression<String>("DBdocFoto")
    let DBdocVenc           = Expression<String>("DBdocVenc")
    let DBdocData           = Expression<String>("DBdocData")
    let DBcolaborador     = Expression<String>("DBcolaborador")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentosFlag = true
        self.refresh()
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refresh()
        myTableView.reloadData()
        // print(Matrix)
    }
    
    let list = [["RG & CPF",0],
                ["CONTRATO SOCIAL",0],
                ["CNPJ",0],
                ["COMPROVANTE DE ENDEREÇO",0],
                ["CROQUI DA UNIDADE",0],
                ["CERTIFICADO DE ORGÂNICO",365],
                ["LICENÇA SANITÁRIA",365],
                ["ALVARÁ",365]]
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DOCUMENTOS", for: indexPath) as! docs_cell
        
        let index = indexPath.row
        
        cell.documento.text = list[indexPath.row][0] as! String
        cell.data_insercao.text = ""
        cell.dias_a_vencer.text = ""
        cell.status.image = UIImage(named: "sign_red")
        
        if DOCSvector.count > 0 {
            var DOCSVector: DOCS_struct
            for i in 0...DOCSvector.count-1 {
                DOCSVector = DOCSvector[i]
                if DOCSVector.MdocIndex == index {
                    if DOCSVector.MdocFoto != "" {
                        cell.status.image = UIImage(named: "sign_green")
                    }
                    
                    if AnyInt(list[index][1]) == 0 { return(cell)}
                    
                    cell.data_insercao.text = String(DOCSVector.MdocVenc)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    
                    let vencimento = formatter.date(from: String(describing: DOCSVector.MdocVenc))
                    if vencimento != nil {
                        let restantes = Calendar.current.dateComponents([.day], from: Date(), to: vencimento!)
                        var totalDias = 0
                        print("restantes: \(restantes)")
                        let days = AnyInt(list[indexPath.row][1])
                        
                        if restantes.day != nil {
                            totalDias = restantes.day!
                            if totalDias <= 0 {
                                cell.status.image = UIImage(named: "sign_red")
                            }
                        }
                        cell.dias_a_vencer.text = "\(totalDias)/\(days)"//String(totalDias)
                    }
                }
            }
        }
        
        if cell.status.image == UIImage(named: "sign_red") {
            documentosFlag = false
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "documentosFlag")
        } else {
            documentosFlag = true
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "documentosFlag")
        }

        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //rint(indexPath.row)
        //
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            //print(indexPath.row)
            if let destinationVC = segue.destination as? DOCfoto_VC {destinationVC.mytitle = String(describing: list[indexPath.row][0])
                 destinationVC.index = indexPath.row
            }
        }
    }
    
    var DOCSvector  = [DOCS_struct]()
    func refresh(){
        self.DOCSvector.removeAll()
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        for DOCStable in try! db!.prepare(DOCStable) {
            DOCSvector.append(DOCS_struct(
                MdocIndex   : Int(DOCStable[DBdocIndex]),
                MdocFoto    : DOCStable[DBdocFoto],
                MdocVenc    : DOCStable[DBdocVenc],
                MdocData    : DOCStable[DBdocData],
                Mcolaborador: DOCStable[DBcolaborador]))
        }
        //print(DOCSvector)
        //print("=============")
        //myTableView.reloadData()
    }
}


func AnyInt(_ value: Any) -> Int {
    var strValue: String
    var ret = 0
    if value != nil {
        strValue = "\(value)"
        if !(strValue == "") && !(strValue == "null") {
            ret = Int((strValue as NSString ?? "0").intValue)
        }
    }
    return ret
}

