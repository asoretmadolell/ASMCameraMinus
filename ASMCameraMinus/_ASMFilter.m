// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMFilter.m instead.

#import "_ASMFilter.h"

const struct ASMFilterAttributes ASMFilterAttributes = {
	.filterName = @"filterName",
};

const struct ASMFilterRelationships ASMFilterRelationships = {
	.photo = @"photo",
};

const struct ASMFilterFetchedProperties ASMFilterFetchedProperties = {
};

@implementation ASMFilterID
@end

@implementation _ASMFilter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Filter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Filter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Filter" inManagedObjectContext:moc_];
}

- (ASMFilterID*)objectID {
	return (ASMFilterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic filterName;






@dynamic photo;

	






@end
