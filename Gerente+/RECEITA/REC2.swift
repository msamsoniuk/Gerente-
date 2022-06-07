//
//  REC2.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 15/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class REC2: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var RECvector = [REC_struct]()

    let RECtable            = Table("REC")
    let DBreceita           = Expression<String>("DBreceita")
    let DBingredientes      = Expression<String>("DBingredientes")
    let DBmodoPreparo       = Expression<String>("DBmodoPreparo")
    let DBfotoRec           = Expression<String>("DBfotoRec")
    let DBseqRec            = Expression<Int>("DBseqRec")
    let DBdataRec           = Expression<String>("DBdataRec")
    let DBRendimento        = Expression<Double>("DBRendimento")
    let DBcodigo            = Expression<Int>("DBcodigo")        //colaborador
    
   // let list = ["COXINHA","COXINHA COM CATUPIRY","COXINHA COM CHEEDAR","PASTEL DE BANANA","PASTEL DE  FRANGO"]

    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.limpar(UIButton())
        REClist.removeAll()
        
        self.adicionar_view.isHidden = true
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for RECtable in try! db!.prepare(RECtable) {
            RECvector.append(REC_struct(RECreceita: String(RECtable[DBreceita]),
                                        RECingredientes: String(RECtable[DBingredientes]),
                                        RECmodoPreparo: String(RECtable[DBmodoPreparo]),
                                        RECfotoRec: String(RECtable[DBfotoRec]),
                                        RECseqRec: Int(RECtable[DBseqRec]),
                                        RECdataRec: String(RECtable[DBdataRec]),
                                        RECRendimento: Double(RECtable[DBRendimento]),
                                        RECcodigo: Int(RECtable[DBcodigo])))
        }
        
        RECvector = RECvector.reversed()
        centerView.center.x = view.center.x
        centerView.center.y = view.center.y + 48
        
        if RECvector.count > 0 {
            let defaults = UserDefaults.standard
            receitasFlag = true
            defaults.set(true, forKey: "receitasFlag")
        } else {
            let defaults = UserDefaults.standard
            receitasFlag = false
            defaults.set(false, forKey: "receitasFlag")
        }
        
        
    }
    
    @IBOutlet weak var centerView: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if REClist.count > 0 {
            status_ingredientes.image = UIImage(named: "sign_green")
            preparo.isEnabled = true
        }
        else {status_ingredientes.image = UIImage(named: "sign_orange")}
        
        if modoDePreparo != "" {
           status_modoPreparo.image = UIImage(named: "sign_green")
           rendimento.isEnabled = true
        }
        else {status_modoPreparo.image = UIImage(named: "sign_orange")}
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func limpar(_ sender: UIButton) {
        
        status_nomeReceita.image    = UIImage(named: "sign_orange")
        status_ingredientes.image   = UIImage(named: "sign_orange")
        status_modoPreparo.image    = UIImage(named: "sign_orange")
        statusRendimento.image      = UIImage(named: "sign_orange")
        status_nomeFoto.image       = UIImage(named: "sign_orange")
        status_Foto.image           = UIImage(named: "sign_orange")
        status_salvar.image         = UIImage(named: "sign_orange")
        
        ingredientes.isEnabled  = false
        preparo.isEnabled       = false
        rendimento.isEnabled    = false
        btnSalvar.isEnabled     = false
        bntFoto.isEnabled       = false
        
        self.TemFoto    = false
        texto           = false
        modoDePreparo   = ""
        REClist.removeAll()
        
    }
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true
            
            
           // dataEntrada.text = dateInFormat
           // self.sequencia.text = ""
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(RECvector.count) //return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "REC2")
        // cell.textLabel?.text = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "REC2", for: indexPath) as! REC2_TC
        
        let RECVector: REC_struct
        RECVector                       = RECvector[(indexPath as NSIndexPath).row]
        
        cell.fotoColaborador.image      =  UIImage(named: "AVATAR")
        cell.receita.text               =  RECVector.RECreceita
        cell.rendimento.text            =  String(RECVector.RECRendimento)
        
        let s = RECVector.RECdataRec
        let result = String(s.prefix(19))
        cell.dataReceita.text           =  result //RECVector.RECdataRec
        
        if RECVector.RECfotoRec != "" {
            cell.TemFoto.image  = UIImage(named: "camera")
        } else { cell.TemFoto.image  = UIImage(named: "noCamera")}
        
        if RECVector.RECmodoPreparo != "" {
            cell.TemRec.image   = UIImage(named: "inventory")
        } else {  cell.TemRec.image   = UIImage(named: "noInventory")} //noInventory
        
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
    
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
                let RECVector: REC_struct
                RECVector = self.RECvector[(indexPath as NSIndexPath).row]
                let reference = RECVector.RECreceita
                
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.RECtable.filter(self.DBreceita == reference)
                
                //OBTER NUMERO DA FOTO
                
                let myImageName = RECVector.RECfotoRec + ".jpg"
                let imagePath = self.fileInDocumentsDirectory(myImageName)
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
        return [delete]
    }
    
    @IBOutlet weak var adicionar_view: UIView!
    
    @IBAction func nomeRec(_ sender: UIButton) {
        self.limpar(UIButton())
        self.openAlertView()
    }
    
    var textField: UITextField?
    var textRend : UITextField?
    
    func configurationTextRend(textField: UITextField!) {
        if (textField) != nil {
            self.textRend = textField!
            self.textRend?.clearsOnBeginEditing = true
            //self.textRend?.autocapitalizationType = .allCharacters
            self.textRend?.keyboardType = .decimalPad
            self.textRend?.placeholder = "RENDIMENTO";
        }
    }
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!
            self.textField?.clearsOnBeginEditing = true
            self.textField?.autocapitalizationType = .allCharacters
            self.textField?.placeholder = "Minha Receita";
        }
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: "Nome da RECEITA", message: "por exemplo: \"PÃO DE MILHO\"", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancela", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            //print(self.textField?.text ?? "")
            if self.textField?.text != "" {
                self.status_nomeReceita.image = UIImage(named: "sign_green")
                self.ingredientes.isEnabled = true
                //self.RECEITA.text = self.textField?.text
                
            } else {
                self.status_nomeReceita.image = UIImage(named: "sign_orange")
                self.ingredientes.isEnabled = false
                self.preparo.isEnabled = false
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var status_nomeReceita: UIImageView!
    @IBOutlet weak var status_ingredientes: UIImageView!
    @IBOutlet weak var status_modoPreparo: UIImageView!
    @IBOutlet weak var status_Foto: UIImageView!
    @IBOutlet weak var status_salvar: UIImageView!
    
    @IBOutlet weak var ingredientes: UIButton!
    @IBOutlet weak var preparo: UIButton!
    @IBOutlet weak var rendimento: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ITENSREC") {
            if let destinationVC = segue.destination as? REC_ITENS_VC
            {
                destinationVC.tempstring = (self.textField?.text)!
                
            }
        }
    
        if (segue.identifier == "MODOREC") {
            if let destinationVC = segue.destination as? REC_MODO
            {
                destinationVC.tempstring = (self.textField?.text)!
                
            }
        }
    
    } // end prepare segue
    
    
    // SALVAR
    @IBOutlet weak var btnSalvar: UIButton!
    @IBAction func salvar(_ sender: UIButton) {
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        //let dateInFormat = dateFormatter.string(from: Date())
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        var seq = 0
        
        for REC in try! db!.prepare(RECtable) {
            print("id: \(REC[DBseqRec])")
            seq = REC[DBseqRec] + 1
        }
        //if sequencia.text != "" { seq = Int(sequencia.text!)! }
        
        let col = 1 // colaborador logado
        
        var nome_receita = ""
        if self.textField?.text != "" {
            nome_receita = (self.textField?.text)!
        }
        
        let f1  = nome_receita
        let f2  = "\(REClist)"
        let f3  = modoDePreparo
        var f4  = ""
        if self.TemFoto {
            f4 = "REC\(seq)"
        }
        let f5  = seq
        let f6  = String(describing: Date())
        var f7  = 1.0
        if textRend?.text != nil {
            f7 = Double((textRend!.text?.floatValue)!)
        }
        
        let f8  = col
    
        let insert = RECtable.insert(DBreceita          <- f1,
                                     DBingredientes     <- f2,
                                     DBmodoPreparo      <- f3,
                                     DBfotoRec          <- f4,
                                     DBseqRec           <- f5,
                                     DBdataRec          <- f6,
                                     DBRendimento       <- f7,
                                     DBcodigo           <- f8)
        print("\(f1)\n\(f2)\n\(f3)\n\(f4)\n\(f5)\n\(f6)\n\(f7)\n\(f8)\n")
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "Item Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.status_salvar.image = UIImage(named: "sign_green")
            
            if f4  != "" {self.stampREC(nome: f4)}
           // if f10 != "" {self.stampORG(nome: f10)}
           self.refresh()
            
        } catch {
            
            /*
             print("insertion Principal failed: \(error)")
             var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
             message: "Ocorreu um erro, contacte o suporte",
             delegate: nil,
             cancelButtonTitle: "Fechar")
             alert.show()
             return()
             */
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message: "Produto JÁ CADASTRADO!\nGostaria de atualizar o registro?", preferredStyle: .alert)
            
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
                
                let update = self.RECtable .filter(self.DBreceita == f1).update(
                                    self.DBreceita          <- f1,
                                    self.DBingredientes     <- f2,
                                    self.DBmodoPreparo      <- f3,
                                    self.DBfotoRec          <- f4,
                                    self.DBseqRec           <- f5,
                                    self.DBdataRec          <- f6,
                                    self.DBRendimento       <- f7,
                                    self.DBcodigo           <- f8)
                
                do{
                    _ = try db!.run(update)
                    
                    let alertController = UIAlertController(title: "AVISO", message:
                        "Registro atualizado com sucesso!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.status_salvar.image = UIImage(named: "sign_green")
                    self.refresh()
                    if f4  != "" {self.stampREC(nome: f4)}
                    
                }  catch {
                    print("insertion Principal UPDATE failed: \(error)")
                    
                    let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                        "Erro ao atualizar o registro! \nCODIGO: 004\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
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
    
    func refresh(){
        self.RECvector.removeAll()
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        for RECtable in try! db!.prepare(RECtable) {
            RECvector.append(REC_struct(RECreceita: String(RECtable[DBreceita]),
                                        RECingredientes: String(RECtable[DBingredientes]),
                                        RECmodoPreparo: String(RECtable[DBmodoPreparo]),
                                        RECfotoRec: String(RECtable[DBfotoRec]),
                                        RECseqRec: Int(RECtable[DBseqRec]),
                                        RECdataRec: String(RECtable[DBdataRec]),
                                        RECRendimento: Double(RECtable[DBRendimento]),
                                        RECcodigo: Int(RECtable[DBcodigo])))
        }
        
        RECvector = RECvector.reversed()
        myTableView.reloadData()
    }
    
    // RENDIMENTO
    @IBOutlet weak var statusRendimento: UIImageView!
    @IBAction func infoRendimento(_ sender: UIButton) {

            let alert = UIAlertController(title: "RENDIMENTO", message: "quantas porções\nrende esta receita?", preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: configurationTextRend(textField:))
            alert.addAction(UIAlertAction(title: "Cancela", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in

                if self.textRend?.text != "" {
                    self.statusRendimento.image = UIImage(named: "sign_green")
                    self.btnSalvar.isEnabled = true
 
                } else {
                    self.statusRendimento.image = UIImage(named: "sign_orange")
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    // FOTO
    @IBOutlet weak var status_nomeFoto: UIImageView!
    @IBAction func NomeFoto(_ sender: UIButton) {
    
        self.limpar(UIButton())
        
        let alert = UIAlertController(title: "Nome da RECEITA", message: "por exemplo: \"PÃO DE MILHO\"", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancela", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            self.TemFoto = false
            if self.textField?.text != "" {
                self.status_nomeFoto.image = UIImage(named: "sign_green")
                self.bntFoto.isEnabled = true

            } else {
                self.status_nomeFoto.image = UIImage(named: "sign_orange")
                self.bntFoto.isEnabled = false
                
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var bntFoto: UIButton!
    @IBAction func tirarFoto(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var TemFoto = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[.originalImage] as! UIImage
        imagePicked.image = image
        TemFoto = true
        btnSalvar.isEnabled = true
        //stat1.image = UIImage(named: "sign_green")
        //self.stamp()
        dismiss(animated:true, completion: nil)
    }
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    var imagePath = ""
    
    func stampREC(nome: String) {
        if  let image = self.imagePicked.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            imagePicked.image = scale(image: image, toLessThan: 1024)
            let imageData = imagePicked.image!.jpegData(compressionQuality: CGFloat(compressFotos))
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
    
    func overlayText(_ drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.red //UIColor.blueColor()//.redColor() // .whiteColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Creating a point within the space that is as big as the image.
        let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        
        return newImage
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
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
