// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMPhoto.h instead.

#import <CoreData/CoreData.h>
#import "ASMBaseEntity.h"

extern const struct ASMPhotoAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *altitude;
	__unsafe_unretained NSString *height;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *weight;
	__unsafe_unretained NSString *width;
} ASMPhotoAttributes;

extern const struct ASMPhotoRelationships {
	__unsafe_unretained NSString *faces;
} ASMPhotoRelationships;

extern const struct ASMPhotoFetchedProperties {
} ASMPhotoFetchedProperties;

@class ASMFace;









@interface ASMPhotoID : NSManagedObjectID {}
@end

@interface _ASMPhoto : ASMBaseEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ASMPhotoID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* altitude;



@property float altitudeValue;
- (float)altitudeValue;
- (void)setAltitudeValue:(float)value_;

//- (BOOL)validateAltitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* height;



@property int16_t heightValue;
- (int16_t)heightValue;
- (void)setHeightValue:(int16_t)value_;

//- (BOOL)validateHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weight;



@property float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* width;



@property int16_t widthValue;
- (int16_t)widthValue;
- (void)setWidthValue:(int16_t)value_;

//- (BOOL)validateWidth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ASMFace *faces;

//- (BOOL)validateFaces:(id*)value_ error:(NSError**)error_;





@end

@interface _ASMPhoto (CoreDataGeneratedAccessors)

@end

@interface _ASMPhoto (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSNumber*)primitiveAltitude;
- (void)setPrimitiveAltitude:(NSNumber*)value;

- (float)primitiveAltitudeValue;
- (void)setPrimitiveAltitudeValue:(float)value_;




- (NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(NSNumber*)value;

- (int16_t)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(int16_t)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;




- (NSNumber*)primitiveWidth;
- (void)setPrimitiveWidth:(NSNumber*)value;

- (int16_t)primitiveWidthValue;
- (void)setPrimitiveWidthValue:(int16_t)value_;





- (ASMFace*)primitiveFaces;
- (void)setPrimitiveFaces:(ASMFace*)value;


@end
