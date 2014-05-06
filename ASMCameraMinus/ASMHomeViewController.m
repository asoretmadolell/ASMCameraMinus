//
//  ASMHomeViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMHomeViewController.h"
#import "ASMPhotoCell.h"
#import "ASMListViewController.h"
#import "ASMInfoViewController.h"

@interface ASMHomeViewController () {
    NSMutableArray *myPhotosArray;
}

@end

@implementation ASMHomeViewController

/*
 Este método devuelve un ViewController inicializado con el
 fichero nib (también conocido como xib) en el bundle. También
 nombre del fichero. Por eso, para la celda, había que hacer
 un registerNib :-)
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = @"Camera Minus";
    }
    return self;
}

/*
 A este método se le llama justo antes de que se empiece a
 cargar cualquier vista. Por tanto, aquí conviene implementar
 todo aquello que tenga que ver con mostrar la vista.
*/
- (void)viewWillAppear:(BOOL)animated
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.shootButton.enabled = YES;
    }
}

/*
 Este método es llamado después de que se haya cargado la vista.
 Por eso inicializamos aquí las vistas que metimos en el xib,
 además de inicializar el controlador de mi celdita.
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.photosCV.delegate = self;
    self.photosCV.dataSource = self;
    self.photosCV.allowsMultipleSelection = YES;
    
    myPhotosArray = [[NSMutableArray alloc]init];
    
    // Thanks to our friends at U-Tad, we're unable to use their iPad devices at home... So we'll just init the array with some images.
    [myPhotosArray addObject:[UIImage imageNamed:@"c3po.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"darthVader.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"c3po.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"darthVader.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"darthVader.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"darthVader.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    
    [self.photosCV registerNib:[UINib nibWithNibName:@"ASMPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
    if (myPhotosArray.count == 0) self.listButton.enabled = NO;
    
    self.editButton.enabled = NO;
}

/*
 Este método es llamado por el sistema cuando éste considera
 que la cantidad de memoria disponible es baja.
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Si el usuario pulsa el botón list UIKit llama a este método.
 Se crea una nueva pantalla que se añade a la navegación y
 que mostrará las fotos en formato tabla
*/
- (IBAction)list:(id)sender
{
    ASMListViewController *listVC = [[ASMListViewController alloc] initWithModel:myPhotosArray];
    [self.navigationController pushViewController:listVC animated:NO];
}

/*
 A este método se le llama cuando el usuario pulsa el botón "Edit"
 con una imagen seleccionada. Se creará una nueva pantalla que se
 añadirá a la navegación y que mostrará la imagen en pantalla
 completa con los cinco filtrillos a aplicar.
*/
- (IBAction)edit:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    ASMPhotoCell *cell = (ASMPhotoCell*)[self.photosCV cellForItemAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:cell.image.image];
    [self.navigationController pushViewController:infoVC animated:YES];
}

/*
 A este método se le llama cuando el usuario pulsa el botón "Shoot"
 para cascar una foto.
*/
- (IBAction)shoot:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pc_shoot = [[UIImagePickerController alloc] init];
        pc_shoot.delegate = self;
        pc_shoot.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pc_shoot animated:YES completion:nil];
    }
    
    // okay, we really don't need any of this code right here...
//    // this checks if the device has a camera
//    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    // this checks if the device has front and rear camera
//    BOOL hasFrontCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
//    BOOL hasRearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
//    // this specifies which camera to use
//    pc_shoot.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}

/*
 A este método se le llama cuando el usuario pulsa el botón "Social",
 y la idea inicial es que salga un PopOver con los tres botones distintos.
*/
- (IBAction)social:(id)sender {
}

/*
 A este método se le llama cuando el usuario pulsa el botón "Delete",
 y lo que hace es borrar las imágenes seleccionadas después de confirmarlo
 en el ActionSheet.
*/
- (IBAction)delete:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    
    NSString *actionSheetTitle = [[NSString alloc] init];
    
    if (selectedItems.count == 1)
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete this image?"];
    }
    else
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete these %lu images?", (unsigned long)selectedItems.count];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
                                                             delegate:self
                                                    cancelButtonTitle:@"Yup"
                                               destructiveButtonTitle:@"Nope"
                                                    otherButtonTitles:nil];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - picker view delegate methods

/*
 Este método lo llama la cámara después de haber cascado la foto.
*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [myPhotosArray addObject:image];
    if (myPhotosArray.count == 1) self.listButton.enabled = YES;
    [self.photosCV reloadData];
}

#pragma mark - collection view flow layout delegate methods

/*
Este método del protocolo UICollectionViewLayout lo llama la Colletion View
para saber el tamaño que de aplicar a cada celda
*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

#pragma mark - collection view data source delegate methods

/*
Este método del protocolo UICollectionViewLayout lo llama la Colletion View
 para saber el número de secciones que contendrá la Collection View.
*/
// This code isn't necessary if we're using only 1 section
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/*
 Este método define la cantidad de ítems (celdas) que tiene el
 CollectionView. Vamos, el total de ítems del array de fotos.
*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return myPhotosArray.count;
}

/*
 Este método devuelve la celda ya visible en el indexPath especificado,
 por tanto, dentro creamos mi celdita, y dentro de ésta ponemos
 la imagen que toque, además de distinguir las que estén seleccionadas
 de las que no.
*/
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.image.image = [myPhotosArray objectAtIndex:indexPath.item];
    
    if (cell.selected)
    {
        cell.backgroundColor = [UIColor blueColor];
    }
    else
    {
        cell.backgroundColor = [UIColor blackColor];
    }
//    // By the way, this is another way of doing the same thing:
//    cell.backgroundColor = ( cell.selected ) ? [UIColor blueColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark - collection view delegate methods

/*
 Este método se ejecuta cuando se pincha en un elemento del Collection
 View, independientemente de si la selección múltiple está habilitada
 o no.
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    // These indicate which section and item has been selected (mainly for debugging matters, because otherwise this crappy debugger won't tell us)
//    long sectionID = indexPath.section;
//    long itemID = indexPath.item;

    self.editButton.enabled = ( [self.photosCV indexPathsForSelectedItems].count == 1);
//    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
//    if( selectedItems.count == 1 )
//    {
//        self.editButton.enabled = YES;
//    }
//    else
//    {
//        self.editButton.enabled = NO;
//    }
    
    self.deleteButton.enabled = YES;
    
    UICollectionViewCell* cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
}

/*
 Este método se ejecuta cuando se anula la selección de un elemento
 del CollectionView. Esto es, si la selección múltiple está habilitada,
 cuando se pincha en un elemento seleccionado, o si está deshabilitada,
 cuando un elemento deja de estarlo por haber pinchado otro.
*/
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    // These indicate which section and item has been selected (mainly for debugging matters)
//    long sectionID = indexPath.section;
//    long itemID = indexPath.item;
    
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    if( selectedItems.count == 1 )
    {
        self.editButton.enabled = YES;
    }
    else
    {
        self.editButton.enabled = NO;
    }
    
    self.deleteButton.enabled = YES;
    
    if( [self.photosCV indexPathsForSelectedItems].count == 0 ) self.deleteButton.enabled = NO;

    UICollectionViewCell *cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
}

#pragma mark - action sheet delegate methods

/*
 Este método lo llama el ActionSheet que hemos creado para preguntar
 al usuario que si está seguro de que quiere borrar las fotos.
 Nos devuelve un número, 0 para cancelar, 1 para aceptar.
*/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
        NSArray *sortSelectedItems = [selectedItems sortedArrayWithOptions:0 usingComparator:^NSComparisonResult( id obj1, id obj2 )
        {
            if( ((NSIndexPath*)obj1).item > ( (NSIndexPath*)obj2).item) return (NSComparisonResult)NSOrderedAscending;
            if( ((NSIndexPath*)obj1).item < ( (NSIndexPath*)obj2).item) return (NSComparisonResult)NSOrderedDescending;
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        for (NSIndexPath *indexPath in sortSelectedItems)
        {
            [myPhotosArray removeObjectAtIndex:indexPath.item];
        }
        
        [self.photosCV reloadData];
        
        self.deleteButton.enabled = NO;
        
        if (myPhotosArray.count == 0) self.listButton.enabled = NO;
    }
}

@end
