//
//  SaveWriteViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "SaveWriteViewController.h"

@interface SaveWriteViewController ()
{
    BOOL success;
}
@end

@implementation SaveWriteViewController

@synthesize opinion;
@synthesize okButton;
@synthesize loading;
@synthesize message;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [okButton setHidden:YES];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    //
    //  Enregistrement
    //
    
    NSString *status = @"";
    NSString *error = @"";
    
    success = NO;
    success = [Opinion saveOpinionWithOpinion:opinion getStatus:&status andError:&error];
    
    // Hidden de loading + apparition du bouton close
    [loading setHidden:YES];
    [okButton setHidden:NO];
    
    // Texte de confirmation ou non dans message
    if (success)
    {
        message.text = @"L'enregistrement a bien été effectué ! \n Merci pour votre participation.";
    }
    else
    {
        NSLog(@"Status: %@ \n Erreur: %@", status, error);
        if([status isEqualToString:@""])
        {
           message.text = @"L'enregistrement a échoué, veuillez vérifier votre connexion à internet et réessayer.";
        }
        else if ([status isEqualToString:@"400"])
        {
            message.text = [NSString stringWithFormat:@"L'enregistrement a échoué:\n %@", error];
        }
        else
        {
            message.text = @"L'enregistrement a échoué à cause d'une erreur interne, veuillez réessayer plus tard.";
        }
    }
    
}

- (IBAction)okButton:(id)sender
{
    if(success)
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
