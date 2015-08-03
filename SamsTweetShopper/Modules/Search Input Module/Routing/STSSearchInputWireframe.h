//
//  STSSearchInputWireframe.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

// Protocols
#import "STSSearchInputModuleInterface.h"

/**
 *  The wireframe is responsible for glueing all the constiuant parts of the module together,
 *  via dependancy injection, and for exposing the necessary parts of the module to other
 *  modules. Such as
 *   - Data to handed over a mdule boundary
 *   - References to view/navigation controllers for routing
 */
@interface STSSearchInputWireframe : NSObject <STSSearchInputModuleInterface>



@end
