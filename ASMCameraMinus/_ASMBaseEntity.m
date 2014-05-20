// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMBaseEntity.m instead.

#import "_ASMBaseEntity.h"

const struct ASMBaseEntityAttributes ASMBaseEntityAttributes = {
	.creationDate = @"creationDate",
	.modifiedDate = @"modifiedDate",
	.name = @"name",
};

const struct ASMBaseEntityRelationships ASMBaseEntityRelationships = {
};

const struct ASMBaseEntityFetchedProperties ASMBaseEntityFetchedProperties = {
};

@implementation ASMBaseEntityID
@end

@implementation _ASMBaseEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BaseEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BaseEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BaseEntity" inManagedObjectContext:moc_];
}

- (ASMBaseEntityID*)objectID {
	return (ASMBaseEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic creationDate;






@dynamic modifiedDate;






@dynamic name;











@end
