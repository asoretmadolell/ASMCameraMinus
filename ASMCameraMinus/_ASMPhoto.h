// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMPhoto.h instead.

#import <CoreData/CoreData.h>
#import "ASMBaseEntity.h"

extern const struct ASMPhotoAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *altitude;
	__unsafe_unretained NSString *filter1;
	__unsafe_unretained NSString *filter2;
	__unsafe_unretained NSString *filter3;
	__unsafe_unretained NSString *filter4;
	__unsafe_unretained NSString *filter5;
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





@property (nonatomic, strong) NSNumber* filter1;



@property BOOL filter1Value;
- (BOOL)filter1Value;
- (void)setFilter1Value:(BOOL)value_;

//- (BOOL)validateFilter1:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* filter2;



@property BOOL filter2Value;
- (BOOL)filter2Value;
- (void)setFilter2Value:(BOOL)value_;

//- (BOOL)validateFilter2:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* filter3;



@property BOOL filter3Value;
- (BOOL)filter3Value;
- (void)setFilter3Value:(BOOL)value_;

//- (BOOL)validateFilter3:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* filter4;



@property BOOL filter4Value;
- (BOOL)filter4Value;
- (void)setFilter4Value:(BOOL)value_;

//- (BOOL)validateFilter4:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* filter5;



@property BOOL filter5Value;
- (BOOL)filter5Value;
- (void)setFilter5Value:(BOOL)value_;

//- (BOOL)validateFilter5:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSSet *faces;

- (NSMutableSet*)facesSet;





@end

@interface _ASMPhoto (CoreDataGeneratedAccessors)

- (void)addFaces:(NSSet*)value_;
- (void)removeFaces:(NSSet*)value_;
- (void)addFacesObject:(ASMFace*)value_;
- (void)removeFacesObject:(ASMFace*)value_;

@end

@interface _ASMPhoto (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSNumber*)primitiveAltitude;
- (void)setPrimitiveAltitude:(NSNumber*)value;

- (float)primitiveAltitudeValue;
- (void)setPrimitiveAltitudeValue:(float)value_;




- (NSNumber*)primitiveFilter1;
- (void)setPrimitiveFilter1:(NSNumber*)value;

- (BOOL)primitiveFilter1Value;
- (void)setPrimitiveFilter1Value:(BOOL)value_;




- (NSNumber*)primitiveFilter2;
- (void)setPrimitiveFilter2:(NSNumber*)value;

- (BOOL)primitiveFilter2Value;
- (void)setPrimitiveFilter2Value:(BOOL)value_;




- (NSNumber*)primitiveFilter3;
- (void)setPrimitiveFilter3:(NSNumber*)value;

- (BOOL)primitiveFilter3Value;
- (void)setPrimitiveFilter3Value:(BOOL)value_;




- (NSNumber*)primitiveFilter4;
- (void)setPrimitiveFilter4:(NSNumber*)value;

- (BOOL)primitiveFilter4Value;
- (void)setPrimitiveFilter4Value:(BOOL)value_;




- (NSNumber*)primitiveFilter5;
- (void)setPrimitiveFilter5:(NSNumber*)value;

- (BOOL)primitiveFilter5Value;
- (void)setPrimitiveFilter5Value:(BOOL)value_;




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





- (NSMutableSet*)primitiveFaces;
- (void)setPrimitiveFaces:(NSMutableSet*)value;


@end
