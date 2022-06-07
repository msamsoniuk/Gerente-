//
//  RECOL_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 14/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class RECOL_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var RECvector = [String]()
    // TABELA RECEITAS
    let RECtable            = Table("REC")
    let DBreceita           = Expression<String>("DBreceita")
    
    var RECOLvector = [RECOL_struct]()
    // TABELA RECOLHIMENTO
    let RECOLtable         = Table("RECOL")
    let DBReclamIndex      = Expression<Int>("DBReclamIndex")
    let DBreclamante       = Expression<String>("DBreclamante")
    let DBemailReclam      = Expression<String>("DBemailReclam")
    let DBdataReclam       = Expression<String>("DBdataReclam")
    let DBdataFab          = Expression<String>("DBdataFab")
    let DBproduto          = Expression<String>("DBproduto")
    let DBamostraData      = Expression<String>("DBamostraData")
    let DBamostraFoto      = Expression<String>("DBamostraFoto")
    let DBamostraTexto     = Expression<String>("DBamostraTexto")
    let DBcontaminado      = Expression<Int>("DBcontaminado")
    let DBcolaborador      = Expression<String>("DBcolaborador")

    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTextoAmostra.isHidden = true
        addView.isHidden = true
        reclamante.delegate = self
        email.delegate = self
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for RECtable in try! db!.prepare(RECtable) {
            RECvector.append(RECtable[DBreceita])
        }
        
        for RECOLtable in try! db!.prepare(RECOLtable) {
            RECOLvector.append(
                RECOL_struct(MreclamIndex: RECOLtable[DBReclamIndex],
                             Mreclamante: RECOLtable[DBreclamante],
                             MemailReclam: RECOLtable[DBemailReclam],
                             MdataReclam: RECOLtable[DBdataReclam],
                             MdataFab: RECOLtable[DBdataFab],
                             Mproduto: RECOLtable[DBproduto],
                             MamostraData: RECOLtable[DBamostraData],
                             MamostraFoto: RECOLtable[DBamostraFoto],
                             MamostraTexto: RECOLtable[DBamostraTexto],
                             Mcontaminado: RECOLtable[DBcontaminado],
                             Mcolaborador: RECOLtable[DBcolaborador]))
        }
        
        RECOLvector = RECOLvector.reversed()
        
        thePicker1.delegate         = self
        thePicker1.dataSource       = self
        
        // linkar campos ao Picker
        produto.inputView           = thePicker1
        
        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(RECOL_VC.dismissPicker))
        produto.inputAccessoryView            = toolBar
        reclamacaoData.inputAccessoryView     = toolBar
        fabricacaoData.inputAccessoryView     = toolBar
        amostraTexto.inputAccessoryView       = toolBar
        amostraTexto.delegate                 = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var reclamacaoData: UITextField!
    @IBOutlet weak var fabricacaoData: UITextField!
    
    @IBOutlet weak var colaborador: UIImageView!
    @IBOutlet weak var reclamante: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
   // @IBOutlet weak var dataReclamacao: UITextField!
   // @IBOutlet weak var dataFabricacao: UITextField!
    
    @IBOutlet weak var produto: UITextField!
    @IBOutlet weak var statusAmostraTexto: UIImageView!
    @IBOutlet weak var statusAmostraFoto: UIImageView!
    @IBOutlet weak var contaminado: UISegmentedControl!
    @IBOutlet weak var amostraTexto: UITextView!

    @IBOutlet weak var addView: UIView!
    

    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var viewTextoAmostra: UIView!
    @IBAction func textoAmostra(_ sender: UIButton) {
        viewTextoAmostra.isHidden = false
  
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == self.amostraTexto) {
            viewTextoAmostra.isHidden = true
        }
        return true
    }
 
    @IBAction func limpaTexto(_ sender: UIButton) {
        amostraTexto.text = ""
    }
    
    @IBAction func fechaTexto(_ sender: UIButton) {
        viewTextoAmostra.isHidden = true
        if amostraTexto.text != "" {
            statusAmostraTexto.image = UIImage(named: "sign_green")
        } else { statusAmostraTexto.image = UIImage(named: "sign_orange")}
    }
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(RECOLvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RECOL", for: indexPath) as! RECOL_TC
        
        let RECOLVector: RECOL_struct
        RECOLVector =  RECOLvector[(indexPath as NSIndexPath).row]
        
        //cell.imgColaborador.image       =  nil
        if RECOLVector.MamostraFoto != "" {cell.imgFoto.image = UIImage(named: "camera")}
        
        if RECOLVector.MamostraTexto != "" {cell.imgTexto.image = UIImage(named: "inventory")}
        
        //cell.imgContaminado.image       =  nil
        //cell.imgFoto.image              =  nil
        //cell.imgTexto.image             =  nil
        cell.produto.text               = RECOLVector.Mproduto
        cell.reclamante.text            = RECOLVector.Mreclamante
        cell.emailReclamante.text       = RECOLVector.MemailReclam
        cell.dataFab.text               = RECOLVector.MdataFab
        cell.dataReclam.text            = RECOLVector.MdataReclam
        cell.dataAmostra.text           = RECOLVector.MamostraData
        if RECOLVector.Mcontaminado == 0 { cell.contaminado.text = "S"}
        else {
            cell.contaminado.text = "N"
            cell.imgContaminado.isHidden = true
        }
        
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
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
                let RECOLVector: RECOL_struct
                RECOLVector = self.RECOLvector[(indexPath as NSIndexPath).row]
                let reference = RECOLVector.MreclamIndex
                
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.RECOLtable.filter(self.DBReclamIndex == reference)
                
                //OBTER NUMERO DA FOTO
                
                var myImageName = RECOLVector.MamostraFoto + ".jpg"
                var imagePath = self.fileInDocumentsDirectory(myImageName)
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
 
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        
        if addView.isHidden == true {
            addView.isHidden = false
            myTableView.isHidden = true
            
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )

        }
        else {
            addView.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
 
    }
    
    @IBAction func goContaminado(_ sender: UISegmentedControl) {
        if contaminado.selectedSegmentIndex == 0
             {aviso.text = ">> RECOLHER PRODUTO <<"}
        else {aviso.text = ">> NÃO recolher produto <<"}
        
    }
    
    @IBOutlet weak var statusGravar: UIImageView!
    @IBAction func salvar(_ sender: UIButton) {
        
        self.statusGravar.image = UIImage(named: "sign_orange")
        let db = try? Connection("\(path)/gerente.sqlite3")
        var seq = 0
        
        for RECOL in try! db!.prepare(RECOLtable) {
            print("id: \(RECOL[DBReclamIndex])")
            seq = Int(RECOL[DBReclamIndex]) + 1
        }

        let col = 1 // colaborador logado
        
        let f1  = seq
        let f2  = reclamante.text
        var f3  = email.text
        let f4  = reclamacaoData.text
        let f5  = fabricacaoData.text
        let f6  = produto.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy" // HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        
        let f7  = dateInFormat
        let f8  = String(col)
        var f9  = ""
        if statusAmostraFoto.image != UIImage(named: "sign_orange") {
            f9  = "RECOL_AMOSTRA" + String(seq)
            self.stampRECOL(nome: f8)
        }
        var f10  = amostraTexto.text
        var f11 = contaminado.selectedSegmentIndex
        

        let insert = RECOLtable.insert(DBReclamIndex      <- f1,
                                       DBreclamante       <- f2!,
                                       DBemailReclam      <- f3!,
                                       DBdataReclam       <- f4!,
                                       DBdataFab          <- f5!,
                                       DBproduto          <- f6!,
                                       DBamostraData      <- f7,
                                       DBcolaborador      <- f8,
                                       DBamostraFoto      <- f9,
                                       DBamostraTexto     <- f10!,
                                       DBcontaminado      <- f11)
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "RECOLHIMENTO Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            //if f8 != "" {self.stampRECOL(nome: f8)}
            
            self.statusGravar.image = UIImage(named: "sign_green")
            self.refresh()
            
        } catch {
            print("erro na inclusao do PRODUCAO")
            //self.refresh()
        }
 
    }
    
    
    @IBOutlet weak var aviso: UITextField!
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RECvector.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        produto.text = RECvector[row]
        return RECvector[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    // end picker
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // DATE PICKER
    var valid = Double(0) // NUMERO DE DIAS PARA VALIDADE
    
    @IBAction func dataReclamPicker(_ sender: UITextField) {
        //view.endEditing(true)
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        reclamacaoData.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RECOL_VC.datePickerValueChangedR), for: UIControl.Event.valueChanged)
    }
    
    @IBAction func dataFabPicker(_ sender: UITextField) {
        //view.endEditing(true)
        view.resignFirstResponder()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        fabricacaoData.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RECOL_VC.datePickerValueChangedF), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func datePickerValueChangedR(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        reclamacaoData.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePickerValueChangedF(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        fabricacaoData.text = dateFormatter.string(from: sender.date)
    }
    // END DATE PICKER
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textPicked: UIImageView!
    var foto = false
    
    @IBAction func openCameraButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.videoQuality = .typeLow
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            /*
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            //data = true
             */
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
                    imagePicked.image = info[.originalImage] as? UIImage
                    self.dismiss(animated: true, completion: nil)
                    foto = true
                }
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[.editedImage] as! UIImage
        imagePicked.image = image
        
        foto = true
        dismiss(animated:true, completion: nil)
    }
    */
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    var imagePath = ""
    var fotoNome = ""
    
    func stampRECOL(nome: String) {
        if  let image = self.statusAmostraFoto.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            statusAmostraFoto.image = scale(image: image, toLessThan: 1024)
            let imageData = statusAmostraFoto.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            let compressedJPGImage = UIImage(data: imageData!)
            self.saveImage(compressedJPGImage!, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        }
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
    
    func refresh () {
        
        RECOLvector.removeAll()
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for RECOLtable in try! db!.prepare(RECOLtable) {
            RECOLvector.append(
                RECOL_struct(MreclamIndex: RECOLtable[DBReclamIndex],
                             Mreclamante: RECOLtable[DBreclamante],
                             MemailReclam: RECOLtable[DBemailReclam],
                             MdataReclam: RECOLtable[DBdataReclam],
                             MdataFab: RECOLtable[DBdataFab],
                             Mproduto: RECOLtable[DBproduto],
                             MamostraData: RECOLtable[DBamostraData],
                             MamostraFoto: RECOLtable[DBamostraFoto],
                             MamostraTexto: RECOLtable[DBamostraTexto],
                             Mcontaminado: RECOLtable[DBcontaminado],
                             Mcolaborador: RECOLtable[DBcolaborador]))
        }
        
        RECOLvector = RECOLvector.reversed()
        myTableView.reloadData()
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
