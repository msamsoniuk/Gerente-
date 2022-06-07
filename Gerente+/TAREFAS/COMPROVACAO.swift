//
//  COMPROVACAO.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 20/09/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite

var TextoComprovacao = ""

class COMPROVACAO: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // TABELA STATUS
    let STATtable           = Table("STAT")
    let DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")
    
    
    @IBOutlet weak var tarefa: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var reference: UILabel!
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    var mytitle  = ""
    var mytarefa = ""
    var linha   = 0
    
    var FotoNC = false
    var TextNC = false
    var FotoC  = false
    var TextC  = false
    
    var foto     = false
    var ref      = 0
    var fotoNome = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tarefa.text = "" + mytitle + ""
        item.text   = mytarefa
        //titulo.text = mytitle
        reference.text = "\(C)\(D)\(U)"
        
        //let teste = "\(C)\(D)\(U)"
        
        if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
            
            if Matrix[index].NCF == 1 {FotoNC = true} else {FotoNC = false}
            if Matrix[index].NCT == 1 {TextNC = true} else {TextNC = false}
            if Matrix[index].CF  == 1 {FotoC  = true} else {FotoC  = false}
            if Matrix[index].CT  == 1 {TextC  = true} else {TextC  = false}
            
            TextoComprovacao      = String(describing: Matrix[index].txt)
            fotoNome              = String(describing: Matrix[index].foto)
            
            if Matrix[index].foto == "" {
                foto = false
            } else {foto = true} //fotoNome
            
            if Matrix[index].txt == "" {
                texto = false
            } else {texto = true}//TextoComprovacao
            
            self.conforme.selectedSegmentIndex = Matrix[index].mS
            ref = index
        }
        
        switch conforme.selectedSegmentIndex {
        case 0:
            conforme.tintColor = UIColor.black
            foto     = false
            texto    = false
            break;
        case 1:
            conforme.tintColor = UIColor.red
            // CHECAR NA TABELA SE ITEM NECESSITA JUSTIFICATIVA
            box.isHidden           = false
            
            if FotoNC {
                comp_foto.isHidden     = false
                stat1.isHidden         = false
                photo_icon.isHidden    = false
                imagePicked.isHidden   = false
            } //else { imagePicked.image = nil }
            if TextNC {
                comp_esc.isHidden      = false
                stat2.isHidden         = false
                write_icon.isHidden    = false
                textPicked.isHidden    = false
            } //else { comp_esc.text = ""}
            break;
        case 2:
            // CHECAR NA TABELA SE ITEM NECESSITA JUSTIFICATIVA
            box.isHidden           = false
            
            if FotoC {
                comp_foto.isHidden     = false
                stat1.isHidden         = false
                photo_icon.isHidden    = false
                imagePicked.isHidden   = false
            }  //else { imagePicked.image = nil }
            if TextC {
                comp_esc.isHidden      = false
                stat2.isHidden         = false
                write_icon.isHidden    = false
                textPicked.isHidden    = false
            } //else { comp_esc.text = ""}
            
            conforme.tintColor = UIColor(red:0.2, green:0.7, blue:0.2, alpha:1.0)
            //flag = true
            break;
        default:
            break;
        }

        centerView.center.x = view.center.x
        centerView.center.y = view.center.y + 32
 
    }
    
    @IBOutlet weak var centerView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        if texto {
            textPicked.image = UIImage(named: "document_text")
            stat2.image = UIImage(named: "sign_green")
        }
        
        if foto {
            stat1.image = UIImage(named: "sign_green")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Platform {
        
        static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0
        }
        
    }
    
    @IBAction func bntDone(_ sender: UIButton) {
        var naoOK = false

        if Platform.isSimulator {
            print("Running on Simulator")
            foto = true
            texto = true
            FotoC = true
            FotoNC = true
            fotoNome = "simulado.jpg"
            TextoComprovacao = "simulador - receita ok"
        }
        
        
        if FotoNC && !foto  && conforme.selectedSegmentIndex == 1 { naoOK = true
            //print("1")
        }
        if TextNC && !texto && conforme.selectedSegmentIndex == 1 { naoOK = true
            //print("2")
        }
        if FotoC  && !foto  && conforme.selectedSegmentIndex == 2 { naoOK = true
            //print("3")
        }
        if TextC  && !texto && conforme.selectedSegmentIndex == 2 { naoOK = true
            //print("4")
        }
        
        if naoOK {
            if conforme.selectedSegmentIndex != 0 {
                var alert = UIAlertView(title: "OPS!!!!!",
                                        message: "Voce deve complementar conforme a exigencia desse item.\n\nCaso nao possa escrever a justifica ou fotografar agora, retorne o status para zero",
                                        delegate: nil,
                                        cancelButtonTitle: "Fechar")
                alert.show()
                return
            }
         }
        
        /*
        if AnyInt(Matrix[ref][3]) == 2 {
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message: "Este item já foi\nindicado como CONFORME.\nGostaria de modifica?", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Retornar", style: .cancel) { action -> Void in
                
                self.dismiss(animated: false, completion: nil)
                //return
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let Overwrite: UIAlertAction = UIAlertAction(title: "MODIFICAR", style: .default) { action -> Void in
                print("continuar e modificar")
            }
            actionSheetController.addAction(Overwrite)
            self.present(actionSheetController, animated: true, completion: nil)
        }
        */
        
      //  Matrix[ref][3]  = 0
      //Matrix[ref][4]  = ""
      //  Matrix[ref][5]  = ""
      //  Matrix[ref][6]  = ""
      //  Matrix[ref][7]  = ""
      //  Matrix[ref][8]  = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let HOJE = dateFormatter.string(from: Date())
        /*
        if let index = Matrix.index(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
            Matrix[index].mS     = 1
            Matrix[index].foto   = fotoNome
            Matrix[index].dF     = HOJE
        }
        */
        if FotoNC && foto  && conforme.selectedSegmentIndex == 1 {
          //  Matrix[ref][3]  = 1
          //  Matrix[ref][5]  = fotoNome
          //  Matrix[ref][7] = HOJE //String(describing: Date())
            
            if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
                Matrix[index].mS     = 1
                Matrix[index].foto   = fotoNome
                Matrix[index].dF     = HOJE
            }
        }
        if TextNC && texto && conforme.selectedSegmentIndex == 1 {
           // Matrix[ref][3] = 1
           // Matrix[ref][6] = TextoComprovacao
           // Matrix[ref][8] = HOJE //String(describing: Date())
            
            if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
                Matrix[index].mS     = 1
                Matrix[index].txt   = TextoComprovacao
                //Matrix[index].dT     = HOJE
            }
        }
        if FotoC  && foto  && conforme.selectedSegmentIndex == 2 {
            //Matrix[ref][3] = 2
            //Matrix[ref][5] = fotoNome
            //Matrix[ref][7] = HOJE //String(describing: Date())
            
            if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
                Matrix[index].mS     = 2
                Matrix[index].foto   = fotoNome
                Matrix[index].dF     = HOJE
            }
        }
        if TextC  && texto && conforme.selectedSegmentIndex == 2 {
            //Matrix[ref][3] = 2
            //Matrix[ref][6] = TextoComprovacao
            //Matrix[ref][8] = HOJE //String(describing: Date())
            
            if let index = Matrix.firstIndex(where: { $0.mC == C && $0.mD == D && $0.mU == U}) {
                Matrix[index].mS     = 2
                Matrix[index].foto   = TextoComprovacao
                //Matrix[index].dT     = HOJE
            }
        }

        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/yy"
        //let HOJE = dateFormatter.string(from: Date())
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        /*
        for _ in try! db!.prepare(STATtable.filter(DBStatusData == HOJE)) {
            print("have one")
            //return
        }
        */
        
        // JSON
        var jsonString = ""
        do {
            //encode
            let jsonData = try JSONEncoder().encode(Matrix)
            jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            
            //decode
            //let OldMatrix = try JSONDecoder().decode([line].self, from: string)//jsonData)
            //print(OldMatrix)
        } catch { print(error) }
        
        let update = STATtable.filter(self.DBStatusData == HOJE).update(
                                      DBVector <- "", //String(describing: Matrix),
                                      //DBStatusData <- HOJE,
                                      //DBProducao <- "0",
                                      //DBVector <- String(describing: Matrix)//
                                      DBflag   <- jsonString)
        do{
            _ = try db!.run(update)
            print("update STATUS DB OK")
            /*
             for STATtable in try! db!.prepare(STATtable){
             STATvector.append(Status_struct(
             MStatusData: String(STATtable[DBStatusData]),
             MProducao: String(STATtable[DBProducao]),
             MVector: String(STATtable[DBVector]),
             Mflag: String(STATtable[DBflag])))
             }
             */
            
        } catch {
            print("falha no update STATUS DB: \(error)")
        }
        
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var conforme: UISegmentedControl!
    @IBAction func DoYesNo(_ sender: UISegmentedControl) {
        
        foto = false
        
        box.isHidden = true
        
        comp_esc.isHidden    = true
        comp_foto.isHidden   = true
        write_icon.isHidden  = true
        photo_icon.isHidden  = true
        write_icon.isHidden  = true
        photo_icon.isHidden  = true
        imagePicked.isHidden = true
        textPicked.isHidden  = true
        stat1.isHidden       = true
        stat2.isHidden       = true

        switch conforme.selectedSegmentIndex {
        case 0:
            conforme.tintColor = UIColor.black
            foto     = false
            texto    = false
            break;
        case 1:
            conforme.tintColor = UIColor.red
            // CHECAR NA TABELA SE ITEM NECESSITA JUSTIFICATIVA
            box.isHidden           = false
            
            if FotoNC {
                comp_foto.isHidden     = false
                stat1.isHidden         = false
                photo_icon.isHidden    = false
                imagePicked.isHidden   = false
            }
            if TextNC {
                comp_esc.isHidden      = false
                stat2.isHidden         = false
                write_icon.isHidden    = false
                textPicked.isHidden    = false
            }
            break;
        case 2:
            // CHECAR NA TABELA SE ITEM NECESSITA JUSTIFICATIVA
            box.isHidden           = false
            
            if FotoC {
                comp_foto.isHidden     = false
                stat1.isHidden         = false
                photo_icon.isHidden    = false
                imagePicked.isHidden   = false
            }
            if TextC {
                comp_esc.isHidden      = false
                stat2.isHidden         = false
                write_icon.isHidden    = false
                textPicked.isHidden    = false
            }
            
            conforme.tintColor = UIColor(red:0.2, green:0.7, blue:0.2, alpha:1.0)
            //flag = true
            break;
        default:
            break;
        }
    }

    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textPicked: UIImageView!
    
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
             */
            //data = true
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    imagePicked.image = info[.originalImage] as? UIImage
                    stat1.image = UIImage(named: "sign_green")
                    self.stamp()
                    foto = true
                    dismiss(animated:true, completion: nil)
                }
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[.editedImage] as! UIImage
        imagePicked.image = image
        stat1.image = UIImage(named: "sign_green")
        self.stamp()
        foto = true
        dismiss(animated:true, completion: nil)
    }
    */
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var stat1: UIImageView!
    @IBOutlet weak var stat2: UIImageView!
    @IBOutlet weak var comp_esc: UILabel!
    @IBOutlet weak var comp_foto: UILabel!
    @IBOutlet weak var write_icon: UIButton!
    @IBOutlet weak var photo_icon: UIButton!
    
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    var imagePath = ""
    
    func stamp() {
        if  let image = self.imagePicked.image{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyy"
            let dateInFormat = dateFormatter.string(from: Date())
            print(dateInFormat)
            
            let COD_CLI  = "0001"
            let COD_TAR  = "\(C)"
            let COD_PROC = "\(D)"
            let COD_ITEM = "\(U)"
            
            let myImageName = COD_CLI + COD_TAR + COD_PROC + COD_ITEM + dateInFormat + ".jpg"
            
            fotoNome = myImageName
            
            imagePath = fileInDocumentsDirectory(myImageName)
            
            let overlay = myImageName + "\n\(dateInFormat) \n\(compressFotos)"
            
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
