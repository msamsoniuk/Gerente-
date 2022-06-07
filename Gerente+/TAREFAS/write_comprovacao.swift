//
//  write_comprovacao.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 21/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

class write_comprovacao: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myText: UITextView!
    @IBOutlet weak var reference: UILabel!
    
    let list = ["cheguei atrasado","nao tinha material", "material insuficiente", "tomei remédio e dormi", "nao tinha energia eletrica", "estava chovendo", "fiquei doente"]

    override func viewDidLoad() {
        super.viewDidLoad()
        reference.text = "\(C)\(D)\(U)"
        texto = false
        // show ticket
        myTableView.setEditing(true, animated: true)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsMultipleSelectionDuringEditing = true
    }

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "texto")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // checked
        if myText.text == "" {
            myText.text = myText.text + list[indexPath.row]
        } else {
            myText.text = myText.text + " - " + list[indexPath.row]
        }
        
        
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //unchecked
        let s1 : String = myText.text
        
        let s2 = s1.replacingOccurrences(of: list[indexPath.row], with: "", options: .regularExpression)
        
        myText.text = s2
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func limpar(_ sender: UIButton) {
        myText.text = ""
    }
    @IBAction func salvar(_ sender: UIButton) {
        texto = true
        var clean = myText.text
        var string = clean?.replacingOccurrences(of: "[", with: "-")
        clean = string?.replacingOccurrences(of: "]", with: "-")
        string = clean?.replacingOccurrences(of: ",", with: "-")
        
        TextoComprovacao = string! //myText.text

        var alert = UIAlertView(title: "Aviso!",
                                message: "Justificativa adicionada aos registos da tarefa",
                                delegate: nil,
                                cancelButtonTitle: "Fechar")
        alert.show()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
