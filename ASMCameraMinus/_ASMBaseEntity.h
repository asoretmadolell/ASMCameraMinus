// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMBaseEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct ASMBaseEntityAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *modifiedDate;
	__unsafe_unretained NSString *name;
} ASMBaseEntityAttributes;

extern const struct ASMBaseEntityRelationships {
} ASMBaseEntityRelationships;

extern const struct ASMBaseEntityFetchedProperties {
} ASMBaseEntityFetchedProperties;






@interface ASMBaseEntityID : NSManagedObjectID {}
@end

@interface _ASMBaseEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ASMBaseEntityID*)objectID;





@property (nonatomic, strong) NSDate* creationDate;



//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* modifiedDate;



//- (BOOL)validateModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _ASMBaseEntity (CoreDataGeneratedAccessors)

@end

@interface _ASMBaseEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;




- (NSDate*)primitiveModifiedDate;
- (void)setPrimitiveModifiedDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
