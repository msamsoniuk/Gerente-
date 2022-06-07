//
//  REPORT_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 25/10/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import SQLite
import PDFGenerator
import CoreBluetooth
import MessageUI // email

var interactionController: UIDocumentInteractionController?

class REPORT_VC: UIViewController , UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate, MFMailComposeViewControllerDelegate {
    
    // TABELA STATUS
    let STATtable           = Table("STAT")
    let DBStatusData        = Expression<String>("DBStatusData")
    let DBProducao          = Expression<String>("DBProducao")
    let DBVector            = Expression<String>("DBVector")
    let DBflag              = Expression<String>("DBflag")
    
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    var HOJE = ""
    
    var REPOMatrix = Matrix
    var REPOTarefa = [itens]()
    
    var manager: CBCentralManager!
    var printer: CBPeripheral!
    var charact: CBCharacteristic!
    var CVS = false
    
    @IBOutlet weak var BLEbutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        REPOTarefa = tarefas.filter {$0.ativo == 1}
    
        if !CVS {
            manager = CBCentralManager.init(delegate: self, queue: nil)
            //BLEbutton.tintColor = UIColor.blue
        } else {
            //BLEbutton.tintColor = UIColor.red
        }

        let db = try? Connection("\(path)/gerente.sqlite3")
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/yy"
        //HOJE = dateFormatter.string(from: Date())
        
        tit3.text = HOJE
        
        for STATtable in try! db!.prepare(STATtable){
            STATvector.append(Status_struct(
                MStatusData: String(STATtable[DBStatusData]),
                MProducao: String(STATtable[DBProducao]),
                MVector: String(STATtable[DBVector]),
                Mflag: String(STATtable[DBflag])))
        }
        
        var STATVector : Status_struct
        
        if STATvector.count <= 0 { return}
        
        for i in 0...STATvector.count - 1 {
            STATVector = STATvector[i]
            if STATVector.MStatusData == HOJE {
                print("data report ok")
                //json
                if STATVector.Mflag != "" {
                    let string = (STATVector.Mflag).data(using: .utf8)!
                    do {
                        //decode
                        REPOMatrix = try JSONDecoder().decode([line].self, from: string)
                    } catch { print(error) }
                    
                } // mflag
                // json
            }
        }
        //Matrix = Matrix.reversed()
        self.myTableView.tableHeaderView = tableheader
        self.myTableView.tableFooterView = botton
        // self.runPDF()
        
        let page1 = PDFPage.view(self.myTableView)//v1)
        let pages = [page1]
        
        let dst = NSTemporaryDirectory().appending("listagem.pdf")
        do {
            try PDFGenerator.generate(pages, to: dst)
        } catch (let e) {
            print(e)
        }
        
    }

    @IBAction func goReport(_ sender: UIButton) {
        self.runPDF()
        //print(BLEmtx)
    }
    
    @IBAction func GoBLE(_ sender: UIButton) {
        //manager = CBCentralManager.init(delegate: self, queue: nil)
        self.RunBLE()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var STATvector = [Status_struct]()
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableheader: UIView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return REPOTarefa.count  //return(Matrix.count)
    }
    
    var BLEmtx      = [""]

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "REPORT", for: indexPath) as! REPORT_TC
        
        let index = (indexPath as NSIndexPath).row
        
        var BLEcod      = ""
        var BLEstatus   = ""
        var BLEfoto     = "."
        var BLEtexto    = "."
        var BLEdias     = ""
        
        let c = REPOTarefa[index].mC
        let d = REPOTarefa[index].mD
        let u = REPOTarefa[index].mU
        
        let cod = "\(c)\(d)\(u)"
        BLEcod  = "\(c)\(d)\(u)"
        cell.codigo.text = cod
        
        cell.item.text = REPOTarefa[index].item
        //cell.tarefa.text = ""
        
        if  u == 0 {
            cell.codigo.text          = ""
            cell.DiasVencer.text      = ""
            cell.foto.isHidden        = true
            cell.escrito.isHidden     = true
            cell.status.image         = nil
            cell.NCouC.text           = ""
            cell.colaborador.image    = nil
            cell.item.frame.origin.x  = 3
        }
        
        if let i = REPOMatrix.firstIndex(where: { $0.mC == c &&
                                             $0.mD == d &&
                                             $0.mU == u}) {
            
            let status =  REPOMatrix[i].mS
            
            if status == 2 {
                cell.NCouC.text = "C"
                cell.status.image = UIImage(named: "sign_green")}
            BLEstatus = " C "
            
            if status == 1 {
                cell.NCouC.text = "NC"
                BLEstatus   = "N/C"
                if REPOMatrix[i].foto == "" || REPOMatrix[i].txt == "" {
                    cell.status.image = UIImage(named: "sign_half")
                    //BLEstatus   = "nV"
                } else {
                    cell.status.image = UIImage(named: "sign_red")
                    //BLEstatus   = "NC"
                }
            }
            if REPOMatrix[i].foto != "" {
                cell.foto.isHidden = false
                BLEfoto     = "F"
            }
            if REPOMatrix[i].txt != "" {
                cell.escrito.isHidden = false
                BLEtexto    = "T"
            }
            
            cell.DiasVencer.text = ""
            
            var days = 0
            if REPOMatrix[i].mC == 1 {
                switch REPOMatrix[i].mP {
                case 0:
                    days = 0 // " [D]"
                case 1:
                    days = 0 // " [P]"
                case 2:
                    days = 7 // " [S]"
                case 3:
                    days = 15 // " [Q]"
                case 4:
                    days = 30 // " [M]"
                case 5:
                    days = 180 // " [6]"
                case 6:
                    days = 365 // " [A]"
                default:
                    break
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yy"
                //print("data do DB: \(Matrix[index].dF)")
                let secondDate = formatter.date(from: REPOMatrix[i].dF)
                let firstDate  = formatter.date(from: HOJE)
                if secondDate != nil {
                    let components = Calendar.current.dateComponents([.day], from: secondDate!, to: firstDate!) //Date())
                    var totalDias = 0
                    print("components: \(components)")
                    if components.day != nil {totalDias = days - components.day!}
                    //print("dias vencidos: \(totalDias)")
                    cell.DiasVencer.text = "\(totalDias)"
                    BLEdias     = "dias rest: \(totalDias)"
                }  else { cell.DiasVencer.text = "" }
            }
            
            if status == 0  {BLEstatus   = "s/p"}
            BLEmtx.append("\(BLEcod) :\(BLEstatus) :\(BLEfoto) :\(BLEtexto): \(BLEdias)")
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

    @IBAction func bntDone(_ sender: UIButton) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet weak var tit1: UILabel!
    @IBOutlet weak var tit2: UILabel!
    @IBOutlet weak var tit3: UILabel!
    @IBOutlet weak var botton: UIView!
    
    
    var interactionController: UIDocumentInteractionController?
    
    func runPDF() {

        let dst = NSTemporaryDirectory().appending("listagem.pdf")

        interactionController = UIDocumentInteractionController(url: NSURL(fileURLWithPath:dst) as URL)
        
        interactionController!.uti = "com.adobe.pdf "
        interactionController!.presentOpenInMenu(from: CGRect.zero,in: view, animated:false)
        
    }
    
    
    func convertPDFPageToImage(page:Int) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("pathLocation").path
        
        do {
            
            let pdfdata = try NSData(contentsOfFile: filePath, options: NSData.ReadingOptions.init(rawValue: 0))
            
            let pdfData = pdfdata as CFData
            let provider:CGDataProvider = CGDataProvider(data: pdfData)!
            let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
            let pageCount = pdfDoc.numberOfPages;
            let pdfPage:CGPDFPage = pdfDoc.page(at: page)!
            var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
            
            //print("\(pageRect.width) by \(pageRect.height)")
            
            UIGraphicsBeginImageContext(pageRect.size)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            //self.imageView.image = pdfImage
            
        }
        catch {
            
        }
        
    }

    
    func RunBLE () {
        if self.charact != nil {

            print("BLE conectada")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy HH:mm"
            
            let date    = String(dateFormatter.string(from: Date())) as String
            let app     = "GERENTE+"
            
            var msg = "\(app) \(date)\nRef: \(HOJE)\n"
            var txt = msg.data(using: .utf8)!
            self.printer.writeValue(txt , for: charact, type: CBCharacteristicWriteType.withoutResponse)
            
            var str = "CLIENTE: 0001\nRelatorio TAREFAS" // CLIENTE
            var trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
            
            msg = trimmed
            if msg != "" {
                msg.append("\n")
                txt = msg.data(using: .utf8)!
                self.printer.writeValue(txt , for: charact, type: CBCharacteristicWriteType.withoutResponse)
            }
            
            msg = "===============================\n"
            txt = msg.data(using: .utf8)!
            self.printer.writeValue(txt , for: charact, type: CBCharacteristicWriteType.withoutResponse)
            // CORPO RELATORIO
            
            for i in 1...BLEmtx.count-1 {
                msg = "\(BLEmtx[i])\n"
                txt = msg.data(using: .utf8)!
                self.printer.writeValue(txt, for: charact, type: CBCharacteristicWriteType.withoutResponse)
            }
            
            // FIM 3 LINHAS DE AVANCO
            msg = "===============================\n\n\n\n\n\n\n\n\n------------------------------\n assinatura do produtor \n"
            txt = msg.data(using: .utf8)!
            self.printer.writeValue(txt , for: charact, type: CBCharacteristicWriteType.withoutResponse)
            
            msg = "------------------------------\n\n\n"
            txt = msg.data(using: .utf8)!
            self.printer.writeValue(txt , for: charact, type: CBCharacteristicWriteType.withoutResponse)
        }
    }

    // BLE
    
    var MBLEname  = ""
    var BLEChar  =  ""
    var MBLEserv  = ""
    var MBLEcode  = ""
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let defaults = UserDefaults.standard
        
        let BLED = defaults.string(forKey: "BLEname")
        if BLED != nil {
            MBLEname = BLED!
        } else {MBLEname = "NP100S51CE"}
        
        //MBLEname = "NP100S51CE"
        
        /*
         BLED = defaults.string(forKey: "WiFiChar")
         if BLED != nil {
         BLEChar = BLED!
         } else {BLEChar = "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"}
         
         BLED = defaults.string(forKey: "WiFiBserv")
         if BLED != nil {
         MBLEserv = BLED!
         } else {MBLEserv = "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"}
         BLED = defaults.string(forKey: "WiFicode")
         if BLED != nil {
         MBLEcode = BLED!
         } else {MBLEcode = "18F0"}
         
         print("MBLEname \(MBLEname)")
         print("BLEChar \(BLEChar)")
         print("MBLEserv \(MBLEserv)")
         print("MBLEcode \(MBLEcode)")
         
         */
        
        
        //print("Name= \(peripheral.name)")
        let nameofBLE = peripheral.name
        print("Name= \(nameofBLE?.trimmingCharacters(in: .whitespacesAndNewlines))")
        
        if(nameofBLE?.trimmingCharacters(in: .whitespacesAndNewlines) == MBLEname) //"NP100S3233"
        {
            print("step 1")
            self.printer = peripheral
            self.printer.delegate = self
            manager.stopScan()
            manager.connect(self.printer, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services as [CBService]?
        {
            for i in services
            {
                print("service=\(i)")
                if i.uuid.uuidString == "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"
                {
                    print("service found")
                    peripheral.discoverCharacteristics(nil, for: i)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("1st step")
        print(service.characteristics)
        if let carac = service.characteristics as [CBCharacteristic]?
        {
            for x in carac
            {
                print("Carac=\(x.uuid.uuidString)")
                if x.uuid.uuidString == "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F" {
                    print("characteristics FOUND")
                    charact = x
                    //let msg = "printer FOUND"
                    // printer.writeValue(msg.data(using: .utf8)!, for: c, type: CBCharacteristicWriteType.withoutResponse)
                    //printStatus.backgroundColor = UIColor.blue
                } else { //printStatus.backgroundColor = UIColor.red
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid.uuidString == "18F0"{
            let value =  characteristic.value!
            print ("new value = \(String(describing: value))")
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var msg = ""
        switch central.state {
        case .poweredOff:
            msg = "BLE OFF"
        case .poweredOn:
            msg = "BLE ON"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "No supported BLE"
        case .resetting:
            msg = "reseting"
        default:
            msg = "unknow error"
        }
        print ("status: \(msg)")
    }
    // BLE
    
    // email
    func sendmail() {

        let dst = NSTemporaryDirectory().appending("listagem.pdf")

        // ------ PDF done
        
        let picker = MFMailComposeViewController()
        
        picker.mailComposeDelegate = self //as MFMailComposeViewControllerDelegate
        
        picker.setSubject("Relatório Tarefas e Controles: " + tit3.text!)
        
        var Text = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        Text = "Relatório gerado em: " + dateInFormat + " usando GERENTE+"
        
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: dst)) {
            picker.addAttachmentData(fileData,  mimeType: "application/pdf", fileName: "listagem.pdf")
            
        }
        
        picker.setToRecipients(["email@responsavel.com"])
        
        picker.setMessageBody(Text, isHTML: true)
        
        // checking mail run
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        // checking mail service
        
        present(picker, animated: true, completion: nil)
        
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // email
    @IBAction func email(_ sender: UIButton) {
        self.sendmail()
    }
    
}
