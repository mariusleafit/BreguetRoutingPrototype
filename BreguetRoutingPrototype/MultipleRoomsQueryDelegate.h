//
//  MultipleRoomsQueryDelegate.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 06.08.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultipleRoomsQueryDelegate <NSObject>
-(void) roomQueryRoomsFound:(NSArray *)rooms andQueryName:(NSString *)queryName;
-(void) roomQueryErrorOccured:(NSString*)queryName;
@end
