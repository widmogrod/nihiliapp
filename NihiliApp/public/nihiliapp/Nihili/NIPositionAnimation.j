@import <AppKit/CPAnimation.j>

/*
	Prosta animacja pozycji okna

*/
@implementation NIPositionAnimation : CPAnimation
{
	CPWindow _window;
	CGRect _start;
	CGRect _end;
}

- (id)initWithWindow:(CPWindow)aWindow
{
	self = [super initWithDuration:1.0 animationCurve:CPAnimationLinear];
	if(self)
	{
		if([aWindow respondsToSelector:@selector(frame)]){
			_window = aWindow;
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


	if (_end.origin.y != _start.origin.y || _end.origin.x != _start.origin.x)
	{
		var y = (progress * (_end.origin.y - _start.origin.y)) + _start.origin.y,
			x = (progress * (_end.origin.x - _start.origin.x)) + _start.origin.x;
		
		[_window setFrameOrigin:CGPointMake(x, y)];
	}
	
	if (_end.size.width  != _start.size.width || _end.size.height != _start.size.height) 
	{
		var width = (progress  * (_end.size.width  - _start.size.width))  + _start.size.width,
			height = (progress * (_end.size.height - _start.size.height)) + _start.size.height;	

		[_window setFrameSize:CGSizeMake(width, height)];
	}
}

- (void)setStart:(CGRect)aValue
{
	_start = aValue;
}

- (CGRect)start
{
	return _start;
}

- (void)setEnd:(CGRect)aValue
{
	_end = aValue;
}

- (CGRect)end
{
	return _end;
}

@end