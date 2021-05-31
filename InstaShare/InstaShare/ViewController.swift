//
//  ViewController.swift
//  InstaShare
//
//  Created by Dogus Yigit Ozcelik on 31.05.2021.
//

import UIKit

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    private var documentInteractionController = UIDocumentInteractionController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sharePhotoAsStory(_ sender: Any) {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = UIImage(named: "photo.jpg") else { return }
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Sorry the application is not installed")
            }
        }
    }
    
    @IBAction func shareVideoAsStory(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "vid", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        do {
            let video = try Data(contentsOf: URL(fileURLWithPath: path))
            if let storiesUrl = URL(string: "instagram-stories://share") {
                if UIApplication.shared.canOpenURL(storiesUrl) {
                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.backgroundVideo": video,
                        "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                        "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                    ]
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                    ]
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Sorry the application is not installed")
                }
            }
        } catch {
           print(error)
           return
        }
    }
    
    @IBAction func sharePhotoAsFeed(_ sender: Any) {
        guard let imageInstagram = UIImage(named: "photo.jpg") else { return }
        let instagramURL = NSURL(string: "instagram://")
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            do {
            try imageInstagram.jpegData(compressionQuality: 0.75)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                print(error)
                return
            }

            let rect = CGRect.zero
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            
            documentInteractionController = UIDocumentInteractionController()
            
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = "com.instagram.exclusivegram"
            
            documentInteractionController.presentOpenInMenu(from: rect, in: self.view, animated: true)
        }
        else {
            print("Sorry the application is not installed")
        }
    }
    
    @IBAction func shareVideoAsFeed(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "vid", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let rect = CGRect.zero
        let fileURL = NSURL.fileURL(withPath: path)

        documentInteractionController = UIDocumentInteractionController()

        documentInteractionController.url = fileURL
        documentInteractionController.delegate = self
        documentInteractionController.uti = "com.instagram.exclusivegram"
        
        documentInteractionController.presentOpenInMenu(from: rect, in: self.view, animated: true)
    }
}

