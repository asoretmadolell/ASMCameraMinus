#import "_ASMFace.h"

@interface ASMFace : _ASMFace {}
// Custom logic goes here.

+(instancetype)faceWithPhoto:(ASMPhoto*)photo inContext:(NSManagedObjectContext*)context;

@end
