//
//  MMTextView.swift
//  MultimediaTextView
//
//  Created by Eric on 9/28/17.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class MMTextContent {

    // Properties:
    
    enum ContentTypes {
        case defaultType
        case attributedText
        case stillImage
        case livePhoto
        case animatedImage
        case shortVideo
        case placeholder
    }
    /**
     Content Type:
     Use to judge the type of the current.
     */
    var contentType: ContentTypes?
    
    /**
     Store Attributed Text String
     */
    var MMString: NSAttributedString?
    
    /**
     Store Still Image
     */
    var MMAsset: PHAsset?
    
    required init() {
        self.contentType = ContentTypes.defaultType
        self.MMString = nil
        self.MMAsset = nil
    }
    
    init(placeholder: Bool) {
        self.contentType = ContentTypes.placeholder
        self.MMString = nil
        self.MMAsset = nil
    }
    
    init(textIs text: NSAttributedString?) {
        self.contentType = ContentTypes.attributedText
        self.MMString = text!
        self.MMAsset = nil
    }
    
    init(mediaIs asset: PHAsset?) {
        var type:ContentTypes = .defaultType
        
        if #available(iOS 11.0, *) {
            switch asset!.playbackStyle {
            case .image:
                type = .stillImage
                break
            case .livePhoto:
                type = .livePhoto
                break
            case .imageAnimated:
                type = .animatedImage
                break
            case .video:
                type = .shortVideo
                break
            default:
                break
            }
        } else {
            if let identifier = asset!.value(forKey: "uniformTypeIdentifier") as? String {
                if identifier == kUTTypeLivePhoto as String {
                    type = .livePhoto
                }else if identifier == kUTTypeGIF as String {
                    type = .animatedImage
                }else if identifier == kUTTypeImage as String {
                    type = .stillImage
                }else if identifier == kUTTypeMovie as String {
                    type = .shortVideo
                }else{
                    type = .defaultType
                }
            }
        }
        
        self.contentType = type
        self.MMAsset = asset!
    }
    
}
