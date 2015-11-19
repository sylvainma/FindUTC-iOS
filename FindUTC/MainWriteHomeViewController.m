//
//  MainWriteHomeViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 29/07/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "MainWriteHomeViewController.h"

@interface MainWriteHomeViewController ()

@end

@implementation MainWriteHomeViewController

@synthesize opinion, pickerData;
@synthesize storeName, commentary, login, noteNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //  Configuration du PickerData
    //
    noteNumber.delegate = self;
    pickerData = @[@{@"noteName" : @"Excellent", @"noteNumber" : @"5"},
                   @{@"noteName" : @"Très bien", @"noteNumber" : @"4"},
                   @{@"noteName" : @"Bien", @"noteNumber" : @"3"},
                   @{@"noteName" : @"Moyen", @"noteNumber" : @"2"},
                   @{@"noteName" : @"Médiocre", @"noteNumber" : @"1"}];
    [noteNumber selectRow:2 inComponent:0 animated:YES];  // Sélection par défaut
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Cancel & save

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    //
    //  Vérifier que les données sont correctement entrées
    //
    
    if (![storeName.text isEqualToString:@""]
        && storeName.text.length>=3
        && ![login.text isEqualToString:@""]
        && login.text.length>=3
        && ![commentary.text isEqualToString:@""]
        && commentary.text.length>=10)
    {
        
        //
        //  Récupération des données
        //
        
        opinion = [[Opinion alloc] init];
        opinion.idStore = @"0";
        opinion.storeName = storeName.text;
        opinion.login = login.text;
        opinion.comment = commentary.text;
        opinion.noteNumber = [[pickerData objectAtIndex:[noteNumber selectedRowInComponent:0]] objectForKey:@"noteNumber"];
        
        //
        //  Enclenchement de la segue
        //
        
        [self performSegueWithIdentifier:@"goToSaveFromHome" sender:self];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation"
                                                        message:@"Veuillez compléter le formulaire avant d'enregistrer."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - PickerView

// Nombre de catégorie dans le pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Nombre de ligne dans le pickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerData count];
}

// Source de données pour le pickerView
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[pickerData objectAtIndex:row] objectForKey:@"noteName"];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToSaveFromHome"])
    {
        SaveWriteViewController *destViewController = segue.destinationViewController;
        destViewController.opinion = opinion;
    }
}
@end
