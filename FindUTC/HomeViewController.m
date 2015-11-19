//
//  HomeViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 06/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize buttonSearch, buttonFind, buttonWrite;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //  Border radius
    //
    
    [buttonSearch.layer setCornerRadius:7.0f];
    [buttonFind.layer setCornerRadius:7.0f];
    [buttonWrite.layer setCornerRadius:7.0f];
    
    //
    //  On check l'API et on la met à jour si nécessaire (trop long)
    //
    
    //[API checkApi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Permet d'avoir la même couleur de background entre la tableview et les cell
    [cell setBackgroundColor:[UIColor clearColor]];
    
    // Désactive le voile gris lors de la sélection d'une cellule
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

#pragma mark - Segue

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Permet de passer à un onglet de la tabBar
    if (indexPath.row>=1 && indexPath.row<=2) {
        self.tabBarController.selectedIndex = indexPath.row;
    }
    else if (indexPath.row==3)
    {
        [self performSegueWithIdentifier:@"goToWriteFromHome" sender:self];
    }
}

#pragma mark - Infos

- (IBAction)getInfo:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Informations"
                                                    message:@"Rendez-vous sur le site internet de l'asso Find'UTC pour obtenir plus d'informations: qui sommes-nous, partenaires, mentions légales."
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"S'y rendre", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // Bouton "S'y rendre", on ouvre Safari avec l'url du site de l'asso
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://assos.utc.fr/findutc"]];
    }
}

@end
