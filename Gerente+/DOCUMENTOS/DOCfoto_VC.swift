//
//  DOCfoto_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 31/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

class DOCfoto_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // TABELA DOCUMENTOS
    let DOCStable           = Table("DOCS")
    let DBdocIndex          = Expression<Int>("DBdocIndex")
    let DBdocFoto           = Expression<String>("DBdocFoto")
    let DBdocVenc           = Expression<String>("DBdocVenc")
    let DBdocData           = Expression<String>("DBdocData")
    let DBcolaborador     = Expression<String>("DBcolaborador")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var titulo: UILabel!
    var mytitle = ""
    var index   = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(DOCfoto_VC.dismissPicker))
        
        titulo.text = mytitle
        dataValidade.inputAccessoryView = toolBar

        if index < 5 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            let dateInFormat = dateFormatter.string(from: Date())
            dataValidade.text = dateInFormat
            tirarFoto.isEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // data picker
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    @IBOutlet weak var dataValidade: UITextField!
    var valid = Double(0)
    @IBAction func data_validade(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        // CALCULO VALIDADE
        datePickerView.date = Calendar.current.date(byAdding: .day, value: Int(valid), to: Date())!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dataValidade.text =  dateFormatter.string(from: datePickerView.date)
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EMP_VC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dataValidade.text = dateFormatter.string(from: sender.date)
        
        tirarFoto.isEnabled = true
    }
    // END DATE PICKER
    
    // FOTO
    var foto = false
    @IBOutlet weak var tirarFoto: UIButton!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBAction func openCameraButton(sender: UIButton) {
        
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
             let imagePicker = UIImagePickerController()
             imagePicker.videoQuality = .typeLow
             imagePicker.delegate = self
             imagePicker.sourceType = .camera;
             imagePicker.allowsEditing = false
             self.present(imagePicker, animated: true, completion: nil)
             //data = true
         }
        
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                imagePicked.image = info[.originalImage] as? UIImage
                confirma.isEnabled = true
                self.dismiss(animated: true, completion: nil)
                foto = true
            }
    
    
    @IBOutlet weak var confirma: UIButton!

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
    
    func stamp() {
        if  let image = self.imagePicked.image{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyy"
            let dateInFormat = dateFormatter.string(from: Date())
            //print(dateInFormat)
            
            let COD_CLI  = "0001"
            let COD_TAR  = "DOCS"
            let COD_PROC = ""
            let COD_ITEM = "\(index)"
            
            let myImageName = COD_CLI + COD_TAR + COD_PROC + COD_ITEM + dateInFormat + ".jpg"
            
            fotoNome = myImageName
            
            imagePath = fileInDocumentsDirectory(myImageName)
            
            let overlay = myImageName + "\n\(dateInFormat)"
            
            imagePicked.image = scale(image: image, toLessThan: 1024)
            
            let imageData = imagePicked.image!.jpegData(compressionQuality: CGFloat(compressFotos))
            
            let compressedJPGImage = UIImage(data: imageData!)
            
            let changedImage : UIImage = self.overlayText(overlay as NSString, inImage: compressedJPGImage!, atPoint: CGPoint(x: 20, y: 20))
            
            //print(compressedJPGImage?.size.width, compressedJPGImage?.size.height)
            
            self.saveImage(changedImage, path: imagePath)
            //UIImageWriteToSavedPhotosAlbum(changedImage, nil, nil, nil)
            // TROCA PARA FOLDER DO SISTEMA
            
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
        
        print("tamanho da foto: \(originalWidth) x \(originalHeight)")
        
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
    
        print("tamanho da foto: \(newWidth) x \(newHeight)")
        return copy
    }
    
    @IBOutlet weak var status: UIImageView!
    
    @IBAction func gravar(_ sender: UIButton) {
        self.status.image = nil //UIImage(named: "sign_orange")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"
        var dateInFormat = dateFormatter.string(from: Date())
        //print(dateInFormat)
        
        let COD_CLI  = "0001"
        let COD_TAR  = "DOCS"
        let COD_PROC = ""
        let COD_ITEM = "\(index)"
        
        let myImageName = COD_CLI + COD_TAR + COD_PROC + COD_ITEM + dateInFormat + ".jpg"
        fotoNome = myImageName
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        let col = 1 // colaborador logado
        
        dateFormatter.dateFormat = "dd/MM/yy"
        dateInFormat = dateFormatter.string(from: Date())
        
        let f1  = index
        let f2  = fotoNome
        let f3  = dataValidade.text
        let f4  = dateInFormat
        let f5  = String(col)
        
        let insert = DOCStable.insert(DBdocIndex      <- f1,
                                      DBdocFoto       <- f2,
                                      DBdocVenc       <- f3!,
                                      DBdocData       <- f4,
                                      DBcolaborador   <- f5)
        // DATABASE
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "Item Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.status.image = UIImage(named: "sign_green")
            
            self.stamp()
            //self.refresh()
            
        } catch {
            
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
                
                let update = self.DOCStable.filter(self.DBdocIndex == f1).update(
                             self.DBdocIndex      <- f1,
                             self.DBdocFoto       <- f2,
                             self.DBdocVenc       <- f3!,
                             self.DBdocData       <- f4,
                             self.DBcolaborador   <- f5)
                
                do{
                    _ = try db!.run(update)
                    
                    let alertController = UIAlertController(title: "AVISO", message:
                        "Registro atualizado com sucesso!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.status.image = UIImage(named: "sign_green")
                    
                    self.stamp()
                    //self.refresh()
                    
                }  catch {
                    print("insertion Principal UPDATE failed: \(error)")
                    
                    let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                        "Erro ao atualizar o registro! \nCODIGO: 010\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            actionSheetController.addAction(Overwrite)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            // alert override
            
        }
        
        self.status.image = UIImage(named: "sign_green")
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
