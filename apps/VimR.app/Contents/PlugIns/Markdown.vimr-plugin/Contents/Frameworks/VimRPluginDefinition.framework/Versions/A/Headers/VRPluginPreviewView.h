/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


@protocol VRPluginPreviewView

@required
- (BOOL)previewFileAtUrl:(NSURL *)url;

@end
