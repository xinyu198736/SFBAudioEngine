/*
 * Copyright (c) 2010 - 2020 Stephen F. Booth <me@sbooth.org>
 * See https://github.com/sbooth/SFBAudioEngine/blob/master/LICENSE.txt for license information
 */

#import "SFBDataInputSource.h"
#import "SFBFileContentsInputSource.h"
#import "SFBFileInputSource.h"
#import "SFBHTTPInputSource.h"
#import "SFBInputSource+Internal.h"
#import "SFBMemoryMappedFileInputSource.h"

@implementation SFBInputSource

+ (instancetype)inputSourceForURL:(NSURL *)url flags:(SFBInputSourceFlags)flags error:(NSError **)error
{
	if(url == nil)
		return nil;

	if(url.isFileURL) {
		if(flags & SFBInputSourceFlagsMemoryMapFiles)
			return [[SFBMemoryMappedFileInputSource alloc] initWithURL:url error:error];
		else if(flags & SFBInputSourceFlagsLoadFilesInMemory)
			return [[SFBFileContentsInputSource alloc] initWithContentsOfURL:url error:error];
		else
			return [[SFBFileInputSource alloc] initWithURL:url error:error];
	}
	else if([url.scheme.lowercaseString hasPrefix:@"http"])
		return [[SFBHTTPInputSource alloc] initWithURL:url error:error];

	return nil;
}

+ (instancetype)inputSourceWithBytes:(const void *)bytes length:(NSInteger)length error:(NSError **)error
{
	if(bytes == NULL || length <= 0)
		return nil;

	return [[SFBDataInputSource alloc] initWithBytes:bytes length:length];
}

+ (instancetype)inputSourceWithBytesNoCopy:(void *)bytes length:(NSInteger)length error:(NSError **)error
{
	if(bytes == NULL || length <= 0)
		return nil;

	return [[SFBDataInputSource alloc] initWithBytesNoCopy:bytes length:length];
}

- (BOOL)openReturningError:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)closeReturningError:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)isOpen
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)readBytes:(void *)buffer length:(NSInteger)length bytesRead:(NSInteger *)bytesRead error:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)getOffset:(NSInteger *)offset error:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)getLength:(NSInteger *)length error:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)supportsSeeking
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

- (BOOL)seekToOffset:(NSInteger)offset error:(NSError **)error
{
	[self doesNotRecognizeSelector:_cmd];
	__builtin_unreachable();
}

@end

@implementation SFBInputSource (SFBSignedIntegerReading)
- (BOOL)readInt8:(int8_t *)i8 error:(NSError **)error			{ return [self readUInt8:(uint8_t *)i8 error:error]; }
- (BOOL)readInt16:(int16_t *)i16 error:(NSError **)error		{ return [self readUInt16:(uint16_t *)i16 error:error]; }
- (BOOL)readInt32:(int32_t *)i32 error:(NSError **)error		{ return [self readUInt32:(uint32_t *)i32 error:error]; }
- (BOOL)readInt64:(int64_t *)i64 error:(NSError **)error		{ return [self readUInt64:(uint64_t *)i64 error:error]; }
@end

@implementation SFBInputSource (SFBUnsignedIntegerReading)
- (BOOL)readUInt8:(uint8_t *)ui8 error:(NSError **)error
{
	NSInteger bytesRead;
	return [self readBytes:ui8 length:sizeof(ui8) bytesRead:&bytesRead error:error] && bytesRead == sizeof(ui8);
}

- (BOOL)readUInt16:(uint16_t *)ui16 error:(NSError **)error
{
	NSInteger bytesRead;
	return [self readBytes:ui16 length:sizeof(ui16) bytesRead:&bytesRead error:error] && bytesRead == sizeof(ui16);
}

- (BOOL)readUInt32:(uint32_t *)ui32 error:(NSError **)error
{
	NSInteger bytesRead;
	return [self readBytes:ui32 length:sizeof(ui32) bytesRead:&bytesRead error:error] && bytesRead == sizeof(ui32);
}

- (BOOL)readUInt64:(uint64_t *)ui64 error:(NSError **)error
{
	NSInteger bytesRead;
	return [self readBytes:ui64 length:sizeof(ui64) bytesRead:&bytesRead error:error] && bytesRead == sizeof(ui64);
}

@end

@implementation SFBInputSource (SFBBigEndianReading)

- (BOOL)readUInt16BigEndian:(uint16_t *)ui16 error:(NSError * _Nullable *)error
{
	if(![self readUInt16:ui16 error:error])
		return NO;
	*ui16 = OSSwapHostToBigInt16(*ui16);
	return YES;
}

- (BOOL)readUInt32BigEndian:(uint32_t *)ui32 error:(NSError * _Nullable *)error
{
	if(![self readUInt32:ui32 error:error])
		return NO;
	*ui32 = OSSwapHostToBigInt32(*ui32);
	return YES;
}

- (BOOL)readUInt64BigEndian:(uint64_t *)ui64 error:(NSError * _Nullable *)error
{
	if(![self readUInt64:ui64 error:error])
		return NO;
	*ui64 = OSSwapHostToBigInt64(*ui64);
	return YES;
}

@end

@implementation SFBInputSource (SFBLittleEndianReading)

- (BOOL)readUInt16LittleEndian:(uint16_t *)ui16 error:(NSError * _Nullable *)error
{
	if(![self readUInt16:ui16 error:error])
		return NO;
	*ui16 = OSSwapHostToLittleInt16(*ui16);
	return YES;
}

- (BOOL)readUInt32LittleEndian:(uint32_t *)ui32 error:(NSError * _Nullable *)error
{
	if(![self readUInt32:ui32 error:error])
		return NO;
	*ui32 = OSSwapHostToLittleInt32(*ui32);
	return YES;
}

- (BOOL)readUInt64LittleEndian:(uint64_t *)ui64 error:(NSError * _Nullable *)error
{
	if(![self readUInt64:ui64 error:error])
		return NO;
	*ui64 = OSSwapHostToLittleInt64(*ui64);
	return YES;
}

@end
