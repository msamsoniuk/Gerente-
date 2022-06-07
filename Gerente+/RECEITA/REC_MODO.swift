//
//  REC_MODO.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 17/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit

var texto     = false
var modoDePreparo = ""

class REC_MODO: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myText: UITextView!
    @IBOutlet weak var rec_name: UILabel!
    
    var tempstring = ""
    
    var list = ["bata ","misture ","até obter ","uma massa homogênea","acrescente ","aos poucos ","sem parar de bater ","por último ","adicione ","despeje ","numa forma ","grande ","pequena ","untada ","enfarinhada ","asse em forno ","medio ","alto ","minutos ","furar ","garfo ","saia limpo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.list.reverse()
        for i in 0...(REClist.count - 1) {
             self.list.append(REClist[i][0])
        }
        self.list.reverse()
        
        modoDePreparo = ""
        texto = false
        stautus.image = UIImage(named: "sign_orange")
        // show ticket
        
        myTableView.setEditing(true, animated: true)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
        
        self.rec_name.text = tempstring
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
            myText.text = myText.text + list[indexPath.row]
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
        myText.text     = ""
        modoDePreparo   = ""
    }
    @IBAction func salvar(_ sender: UIButton) {
        texto = true
        modoDePreparo = myText.text
        stautus.image = UIImage(named: "sign_green")
        
        var alert = UIAlertView(title: "AVISO!",
                                message: "MODO DE PREPARO gravado",
                                delegate: nil,
                                cancelButtonTitle: "Fechar")
        alert.show()
        
    }
    @IBOutlet weak var stautus: UIImageView!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
