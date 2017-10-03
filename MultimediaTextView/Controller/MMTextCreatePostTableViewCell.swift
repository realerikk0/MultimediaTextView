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
        addTextButton.layer.borderWidth = 1.0
        addTextButton.layer.borderColor = UIColor.lightGray.cgColor
        addTextButton.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        print("TextView Change Detected!")
//        delegate?.didAddText(text: textView.attributedText, at: self.tblViewCellId)
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("TextView Change Detected!")
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
