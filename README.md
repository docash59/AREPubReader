# AREPubReader

**AREPubReader** is a light-weight and easy to use `.epub` viewer.<br>
So now you can view `.epub` documents that simply uses `UIWebView`.

# Requirements
- iOS 8 or later.

# Get Set Up!
`AREPubReaderViewController` is a `UIViewController`.

1. Click and drag the folder into your Xcode project.
2. Add `import "AREPubReaderViewController.h"` to your header file.
3. Create a new `UIViewController` in your Storyboard.
4. Add a `Storyboard ID` to the ViewController.
4. Assign the newly created `UIViewController` class to `AREPubReaderViewController`.
5. Click onto the 'Commections' tab and you have the available `IBOutlets` and `IBActions`.<br><br>
![Connection tab](https://pasteboard.co/images/GCHGpeF.png/download)<br>
6. Start designing your Reader:<br>

| Connection | Type | Description |
|---|---|---|
| **webview** | `UIWebView` | Displays the epub file. |
| **pageNumberLbl** | `UILabel` | Label for [`currentPage` of `totalPages`]. |
| **nextPage** | `IBAction` | Navigates to next page in the ePub. |
| **previousPage** | `IBAction` | Navigates to previous page in the ePub. |

# Load An EPub

** Ensure you have assigned the ViewController to a `Storyboard ID`!**

Assign the `epubFileName` property with the file name of the .epub (in your project) you want the reader to load up.

```
AREPubReaderViewController *readerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"reader"];
readerViewController.epubFileName=@"my-first-book";
[self.navigationController pushViewController:readerViewController animated:YES];
```
and... you're done!

# The Future
- Be able to open an .epub via URL.

# Dependancies
- **ZipArchive** - https://github.com/mattconnolly/ZipArchive *(included)*
