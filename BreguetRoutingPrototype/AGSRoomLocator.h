//
//  AGSRoomLocator.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>
#import "Room.h"

@interface AGSRoomLocator : AGSLocator
@property (nonatomic) Room *room;

-(id)initWithURL:(NSURL *)url room:(Room *)room delegate:(id<AGSLocatorDelegate>)delegate;

-(void)execute;
@end
