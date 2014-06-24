// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMFace.m instead.

#import "_ASMFace.h"

const struct ASMFaceAttributes ASMFaceAttributes = {
	.faceRect = @"faceRect",
	.leftEye = @"leftEye",
	.mouth = @"mouth",
	.rightEye = @"rightEye",
};

const struct ASMFaceRelationships ASMFaceRelationships = {
	.photo = @"photo",
};

const struct ASMFaceFetchedProperties ASMFaceFetchedProperties = {
};

@implementation ASMFaceID
@end

@implementation _ASMFace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Face" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Face";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Face" inManagedObjectContext:moc_];
}

- (ASMFaceID*)objectID {
	return (ASMFaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic faceRect;






@dynamic leftEye;






@dynamic mouth;






@dynamic rightEye;






@dynamic photo;

	






@end
