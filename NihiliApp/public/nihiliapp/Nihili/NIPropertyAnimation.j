@import <AppKit/CPAnimation.j>

/*
	Prosta animacja różnych właności CPView
	- width & height
	- size
	- alphaValue
*/
@implementation NIPropertyAnimation : CPAnimation
{
	CPView _view;
	CPString _keyPath;

	CPValue _start;
	CPValue _end;
}

- (id)initWithView:(CPView)aView property:(NSString)keyPath
{
	self = [super initWithDuration:1.0 animationCurve:CPAnimationLinear];
	if(self)
	{
		if([aView respondsToSelector:keyPath]){
			_view = aView;
			_keyPath = keyPath;
		} else {
			return null;
		}
	}

	return self;
}

- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];

	progress = [self currentValue];

	if(_keyPath == 'width' || _keyPath == 'height')
        progress = (progress * (_end - _start)) + _start;
    else if(_keyPath == 'size')
        progress = CGSizeMake((progress * (_end.width - _start.width)) + _start.width, (progress * (_end.height - _start.height)) + _start.height);
	else if(_keyPath == 'alphaValue')
		progress = (progress * (_end - _start)) + _start;
        
	[_view setValue:progress forKey:_keyPath];
}

- (void)setStart:(id)aValue
{
	_start = aValue;
}

- (id)start
{
	return _start;
}

- (void)setEnd:(id)aValue
{
	_end = aValue;
}

- (id)end
{
	return _end;
}

@end