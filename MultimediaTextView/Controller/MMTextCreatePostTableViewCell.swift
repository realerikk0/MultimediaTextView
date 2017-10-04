//
//  MMTextCreatePostTableViewCell.swift
//  MultimediaTextView
//
//  Created by Eric on 10/2/17.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

protocol MMTextCreatePostTableViewCellDelegate  {
    func didTapAddText()
    func didAddText(text: NSAttributedString, at: Int)
}

class MMTextCreatePostTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var addTextButton: UIButton!
    @IBOutlet var attributedTextView: UITextView!
    @IBOutlet var animatedImageView: AnimatedImageView!
    @IBOutlet var livePhotoView: PHLivePhotoView!
    @IBOutlet var stillImageView: UIImageView!
    
    @IBOutlet var progressView: UIProgressView!
    
    var tblViewCellId = 0
    var isPlayingHint = false
    var delegate: MMTextCreatePostTableViewCellDelegate?
    
    @IBAction func addTextTapped(_ sender: UIButton) {
        
        delegate?.didTapAddText()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attributedTextView.delegate = self
        attributedTextView.font = UIFont.preferredFont(forTextStyle: .body)
        //attributedTextView.placeholder = "Your mind begins here..."
        attributedTextView.keyboardDismissMode = .interactive
        attributedTextView.inputAccessoryView = inputToolBar
        addTextButton.layer.borderWidth = 1.0
        addTextButton.layer.borderColor = UIColor.lightGray.cgColor
        addTextButton.layer.cornerRadius = 5.0
        stillImageView.contentMode = .scaleAspectFit
        livePhotoView.contentMode = .scaleAspectFit
        
    }
 
    lazy var inputToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let returnButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.handleDoneClicked))
        
        toolBar.setItems([flexibleSpace,returnButton], animated: false)
        return toolBar
    }()
    
    @objc func handleDoneClicked() {
        self.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        attributedTextView.layer.borderWidth = 1.0
        attributedTextView.layer.cornerRadius = 2.0
        attributedTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("TextView Change Detected!")
        attributedTextView.layer.borderWidth = 0.0
        
        if textView.attributedText.length == 0 {
            //textView.placeholder = "Your mind begins here..."
        }
        
        delegate?.didAddText(text: textView.attributedText, at: self.tblViewCellId)
    }

}

// MARK: PHLivePhotoViewDelegate
extension MMTextCreatePostTableViewCell: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
}
