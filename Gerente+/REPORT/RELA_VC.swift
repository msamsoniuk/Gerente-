//
//  RELA_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 20/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import Zip

class RELA_VC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let list = [["Status de Controles & Tarefas ","rev 1.0a"]]//,
               /* ["Listagem de Produtos Recolhidos","rev 1.0a"],
                ["Listagem de Saidas de Produtos","rev 1.0a"],
                ["Listagem de Entradas de Matéria Prima","rev 1.0a"],
                ["Listagem dos Colaboradores","rev 1.0a"],
                ["Listagem das Receitas","rev 1.0a"]] */
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "POPS", for: indexPath) as! POPS_TC
        
        let index = indexPath.row
        
        cell.pop.text = String(list[index][0])
        cell.revisao.text = String(list[index][1])
        cell.sequencia.text  = ("REL: \(index + 1)/\(list.count)")
        
        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //if mylicense == "[]" {
            //    self.performSegue(withIdentifier: "LOGIN", sender: self)
            //    return
            //} else {
                self.performSegue(withIdentifier: "STATUS", sender: self)
            //}
        }
        
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "STATUS" {
            print("status")
        }
    }
 
}

