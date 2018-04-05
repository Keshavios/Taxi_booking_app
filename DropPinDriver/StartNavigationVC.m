//
//  StartNavigationVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 6/6/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "StartNavigationVC.h"
#import "TabBar.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)
#define kBaseUrl @"https://maps.googleapis.com/maps/api/directions/json?"
@interface StartNavigationVC ()

@end

@implementation StartNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _stopRidebtn.clipsToBounds= YES;
    _stopRidebtn.layer.cornerRadius = 3;
     UserInfoV.hidden = NO;
    NSLog(@"%@",_DetailDict);
    userNameLB.text =[NSString stringWithFormat:@"%@",[[_DetailDict objectForKey:@"user"] objectForKey:@"username"]];
    
    estimationcostLB.text =[NSString stringWithFormat:@"Estimation Cost: %@",[_DetailDict  objectForKey:@"estimation_cost"]];
    
    userLocationLB.text =@"";
    contactno =[[_DetailDict objectForKey:@"user"]objectForKey:@"user_mobile"];
    userImgV.clipsToBounds = YES;
    userImgV.layer.cornerRadius = userImgV.frame.size.width/2;
    [userImgV setImageWithURL:[NSURL URLWithString:[[_DetailDict objectForKey:@"user"] objectForKey:@"user_image"]] placeholderImage:[UIImage imageNamed:@"DEFAULT_USER"]];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self showPinOnMapviewWithArray];
}
-(void)viewWillAppear:(BOOL)animated{
    sourceLatt = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]]doubleValue];
    sourceLong = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]]doubleValue];
    
    toAddressString = [NSString stringWithFormat:@"%f,%f",sourceLatt,sourceLong];
    mapView.delegate = self;
    
    userdestination = [NSString stringWithFormat:@"%f,%f",[[_DetailDict objectForKey:@"req_lat_to" ]doubleValue],[[_DetailDict objectForKey:@"req_lng_to"] doubleValue]];
    //userdestination = [NSString stringWithFormat:@"%f,%f",30.6425,76.8173];
    
    destLati = [[_DetailDict objectForKey:@"req_lat_to" ]doubleValue];
    destLongi =[[_DetailDict objectForKey:@"req_lng_to"]doubleValue];
    
    [self performSelector:@selector(appendsk) withObject:nil afterDelay:0.1];
    [mapView removeOverlays:mapView.overlays];
    
    
    MKCoordinateRegion region;
    CLLocation *locObj = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(sourceLatt, sourceLong)
                                                       altitude:0
                                             horizontalAccuracy:0
                                               verticalAccuracy:0
                                                      timestamp:[NSDate date]];
    region.center = locObj.coordinate;
    
    span.latitudeDelta  = 0.1; // values for zoom
    span.longitudeDelta = 0.1;
    region.span = span;
    
    //mapView.showsUserLocation = YES;
    
    [mapView setRegion:region animated:YES];
    
    
    
}
-(void)showPinOnMapviewWithArray
{
    //    GMSCameraPosition *camera = nil;
    //
    //    camera = [GMSCameraPosition cameraWithLatitude: [lat doubleValue]                                             longitude:[lng doubleValue] zoom:14.0];
    //    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapV.frame.size.width, mapV.frame.size.height) camera:camera];
    //
    //
    //    [mapView_ setCamera:camera];
    //    mapView_.myLocationEnabled  = YES;
    //    mapView_.delegate           = self;
    //
    //    [mapV addSubview:mapView_];
    
}
-(void)appendsk{
    dispatch_async(kBgQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *strUrl;
        
        //        if (_wayPoints.count>0) {
        //            strUrl= [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&mode=driving&waypoints=optimize:true",kBaseUrl,_startPoint,_endPoint];
        //            for (NSString *strViaPoint in _wayPoints) {
        //                strUrl=[strUrl stringByAppendingFormat:@"|via:%@",strViaPoint];
        //            }
        //        }
        //        else
        //        {
        strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&mode=driving",kBaseUrl,toAddressString ,userdestination];
        //        }
        
        
        strUrl=[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSArray *arrRouts=[json objectForKey:@"routes"];
    if ([arrRouts isKindOfClass:[NSArray class]]&&arrRouts.count==0) {
        
        return;
    }
    //    NSArray *arrDistance =[[[json valueForKeyPath:@"routes.legs.steps.distance.text"] objectAtIndex:0]objectAtIndex:0];
    //    NSString *totalDuration = [[[json valueForKeyPath:@"routes.legs.duration.text"] objectAtIndex:0]objectAtIndex:0];
    //    NSString *totalDistance = [[[json valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0]objectAtIndex:0];
    //    NSArray *arrDescription =[[[json valueForKeyPath:@"routes.legs.steps.html_instructions"] objectAtIndex:0] objectAtIndex:0];
    //    dictRouteInfo=[NSDictionary dictionaryWithObjectsAndKeys:totalDistance,@"totalDistance",totalDuration,@"totalDuration",arrDistance ,@"distance",arrDescription,@"description", nil];
    
    NSArray* arrpolyline = [[[json valueForKeyPath:@"routes.legs.steps.polyline.points"] objectAtIndex:0] objectAtIndex:0]; //2
    //    double srcLat=[[[[json valueForKeyPath:@"routes.legs.start_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    //    double srcLong=[[[[json valueForKeyPath:@"routes.legs.start_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    //    double destLat=[[[[json valueForKeyPath:@"routes.legs.end_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    //    double destLong=[[[[json valueForKeyPath:@"routes.legs.end_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    //    CLLocation *currentLocation= newlocation;
    //
    //    if (currentLocation != nil) {
    //        newLong = currentLocation.coordinate.longitude;
    //        newlatt = currentLocation.coordinate.latitude;
    //    }
    // Reverse Geocoding
    
    
    CLLocationCoordinate2D sourceCordinate = CLLocationCoordinate2DMake(sourceLatt, sourceLong);
    CLLocationCoordinate2D destCordinate = CLLocationCoordinate2DMake(destLati , destLongi);
    
    [self addAnnotationSrcAndDestination:sourceCordinate :destCordinate];
    //    NSArray *steps=[[aary objectAtIndex:0]valueForKey:@"steps"];
    
    //    replace lines with this may work
    
    NSMutableArray *polyLinesArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < [arrpolyline count]; i++)
    {
        NSString* encodedPoints = [arrpolyline objectAtIndex:i] ;
        MKPolyline *route = [self polylineWithEncodedString:encodedPoints];
        [polyLinesArray addObject:route];
    }
    
    [mapView addOverlays:polyLinesArray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord
{
    //progressView.hidden = YES;
    
    NSArray *annotationsOnMap = mapView.annotations;
    [mapView removeAnnotations:annotationsOnMap];
    
    
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *destAnnotation = [[MKPointAnnotation alloc]init];
    sourceAnnotation.coordinate = srcCord;
    destAnnotation.coordinate = destCord;
    //    sourceAnnotation.title=_startPoint;
    //    destAnnotation.title=_endPoint;
    
    [mapView addAnnotation:sourceAnnotation];
    [mapView addAnnotation:destAnnotation];
    
    
    //    CLGeocoder *geocoder= [[CLGeocoder alloc]init];
    //    for (NSString *strVia in _wayPoints) {
    //        [geocoder geocodeAddressString:strVia completionHandler:^(NSArray *placemarks, NSError *error) {
    //            if ([placemarks count] > 0) {
    //                CLPlacemark *placemark = [placemarks objectAtIndex:0];
    //                CLLocation *location = placemark.location;
    //                //                CLLocationCoordinate2D coordinate = location.coordinate;
    //                MKPointAnnotation *viaAnnotation = [[MKPointAnnotation alloc]init];
    //                viaAnnotation.coordinate=location.coordinate;
    //                [mapView addAnnotation:viaAnnotation];
    //                NSLog(@"%@",placemarks);
    //            }
    //
    //        }];
    //    }
    
    // trackMap.region=region;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        sourceLatt = currentLocation.coordinate.latitude;
        sourceLong = currentLocation.coordinate.longitude;
        toAddressString = [NSString stringWithFormat:@"%f,%f",sourceLatt,sourceLong];
        CLLocationCoordinate2D sourceCordinate = CLLocationCoordinate2DMake(sourceLatt, sourceLong);
        CLLocationCoordinate2D destCordinate = CLLocationCoordinate2DMake(destLati , destLongi);
        [self addAnnotationSrcAndDestination:sourceCordinate :destCordinate];
        [self performSelectorInBackground:@selector(getDistanceBetweenRoute) withObject:nil];
    }
    
    //    if (sourceLatt == destLati && sourceLong ==destLongi) {
    //
    //        TabBar * view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
    //        [[NSUserDefaults standardUserDefaults] setObject:@"finish" forKey:@"finish"];
    //        [self.navigationController pushViewController:view animated:YES];
    //
    //    }
    
}



- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}



#pragma mark - map overlay
- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 10;
    overlayView.strokeColor = UIColorFromRGBAlpha(0, 169, 238, 1);
    overlayView.fillColor = [UIColorFromRGBAlpha(0, 169, 238, 1) colorWithAlphaComponent:0.1f];
    return overlayView;
    
}

#pragma mark - map annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        
        /* MKAnnotationView *pinView = (MKAnnotationView*)[mapView1 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
         if (!pinView)
         {
         
         pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
         pinView.canShowCallout = YES;
         pinView.image = [UIImage imageNamed:@"MAP_ICN"];
         pinView.calloutOffset = CGPointMake(0, 32);
         
         
         // [rightButton addTarget:self action:@selector(goToUserDetailsView:) forControlEvents:UIControlEventTouchUpInside];
         }
         else {
         pinView.annotation = annotation;
         }
         return pinView;
         }*/
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView1 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            
            CLLocationCoordinate2D originCllocation = CLLocationCoordinate2DMake(sourceLatt, sourceLong);
            
            if (originCllocation.latitude == annotation.coordinate.latitude && originCllocation.longitude == annotation.coordinate.longitude) {
                pinView.image=[UIImage imageNamed:@"MAP_CAR_ICN"];
            } else {
                pinView.image=[UIImage imageNamed:@"MAP_ICN"];
            }
            pinView.calloutOffset = CGPointMake(0, 32);
        }
        else {
            
            CLLocationCoordinate2D originCllocation=CLLocationCoordinate2DMake(sourceLatt, sourceLong);
            if (originCllocation.latitude==annotation.coordinate.latitude && originCllocation.longitude==annotation.coordinate.longitude) {
                pinView.image=[UIImage imageNamed:@"MAP_CAR_ICN"];
            } else {
                pinView.image=[UIImage imageNamed:@"MAP_ICN"];
            }
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
    
}
- (IBAction)stopRideBtnaction:(id)sender {
    
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             
             ALERTVIEW( @"Internet Connection not Available!", self);
         }
         else
         {
             
             
             NSDictionary * params = @{
                                       @"auth_token"     : [[NSUserDefaults standardUserDefaults]  objectForKey:@"auth_token"],
                                       @"user_id"          : [_DetailDict objectForKey:@"user_id"],
                                       @"emp_id"           : GET_USER_ID,
                                       @"request_id"   :  [_DetailDict objectForKey:@"request_id"],
                                       @"checkout_time"   :[NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]],
                                       @"stop_trip_lat"    :[NSString stringWithFormat:@"%f",sourceLatt],
                                       @"stop_trip_lng"    : [NSString stringWithFormat:@"%f",sourceLong],
                                       @"status" : @"4"
                                       
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"stop_request.php"];
             [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
              {
                  HIDE_PROGRESS;
                  if (success == false)
                  {
                      ALERTVIEW( message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          UIViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
                          [[NSUserDefaults standardUserDefaults] setObject:@"finish" forKey:@"finish"];
                          [[NSUserDefaults standardUserDefaults] setObject:[_DetailDict objectForKey:@"estimation_cost"] forKey:@"estimation_cost"];
                          [self.view.window setRootViewController:view];
                          }
                      else
                      {
                          
                          if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Authentication Token does not match"]) {
                              UIAlertController *alertController = [UIAlertController
                                                                    alertControllerWithTitle:@""
                                                                    message:[[dictionary objectForKey:@"status"] objectForKey:@"message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction *okAction = [UIAlertAction
                                                         actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                                         {
                                                             SET_USER_ID(nil);
                                                             UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                                                             self.view.window.rootViewController    = view;
                                                             
                                                         }];
                              
                              [alertController addAction:okAction];
                              
                          }
                          else{
                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                          }
                      }
                  }
                  
              }];
         }
         
     }];
    
    
}

#pragma mark
#pragma mark Button action

- (IBAction)contactBtn:(id)sender
{
    phNo = contactno;
    phNo = [phNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    phNo = [phNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        //        alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //        [alert show];
    }
}


- (IBAction)menuBtnAction:(id)sender
{
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuVC"];
    [self addChildViewController:vc2];
    [self.view addSubview:vc2.view];
    [vc2 didMoveToParentViewController:self];
    vc2.view.frame = CGRectMake(-vc2.view.frame.size.width, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    vc2.view.frame = CGRectMake(vc2.view.frame.size.width*0/100, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
    }   completion:^(BOOL finished)
    {
    }];
}



//- (IBAction)startNavigationBtnaction:(id)sender {
//    NSString * destibationAdd =[_dataDic objectForKey:@"location"];
//    destibationAdd =[destibationAdd stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    CLLocationCoordinate2D start = { [[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"] doubleValue], [[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"] doubleValue] };
//
//    CLLocationCoordinate2D destination = { [[_dataDic objectForKey:@"latitude"]doubleValue], [[_dataDic objectForKey:@"longitude"]doubleValue]
//    };
//
//    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%0.6f,%0.6f&daddr=%@",start.latitude, start.longitude,destibationAdd];
//
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:googleMapsURLString]];
//}



#pragma mark
#pragma mark -  Get Distanc Between Route Action

-(void)getDistanceBetweenRoute {
    
    dispatch_async(kBgQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *strUrl;
        strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&mode=driving",kBaseUrl,toAddressString,userdestination];
        strUrl=[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        [self performSelectorOnMainThread:@selector(fetchedDistance:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedDistance:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    NSArray *arrRouts=[json objectForKey:@"routes"];
    if ([arrRouts isKindOfClass:[NSArray class]]&&arrRouts.count==0) {
        return;
    }
    NSString *totalDistance = [[[json valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0]objectAtIndex:0];
    NSInteger  distance = [[[[json valueForKeyPath:@"routes.legs.distance.value"] objectAtIndex:0]objectAtIndex:0]integerValue];
    if (distance <= 10) {
//        TabBar * view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
//        [[NSUserDefaults standardUserDefaults] setObject:@"finish" forKey:@"finish"];
//        [self.navigationController pushViewController:view animated:YES];
    }else {
        //        distanceMsgLbl.text = @"on the way";
        //        [distanceLbl setText: [NSString stringWithFormat:@"%@",totalDistance]];
    }
}


#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
