//
//  ListViewController.h
//  QRCodeReader
//
//  Created by amaury soviche on 18/05/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
-(void) refreshTableView;
@end
