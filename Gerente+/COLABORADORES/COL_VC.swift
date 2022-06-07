//
//  COL_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 02/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class COL_VC: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var COLvector = [COL_struct]()
    // TABELA COLABORADORES
    let COLtable        = Table("COL")
    let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBemail         = Expression<String>("DBemail")
    let DBcodigo        = Expression<Int>("DBcodigo")
    let DBcelular       = Expression<String>("DBcelular")
    let DBfixo          = Expression<String>("DBfixo")
    let DBfoto          = Expression<String>("DBfoto")
    let DBdataCOL       = Expression<String>("DBdataCOL")
    let DBsenha         = Expression<String>("DBsenha")
    let DBfotoCDBP       = Expression<String>("DBfotoCDBP")
    let DBdataCDBP       = Expression<String>("DBdataCDBP")
    let DBfotoADS        = Expression<String>("DBfotoADS")
    let DBdataADS        = Expression<String>("DBdataADS")
    let DBpops           = Expression<String>("DBpops")
    

    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    override func viewDidLoad() {
        super.viewDidLoad()
        master = false
        
        adicionar_view.isHidden = true
        POPsView.isHidden       = true
        
        //CHECAR DE EXISTEM ARQUIVOS PERDIDOS
        //print(listFilesFromDocumentsFolder())
        
        //adicionar botao return ao teclado numerico
        celular.delegate = self
        celular.addDoneButtonToKeyboard(myAction:  #selector(self.celular.resignFirstResponder))
        fixo.delegate = self
        fixo.addDoneButtonToKeyboard(myAction:  #selector(self.fixo.resignFirstResponder))
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(COL_VC.dismissPicker))
        CDBPvalidade.inputAccessoryView      = toolBar
        ADSvalidade.inputAccessoryView       = toolBar
        
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for COLtable in try! db!.prepare(COLtable) {
            COLvector.append(COL_struct(AMPcolaborador: String(COLtable[DBcolaborador]),
                                        AMPemail:       String(COLtable[DBemail]),
                                        AMPcodigo:      Int(COLtable[DBcodigo]),
                                        AMPcelular:     String(COLtable[DBcelular]),
                                        AMPfixo:        String(COLtable[DBfixo]),
                                        AMPfoto:        String(COLtable[DBfoto]),
                                        AMPdata:        String(COLtable[DBdataCOL]),
                                        AMPsenha:       String(COLtable[DBsenha]),
                                        AMPfotoCDBP:    String(COLtable[DBfotoCDBP]),
                                        AMPdataCDBP:    String(COLtable[DBdataCDBP]),
                                        AMPfotoADS:     String(COLtable[DBfotoADS]),
                                        AMPdataADS:     String(COLtable[DBdataADS]),
                                        AMPpops:     String(COLtable[DBpops])
            ))
        }
        //reverter para o ultimo ficar no topo da lista
        COLvector = COLvector.reversed()
        
        self.colaborador.autocapitalizationType = .allCharacters
        
        centerView.center.x = view.center.x
        centerView.center.y = view.center.y + 32
        
        if COLvector.count > 0 {
            let defaults = UserDefaults.standard
            colaboradoresFlag = true
            defaults.set(true, forKey: "colaboradoresFlag")
        } else {
            let defaults = UserDefaults.standard
            colaboradoresFlag = false
            defaults.set(false, forKey: "colaboradoresFlag")
        }
        
    }
    
    @IBOutlet weak var centerView: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(COLvector.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "COLABORADORES", for: indexPath) as! COL_TC
        
        let COLVector: COL_struct
        COLVector = COLvector[(indexPath as NSIndexPath).row]
        
        cell.colaborador.text   = COLVector.AMPcolaborador
        cell.seq.text           = String(indexPath.row)
        cell.email.text         = COLVector.AMPemail
        cell.codigo.text        = String(COLVector.AMPcodigo)
        cell.celular.text       = COLVector.AMPcelular
        cell.fixo.text          = COLVector.AMPfixo
        
        let myImageName = COLVector.AMPfoto + ".jpg"
        let imagePath = fileInDocumentsDirectory(myImageName)
        
        if (FileManager.default.fileExists(atPath: imagePath)){
            cell.foto.image = UIImage(contentsOfFile: imagePath)}
        else {cell.foto.image = UIImage(named: "AVATAR")}
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("COL item: \(indexPath.row)")
        // EDICAO DO PRODUTO
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    var modify = false
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {

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
                let COLVector: COL_struct
                COLVector = self.COLvector[(indexPath as NSIndexPath).row]
                let reference = COLVector.AMPcolaborador
                
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.COLtable.filter(self.DBcolaborador == reference)
                
                //OBTER NUMERO DA FOTO
                
                var myImageName = COLVector.AMPfoto + ".jpg"
                var imagePath = self.fileInDocumentsDirectory(myImageName)
                if (FileManager.default.fileExists(atPath: imagePath)){
                    //print("file exist after refresh")
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print("erro removendo foto")
                    }
                }
                
                myImageName = COLVector.AMPfotoCDBP + ".jpg"
                imagePath = self.fileInDocumentsDirectory(myImageName)
                if (FileManager.default.fileExists(atPath: imagePath)){
                    //print("file exist after refresh")
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print("erro removendo foto")
                    }
                }

                myImageName = COLVector.AMPfotoADS + ".jpg"
                imagePath = self.fileInDocumentsDirectory(myImageName)
                if (FileManager.default.fileExists(atPath: imagePath)){
                    //print("file exist after refresh")
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print("erro removendo foto")
                    }
                }

                do{try db!.run(delrecord.delete())} catch {
                    print("record deleted failed: \(error)")}

                self.refresh()
            }
            actionSheetController.addAction(GoDelete)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
        }
        let edit = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "MODIFICAR"){(UITableViewRowAction,NSIndexPath) -> Void in
            // ROTINA MODIFICAR
            self.adicionar(UIButton())
            
            let COLVector: COL_struct
            COLVector = self.COLvector[(indexPath as NSIndexPath).row]
            
            self.colaborador.text       = COLVector.AMPcolaborador
            self.email.text             = COLVector.AMPemail
            self.celular.text           = COLVector.AMPcelular
            self.fixo.text              = COLVector.AMPfixo
            self.codigo.text            = String(COLVector.AMPcodigo)
            //let foto                    = "C\(COLVector.AMPcodigo)"
            
            self.CDBPvalidade.text      = COLVector.AMPdataCDBP
            self.ADSvalidade.text       = COLVector.AMPdataADS
            
            self.senha1.text            = COLVector.AMPsenha
            
            self.meusPOPs.text          = COLVector.AMPpops
            
            
            var myImageName = COLVector.AMPfoto + ".jpg"
            var imagePath = self.fileInDocumentsDirectory(myImageName)
            if (FileManager.default.fileExists(atPath: imagePath)){
                self.foto_colaborador.image = UIImage(contentsOfFile: imagePath)}
            else {self.foto_colaborador.image = UIImage(named: "AVATAR")}
            
             myImageName = COLVector.AMPfotoCDBP + ".jpg"
             imagePath = self.fileInDocumentsDirectory(myImageName)
            if (FileManager.default.fileExists(atPath: imagePath)){
                self.foto_CDBP.image = UIImage(contentsOfFile: imagePath)}
            else {self.foto_CDBP.image = UIImage(named: "nophoto.png")}
            
            myImageName = COLVector.AMPfotoADS + ".jpg"
            imagePath = self.fileInDocumentsDirectory(myImageName)
            if (FileManager.default.fileExists(atPath: imagePath)){
                self.foto_ADS.image = UIImage(contentsOfFile: imagePath)}
            else {self.foto_ADS.image = UIImage(named: "nophoto.png")}
            
            self.modify = true
        }
        
        edit.backgroundColor = UIColor.blue
        return [delete,edit]
    }
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true
            self.status.image = UIImage(named: "sign_orange")
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var adicionar_view: UIView!
    
    @IBOutlet weak var colaborador: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var celular: UITextField!
    @IBOutlet weak var fixo: UITextField!
    @IBOutlet weak var codigo: UILabel!
    @IBOutlet weak var foto_colaborador: UIImageView!
    @IBOutlet weak var foto_CDBP: UIImageView!
    @IBOutlet weak var foto_ADS: UIImageView!
    
    @IBOutlet weak var senha1: UITextField!
    @IBOutlet weak var senha2: UITextField!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var CDBPvalidade: UITextField!
    @IBOutlet weak var ADSvalidade: UITextField!
    @IBOutlet weak var btnFotoColaborador: UIButton!
    @IBOutlet weak var btnFotoCDBP: UIButton!
    @IBOutlet weak var btnFotoADS: UIButton!
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func Salvar(_ sender: UIButton) {
        self.status.image = UIImage(named: "sign_orange")
        /*
        if !master {
            self.enableSectionAlert()
        }
        if !master { return}
        */
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        var cod = 0
        for COLtable in try! db!.prepare(COLtable) {
            cod = COLtable[DBcodigo]
        }
        
        let sen1 = senha1.text
        let sen2 = senha2.text
        
        if sen1 != sen2 {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "SENHAS devem ser iguais.\nModifique e tente novamente",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        let f1 = colaborador.text!
        if f1 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: NOME\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        let f2 = email.text!
        if !f2.isValidEmail() {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "EMAIL INVÁLIDO\nFavor verifique",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        let f3 = celular.text!
        if f3 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: TELEFONE CELULAR\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        let f4 = fixo.text!
        
        var  x = cod + 1
        //codigo.text = NSString(format:"%.00f", x) as String
        var f5 = x
        if modify { x = Int(codigo.text!)!}
        
        var f6 = "0001C\(x)"
        let f7 = String(describing: Date())
        let f8 = sen1
        
        let f9  = "0001C\(x)CDBP"
        let f10 = CDBPvalidade.text!
        
        let f11 = "0001C\(x)ADS"
        let f12 = ADSvalidade.text!
        
        let f13 = meusPOPs.text!
        
        //print(" insert: \(f1)\n\(f2)\n\(f3)\n\(f4)\n\(f5)\n\(f6)\n\(f7)\n\(f8)")
        
        let insert = COLtable.insert(DBcolaborador  <- f1,
                                    DBemail         <- f2,
                                    DBcelular       <- f3,
                                    DBfixo          <- f4,
                                    DBcodigo        <- f5,
                                    DBfoto          <- f6,
                                    DBdataCOL       <- f7,
                                    DBsenha         <- f8!,
                                    DBfotoCDBP      <- f9,
                                    DBdataCDBP      <- f10,
                                    DBfotoADS       <- f11,
                                    DBdataADS       <- f12,
                                    DBpops          <- f13)
        
        // DATABASE
        //let db = try? Connection("\(path)/gerente.sqlite3")
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "Colaborador Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)

            self.refresh()
            self.stamp(nome: f6)
            self.stampCDBP(nome: f9)
            self.stampADS(nome: f11)
            
            self.status.image = UIImage(named: "sign_green")
            
        } catch {
            print("insertion Principal failed: \(error)")
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message: "Colaborador JÁ CADASTRADO!\nGostaria de atualizar o registro?", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Fechar", style: .cancel) { action -> Void in
                //self.tableView.reloadData()
                return
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let Overwrite: UIAlertAction = UIAlertAction(title: "ATUALIZAR", style: .default) { action -> Void in
                // start
                
                // localizador do nome da foto
                
                for COLtable in try! db!.prepare(self.COLtable.filter(self.DBcolaborador == self.colaborador.text!)) {
                    cod = COLtable[self.DBcodigo]
                }
                f5 = cod
                f6 = "C\(cod)"
                    
                //print(" update: \(f1)\n\(f2)\n\(f3)\n\(f4)\n\(f5)\n\(f6)\n\(f7)\n\(f8)")
                let update = self.COLtable .filter(self.DBcolaborador == f1).update(
                    self.DBcolaborador  <- f1,
                    self.DBemail        <- f2,
                    self.DBcelular      <- f3,
                    self.DBfixo         <- f4,
                    self.DBcodigo       <- f5,
                    self.DBfoto         <- f6,
                    self.DBdataCOL      <- f7,
                    self.DBsenha        <- f8!,
                    self.DBfotoCDBP     <- f9,
                    self.DBdataCDBP     <- f10,
                    self.DBfotoADS      <- f11,
                    self.DBdataADS      <- f12,
                    self.DBpops         <- f13)
                
                do{
                    _ = try db!.run(update)
                    
                    let alertController = UIAlertController(title: "AVISO", message:
                        "Registro atualizado com sucesso!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.refresh()
                    
                    self.stamp(nome: f6)
                    self.stampCDBP(nome: f9)
                    self.stampADS(nome: f11)
                    
                    if self.modify { self.modify = false}
                    
                    self.status.image = UIImage(named: "sign_green")
                    
                }  catch {
                    print("insertion Principal UPDATE failed: \(error)")
                    
                    let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                        "Erro ao atualizar o registro! \nCODIGO: 002\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            actionSheetController.addAction(Overwrite)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            // alert override
        }
    }
    
    @IBAction func btnLimpar(_ sender: UIButton) {
        self.colaborador.text = ""
        self.email.text = ""
        self.celular.text = ""
        self.fixo.text = ""
        self.codigo.text = ""
        self.senha1.text = ""
        self.senha2.text = ""
        self.foto_colaborador.image = UIImage(named: "AVATAR")
        self.status.image = UIImage(named: "sign_orange")
        
        self.foto_CDBP.image = UIImage(named: "nophoto.png")
        self.foto_ADS.image = UIImage(named: "nophoto.png")
        self.CDBPvalidade.text = ""
        self.ADSvalidade.text  = ""
        self.meusPOPs.text = "0 0 0 0 0 0 0 0 0"
        modify = false
    }
    
    func refresh(){
        self.COLvector.removeAll()
        
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
    
        for COLtable in try! db!.prepare(COLtable) {
            COLvector.append(COL_struct(
                                    AMPcolaborador: String(COLtable[DBcolaborador]),
                                    AMPemail:       String(COLtable[DBemail]),
                                    AMPcodigo:      Int(COLtable[DBcodigo]),
                                    AMPcelular:     String(COLtable[DBcelular]),
                                    AMPfixo:        String(COLtable[DBfixo]),
                                    AMPfoto:        String(COLtable[DBfoto]),
                                    AMPdata:        String(COLtable[DBdataCOL]),
                                    AMPsenha:       String(COLtable[DBsenha]),
                                    AMPfotoCDBP:    String(COLtable[DBfotoCDBP]),
                                    AMPdataCDBP:    String(COLtable[DBdataCDBP]),
                                    AMPfotoADS:     String(COLtable[DBfotoADS]),
                                    AMPdataADS:     String(COLtable[DBdataADS]),
                                    AMPpops:        String(COLtable[DBpops])
            ))
        }
        
        COLvector = COLvector.reversed()
        myTableView.reloadData()
    }
    
    // POPs
    @IBOutlet weak var POPsView: UIView!
    @IBOutlet weak var pop1: UISegmentedControl!
    @IBOutlet weak var pop2: UISegmentedControl!
    @IBOutlet weak var pop3: UISegmentedControl!
    @IBOutlet weak var pop4: UISegmentedControl!
    @IBOutlet weak var pop5: UISegmentedControl!
    @IBOutlet weak var pop6: UISegmentedControl!
    @IBOutlet weak var pop7: UISegmentedControl!
    @IBOutlet weak var pop8: UISegmentedControl!
    @IBOutlet weak var pop9: UISegmentedControl!
    @IBOutlet weak var meusPOPs: UITextField!
    
    @IBAction func abrirPOP(_ sender: UITextField) {
        POPsView.isHidden = false
        meusPOPs.resignFirstResponder()
        let popsflag = meusPOPs.text!
        let arrayPOPs = popsflag.components(separatedBy: " ").compactMap { Int($0) }
        
        if arrayPOPs.count == 9 {
            pop1.selectedSegmentIndex = arrayPOPs[0]
            pop2.selectedSegmentIndex = arrayPOPs[1]
            pop3.selectedSegmentIndex = arrayPOPs[2]
            pop4.selectedSegmentIndex = arrayPOPs[3]
            pop5.selectedSegmentIndex = arrayPOPs[4]
            pop6.selectedSegmentIndex = arrayPOPs[5]
            pop7.selectedSegmentIndex = arrayPOPs[6]
            pop8.selectedSegmentIndex = arrayPOPs[7]
            pop9.selectedSegmentIndex = arrayPOPs[8]
        }
    }
    @IBAction func fecharPOP(_ sender: UIButton) {
        
        var popsflag = ""
         popsflag = popsflag + String(pop1.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop2.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop3.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop4.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop5.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop6.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop7.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop8.selectedSegmentIndex) + " "
         popsflag = popsflag + String(pop9.selectedSegmentIndex)
        
        meusPOPs.text = popsflag
        POPsView.isHidden = true
    }
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == colaborador {
            let newString = (textField.text! as NSString).uppercased
            textField.text = newString
        }
      
        if textField == fixo {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 2 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("(%@)", areaCode)
                index += 2
            }
            if length - index > 4 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@-", prefix)
                index += 4
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        }
        
        if textField == celular {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 11 && !hasLeadingOne) || length > 12 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 11) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 2 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("(%@)", areaCode)
                index += 2
            }
            if length - index > 5 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 5))
                formattedString.appendFormat("%@-", prefix)
                index += 5
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        }
        return true
    }
    
    // DATE PICKER
    var valid = Double(365) // NUMERO DE DIAS PARA VALIDADE
    
    @IBAction func validade_CDBP(_ sender: UITextField) {
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        CDBPvalidade.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(COL_VC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @IBAction func validade_ADS(_ sender: UITextField) {
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        ADSvalidade.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(COL_VC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
    
        if sender == CDBPvalidade {CDBPvalidade.text = dateFormatter.string(from: sender.date)}
        if sender == ADSvalidade  {ADSvalidade.text = dateFormatter.string(from: sender.date)}
        
    }
    // END DATE PICKER
    
    
    
    var DATA  = false
    var CDBP  = false
    var ADS   = false
    @IBAction func TakeFoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DATA = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func FotoCDBP(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            CDBP = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func FotoADS(_ sender: UIButton) {
        ADS = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[.originalImage]  as! UIImage
        if DATA  {foto_colaborador.image = image}
        if CDBP  {foto_CDBP.image     = image}
        if ADS   {foto_ADS.image = image}
        DATA  = false
        CDBP  = false
        ADS   = false
        dismiss(animated:true, completion: nil)
    }
    
    // SALVAR FOTOS
    var imagePath = ""
    
    func stampCDBP(nome: String) {
        if  let image = self.foto_CDBP.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            foto_CDBP.image = scale(image: image, toLessThan: 1024)
            let imageData = foto_CDBP.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            let compressedJPGImage = UIImage(data: imageData!)
            self.saveImage(compressedJPGImage!, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        }
    }
    
    func stampADS(nome: String) {
        if  let image = self.foto_ADS.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            foto_ADS.image = scale(image: image, toLessThan: 1024)
            let imageData = foto_ADS.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            let compressedJPGImage = UIImage(data: imageData!)
            self.saveImage(compressedJPGImage!, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        }
    }

    func stamp(nome: String) {
        if  let image = self.foto_colaborador.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            foto_colaborador.image = scale(image: image, toLessThan: 1024)
            let imageData = foto_colaborador.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            let compressedJPGImage = UIImage(data: imageData!)
            self.saveImage(compressedJPGImage!, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        }
    }
    
    func loadImageFromPath(_ path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    func saveImage (_ image: UIImage, path: String ) -> Bool{
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = image.jpegData(compressionQuality: CGFloat(compressFotos))
        let result = (try? jpgImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        return result
    }
    
    private func scale(image originalImage: UIImage, toLessThan maxResolution: CGFloat) -> UIImage? {
        guard let imageReference = originalImage.cgImage else { return nil }
        
        let rotate90 = CGFloat.pi/2.0 // Radians
        let rotate180 = CGFloat.pi // Radians
        let rotate270 = 3.0*CGFloat.pi/2.0 // Radians
        
        let originalWidth = CGFloat(imageReference.width)
        let originalHeight = CGFloat(imageReference.height)
        let originalOrientation = originalImage.imageOrientation
        
        var newWidth = originalWidth
        var newHeight = originalHeight
        
        if originalWidth > maxResolution || originalHeight > maxResolution {
            let aspectRatio: CGFloat = originalWidth / originalHeight
            newWidth = aspectRatio > 1 ? maxResolution : maxResolution * aspectRatio
            newHeight = aspectRatio > 1 ? maxResolution / aspectRatio : maxResolution
        }
        
        let scaleRatio: CGFloat = newWidth / originalWidth
        var scale: CGAffineTransform = .init(scaleX: scaleRatio, y: -scaleRatio)
        scale = scale.translatedBy(x: 0.0, y: -originalHeight)
        
        var rotateAndMirror: CGAffineTransform
        
        switch originalOrientation {
        case .up:
            rotateAndMirror = .identity
            
        case .upMirrored:
            rotateAndMirror = .init(translationX: originalWidth, y: 0.0)
            rotateAndMirror = rotateAndMirror.scaledBy(x: -1.0, y: 1.0)
            
        case .down:
            rotateAndMirror = .init(translationX: originalWidth, y: originalHeight)
            rotateAndMirror = rotateAndMirror.rotated(by: rotate180 )
            
        case .downMirrored:
            rotateAndMirror = .init(translationX: 0.0, y: originalHeight)
            rotateAndMirror = rotateAndMirror.scaledBy(x: 1.0, y: -1.0)
            
        case .left:
            (newWidth, newHeight) = (newHeight, newWidth)
            rotateAndMirror = .init(translationX: 0.0, y: originalWidth)
            rotateAndMirror = rotateAndMirror.rotated(by: rotate270)
            scale = .init(scaleX: -scaleRatio, y: scaleRatio)
            scale = scale.translatedBy(x: -originalHeight, y: 0.0)
            
        case .leftMirrored:
            (newWidth, newHeight) = (newHeight, newWidth)
            rotateAndMirror = .init(translationX: originalHeight, y: originalWidth)
            rotateAndMirror = rotateAndMirror.scaledBy(x: -1.0, y: 1.0)
            rotateAndMirror = rotateAndMirror.rotated(by: rotate270)
            
        case .right:
            (newWidth, newHeight) = (newHeight, newWidth)
            rotateAndMirror = .init(translationX: originalHeight, y: 0.0)
            rotateAndMirror = rotateAndMirror.rotated(by: rotate90)
            scale = .init(scaleX: -scaleRatio, y: scaleRatio)
            scale = scale.translatedBy(x: -originalHeight, y: 0.0)
            
        case .rightMirrored:
            (newWidth, newHeight) = (newHeight, newWidth)
            rotateAndMirror = .init(scaleX: -1.0, y: 1.0)
            rotateAndMirror = rotateAndMirror.rotated(by: CGFloat.pi/2.0)
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.concatenate(scale)
        context.concatenate(rotateAndMirror)
        context.draw(imageReference, in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copy
    }
    
    
    func listFilesFromDocumentsFolder() -> [String]?
    {
        let fileMngr = FileManager.default;
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        // List all contents of directory and return as [String] OR nil if failed
        return try? fileMngr.contentsOfDirectory(atPath:docs)
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

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
