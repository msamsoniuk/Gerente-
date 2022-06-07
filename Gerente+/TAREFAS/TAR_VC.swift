//
//  TAR_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 18/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit



class TAR_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let list = ["CONTROLES","LIMPEZA DIÁRIA","PRODUÇÃO"]
    
    var s1 = false
    var s2 = false
    var s3 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if producao { print("COM producao")} else {
            print("SEM producao")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
        
        if s1 && s2 && s3 { statusGeralTarefas = false } else {statusGeralTarefas = true }
    
        //print(Matrix)
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
    
    @IBOutlet weak var myTableView: UITableView!
    //@IBOutlet weak var controle: UIProgressView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "tarefas", for: indexPath) as! TAR_TC
        cell.DoListSub.text = list[indexPath.row]
        
        cell.SeqTarefa.text = String(indexPath.row + 1)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        //cell.Data.text = dateInFormat
        
        let randomNum = arc4random_uniform(3)
        switch randomNum {
        case 0:
            cell.Colaborador.image = UIImage(named: "AVATAR")
        case 1:
            cell.Colaborador.image = UIImage(named: "AVATAR")
        case 2:
            cell.Colaborador.image = UIImage(named: "AVATAR")
        default:
            break
        }
        
        // Matrix
        cell.barra.isHidden = false
        switch indexPath.row {
        case 0:
            cell.Status.image = UIImage(named: "sign_green")
            s1 = true
            for i in 0...Matrix.count-1 {
                
                if Matrix[i].mC == 1 {
                    if Matrix[i].mP == 1 && !producao { continue}
                        if Matrix[i].mS  == 2 { continue }
                    cell.Status.image = UIImage(named: "sign_half")
                    s1 = false
                    //print("\(Matrix[i].mC) \(Matrix[i].mD) \(Matrix[i].mU) \(Matrix[i].mS) \(Matrix[i].mP)")
                }
            }
            
            var count   = 0
            var tarefas = 0
            for i in 0...Matrix.count-1 {
                if Matrix[i].mC == 1   && Matrix[i].use == 1 {
                    if Matrix[i].mP == 1 && !producao { continue}
                    tarefas = tarefas + 1
                    if Matrix[i].mS == 2 {
                       count = count + 1
                    }
                }
            }
            
            cell.Data.text = "Tarefas prontas: \(count)/\(tarefas)"
            cell.barra.progress = Float(count) / Float(tarefas)
            
        case 1:
            cell.Status.image = UIImage(named: "sign_green")
            s2 = true
            for i in 0...Matrix.count-1 {
                if Matrix[i].mC == 2 {
                    if Matrix[i].mP == 1 && !producao {continue}
                        if Matrix[i].mS  == 2 { continue }
                    cell.Status.image = UIImage(named: "sign_half")
                    s2 = false
                       //print("erro: \(Matrix[i].mC) \(Matrix[i].mD) \(Matrix[i].mU)")
                }
            }
            
            var count   = 0
            var tarefas = 0
            for i in 0...Matrix.count-1 {
                if Matrix[i].mC == 2  && Matrix[i].use == 1  {
                    if Matrix[i].mP == 1 && !producao { continue}
                    tarefas = tarefas + 1
                    if Matrix[i].mS == 2 {
                        count = count + 1
                    }
                }
            }
            
            cell.Data.text = "Tarefas prontas: \(count)/\(tarefas)"
            cell.barra.progress = Float(count) / Float(tarefas)
            
        case 2:
            cell.Status.image = UIImage(named: "sign_green")
            s3 = true
            for i in 0...Matrix.count-1 {
                if Matrix[i].mC == 3 {
                    if Matrix[i].mP == 1 && !producao {continue}
                       if Matrix[i].mS  == 2 {continue }
                          if  Matrix[i].use == 0 { continue }
                    cell.Status.image = UIImage(named: "sign_half")
                    s3 = false
                }
            }
            
            var count   = 0
            var tarefas = 0
            for i in 0...Matrix.count-1 {
                if Matrix[i].mC == 3 && Matrix[i].use == 1 {
                    if Matrix[i].mP == 1 && !producao { continue}
                    tarefas = tarefas + 1
                    if Matrix[i].mS == 2 {
                        count = count + 1
                    }
                }
            }
            
            cell.Data.text = "Tarefas prontas: \(count)/\(tarefas)"
            cell.barra.progress = Float(count) / Float(tarefas)
            if !producao {
               cell.barra.isHidden = true
               cell.Data.text = "Sem produção"
                
            }
            
        default:
            break
        }
        
        return(cell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var list_title = ""
        
        if let indexPath = myTableView.indexPathForSelectedRow {
            
            C = indexPath.row + 1
            
            switch indexPath.row{
            case 0: list_title = "CONTROLES"
            case 1: list_title =  "LIMPEZA"
            case 2: list_title = "PRODUCAO"
            default: break
            }
        }
        
        //print(C, list_title)
        if let destinationVC = segue.destination as? VC_limpeza {destinationVC.mytitle = list_title}
    }
    
}

