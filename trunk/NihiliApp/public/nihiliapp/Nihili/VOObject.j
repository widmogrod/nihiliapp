@import <Foundation/CPObject.j>

@implementation VOObject : CPObject

- (CPString)toJSON
{
	CPLog.debug([self class] + '::toJSON');

	var result = {};
	var ivarList = class_copyIvarList([self class]);
	for (var i = 0; i < ivarList.length; ++i)
	{
		var name = ivarList[i]['name'];
		if([name hasPrefix:@"__"])
			continue;

		var value = [self valueForKey:name];

		switch(true)
		{
			case @"null" == value:
			case [value isKindOfClass:[CPNull class]]:
				value = @"";
				break;

			// case [value isSubclassOfClass:[CPControl class]]:
			case [value isKindOfClass:[CPControl class]]:
			// console.log([value stringValue]);
				// value = [value objectValue];
				value = [value stringValue];
				break;
		}

		result[name] = encodeURIComponent(value);
	}

	CPLog.debug('RESULT:');
	CPLog.debug(result);

	return result;
}

- (CPString)toJSONString
{
	return JSON.stringify([self toJSON]);
}

@end