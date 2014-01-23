//
//  AGSRoomLocator.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "AGSRoomLocator.h"

@interface AGSRoomLocator()

@end

@implementation AGSRoomLocator
-(id)initWithURL:(NSURL *)url room:(Room *)room delegate:(id<AGSLocatorDelegate>)delegate {
    self = [super initWithURL:url];
    if(self) {
        self.room = room;
        self.delegate = delegate;
        self.timeoutInterval = 20;
    }
    return self;
}

-(void)execute {
    NSDictionary *address = [NSDictionary dictionaryWithObjectsAndKeys: self.room.name, @"SingleKey",  nil];
    NSArray *outFields = [NSArray arrayWithObjects: @"*", nil];    
    //start request
    [self locationsForAddress:address returnFields:outFields];
}
@end
