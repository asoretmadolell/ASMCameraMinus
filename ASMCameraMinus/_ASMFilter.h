// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMFilter.h instead.

#import <CoreData/CoreData.h>


extern const struct ASMFilterAttributes {
	__unsafe_unretained NSString *filterName;
} ASMFilterAttributes;

extern const struct ASMFilterRelationships {
	__unsafe_unretained NSString *photo;
} ASMFilterRelationships;

extern const struct ASMFilterFetchedProperties {
} ASMFilterFetchedProperties;

@class ASMPhoto;



@interface ASMFilterID : NSManagedObjectID {}
@end

@interface _ASMFilter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ASMFilterID*)objectID;





@property (nonatomic, strong) NSString* filterName;



//- (BOOL)validateFilterName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) ASMPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;





@end

@interface _ASMFilter (CoreDataGeneratedAccessors)

@end

@interface _ASMFilter (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFilterName;
- (void)setPrimitiveFilterName:(NSString*)value;





- (ASMPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(ASMPhoto*)value;


@end
