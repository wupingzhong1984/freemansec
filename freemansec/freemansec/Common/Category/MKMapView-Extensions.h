//
//  MKMapView-Extensions.h
//  myplan
//
//  Created by adamwu on 17/3/20.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (CS_Extensions)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
