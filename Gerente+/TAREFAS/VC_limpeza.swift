//
//  VC_limpeza.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 11/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class VC_limpeza: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    struct lista     : Codable {
        var titulo   : String
        var itens    : Int
    }
    var menu = [lista]()
    var mytitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        titulo.text = mytitle
        status.removeAll()
        reference.text = "\(C)"
        
        //print("--- tarefas---")
        // CARREGAR MENU COM ITENS
        menu.removeAll()
        for index in 0...tarefas.count-1 {
            if tarefas[index].mC == C && tarefas[index].mU == 0 {
                var total = 0
                for i in index...tarefas.count-1 {
                    if tarefas[i].mC == C && tarefas[i].mD == tarefas[index].mD { total = total + 1 }
                }
                //print ("\(total-1) : \(tarefas[index].item)")
                menu.append(lista(titulo: tarefas[index].item,
                                  itens : total-1))
            }
        }
       // print("--- tarefas---")
       // print(menu)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(menu.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "limpeza", for: indexPath) as! limpeza_cell
        
        cell.tarefa.text = menu[indexPath.row].titulo
        
        cell.SeqTarefa.text = String(indexPath.row + 1)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = ""//dd/MM/yy"// HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        cell.data.text = dateInFormat
        
        status.append([indexPath.row])
        let row = indexPath.row + 1
        
        let periodo = ["D ","P ","S ","Q ","M ","6 ","A ",". "]
        
        for i in 0..<menu[indexPath.row].itens {
            if i == 0 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status1.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status1.image = UIImage(named: "sign_orange")
                        
                    }
                    /*
                    // checa se sao itens ativos
                    if let index = tarefas.index(where: { $0.mC == C && $0.mD == D && $0.mU == i+1}) {
                        if tarefas[index].ativo == 0 {
                            cell.status1.isHidden = true
                        }
                    } */
                }
            }
            
            if i == 1 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status2.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status2.image = UIImage(named: "sign_orange")
                        
                    }
                    
                }
            }
            
            if i == 2 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1 && $0.use == 1 }) {
                    cell.status3.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status3.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            
            if i == 3 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status4.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status4.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            
            if i == 4 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status5.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status5.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            
            if i == 5 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status6.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status6.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            
            if i == 6 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status7.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status7.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            
            if i == 7 {
                if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == row && $0.mU == i+1  && $0.use == 1 }) {
                    cell.status8.isHidden = false
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
                    if Matrix[index].mP == 1 && !producao {
                        cell.status8.image = UIImage(named: "sign_orange")
                        
                    }
                }
            }
            status[indexPath.row].append(1)
        }
 
        return(cell)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            
            D = indexPath.row + 1
        }

    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
