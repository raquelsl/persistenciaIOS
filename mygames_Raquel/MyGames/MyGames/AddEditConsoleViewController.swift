//
//  AddEditConsoleViewController.swift
//  MyGames
//
//  Created by aluno on 16/05/21.
//  Copyright © 2021 raquel. All rights reserved.
//

import UIKit

import Photos

class AddEditConsoleViewController: UIViewController {
    var console: Console?
     
     @IBOutlet weak var tfName: UITextField!
     @IBOutlet weak var ivCover: UIImageView!
     
     @IBOutlet weak var btAddImagem: UIButton!
     @IBOutlet weak var btAddEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataLayout()
    }
    
    ///
    /// - returns irá setar os dados do console caso a tela seja aberta em modo de ediçao
    func prepareDataLayout() {
        if console != nil {
            title = "Editar console"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfName.text = console?.name
          
            ivCover.image = console?.cover as? UIImage
        }
        
        if console?.cover != nil {
            btAddImagem.setTitle(nil, for: .normal)
        }
    }
    
    
    /// action para montar e apresentar alert com opcoes de escolha da imagem do console
    @IBAction func addImageConsole(_ sender: Any) {
        let alert = UIAlertController(title: "Selecinar console", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    /// Metodo para abrir as fotos e requerir autorizacao do usuario
    /// - warning para este metodo funcionar é preciso setar as permissoes de 'Privacy - Media Library Usage Description' e 'Privacy - Photo Library Usage Description' no info.plist
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    /// Metodo para apresentar galeria e captar a escolha da imagem
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    /// Metodo para salvar o novo console ou edicoes de um já existente
    @IBAction func saveConsole(_ sender: Any) {
        
        if console == nil {
          console = Console(context: context)
        }
        console?.name = tfName.text
        console?.cover = ivCover.image
        
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            DispatchQueue.main.async {
                self.ivCover.image = pickedImage
                self.ivCover.setNeedsDisplay()
                self.btAddImagem.setTitle(nil, for: .normal)
                self.btAddImagem.setNeedsDisplay()
            }
        }
       
        dismiss(animated: true, completion: nil)
       
    }
   
}
