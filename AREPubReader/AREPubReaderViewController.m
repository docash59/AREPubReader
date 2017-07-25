//
//  AREPubReader.m
//  EpubReader
//
//  Created by Ashley Richards on 25/07/2017.
//
//

#import "AREPubReaderViewController.h"

@interface AREPubReaderViewController ()

@property XMLHandler *xmlHandler;
@property EpubContent *ePubContent;

@property IBOutlet UIWebView *webview;
@property IBOutlet UILabel *pageNumberLbl;

@property NSString *pagesPath;
@property int pageNumber;

@end

@implementation AREPubReaderViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self unzipAndSaveWithFileName:_epubFileName];
    _xmlHandler=[[XMLHandler alloc] init];
    _xmlHandler.delegate=self;
    [_xmlHandler parseXMLFileAt:[self getRootFilePath]];
}

/*Function Name : unzipAndSaveFile
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To unzip the epub file to documents directory
 */
- (void)unzipAndSaveWithFileName:(NSString*)name {
    
    ZipArchive* za = [[ZipArchive alloc] init];
    if( [za UnzipOpenFile:[[NSBundle mainBundle] pathForResource:_epubFileName ofType:@"epub"]] ){
        
        NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
        
        //Delete all the previous files
        NSFileManager *filemanager=[[NSFileManager alloc] init];
        if ([filemanager fileExistsAtPath:strPath]) {
            
            NSError *error;
            [filemanager removeItemAtPath:strPath error:&error];
        }
        
        //start unzip
        BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
        if( NO==ret ){
            // error handler here
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"An unknown error occured"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Dismiss"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
            [alert addAction:ok];
            
//            [self presentViewController:alert animated:YES completion:nil];
            
            alert=nil;
        }
        [za UnzipCloseFile];
    }
}

/*Function Name : applicationDocumentsDirectory
 *Return Type   : NSString - Returns the path to documents directory
 *Parameters    : nil
 *Purpose       : To find the path to documents directory
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

/*Function Name : getRootFilePath
 *Return Type   : NSString - Returns the path to container.xml
 *Parameters    : nil
 *Purpose       : To find the path to container.xml.This file contains the file name which holds the epub informations
 */
- (NSString*)getRootFilePath{
    
    //check whether root file path exists
    NSFileManager *filemanager=[[NSFileManager alloc] init];
    NSString *strFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml",[self applicationDocumentsDirectory]];
    if ([filemanager fileExistsAtPath:strFilePath]) {
        
        //valid ePub
        NSLog(@"Parse now");
        
        return strFilePath;
    } else {
        
        //Invalid ePub file
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Root File not Valid"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Dismiss"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    return @"";
}

#pragma mark XMLHandler Delegate Methods

- (void)foundRootPath:(NSString*)rootPath{
    
    //Found the path of *.opf file
    
    //get the full path of opf file
    NSString *strOpfFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],rootPath];
    NSFileManager *filemanager=[[NSFileManager alloc] init];
    
    self._rootPath=[strOpfFilePath stringByReplacingOccurrencesOfString:[strOpfFilePath lastPathComponent] withString:@""];
    
    if ([filemanager fileExistsAtPath:strOpfFilePath]) {
        
        //Now start parse this file
        [_xmlHandler parseXMLFileAt:strOpfFilePath];
    }
    else {
        
        //Invalid ePub file
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"OPF File not found"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Dismiss"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)finishedParsing:(EpubContent*)ePubContents{
    
    _pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[ePubContents._manifest valueForKey:[ePubContents._spine objectAtIndex:0]]];
    self._ePubContent=ePubContents;
    _pageNumber=0;
    [self loadPage];
}

/*Function Name : loadPage
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To load actual pages to webview
 */
- (void)loadPage {
    
    _pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:_pageNumber]]];
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_pagesPath]]];
    //set page number
    _pageNumberLbl.text=[NSString stringWithFormat:@"%d of %i",_pageNumber+1, (int)[self._ePubContent._spine count]];
}

-(IBAction)nextPage:(id)sender {
    if ([self._ePubContent._spine count]-1>_pageNumber) {
        _pageNumber++;
        [self loadPage];
    }
}

-(IBAction)previousPage:(id)sender {
    if (_pageNumber>0) {
        _pageNumber--;
        [self loadPage];
    }
}

@end
