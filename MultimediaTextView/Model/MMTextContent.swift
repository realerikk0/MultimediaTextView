//
//  MMTextView.swift
//  MultimediaTextView
//
//  Created by Eric on 9/28/17.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit
import Photos

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
     1  --  Plain Text in Attributed Text String.
     2  --  Still Image.
     3  --  Live Photo^.
     4  --  GIF^.
     5  --  Short Video^.
     
     99 --  Add content place holder
     
     ^  :   Type Current Unavailable
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
        
        self.contentType = type
        self.MMAsset = asset!
    }
    
}
