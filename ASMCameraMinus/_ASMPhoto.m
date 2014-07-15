// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASMPhoto.m instead.

#import "_ASMPhoto.h"

const struct ASMPhotoAttributes ASMPhotoAttributes = {
	.address = @"address",
	.altitude = @"altitude",
	.filter1 = @"filter1",
	.filter2 = @"filter2",
	.filter3 = @"filter3",
	.filter4 = @"filter4",
	.filter5 = @"filter5",
	.height = @"height",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.weight = @"weight",
	.width = @"width",
};

const struct ASMPhotoRelationships ASMPhotoRelationships = {
	.faces = @"faces",
};

const struct ASMPhotoFetchedProperties ASMPhotoFetchedProperties = {
};

@implementation ASMPhotoID
@end

@implementation _ASMPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (ASMPhotoID*)objectID {
	return (ASMPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"altitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"altitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"filter1Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"filter1"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"filter2Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"filter2"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"filter3Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"filter3"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"filter4Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"filter4"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"filter5Value"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"filter5"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"widthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"width"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic address;






@dynamic altitude;



- (float)altitudeValue {
	NSNumber *result = [self altitude];
	return [result floatValue];
}

- (void)setAltitudeValue:(float)value_ {
	[self setAltitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAltitudeValue {
	NSNumber *result = [self primitiveAltitude];
	return [result floatValue];
}

- (void)setPrimitiveAltitudeValue:(float)value_ {
	[self setPrimitiveAltitude:[NSNumber numberWithFloat:value_]];
}





@dynamic filter1;



- (BOOL)filter1Value {
	NSNumber *result = [self filter1];
	return [result boolValue];
}

- (void)setFilter1Value:(BOOL)value_ {
	[self setFilter1:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFilter1Value {
	NSNumber *result = [self primitiveFilter1];
	return [result boolValue];
}

- (void)setPrimitiveFilter1Value:(BOOL)value_ {
	[self setPrimitiveFilter1:[NSNumber numberWithBool:value_]];
}





@dynamic filter2;



- (BOOL)filter2Value {
	NSNumber *result = [self filter2];
	return [result boolValue];
}

- (void)setFilter2Value:(BOOL)value_ {
	[self setFilter2:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFilter2Value {
	NSNumber *result = [self primitiveFilter2];
	return [result boolValue];
}

- (void)setPrimitiveFilter2Value:(BOOL)value_ {
	[self setPrimitiveFilter2:[NSNumber numberWithBool:value_]];
}





@dynamic filter3;



- (BOOL)filter3Value {
	NSNumber *result = [self filter3];
	return [result boolValue];
}

- (void)setFilter3Value:(BOOL)value_ {
	[self setFilter3:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFilter3Value {
	NSNumber *result = [self primitiveFilter3];
	return [result boolValue];
}

- (void)setPrimitiveFilter3Value:(BOOL)value_ {
	[self setPrimitiveFilter3:[NSNumber numberWithBool:value_]];
}





@dynamic filter4;



- (BOOL)filter4Value {
	NSNumber *result = [self filter4];
	return [result boolValue];
}

- (void)setFilter4Value:(BOOL)value_ {
	[self setFilter4:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFilter4Value {
	NSNumber *result = [self primitiveFilter4];
	return [result boolValue];
}

- (void)setPrimitiveFilter4Value:(BOOL)value_ {
	[self setPrimitiveFilter4:[NSNumber numberWithBool:value_]];
}





@dynamic filter5;



- (BOOL)filter5Value {
	NSNumber *result = [self filter5];
	return [result boolValue];
}

- (void)setFilter5Value:(BOOL)value_ {
	[self setFilter5:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFilter5Value {
	NSNumber *result = [self primitiveFilter5];
	return [result boolValue];
}

- (void)setPrimitiveFilter5Value:(BOOL)value_ {
	[self setPrimitiveFilter5:[NSNumber numberWithBool:value_]];
}





@dynamic height;



- (int16_t)heightValue {
	NSNumber *result = [self height];
	return [result shortValue];
}

- (void)setHeightValue:(int16_t)value_ {
	[self setHeight:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result shortValue];
}

- (void)setPrimitiveHeightValue:(int16_t)value_ {
	[self setPrimitiveHeight:[NSNumber numberWithShort:value_]];
}





@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic weight;



- (float)weightValue {
	NSNumber *result = [self weight];
	return [result floatValue];
}

- (void)setWeightValue:(float)value_ {
	[self setWeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result floatValue];
}

- (void)setPrimitiveWeightValue:(float)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithFloat:value_]];
}





@dynamic width;



- (int16_t)widthValue {
	NSNumber *result = [self width];
	return [result shortValue];
}

- (void)setWidthValue:(int16_t)value_ {
	[self setWidth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWidthValue {
	NSNumber *result = [self primitiveWidth];
	return [result shortValue];
}

- (void)setPrimitiveWidthValue:(int16_t)value_ {
	[self setPrimitiveWidth:[NSNumber numberWithShort:value_]];
}





@dynamic faces;

	
- (NSMutableSet*)facesSet {
	[self willAccessValueForKey:@"faces"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"faces"];
  
	[self didAccessValueForKey:@"faces"];
	return result;
}
	






@end
