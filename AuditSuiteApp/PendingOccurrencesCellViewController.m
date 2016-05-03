//
//  PendingOccurrencesCellViewController.m
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PendingOccurrencesCellViewController.h"

@implementation PendingOccurrencesCellViewController

@synthesize DueDate;
@synthesize Area;
@synthesize Type;
@synthesize Focus;
@synthesize Instruction;
@synthesize Obs;
@synthesize LeadAuditor;
@synthesize OriginalDueDate;
@synthesize AuditId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
