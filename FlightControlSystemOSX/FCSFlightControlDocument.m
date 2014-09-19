//
//  Document.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/15/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSFlightControlDocument.h"

@interface FCSFlightControlDocument ()

@end

@implementation FCSFlightControlDocument
            
- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
                                    
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
                                
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
                                
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
                                
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialController]];
                                
}

@end
