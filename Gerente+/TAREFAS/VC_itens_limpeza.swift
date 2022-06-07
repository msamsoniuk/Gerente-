//
//  VC_itens_limpeza.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 11/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class VC_itens_limpeza: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var itemstatus:Int!
    var mytitle = ""
    @IBOutlet weak var reference: UILabel!
    var listVarLimp = [""]
   // var FilterMatrix = [[]]
    
    struct lista     : Codable {
        var titulo   : String
        var mU       : Int
    }
    var menu = [lista]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titulo.text = mytitle //list_title
        reference.text = "\(C)\(D)"
        
        //print("--- tarefas---")
        // CARREGAR MENU COM ITENS
        menu.removeAll()
        for index in 0...tarefas.count-1 {
            if tarefas[index].mC == C && tarefas[index].mD == D && tarefas[index].mU == 0 {
                titulo.text = tarefas[index].item
                mytitle     = tarefas[index].item
                for i in index+1...tarefas.count-1 {
                    if tarefas[i].mC == C && tarefas[i].mD == tarefas[index].mD && tarefas[i].ativo == 1 {
                        menu.append(lista(titulo: tarefas[i].item, mU : tarefas[i].mU))
                    }
                }
            }
        }
        /*
        // analise equipmentos
        if D == 3 {
            for index in 0...tools.count-1 {
                print(index, tools[index].cod,tools[index].ativo, tools[index].item)
            }
            
            print("-------------------")
            let tools2  = tools.filter { $0.ativo == 1 }
            for index in 0...tools2.count-1 {
                print(index, tools2[index].cod,tools2[index].ativo, tools2[index].item)
            }
        }
        */
    }

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
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
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(menu.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "limpeza_item", for: indexPath) as! limpeza_cell
        
        cell.tarefa.text = menu[indexPath.row].titulo
        cell.SeqTarefa.text = String(menu[indexPath.row].mU)  //String(indexPath.row + 1)
        let row = menu[indexPath.row].mU //indexPath.row + 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"// HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        cell.data.text = dateInFormat
        //print("ITEM de \(C)\(D)\(row): ")
        // check status Matrix
        if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == row}) {
            //print("status de \(C)\(D)\(row): \(Matrix[index].mS)")
            switch Matrix[index].mS {
            case 0:
                cell.itemStatus.image = UIImage(named: "sign_orange")
            case 1:
                if Matrix[index].foto == "" || Matrix[index].txt == ""
                {cell.itemStatus.image = UIImage(named: "sign_half")}
                else {cell.itemStatus.image = UIImage(named: "sign_red")}
            case 2:
                cell.itemStatus.image = UIImage(named: "sign_green")
            default:
                break
            }
            
            if Matrix[index].mP == 1 && !producao {
                cell.itemStatus.image = UIImage(named: "sign_orange")
                
            }
            
            if Matrix[index].mC == 1 {
                
                var days = 0
                switch Matrix[index].mP {
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
                //print("data do DB: \(oldMatrix[k][7])")
                let secondDate = formatter.date(from: Matrix[index].dF)
                if secondDate != nil {
                    let components = Calendar.current.dateComponents([.day], from: secondDate!, to: Date())
                    var totalDias = 0
                    print(components)
                    if components.day != nil {totalDias = days - components.day!}
                    
                    //if totalDias <= 0 {
                    print("dias vencidos: \(totalDias)")
                    
                    switch Matrix[index].mP {
                    case 0:
                        cell.data.text = "[Diário:    \(totalDias) dias]"
                    case 1:
                        cell.data.text = "[Produção:  \(totalDias) dias]"
                    case 2:
                        cell.data.text = "[Semanal:   \(totalDias) dias]"
                    case 3:
                        cell.data.text = "[Quinzenal: \(totalDias) dias]"
                    case 4:
                        cell.data.text = "[Mensal:    \(totalDias) dias]"
                    case 5:
                        cell.data.text = "[Semestral: \(totalDias) dias]"
                    case 6:
                        cell.data.text = "[Anual:     \(totalDias) dias]"
                        
                    default:
                        break
                        //  }
                        
                    }
                } else {
                    switch Matrix[index].mP {
                    case 0:
                        cell.data.text = "[Diario:    Não conferido]"
                    case 1:
                        cell.data.text = "[Produção:  Não conferido]"
                    case 2:
                        cell.data.text = "[Semanal:   Não conferido]"
                    case 3:
                        cell.data.text = "[Quinzenal: Não conferido]"
                    case 4:
                        cell.data.text = "[Mensal:    Não conferido]"
                    case 5:
                        cell.data.text = "[Semestral: Não conferido]"
                    case 6:
                        cell.data.text = "[Anual:     Não conferido]"
                        
                    default:
                        break
                    }
                }
            } else
            {
                switch Matrix[index].mP {
                case 0:
                    cell.data.text = "checagem: " + " [Diária]" //dateInFormat + " [D]"
                case 1:
                    cell.data.text = "checagem: " + " [Dias de produção]"
                case 2:
                    cell.data.text = "checagem: " + " [Semanal]"
                case 3:
                    cell.data.text = "checagem: " + " [Quinzenal]"
                case 4:
                    cell.data.text = "checagem: " + " [Mensal]"
                case 5:
                    cell.data.text = "checagem: " + " [Semestral]"
                case 6:
                    cell.data.text = "checagem: " + " [Anual]"
                    
                default:
                    break
                }
            }
        }
        
        return(cell)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            //text_item = indexPath.row
            
            if let destinationVC = segue.destination as? COMPROVACAO {
                destinationVC.mytitle  = mytitle
                destinationVC.linha    = indexPath.row
                destinationVC.mytarefa = menu[indexPath.row].titulo
                U = menu[indexPath.row].mU
            }
        }
    }
}

