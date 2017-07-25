//
//  AREPubReader.h
//  EpubReader
//
//  Created by Ashley Richards on 25/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"
#import "XMLHandler.h"
#import "EpubContent.h"

@interface AREPubReaderViewController : UIViewController <XMLHandlerDelegate>

@property (nonatomic, retain)EpubContent *_ePubContent;
@property (nonatomic, retain)NSString *_rootPath;
@property (nonatomic, retain)NSString *epubFileName;

@end
