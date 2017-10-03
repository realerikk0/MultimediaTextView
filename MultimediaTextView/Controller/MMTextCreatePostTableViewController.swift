//
//  MMTextCreatePostTableViewController.swift
//  MultimediaTextView
//
//  Created by Eric on 10/2/17.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class MMTextCreatePostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var content: [MMTextContent] = []
    
    /**
      Generate and present an alert view with single button.
     - parameters:
         - alertTitle : the title of the alert view
         - alertMsg : the message of the alert view
         - buttonTitle : the title of the button
         - buttonStyle : the style of the button
     */
    func singleButtonAlert(alertTitle: String, alertMsg: String, buttonTitle: String, buttonStyle: UIAlertActionStyle) {
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: buttonStyle, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addAsset() {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Take a picture from one of the following sources...", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.cameraCaptureMode = .photo
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.singleButtonAlert(alertTitle: "Camera is not allowed", alertMsg: "ERROR: Camera is not available!", buttonTitle: "OK", buttonStyle: .cancel)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Record a video", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.cameraCaptureMode = .video
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.singleButtonAlert(alertTitle: "Camera is not allowed", alertMsg: "ERROR: Camera is not available!", buttonTitle: "OK", buttonStyle: .cancel)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.singleButtonAlert(alertTitle: "Photo Library is not allowed", alertMsg: "ERROR: Photo Library is not available!", buttonTitle: "OK", buttonStyle: .cancel)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New post"
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAsset)),self.editButtonItem]
        
        content.append(MMTextContent(placeholder: true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postContentCell", for: indexPath) as! MMTextCreatePostTableViewCell
        //let cell = MMTextCreatePostTableViewCell()
        
        print("cell: row: \(indexPath.row)")
        
        cell.delegate = self
        cell.tblViewCellId = indexPath.row

        if content[indexPath.row].contentType == .placeholder {
            cell.addTextButton.isOpaque = true
            cell.addTextButton.isHidden = false
            cell.attributedTextView.isHidden = true
            cell.stillImageView.isHidden = true
            cell.animatedImageView.isHidden = true
            cell.livePhotoView.isHidden = true
        }else if content[indexPath.row].contentType == .attributedText {
            
            cell.addTextButton.isHidden = true
            cell.attributedTextView.isHidden = false
            cell.stillImageView.isHidden = true
            cell.animatedImageView.isHidden = true
            cell.livePhotoView.isHidden = true
            
            if let str = content[indexPath.row].MMString {
                cell.attributedTextView.attributedText = str
            }
        }else if content[indexPath.row].contentType == .stillImage {
            
            cell.addTextButton.isHidden = true
            cell.attributedTextView.isHidden = true
            cell.stillImageView.isHidden = false
            cell.animatedImageView.isHidden = true
            cell.livePhotoView.isHidden = true
            
            if let imageAsset = content[indexPath.row].MMAsset {
                if imageAsset.playbackStyle == .image {
                    updateStillImage(cell: cell, assets: imageAsset)
                }
            }
        }else if content[indexPath.row].contentType == .livePhoto {
            
            cell.addTextButton.isHidden = true
            cell.attributedTextView.isHidden = true
            cell.stillImageView.isHidden = true
            cell.animatedImageView.isHidden = true
            cell.livePhotoView.isHidden = false
            
            if let livePhotoAsset = content[indexPath.row].MMAsset {
                if livePhotoAsset.playbackStyle == .image {
                    updateLivePhoto(cell: cell, assets: livePhotoAsset)
                }
            }
        }else if content[indexPath.row].contentType == .animatedImage {
            
            cell.addTextButton.isHidden = true
            cell.attributedTextView.isHidden = true
            cell.stillImageView.isHidden = true
            cell.animatedImageView.isHidden = false
            cell.livePhotoView.isHidden = true
            
            if let animatedImageAsset = content[indexPath.row].MMAsset {
                if animatedImageAsset.playbackStyle == .image {
                    updateAnimatedImage(cell: cell, assets: animatedImageAsset)
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! MMTextCreatePostTableViewCell
        print("Cell Selected!")
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Cell Deselected!")
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func targetSize(view: UIImageView) -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: view.bounds.width * scale,
                      height: view.bounds.width * scale)
    }
    func targetSize(view: PHLivePhotoView) -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: view.bounds.width * scale,
                      height: view.bounds.width * scale)
    }
    
    func updateStillImage(cell: MMTextCreatePostTableViewCell, assets: PHAsset) {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            cell.progressView.progress = Float(progress)
        }
        
        cell.progressView.isHidden = false
        PHImageManager.default().requestImage(for: assets,
                                              targetSize: targetSize(view: cell.stillImageView),
                                              contentMode: .aspectFit,
                                              options: options,
                                              resultHandler: { image, _ in
            // Hide the progress view now the request has completed.
            cell.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let image = image else { return }
            
            // Now that we have the image, show it.
            cell.stillImageView.image = image
        })
    }

    func updateLivePhoto(cell: MMTextCreatePostTableViewCell, assets: PHAsset) {
        // Prepare the options to pass when fetching the live photo.
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                cell.progressView.progress = Float(progress)
            }
        }
        
        cell.progressView.isHidden = false
        // Request the live photo for the asset from the default PHImageManager.
        PHImageManager.default().requestLivePhoto(for: assets,
                                                  targetSize: targetSize(view: cell.livePhotoView),
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: { livePhoto, _ in
            // Hide the progress view not the request has completed.
            cell.progressView.isHidden = true
            
            // If successful, show the live photo and display the live photo.
            guard let livePhoto = livePhoto else { return }
            
            // Now that we have the Live Photo, show it.
            cell.livePhotoView.livePhoto = livePhoto
            
            if !cell.isPlayingHint {
                // Playback a short section of the live photo; similar to the Photos share sheet.
                cell.isPlayingHint = true
                cell.livePhotoView.startPlayback(with: .hint)
            }
        })
    }
    
    func updateAnimatedImage(cell: MMTextCreatePostTableViewCell, assets: PHAsset) {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.version = .original
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.sync {
                cell.progressView.progress = Float(progress)
            }
        }
        
        cell.progressView.isHidden = false
        PHImageManager.default().requestImageData(for: assets, options: options, resultHandler: { (data, _, _, _) in
            // Hide the progress view not the request has completed.
            cell.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let data = data else { return }
            
            let animatedImage = AnimatedImage(data: data)
            cell.animatedImageView.animatedImage = animatedImage
            cell.animatedImageView.isPlaying = true
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MMTextCreatePostTableViewController: MMTextCreatePostTableViewCellDelegate {
    func didTapAddText() {
        if content[content.count - 1].contentType == .placeholder {
            
            content[content.count - 1].contentType = .attributedText
            let cell = tableView.cellForRow(at: IndexPath(row: content.count - 1, section: 0)) as! MMTextCreatePostTableViewCell
            
            cell.addTextButton.isHidden = true
            cell.attributedTextView.isHidden = false
            cell.stillImageView.isHidden = true
            cell.animatedImageView.isHidden = true
            cell.livePhotoView.isHidden = true
            
            content.append(MMTextContent(placeholder: true))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: content.count - 1, section: 0)], with: .automatic)
            tableView.endUpdates()
            
        }
    }
    
    func didAddText(text: NSAttributedString, at: Int) {
        content[at].MMString = text
        tableView.reloadData()
        print("content saved!")
        print(content)
    }
}
