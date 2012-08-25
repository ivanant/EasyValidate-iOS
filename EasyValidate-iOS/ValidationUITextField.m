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

#import "ValidationUITextField.h"
#import "TextCheckFactory.h"

@implementation ValidationUITextField

@synthesize checkRule = _checkRule;
@synthesize title = _title;

-(bool) validate{
    TextCheckFactory* checker = [[TextCheckFactory alloc] init];
    if(![checker validateValue:self.text withRule:self.checkRule])
    {
        errorMsg = [checker getErrorMessage];
        return NO;
    }
    return YES;
}

-(NSString *) getErrorMessage
{
    return [NSString stringWithFormat:@"%@:%@",self.title, errorMsg];
}

@end
