// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMFace.h instead.

#import <CoreData/CoreData.h>


extern const struct ASMFaceAttributes {
	__unsafe_unretained NSString *faceRect;
	__unsafe_unretained NSString *leftEye;
	__unsafe_unretained NSString *mouth;
	__unsafe_unretained NSString *rightEye;
} ASMFaceAttributes;

extern const struct ASMFaceRelationships {
	__unsafe_unretained NSString *photo;
} ASMFaceRelationships;

extern const struct ASMFaceFetchedProperties {
} ASMFaceFetchedProperties;

@class ASMPhoto;






@interface ASMFaceID : NSManagedObjectID {}
@end

@interface _ASMFace : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ASMFaceID*)objectID;





@property (nonatomic, strong) NSString* faceRect;



//- (BOOL)validateFaceRect:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* leftEye;



//- (BOOL)validateLeftEye:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mouth;



//- (BOOL)validateMouth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* rightEye;



//- (BOOL)validateRightEye:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ASMPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;





@end

@interface _ASMFace (CoreDataGeneratedAccessors)

@end

@interface _ASMFace (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFaceRect;
- (void)setPrimitiveFaceRect:(NSString*)value;




- (NSString*)primitiveLeftEye;
- (void)setPrimitiveLeftEye:(NSString*)value;




- (NSString*)primitiveMouth;
- (void)setPrimitiveMouth:(NSString*)value;




- (NSString*)primitiveRightEye;
- (void)setPrimitiveRightEye:(NSString*)value;





- (ASMPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(ASMPhoto*)value;


@end
