//
//  testView.m
//  208
//
//  Created by amaury soviche on 18/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "testView.h"

@implementation testView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        //load xib file
        [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:self options:nil];
        
        
        //adjust bounds
        self.bounds = self.view.bounds;
        
        
        
        //add as a subview
        [self addSubview:self.view];
        
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self= [super initWithCoder:aDecoder];
    if (self) {
        //1. load xib
        [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:self options:nil];
        
        //2. add it as a subview
        [self addSubview:self.view];
        
        
    }
    
    return self;
}

@end
