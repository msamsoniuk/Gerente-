//
//  INF_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 09/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class INF_VC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

     let CLItable        = Table("Cliente")
     let DBcfpCNPJ       = Expression<String>("DBcfpCNPJ")
     let DBnome          = Expression<String>("DBnome")
     let DBempresa       = Expression<String>("DBempresa")
     let DBcadastroProd  = Expression<String>("DBcadastroProd")
     let DBendereco      = Expression<String>("DBendereco")
     let DBcidade        = Expression<String>("DBcidade")
     let DBCEP           = Expression<String>("DBCEP")
     let DBarea          = Expression<String>("DBarea")
     let DBUF            = Expression<String>("DBUF")
     let DBemail         = Expression<String>("DBemail")
     let DBtipoNegocio   = Expression<String>("DBtipoNegocio")
     let DBProdOrg       = Expression<Int>("DBProdOrg")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    var HOJE = ""
    
    let meuBusiness = ["AGROINDUSTRIA","AÇOUGUE", "MERCADO","RESTAURANTE", "PADARIA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        HOJE = dateFormatter.string(from: Date())
        
        var CLIvector = [cliente]()
        
        for CLItable in try! db!.prepare(CLItable){
            CLIvector.append(cliente(
                cfpCNPJ         : String(CLItable[DBcfpCNPJ]),
                nome            : String(CLItable[DBnome]),
                empresa         : String(CLItable[DBempresa]),
                cadastroProd    : String(CLItable[DBcadastroProd]),
                endereco        : String(CLItable[DBendereco]),
                cidade          : String(CLItable[DBcidade]),
                CEP             : String(CLItable[DBCEP]),
                area            : String(CLItable[DBarea]),
                UF              : String(CLItable[DBUF]),
                email           : String(CLItable[DBemail]),
                tipoNegocio     : String(CLItable[DBtipoNegocio]),
                ProdOrg         : Int(CLItable[DBProdOrg])
                ))
        }
        
        if CLIvector.count > 0 {
            cfpCNPJ.text       = CLIvector[0].cfpCNPJ
            nome.text          = CLIvector[0].nome
            empresa.text       = CLIvector[0].empresa
            cadastroProd.text  = CLIvector[0].cadastroProd
            endereco.text      = CLIvector[0].endereco
            cidade.text        = CLIvector[0].cidade
            CEP.text           = CLIvector[0].CEP
            area.text          = CLIvector[0].area
            UF.text            = CLIvector[0].UF
            email.text         = CLIvector[0].email
            tipoNegocio.text   = CLIvector[0].tipoNegocio
            ProdOrg.selectedSegmentIndex = CLIvector[0].ProdOrg
        }
        
        //botao fechar para teclado numerico
        cfpCNPJ.addDoneButtonToKeyboard(myAction:  #selector(self.cfpCNPJ.resignFirstResponder))
        cadastroProd.addDoneButtonToKeyboard(myAction:  #selector(self.cadastroProd.resignFirstResponder))
        CEP.addDoneButtonToKeyboard(myAction:  #selector(self.CEP.resignFirstResponder))
        area.addDoneButtonToKeyboard(myAction:  #selector(self.area.resignFirstResponder))
        // Do any additional setup after loading the view.
        
        
        thePicker1.delegate  = self
        tipoNegocio.inputView           = thePicker1
        
        tipoNegocio.delegate = self
        tipoNegocio.addDoneButtonToKeyboard(myAction:  #selector(self.tipoNegocio.resignFirstResponder))
        
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //print("fechar teclado 1")

        return true
    }
    @IBAction func limpar(_ sender: UIButton) {
        
         cfpCNPJ.text       = ""
         nome.text          = ""
         empresa.text       = ""
         cadastroProd.text  = ""
         endereco.text      = ""
         cidade.text        = ""
         CEP.text           = ""
         area.text          = ""
         UF.text            = ""
         email.text         = ""
         tipoNegocio.text   = ""
         ProdOrg.selectedSegmentIndex = 0
        
    }
    
    @IBAction func gravar(_ sender: UIButton) {
        
        let f1  = cfpCNPJ.text
        let f2  = nome.text
        let f3  = empresa.text
        let f4  = cadastroProd.text
        let f5  = endereco.text
        let f6  = cidade.text
        let f7  = CEP.text
        let f8  = area.text
        let f9  = UF.text
        let f10  = email.text
        let f11 = tipoNegocio.text
        let f12 = Int(ProdOrg.selectedSegmentIndex)
        
        if f1 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O CPF-CNPJ\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        

        let insert = CLItable.insert( DBcfpCNPJ       <- f1!,
                                      DBnome          <- f2!,
                                      DBempresa       <- f3!,
                                      DBcadastroProd  <- f4!,
                                      DBendereco      <- f5!,
                                      DBcidade        <- f6!,
                                      DBCEP           <- f7!,
                                      DBarea          <- f8!,
                                      DBUF            <- f9!,
                                      DBemail         <- f10!,
                                      DBtipoNegocio   <- f11!,
                                      DBProdOrg       <- f12)
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "Dados do Usúario Cadastrados\ncom SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.status.image = UIImage(named: "sign_green")
            
            negocioFlag = true
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "negocioFlag")
            
           
            
        } catch {
            print("ja existe")
            
            let update = self.CLItable .filter(self.DBcfpCNPJ == f1!).update(
                self.DBnome          <- f2!,
                self.DBempresa       <- f3!,
                self.DBcadastroProd  <- f4!,
                self.DBendereco      <- f5!,
                self.DBcidade        <- f6!,
                self.DBCEP           <- f7!,
                self.DBarea          <- f8!,
                self.DBUF            <- f9!,
                self.DBemail         <- f10!,
                self.DBtipoNegocio   <- f11!,
                self.DBProdOrg       <- f12)
            do{
                _ = try db!.run(update)
                self.status.image = UIImage(named: "sign_green")
                
                
                
                negocioFlag = true
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "negocioFlag")
 
                let alertController = UIAlertController(title: "AVISO", message:
                    "Dados do Usúario Atualizados\ncom SUCESSO!", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)

            }  catch {
                print("dados cliente - erro na atualizacao: \(error)")
                let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                    "Erro ao atualizar o registro! \nCODIGO: 099\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }

    @IBOutlet weak var ProdOrg: UISegmentedControl!
    @IBOutlet weak var cfpCNPJ: UITextField!
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var empresa: UITextField!
    @IBOutlet weak var cadastroProd: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var cidade: UITextField!
    @IBOutlet weak var UF: UITextField!
    @IBOutlet weak var CEP: UITextField!
    @IBOutlet weak var area: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var tipoNegocio: UITextField!
    @IBOutlet weak var status: UIImageView!
    
    
    
    // up down keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if  textField == email ||
            textField == tipoNegocio ||
            textField == CEP ||
            textField == area {
            //equiView.isHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.setsView.frame = CGRect(x:self.setsView.frame.origin.x, y:self.setsView.frame.origin.y - 100, width:self.setsView.frame.size.width, height:self.setsView.frame.size.height);
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == email ||
            textField == tipoNegocio ||
            textField == CEP ||
            textField == area {
            UIView.animate(withDuration: 0.3, animations: {
                self.setsView.frame = CGRect(x:self.setsView.frame.origin.x, y:self.setsView.frame.origin.y + 100, width:self.setsView.frame.size.width, height:self.setsView.frame.size.height);
            })
            //equiView.isHidden = false
            //print("fechar teclado 2")
        }
        if textField == cfpCNPJ {
            if (cfpCNPJ.text?.isValidCPF)! || (cfpCNPJ.text?.isValidCNPJ)! { self.cfpCNPJ.textColor = UIColor.black  } else { self.cfpCNPJ.textColor = UIColor.red }
        }
    }
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meuBusiness.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        tipoNegocio.text = meuBusiness[row]
        
        return meuBusiness[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    // end picker

    
}

extension String {
    var isValidCNPJ: Bool {
        let numbers = compactMap({Int(String($0))})
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    
    var isValidCPF: Bool {
        let numbers = compactMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}
