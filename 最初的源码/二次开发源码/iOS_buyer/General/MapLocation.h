//
//  MapLocation.h
//  My_App
//
//  Created by barney on 15/12/11.
//  Copyright © 2015年 barney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

 @interface MapLocation : NSObject<MKAnnotation>


 @property (nonatomic,retain)NSString *title2;
 @property (nonatomic,retain)NSString *subtitle2;
 @property (nonatomic,assign)CLLocationCoordinate2D coordinate;

 - (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;
@end
