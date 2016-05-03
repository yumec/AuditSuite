//
//  PendingOccurrencesCellViewController.h
//  AuditSuiteApp
//
//  Created by Esteban Corrales on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingOccurrencesCellViewController : UITableViewCell
{
    
    UILabel *DueDate;
    UILabel *Area;
    UILabel *Type;
    UILabel *Focus;
    UILabel *Instruction;
    UILabel *Obs;
    NSDate *OriginalDueDate;
    UILabel *LeadAuditor;
    UILabel *AuditId;
}
@property (nonatomic, strong) IBOutlet UILabel *DueDate;
@property (nonatomic, strong) IBOutlet UILabel *Area;
@property (nonatomic, strong) IBOutlet UILabel *Type;
@property (nonatomic, strong) IBOutlet UILabel *Focus;
@property (nonatomic, strong) IBOutlet UILabel *Instruction;
@property (nonatomic, strong) IBOutlet UILabel *Obs;
@property (nonatomic, strong) IBOutlet UILabel *LeadAuditor;
@property (nonatomic, strong) IBOutlet UILabel *AuditId;
@property (nonatomic, strong) NSDate *OriginalDueDate;

@end
