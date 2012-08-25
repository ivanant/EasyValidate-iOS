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

#import "OrLogicChecker.h"

@implementation OrLogicChecker

-(bool) validate:(NSString*) value{
    bool flag = NO;
    for (int i=0; i<_checkers.count; i++) {
        id<TextValidator> checker =  [_checkers objectAtIndex:i];
        // Set to YES if it has one.
        if ([checker validate:value]) {
            flag = YES;
            break;
        }else{
            if( nil == errorMsg){
                errorMsg = [[NSMutableString alloc] init];
            }
            [errorMsg appendString: [checker getErrorMessage]];
            flag = NO;
        }
    }
    return flag;
}

-(NSString*) getErrorMessage{
    return errorMsg;
}

- (void) addChecker:(id<TextValidator>) validator{
    if(_checkers == nil){
        _checkers = [[NSMutableArray alloc] init];
    }
    [_checkers addObject:validator];
}

@end
