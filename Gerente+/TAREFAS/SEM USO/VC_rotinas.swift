//
//  VC_rotinas.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 18/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class VC_rotinas: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reference: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        status.removeAll()
        C = 1
        reference.text = "\(C)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
        //print(Matrix)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let list = ["Pragas e Vetores",
                "Qualidade da Água"]
    
    let itens = [6,
                 3]
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "limpeza", for: indexPath) as! limpeza_cell
        
        cell.tarefa.text = list[indexPath.row]
        
        cell.SeqTarefa.text = String(indexPath.row + 1)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yy"// HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        cell.data.text = "" //dateInFormat
        
        status.append([indexPath.row])
        let row = indexPath.row + 1
        
        let periodo = ["D ","P ","S ","Q ","M ","6 ","A ",". "]
        
        for i in 0..<itens[indexPath.row] {
            if i == 0 {cell.status1.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status1.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status1.image = UIImage(named: "sign_half")
                        } else {
                            cell.status1.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status1.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 1 {cell.status2.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status2.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status2.image = UIImage(named: "sign_half")
                        } else {
                            cell.status2.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status2.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 2 {cell.status3.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status3.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status3.image = UIImage(named: "sign_half")
                        } else {
                            cell.status3.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status3.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 3 {cell.status4.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status4.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status4.image = UIImage(named: "sign_half")
                        } else {
                            cell.status4.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status4.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 4 {cell.status5.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status5.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status5.image = UIImage(named: "sign_half")
                        } else {
                            cell.status5.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status5.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 5 {cell.status6.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status6.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status6.image = UIImage(named: "sign_half")
                        } else {
                            cell.status2.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status6.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 6 {cell.status7.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status7.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status7.image = UIImage(named: "sign_half")
                        } else {
                            cell.status7.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status7.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            
            if i == 7 {cell.status8.isHidden = false
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1}) {
                    switch Matrix[index].mS {
                    case 0:
                        cell.status8.image = UIImage(named: "sign_orange")
                    case 1:
                        if Matrix[index].foto == "" || Matrix[index].txt == "" {
                            cell.status8.image = UIImage(named: "sign_half")
                        } else {
                            cell.status8.image = UIImage(named: "sign_red")
                        }
                    case 2:
                        cell.status8.image = UIImage(named: "sign_green")
                    default:
                        break
                    }
                    cell.data.text = cell.data.text! + periodo[Matrix[index].mP]
                }
            }
            status[indexPath.row].append(1)
        }
        return(cell)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            //print(indexPath.row)
            
            statuslist.removeAll()
            for i in 1..<itens[indexPath.row] {
                statuslist.append(status[indexPath.row][i])
            }
            
            D = indexPath.row + 1
/*
            switch indexPath.row{
            case 0:
                list_title = "PRAGAS & VETORES"
                itemindex = 0
                list_limp = ["Uso de produto químico \"veneno\"",
                             "Avistamento de inseto ou rato",
                             "Telas nas portas e janelas",
                             "Telas bem conservadas",
                             "Lixo retirado para local adequado",
                             "Sistema alternativo de CP&V funciona"]
            case 1:
                list_title = "QUALIDADE DA ÁGUA"
                itemindex = 1
                list_limp = ["Cloração da H2O",
                             "Analise da H2O",
                             "Limpeza da Caixa dágua"]
            default:
                break
            }
            */
        }
       // if let destinationVC = segue.destination as? VC_itens_limpeza {destinationVC.mytitle = list_title}
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
}

