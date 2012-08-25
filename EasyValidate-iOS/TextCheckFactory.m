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

#import "TextCheckFactory.h"
#import "AndLogicChecker.h"
#import "OrLogicChecker.h"
#import "StringCheckerUtil.h"

@implementation TextCheckFactory

-(id) init
{
    self = [super init];
    if(self){
        errorMsg = [[NSMutableString alloc] init];
    }
    return self;
}

/*
 Validate text value with rule.
 */
-(bool) validateValue:(NSString*) value withRule:(NSString*) rule
{
    
    //FIXME It will be check the rule's format in next version.
    if(rule != nil ){
        
        // Check "and" rule.
        NSRange rangeAnd = [rule rangeOfString:AND];
        if(rangeAnd.location != NSNotFound){
            AndLogicChecker* andChecker = [[AndLogicChecker alloc] init];
            NSArray* beanClass = [rule componentsSeparatedByString:AND];
            for(int i=0;i<beanClass.count;i++){
                id<TextValidator> checker = [self getValidator:[beanClass objectAtIndex:i]];
                [andChecker addChecker:checker];
            }
            if (![andChecker validate:value]) {
                [errorMsg appendString:  [andChecker getErrorMessage]];
                return NO;
            }else{
                return YES;
            }
        }
        
        // Check "or" rule.
        NSRange rangeOr = [rule rangeOfString:OR];
        if(rangeOr.location != NSNotFound){
            OrLogicChecker* orChecker = [[OrLogicChecker alloc] init];
            NSArray* beanClass = [rule componentsSeparatedByString:OR];
            for(int i=0;i<beanClass.count;i++){
                id<TextValidator> checker = [self getValidator:[beanClass objectAtIndex:i]];
                [orChecker addChecker:checker];
            }
            if (![orChecker validate:value]) {
                [errorMsg appendString: [orChecker getErrorMessage]];
                return NO;
            }else{
                return YES;
            }
        }
        
        // Check single rule witout use "and" or "or" rule.
        id<TextValidator> singleChecker = [self getValidator:rule];
        if (![singleChecker validate:value]) {
            [errorMsg appendString:  [singleChecker getErrorMessage]];
            return NO;
        }else {
            return YES;
        }
        
    }
    return YES;
}

/*
 Get the validator by rule.
 */
-(id<TextValidator>) getValidator:(NSString*) rule
{
    //Check the rule whether has parameters.
    NSRange paramStart = [rule rangeOfString:PARAM_START];
    NSRange paramEnd = [rule rangeOfString:PARAM_END];
    if(paramStart.location != NSNotFound && paramEnd.location != NSNotFound){
        NSString *paramList = [rule substringWithRange:NSMakeRange(paramStart.location+1,paramEnd.location-paramStart.location-1)];
        NSString *className = [self getCheckerClassName:[rule substringWithRange:NSMakeRange(0, paramStart.location)]];
        id<TextValidator> textValidator = [[NSClassFromString(className) alloc] init];
        [self trySetProperties:[self getParams:paramList] onObject:textValidator];
        return textValidator;
    }else{
        NSString *className = [self getCheckerClassName:rule];
        return [[NSClassFromString(className) alloc] init];
    }
}

/*
 Get the class name of the checker.
 */
-(NSString*) getCheckerClassName:(NSString*) ruleName
{
    if([StringCheckerUtil isNotNull:ruleName]){
        return [NSString stringWithFormat:@"%@%@",ruleName,CHECKER_SUFFIX];
    }else {
        return @"";
    }
}

/*
 Change parameters into dictionary format.
 */
-(NSDictionary*) getParams:(NSString*) paramStr
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if( nil != paramStr){
        NSArray* paramArray = [paramStr componentsSeparatedByString:PARAM_SEPARATOR];
        for (int i=0;i<paramArray.count;i++) {
            NSString* paramKV = (NSString*)[paramArray objectAtIndex:i];
            NSArray*  keyValue = [paramKV componentsSeparatedByString:PARAM_KEY_VALUE_SEPARATOR];
            NSString* k = [keyValue objectAtIndex:0];
            NSString* v = [keyValue objectAtIndex:1];
            
            [params setObject:v forKey:k];
        }
    }
    return params ;
}

/*
 Set all properties on one object.
 */
-(void)trySetProperties:(NSDictionary*) properties onObject:(id)target
{
    for(NSString* key in properties.allKeys){
        [self trySetProperty:key onObject:target withValue:[properties objectForKey:key]];
    }
}

/*
 Set an property on one object
 */
- (void)trySetProperty:(NSString *)propertyName onObject:(id)target withValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        [target setValue:value forKeyPath:propertyName];
    } else if ([value isKindOfClass:[NSNumber class]]){
        [target setValue:value forKeyPath:propertyName];
    } else if ([value isKindOfClass:[NSArray class]]) {
        //TODO
    } else if ([value isKindOfClass:[NSDictionary class]]){
        //TODO
    } else if ([value isKindOfClass:[NSObject class]]){
        [target setValue:value forKeyPath:propertyName];
    } else if (value == nil){
        [target setValue:nil forKeyPath:propertyName];
    }
}

-(NSString *) getErrorMessage
{
    return errorMsg;
}
@end
