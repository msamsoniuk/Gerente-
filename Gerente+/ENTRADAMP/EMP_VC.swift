//
//  EMP_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 03/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite
import AVFoundation

class EMP_VC: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var MPvector  = [MP_struct]()
    var EMPvector = [EMP_struct]()
    var COLvector = [COL_struct]()
    
    // TABLE MATERIA PRIMA
    let MPtable             = Table("MP")
    let DBproduto           = Expression<String>("DBproduto")
    let DBunidade           = Expression<String>("DBunidade")
    let DBvalidade          = Expression<Double>("DBvalidade")
    let DBval_tipo          = Expression<String>("DBval_tipo")
    let DBPosNeg            = Expression<String>("DBPosNeg")
    let DBtempArmazenagem   = Expression<Double>("DBtempArmazenagem")
    let DBarmazenagem       = Expression<Int>("DBarmazenagem")
    let DBproducao          = Expression<Bool>("DBproducao")
    let DBorganico          = Expression<Bool>("DBorganico")
    let DBcodigo            = Expression<Int>("DBcodigo")
    let DBdataMP            = Expression<String>("DBdataMP")
    
    
    // TABELA COLABORADORES
    let COLtable        = Table("COL")
    let DBcolaborador   = Expression<String>("DBcolaborador")
    let DBemail         = Expression<String>("DBemail")
    //let DBcodigo        = Expression<Int>("DBcodigo")
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
    
    // TABELA ENTRADA DE MP
    let EMPtable        = Table("EMP")
   // let DBproduto         = Expression<String>("DBproduto")
    let DBquantidade      = Expression<Double>("DBquantidade")
   // let DBunidade         = Expression<String>("DBunidade")
    let DBvalor           = Expression<Double>("DBvalor")
    let DBlote            = Expression<String>("DBlote")
    let DBdataValidade    = Expression<String>("DBdataValidade")
    let DBdataEntrada     = Expression<String>("DBdataEntrada")
    let DBbarcode         = Expression<String>("DBbarcode")
    let DBnfeFoto         = Expression<String>("DBnfeFoto")
    let DBcorigemFoto     = Expression<String>("DBcorigemFoto")
    let DBsequencia       = Expression<Int>("DBsequencia")
    //let DBcodigo            = Expression<Int>("DBcodigo") // colaborador
    
    
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        for MPtable in try! db!.prepare(MPtable) {
            MPvector.append(MP_struct(AMPproduto        :String(MPtable[DBproduto]),
                                      AMPunidade        :String(MPtable[DBunidade]),
                                      AMPvalidade       :Double(MPtable[DBvalidade]),
                                      AMPval_tipo       :String(MPtable[DBval_tipo]),
                                      AMPPosNeg         :String(MPtable[DBPosNeg]),
                                      AMPtempArmazenagem:Double(MPtable[DBtempArmazenagem]),
                                      AMParmazenagem    :Int(MPtable[DBarmazenagem]),
                                      AMPproducao       :Bool(MPtable[DBproducao]),
                                      AMPorganico       :Bool(MPtable[DBorganico]),
                                      AMPcodigo         :Int(MPtable[DBcodigo]),
                                      AMPdataMP         :String(MPtable[DBdataMP])))
        }
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
                                        AMPpops:        String(COLtable[DBpops])
            ))
        }
        
        
        for EMPtable in try! db!.prepare(EMPtable) {
            EMPvector.append(EMP_struct(EMPproduto          :String(EMPtable[DBproduto]),
                                        EMPquantidade       :Double(EMPtable[DBquantidade]),
                                        EMPunidade          :String(EMPtable[DBunidade]),
                                        EMPvalor            :Double(EMPtable[DBvalor]),
                                        EMPlote             :String(EMPtable[DBlote]),
                                        EMPdataValidade     :String(EMPtable[DBdataValidade]),
                                        EMPdataEntrada      :String(EMPtable[DBdataEntrada]),
                                        EMPbarcode          :String(EMPtable[DBbarcode]),
                                        EMPnfeFoto          :String(EMPtable[DBnfeFoto]),
                                        EMPcorigemFoto      :String(EMPtable[DBcorigemFoto]),
                                        EMPsequencia        :Int(EMPtable[DBsequencia]),
                                        EMPcodigo           :Int(EMPtable[DBcodigo])))
        }
 
        EMPvector = EMPvector.reversed()
        
        
        thePicker1.delegate  = self
        thePicker1.dataSource = self
        
        // linkar campos ao Picker
        produto.inputView   = thePicker1

        // criar botao return no Picker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(EMP_VC.dismissPicker))
        produto.inputAccessoryView      = toolBar
        dataValidade.inputAccessoryView = toolBar
        
        
        //adicionar botao return ao teclado numerico
        quantidade.delegate = self
        quantidade.addDoneButtonToKeyboard(myAction:  #selector(self.quantidade.resignFirstResponder))
        
        valor.delegate = self
        valor.addDoneButtonToKeyboard(myAction:  #selector(self.valor.resignFirstResponder))
        
        lote.delegate = self
        lote.addDoneButtonToKeyboard(myAction:  #selector(self.lote.resignFirstResponder))
        
        barcode.delegate = self
        barcode.addDoneButtonToKeyboard(myAction:  #selector(self.barcode.resignFirstResponder))
        
        self.sequencia.text = ""
        
        adicionar_view.center.x = view.center.x
        adicionar_view.center.y = view.center.y + 32
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var produto: UITextField!
    @IBOutlet weak var quantidade: UITextField!
    @IBOutlet weak var unidade: UILabel!
    
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var lote: UITextField!
    @IBOutlet weak var dataValidade: UITextField!
    @IBOutlet weak var dataEntrada: UILabel!
    @IBOutlet weak var barcode: UITextField!
    @IBOutlet weak var Nfe: UIImageView!
    @IBOutlet weak var CertOrg: UIImageView!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var adicionar_view: UIView!
    @IBOutlet weak var observacoes: UITextView!
    @IBOutlet weak var sequencia: UILabel!

    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == valor {
            valor.text = valor.text?.currency
        }
        return true
    }
 
    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // END FUNCOES
    
    @IBOutlet weak var btn_fechar: UIButton!
    @IBAction func adicionar(_ sender: UIButton) {
        if adicionar_view.isHidden == true {
            adicionar_view.isHidden = false
            myTableView.isHidden = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm"
            let dateInFormat = dateFormatter.string(from: Date())
            dataEntrada.text = dateInFormat
            self.sequencia.text = ""
            btn_fechar.setImage(UIImage(named: "UP"), for: .normal )
        }
        else {
            adicionar_view.isHidden = true
            myTableView.isHidden = false
            // myTableView.reloadData()
            
            btn_fechar.setImage(UIImage(named: "adicionar"), for: .normal )
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // picker
    let thePicker1 = UIPickerView()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MPvector.count //produtos.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let MPVector: MP_struct
        MPVector = MPvector[row]
        produto.text = MPVector.AMPproduto
        unidade.text = MPVector.AMPunidade
        
        return MPVector.AMPproduto
    }
    
    @IBOutlet weak var fotoCertificado: UIButton!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let MPVector: MP_struct
        if MPvector.count > 0 {
            MPVector = MPvector[row]
            produto.text = MPVector.AMPproduto
            unidade.text = MPVector.AMPunidade
            
            valid = MPVector.AMPvalidade
            
            self.sequencia.text = ""
            
            if MPVector.AMPorganico == true {
                fotoCertificado.setImage(UIImage(named: "camera"), for: .normal )
                observacoes.text = "✓ Este item necessita também uma foto do CERTIFICADO DE ORGÂNICO\n✓ Faça uma foto da NFe/NF.\n✓ Temperatura de Amazenagem:" + MPVector.AMPPosNeg + String(MPVector.AMPtempArmazenagem)} else {
                fotoCertificado.setImage(UIImage(named: "noCamera"), for: .normal )
                observacoes.text = "✓ Faça uma foto da NFe/NF.\n✓ Temperatura de Amazenagem:" + MPVector.AMPPosNeg + String(MPVector.AMPtempArmazenagem)}
            
        } else { var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                         message: "Nenhuma Matéria Prima cadastrada!\nRetorne ao menu CADASTRO MP.",
                                         delegate: nil,
                                         cancelButtonTitle: "Fechar")
            alert.show()
            }
    }
    // end picker
    
    // DATE PICKER
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

    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dataValidade.text = dateFormatter.string(from: sender.date)
        
    }
    // END DATE PICKER
    @IBAction func Barcode(_ sender: UIButton) {
        if running {
            running = false
            videoPreviewLayer?.isHidden = true
            captureSession?.stopRunning()
        } else{
            
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            var error:NSError?
            let input: AnyObject!
            do {
                input = try AVCaptureDeviceInput(device: captureDevice!)
            } catch let error1 as NSError {
                error = error1
                input = nil
            }
            if (error != nil) {
                print("\(error?.localizedDescription)")
                return
            }

            view.endEditing(true)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            captureSession?.addInput(input as! AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = QRboundsRef.layer.bounds
            videoPreviewLayer?.borderColor = UIColor.green.cgColor
            videoPreviewLayer?.borderWidth = 10
            
            videoPreviewLayer?.position.x = view.bounds.midX
            videoPreviewLayer?.position.y = view.bounds.maxY - QRboundsRef.layer.bounds.midY - 10
            view.layer.addSublayer(videoPreviewLayer!)
            
            running = true
            captureSession?.startRunning()
        }
    }
    var running = false
    
    // QRCode reader
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    @IBOutlet var QRboundsRef: UIImageView!
    
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr,
                             AVMetadataObject.ObjectType.code128,
                             AVMetadataObject.ObjectType.code39,
                             AVMetadataObject.ObjectType.code93,
                             AVMetadataObject.ObjectType.upce,
                             AVMetadataObject.ObjectType.pdf417,
                             AVMetadataObject.ObjectType.ean13,
                             AVMetadataObject.ObjectType.aztec,
                             AVMetadataObject.ObjectType.ean8]
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //  messageLabel.text = "No QR code is detected"
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                AudioServicesPlaySystemSound(1112)
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedBarCodes.filter({ $0 == metadataObj.type }).count > 0 {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds
            if metadataObj.stringValue != nil {
                if let content = (metadataObj.stringValue){
                    let myStrings = content.components(separatedBy: CharacterSet.newlines)
                    if myStrings.count > 0 {
                        barcode.text = myStrings[0]
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        AudioServicesPlaySystemSound(1111)
                    }
                }
                videoPreviewLayer?.isHidden = true
                running = false
                captureSession?.stopRunning()
            }
        }
    }
    
    var fnfe  = false
    var fcert = false
    @IBAction func FotoNFe(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            fnfe = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func FotoCert(_ sender: UIButton) {
        fcert = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        let image = info[.originalImage] as! UIImage
        if fnfe  {Nfe.image     = image}
        if fcert {CertOrg.image = image}
        fnfe  = false
        fcert = false
        dismiss(animated:true, completion: nil)
    }
    @IBAction func limpar(_ sender: UIButton) {
        valid = 0.0
        sequencia.text      = ""
        produto.text        = ""
        quantidade.text     = ""
        unidade.text        = ""
        valor.text          = ""
        lote.text           = ""
        dataValidade.text   = ""
        dataEntrada.text    = ""
        barcode.text        = ""
        Nfe.image           = UIImage(named: "sign_orange")
        CertOrg.image       = UIImage(named: "sign_orange")
        
        status.image        = UIImage(named: "sign_orange")
        observacoes.text    = ""
        
        fotoCertificado.setImage(UIImage(named: "camera"), for: .normal )
        
    }
    @IBAction func gravar(_ sender: UIButton) {
        self.status.image = UIImage(named: "sign_orange")
       
        // criar desvio do ususario
        //if !master {
        //    self.enableSectionAlert()
        //}
        //if !master { return}
        
        let db = try? Connection("\(path)/gerente.sqlite3")
        
        var seq = 0
        
        for EMP in try! db!.prepare(EMPtable) {
            print("id: \(EMP[DBsequencia])")
            seq = EMP[DBsequencia] + 1
        }
        if sequencia.text != "" { seq = Int(sequencia.text!)! }
        
        //let seq = 1 // ultimo registro + 1
        
        let col = 1 // colaborador logado
        
        
        let COD_CLI  = "0001"
        /*
        let COD_TAR  = "DOCS"
        let COD_PROC = ""
        let COD_ITEM = "\(index)"
        let myImageName = COD_CLI + COD_TAR + COD_PROC + COD_ITEM + ".jpg"
        */
        
        let f1  = produto.text
        let f2  = Double(quantidade.text!)
        let f3  = unidade.text
        let f4  = Double(valor.text!)
        let f5  = lote.text
        let f6  = dataValidade.text
        let f7  = dataEntrada.text
        let f8  = barcode.text
        var f9  = ""
        if Nfe.image != UIImage(named: "sign_orange") {f9  = COD_CLI + "EMP_NFE" + String(seq) } //Nfe.image
        var f10 = ""
        if CertOrg.image != UIImage(named: "sign_orange") {f10  = COD_CLI + "EMP_COR" + String(seq)}  //CertOrg.image
        let f11 = seq
        let f12 = col
        
        if f1 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: PRODUTO\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        if  quantidade.text == ""{
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: QUANTIDADE\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        if f6 == "" {
            var alert = UIAlertView(title: "A.T.E.N.Ç.Ã.O",
                                    message: "O item: VALIDADE\nnão pode ficar em branco",
                                    delegate: nil,
                                    cancelButtonTitle: "Fechar")
            alert.show()
            return()
        }
        
        //print(" insert: \(f1)\n\(f2)\n\(f3)\n\(f4)\n\(f5)\n\(f6)\n\(f7)\n\(f8)\n\(f9)\n\(f10)\n\(f11)\n\(f12)")
        
        let insert = EMPtable.insert(DBproduto          <- f1!,
                                     DBquantidade       <- f2!,
                                     DBunidade           <- f3!,
                                     DBvalor             <- f4!,
                                     DBlote              <- f5!,
                                     DBdataValidade      <- f6!,
                                     DBdataEntrada       <- f7!,
                                     DBbarcode           <- f8!,
                                     DBnfeFoto           <- f9,
                                     DBcorigemFoto       <- f10,
                                     DBsequencia         <- f11,
                                     DBcodigo            <- f12)
        // DATABASE
        
        do{
            _ = try db!.run(insert)
            
            let alertController = UIAlertController(title: "AVISO", message:
                "Item Cadastrado com SUCESSO!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            self.status.image = UIImage(named: "sign_green")
            
            if f9  != "" {self.stampNFE(nome: f9)}
            if f10 != "" {self.stampORG(nome: f10)}
            
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
                
                let update = self.EMPtable .filter(self.DBsequencia == f11).update(
                    self.DBproduto          <- f1!,
                    self.DBquantidade       <- f2!,
                    self.DBunidade          <- f3!,
                    self.DBvalor            <- f4!,
                    self.DBlote             <- f5!,
                    self.DBdataValidade     <- f6!,
                    self.DBdataEntrada      <- f7!,
                    self.DBbarcode          <- f8!,
                    self.DBnfeFoto          <- f9,
                    self.DBcorigemFoto      <- f10,
                    self.DBsequencia        <- f11,
                    self.DBcodigo           <- f12)
                
                do{
                    _ = try db!.run(update)
                    
                    let alertController = UIAlertController(title: "AVISO", message:
                        "Registro atualizado com sucesso!", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.status.image = UIImage(named: "sign_green")
                    self.refresh()
                    
                }  catch {
                    print("insertion Principal UPDATE failed: \(error)")
                    
                    let alertController = UIAlertController(title: "A.T.E.N.Ç.Ã.O", message:
                        "Erro ao atualizar o registro! \nCODIGO: 003\nContacte o desenvolvedor do APP", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Fechar", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            actionSheetController.addAction(Overwrite)
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            // alert override
 
        }
        
        
        //self.status.image = UIImage(named: "sign_green")
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(EMPvector.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entMP", for: indexPath) as! EMP_TC
        
        let EMPVector: EMP_struct
        EMPVector = EMPvector[(indexPath as NSIndexPath).row]
        
        cell.user.image             = UIImage(named: "AVATAR")
        cell.produto.text           =  EMPVector.EMPproduto
        cell.quantidade.text        = String(EMPVector.EMPquantidade) + " " + EMPVector.EMPunidade
        cell.seq.text               = String(EMPVector.EMPsequencia)
        cell.dEntrada.text          = EMPVector.EMPdataEntrada
        cell.dValidade.text         = EMPVector.EMPdataValidade
        cell.lote.text              = EMPVector.EMPlote
        //cell.temp.text =
        //cell.armazenagem.text =
        //cell.prodProp.text =
        //cell.prodOrg.text =
        cell.Barcode.text = EMPVector.EMPbarcode
        //print("EMPVector.EMPcorigemFoto \(EMPVector.EMPcorigemFoto)")
        //print("EMPnfeFoto               \(EMPVector.EMPnfeFoto)")
        if EMPVector.EMPcorigemFoto != "" {cell.statusProdProp.image = UIImage(named: "sign_green")}
        if EMPVector.EMPnfeFoto     != "" {cell.statusNfe.image = UIImage(named: "sign_green")}
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("EMP item: \(indexPath.row)")
        // EDICAO DO PRODUTO
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
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
                let EMPVector: EMP_struct
                EMPVector = self.EMPvector[(indexPath as NSIndexPath).row]
                let reference = EMPVector.EMPsequencia
                
                //apagar no DB
                let db = try? Connection("\(self.path)/gerente.sqlite3")
                
                let delrecord = self.EMPtable.filter(self.DBsequencia == reference)
                
                //OBTER NUMERO DA FOTO
                
                var myImageName = EMPVector.EMPnfeFoto + ".jpg"
                var imagePath = self.fileInDocumentsDirectory(myImageName)
                if (FileManager.default.fileExists(atPath: imagePath)){
                    //print("file exist after refresh")
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print("erro removendo foto")
                    }
                }
                
                myImageName = EMPVector.EMPcorigemFoto + ".jpg"
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
            
            let EMPVector: EMP_struct
            EMPVector = self.EMPvector[(indexPath as NSIndexPath).row]
            
            self.sequencia.text     = String(EMPVector.EMPsequencia)
            
            self.produto.text       = EMPVector.EMPproduto
            self.quantidade.text    = String(EMPVector.EMPquantidade)
            self.unidade.text       = EMPVector.EMPunidade
            self.valor.text         = String(EMPVector.EMPvalor)
            self.lote.text          = EMPVector.EMPlote
            self.dataValidade.text  = EMPVector.EMPdataValidade
            self.dataEntrada.text   = EMPVector.EMPdataEntrada
            self.barcode.text       = EMPVector.EMPbarcode
            
            
            var myImageName = EMPVector.EMPnfeFoto + ".jpg"
            var imagePath = self.fileInDocumentsDirectory(myImageName)
            if (FileManager.default.fileExists(atPath: imagePath)){
                self.Nfe.image = UIImage(contentsOfFile: imagePath)}
            else {self.Nfe.image = UIImage(named: "sign_orange")}
            
            myImageName = EMPVector.EMPcorigemFoto + ".jpg"
            imagePath = self.fileInDocumentsDirectory(myImageName)
            if (FileManager.default.fileExists(atPath: imagePath)){
                self.CertOrg.image = UIImage(contentsOfFile: imagePath)}
            else {self.CertOrg.image = UIImage(named: "sign_orange")}
            
        }
        
        edit.backgroundColor = UIColor.blue
        return [delete,edit]
    }
    
    func refresh(){
        self.EMPvector.removeAll()
        // DATABASE
        let db = try? Connection("\(path)/gerente.sqlite3")
        for EMPtable in try! db!.prepare(EMPtable) {
            EMPvector.append(EMP_struct(EMPproduto          :String(EMPtable[DBproduto]),
                                        EMPquantidade       :Double(EMPtable[DBquantidade]),
                                        EMPunidade          :String(EMPtable[DBunidade]),
                                        EMPvalor            :Double(EMPtable[DBvalor]),
                                        EMPlote             :String(EMPtable[DBlote]),
                                        EMPdataValidade     :String(EMPtable[DBdataValidade]),
                                        EMPdataEntrada      :String(EMPtable[DBdataEntrada]),
                                        EMPbarcode          :String(EMPtable[DBbarcode]),
                                        EMPnfeFoto          :String(EMPtable[DBnfeFoto]),
                                        EMPcorigemFoto      :String(EMPtable[DBcorigemFoto]),
                                        EMPsequencia        :Int(EMPtable[DBsequencia]),
                                        EMPcodigo           :Int(EMPtable[DBcodigo])))
        }
        
        EMPvector = EMPvector.reversed()
        myTableView.reloadData()
    }
    
    // SALVAR FOTOS
    var imagePath = ""
    
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
    
    func stampORG(nome: String) {
        if  let image = self.CertOrg.image{
            let myImageName = nome + ".jpg"
            imagePath = fileInDocumentsDirectory(myImageName)
            CertOrg.image = scale(image: image, toLessThan: 1024)
            let imageData = CertOrg.image!.jpegData(compressionQuality: CGFloat(compressFotos))
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
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
