//
//  EXP_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 06/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class EXP_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var RECvector = [REC_struct]()
    // TABELA RECEITAS
    let RECtable            = Table("REC")
    var DBreceita           = Expression<String>("DBreceita")
    let DBingredientes      = Expression<String>("DBingredientes")
    let DBmodoPreparo       = Expression<String>("DBmodoPreparo")
    let DBfotoRec           = Expression<String>("DBfotoRec")
    let DBseqRec            = Expression<Int>("DBseqRec")
    let DBdataRec           = Expression<String>("DBdataRec")
    let DBRendimento        = Expression<Double>("DBRendimento")
    let DBcodigo            = Expression<Int>("DBcodigo")        //colaborador
    
    var STATvector = [Status_struct]()
    // TABELA STATUS
    let STATtable           = Table("STAT")
    var DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")
    
    var PRODvector = [PRO_struct]()
    // TABELE PRODUCAO
    var PRODtable       = Table("PROD")
    //let DBreceita       = Expression<String>("DBreceita")
    let DBlote          = Expression<String>("DBlote")
    let DBdata          = Expression<String>("DBdata")
    let DBdataValidade      = Expression<String>("DBdataValidade")
    let DBquantidade    = Expression<Double>("DBquantidade")
    let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBrefrigeracao  = Expression<String>("DBrefrigeracao")
    
    var EXPvector = [EXP_struct]()
    // TABELE EXPEDICAO
    let EXPtable       = Table("EXP")
   // let DBreceita       = Expression<String>("DBreceita")
   // let DBlote          = Expression<String>("DBlote")
   // let DBdata          = Expression<String>("DBdata")
   // let DBdataValidade      = Expression<String>("DBdataValidade")
   // let DBquantidade    = Expression<Double>("DBquantidade")
   // let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBnfe      = Expression<String>("DBnfe")
    let DBvalor  = Expression<Double>("DBvalor")
    let DBquebra = Expression<Int>("DBquebra")
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    var HOJE = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for RECtable in try! db!.prepare(RECtable) {
            RECvector.append(
                REC_struct(RECreceita: String(RECtable[DBreceita]),
                           RECingredientes: String(RECtable[DBingredientes]),
                           RECmodoPreparo: String(RECtable[DBmodoPreparo]),
                           RECfotoRec: String(RECtable[DBfotoRec]),
                           RECseqRec: Int(RECtable[DBseqRec]),
                           RECdataRec: String(RECtable[DBdataRec]),
                           RECRendimento: Double(RECtable[DBRendimento]),
                           RECcodigo: Int(RECtable[DBcodigo])))
        }
        
        for PRODtable in try! db!.prepare(PRODtable) {
            PRODvector.append(
                PRO_struct(Mreceita: String(PRODtable[DBreceita]),
                           Mlote: String(PRODtable[DBlote]),
                           Mdata: String(PRODtable[DBdata]),
                           Mvalidade: String(PRODtable[DBdataValidade]),
                           Mquantidade: Double(PRODtable[DBquantidade]),
                           Mcolaborador: String(PRODtable[DBcolaborador]),
                           Mrefrigeracao: String(PRODtable[DBrefrigeracao])))
        }
        
        for EXPtable in try! db!.prepare(EXPtable) {
            EXPvector.append(
                EXP_struct(Mreceita: String(EXPtable[DBreceita]),
                           Mlote: String(EXPtable[DBlote]),
                           Mdata: String(EXPtable[DBdata]),
                           Mvalidade: String(EXPtable[DBdataValidade]),
                           Mquantidade: Double(EXPtable[DBquantidade]),
                           Mcolaborador: String(EXPtable[DBcolaborador]),
                           Mnfe: String(EXPtable[DBnfe]),
                           Mvalor: Double(EXPtable[DBvalor]),
                           Mquebra: Int(EXPtable[DBquebra])))
        }
        
        EXPvector = EXPvector.reversed()
        
        adicionar_view.isHidden = true
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        
        receita.inputView           = thePicker1
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(REC_ITENS_VC.dismissPicker))
        receita.inputAccessoryView     = toolBar
        validade.inputAccessoryView    = toolBar
        
        quantidade.delegate = self
        quantidade.addDoneButtonToKeyboard(myAction:  #selector(self.quantidade.resignFirstResponder))
        
        valor.delegate = self
        valor.addDoneButtonToKeyboard(myAction:  #selector(self.valor.resignFirstResponder))
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(EXPvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXPEDICAO", for: indexPath) as! EXP_TC
        let EXPVector: EXP_struct
        EXPVector =  EXPvector[(indexPath as NSIndexPath).row]
        
        cell.receita.text       =  EXPVector.Mreceita
        cell.lote.text          =  "#\(EXPVector.Mlote)"
        cell.data.text          =  EXPVector.Mdata
        cell.validade.text      =  EXPVector.Mvalidade
        cell.valor.text         =  "R$ \(EXPVector.Mvalor)"
        cell.quantidade.text    =  String(EXPVector.Mquantidade)
        
        if EXPVector.Mquebra == 0 {cell.quebra.text = "SAIDA"} else {cell.quebra.text = "PERDA"}
       // cell.colaborador.image  =  UI

        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //print(list[indexPath.row])
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //unchecked
    }
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBOutlet weak var adicionar_view: UIView!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm"
            let dateInFormat = dateFormatter.string(from: Date())
            data.text = dateInFormat
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
            
            if EXPvector.count > 0 {
                lote.text = EXPvector[EXPvector.count - 1].Mlote
            } else {
                lote.text = "1"
            }
            
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "diminuir"), for: .normal )
        }
    }
    @IBOutlet weak var receita: UITextField!
    @IBOutlet weak var quantidade: UITextField!
    @IBOutlet weak var validade: UITextField!
    @IBOutlet weak var movimento: UISegmentedControl!
    @IBOutlet weak var lote: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var statusGravar: UIImageView!
    
    
    func dismissPicker() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // END FUNCOES
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RECvector.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let RECVector: REC_struct
        RECVector = RECvector[row]
        receita.text = RECVector.RECreceita

        return RECVector.RECreceita
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    // end picker
    
    
    // DATE PICKER
    var valid = Double(0) // NUMERO DE DIAS PARA VALIDADE
    
    
    @IBAction func GOValid(_ sender: UITextField) {
        //view.endEditing(true)
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        validade.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EXP_VC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        validade.text = dateFormatter.string(from: sender.date)
        
    }
    // END DATE PICKER
    
    @IBOutlet weak var qtdsaldo: UILabel!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == quantidade {
            let db = try? Connection("\(path)/gerente.sqlite3")
            var saldo = 0.0
            let filtro = receita.text
            
            let debito = EXPtable.filter(DBreceita == filtro!)
            for i in try! db!.prepare(debito) {
                saldo = saldo - i[DBquantidade]
            }
            
            let credito = PRODtable.filter(DBreceita == filtro!)
            for i in try! db!.prepare(credito) {
                saldo = saldo + i[DBquantidade]
            }
            
            qtdsaldo.text = "(\(saldo))"
            print("saldo: \(saldo)")
            
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == valor {
            valor.text = valor.text?.currency
        }
        return true
    }
    
    @IBAction func gravar(_ sender: UIButton) {
        
        self.statusGravar.image = UIImage(named: "sign_orange")
        let db = try? Connection("\(path)/gerente.sqlite3")
        var seq = 0
        
        for EXP in try! db!.prepare(EXPtable) {
            print("id: \(EXP[DBlote])")
            seq = Int(EXP[DBlote])! + 1
        }
        lote.text = String(seq)
        let col = 1 // colaborador logado
        
        let f1  = lote.text
        let f2  = receita.text
        var f3  = 0.0
        if quantidade.text != ""   { f3 = Double((quantidade.text?.floatValue)!)}
        let f4  = validade.text
        let f5  = Int(movimento.selectedSegmentIndex)
        let f6  = data.text
        let f7  = String(col)
        var f8  = ""
        if Nfe.image != UIImage(named: "sign_orange") {
            f8  = "EXP_NFE" + String(seq)
            self.stampNFE(nome: f8)
        }
        var f9  = 0.0
        if valor.text != "" { f9 = Double((valor.text?.floatValue)!)}
        
        
        if f2 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: RECEITA\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        

      let insert = EXPtable.insert(DBlote            <- f1!,
                                      DBreceita        <- f2!,
                                      DBquantidade     <- f3,
                                      DBdataValidade   <- f4!,
                                      DBquebra         <- f5,
                                      DBdata           <- f6!,
                                      DBcolaborador    <- f7,
                                      DBnfe            <- f8,
                                      DBvalor          <- f9)
      
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "PRODUÇÃO Cadastrada com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            if f8 != "" {self.stampNFE(nome: f8)}
            
            self.statusGravar.image = UIImage(named: "sign_green")
            self.refresh()
            
        } catch {
            print("erro na inclusao do PRODUCAO")
            self.refresh()
        }
    }
    
    func refresh(){
        self.EXPvector.removeAll()
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        for EXPtable in try! db!.prepare(EXPtable) {
            EXPvector.append(EXP_struct(Mreceita: String(EXPtable[DBreceita]),
                                        Mlote: String(EXPtable[DBlote]),
                                        Mdata: String(EXPtable[DBdata]),
                                        Mvalidade: String(EXPtable[DBdataValidade]),
                                        Mquantidade: Double(EXPtable[DBquantidade]),
                                        Mcolaborador: String(EXPtable[DBcolaborador]),
                                        Mnfe: String(EXPtable[DBnfe]),
                                        Mvalor: Double(EXPtable[DBvalor]),
                                        Mquebra: Int(EXPtable[DBquebra])))
        }
        
        EXPvector = EXPvector.reversed()
        myTableView.reloadData()
    }
    
    
    // SALVAR FOTOS
    var imagePath = ""
    var fnfe  = false
    @IBOutlet weak var Nfe: UIImageView!
    
    @IBAction func FotoNFe(_ sender: UIButton) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            fnfe = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else { Nfe.image = UIImage(named: "nfe_teste.JPG")}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        if fnfe  {Nfe.image     = image}
        fnfe  = false
        dismiss(animated:true, completion: nil)
    }
    
    func stampNFE(nome: String) {
        if  let image = self.Nfe.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            Nfe.image = scale(image: image, toLessThan: 1024)
            let imageData = Nfe.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            let compressedJPGImage = UIImage(data: imageData!)
            self.saveImage(compressedJPGImage!, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        }
    }
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
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
    
    @IBAction func movimentacao(_ sender: UISegmentedControl) {
        let db = try? Connection("\(path)/gerente.sqlite3")
        var saldo = 0.0
        let filtro = receita.text
        
        let debito = EXPtable.filter(DBreceita == filtro!)
        for i in try! db!.prepare(debito) {
            saldo = saldo - i[DBquantidade]
        }
        
        let credito = PRODtable.filter(DBreceita == filtro!)
        for i in try! db!.prepare(credito) {
            saldo = saldo + i[DBquantidade]
        }
        
        print("saldo: \(saldo)")
    }
    
    @IBAction func limpar(_ sender: UIButton) {
        valid = 0.0

        receita.text        = ""
        quantidade.text     = ""
        validade.text       = ""
        valor.text          = ""
        //lote.text           = ""
        data.text           = ""
        movimento.selectedSegmentIndex = 0
        qtdsaldo.text       = "0"
        Nfe.image           = UIImage(named: "sign_orange")
        statusGravar.image  = UIImage(named: "sign_orange")
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
