/*
 Copyright Ivan Lam
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "EasyValidate.h"
#import <UIKit/UIKit.h>
#import "ElementValidationDelegate.h"

@implementation EasyValidate

/*
 Check one element and return result.
 withAlert: whether show alert.
 */
-(bool) checkOneElement:(id <ElementValidationDelegate>) element
              withAlert:(bool) withAlert
{
    bool result = [element validate];
    // If validate fail and need to show alert
    if (!result && withAlert) {
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INPUT_WARNING_TITLE", nil)
                                                              message:[element getErrorMessage]
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"ALERT_OK_BUTTON", nil)
                                                    otherButtonTitles:nil];
        [resultAlert show];
    }
    return result;
}

/*
 Check all elements and show alert.
 onlyShowFirstAlert: whether show all error messages.
 */
-(bool) checkAllElement:(NSArray*) elements
              withAlert:(bool) withAlert
     onlyShowFirstAlert:(bool) isFirst
{
    for (id nElement in elements) {
        // Check element type first.
        if(![nElement conformsToProtocol:@protocol(ElementValidationDelegate)])
        {
            NSException* ex = [[NSException alloc]initWithName:@"Parameter Exception"
                                                        reason:@"checkAllElementWithAlert:Elements contain a object that no implement ElementValidationDelegate."
                                                      userInfo:nil];
            @throw ex;
        }
        
        bool nResult = [self checkOneElement:nElement withAlert:NO];
        // If nResult is NO , show alert or record it.
        if(!nResult)
        {
            [self dealwithAlert:nElement onlyShowFirstAlert:isFirst];
            if (isFirst) {
                return NO;
            }
        }
    }
    return YES;    
}

/*
 Private
 Show alert or record it.
 */
-(void) dealwithAlert:(id <ElementValidationDelegate>) element
   onlyShowFirstAlert:(bool) isFirst
{
    if(isFirst)
    {
        NSString *title = NSLocalizedString(@"INPUT_WARNING_TITLE", nil);
        NSString *message = [element getErrorMessage];
        NSString *cancelButton = NSLocalizedString(@"ALERT_OK_BUTTON", nil);
        
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:title
                                                              message:message
                                                             delegate:nil
                                                    cancelButtonTitle:cancelButton
                                                    otherButtonTitles:nil];
        [resultAlert show];
    }
}
@end
