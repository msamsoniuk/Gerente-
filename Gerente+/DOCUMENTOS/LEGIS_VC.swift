//
//  LEGIS_VC.swift
//  Gerente+
//
//  Created by Marcos Samsoniuk on 20/11/18.
//  Copyright © 2018 Marcos Samsoniuk. All rights reserved.
//

import UIKit
import Zip

class LEGIS_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // samples
        
        let DB   = fileInDocumentsDirectory("legis/LEGIS(1).pdf")
        
        // check exist
        if !(FileManager.default.fileExists(atPath: DB))
        {
            // UNzipping
            do {
                let filePath = Bundle.main.url(forResource: "legis", withExtension: "zip")!
                _ = try Zip.quickUnzipFile(filePath) // Unzip
                
            }
            catch {
                print("Something went wrong")
            }
        } else {print("no pdf")}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let list = [["RESOLUÇÃO SESA no 004/2017","rev 1.0a"],
                ["RESOLUÇÃO DE DIRETORIA COLEGIADA – RDC No 275, DE 21 DE OUTUBRO DE 2002 (*)","rev 1.0a"],
                ["Instrução Normativa MAPA No 16 DE 23/06/2015","rev 1.0a"],
                [" Instrução Normativa no 5 de 14/02/2017 / MAPA","rev 1.0a"]]
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "POPS", for: indexPath) as! POPS_TC
        
        let index = indexPath.row
        
        cell.pop.text = String(list[index][0])
        cell.revisao.text = String(list[index][1])
        cell.sequencia.text  = ("LEGIS: \(index + 1)/\(list.count)")
        
        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = getDocumentsURL().appendingPathComponent("legis/LEGIS(\(indexPath.row+1)).pdf")
        
        interactionController = UIDocumentInteractionController(url: data)
        interactionController!.uti = "com.adobe.pdf "
        interactionController!.presentOpenInMenu(from: CGRect.zero,in: view, animated:false)
        

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
    
    func unzipping (filename: String) {
        let source = fileInDocumentsDirectory("legis/" + filename)
        let target = fileInDocumentsDirectory(filename)
        let filemgr = FileManager.default
        do {
            try filemgr.copyItem(atPath: source, toPath: target)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteFilesInDirectory(_ url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
}
