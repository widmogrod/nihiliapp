@import <AppKit/CPView.j>
@import <AppKit/CPImage.j>
@import <AppKit/CPImageView.j>


var NIDefaultFileType = @"blank",
	NIDefaultImageExtension = @"png";
	

@implementation NIFileExplorerFileDataView : CPView
{
	CPString filename @accessors;
	CPString _filetype;
	CPString imageExtension @accessors;
	
	CPImage image;
	CPImageView imageView @accessors;
	CPTextField textField @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
	if(self)
	{
		[self setImageExtension:NIDefaultImageExtension];

		imageView = [[CPImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(aFrame), CGRectGetMinY(aFrame), 16,16)];
		[imageView setImageScaling: CPScaleProportionally];
		//[imageView setImageAlignment: CPImageAlignLeft];
		[self addSubview: imageView];
		
		textField = [[CPTextField alloc] initWithFrame: CGRectMake(CGRectGetMinX(aFrame) + 20, CGRectGetMinY(aFrame), CGRectGetWidth(aFrame) - 20, CGRectGetHeight(aFrame))];
		[self addSubview: textField];
	}
	return self;
}

/*
	Inichowanie wyświetlenia komórki w tabeli
*/
- (void)setObjectValue:(CPString)aValue
{	
	[self setFilename:aValue];
	[[self textField] setObjectValue: aValue];
	[[self textField] sizeToFit];
	[self initImage];
}

- (void)initImage
{
	var image = [[CPImage alloc] initWithContentsOfFile:[self imageFilepath] size:CGSizeMake(16.0, 16.0)];
	[[self imageView] setImage: image];
}

/*
	Ustawienie typu pliku nie jest wymagane.
	Jeżeli nie zostanie ustawiony typ pliku,
	wartość zostanie określona z jego rozszeżenia.
*/
- (void)setFiletype:(CPString)aFiletype
{
	CPLog.debug(@"setFiletype");
	CPLog.trace(_filetype);
	_filetype = aFiletype;
}

- (void)setFiletype:(CPString)aFiletype withImageExtension:(CPString)anImageExtension
{
	[self setFiletype:aFiletype];
	[self setImageExtension:anImageExtension];
}

/*
	Pobieranie wartości typu pliku.
	Typ pliku jest określany na podstawie jego rozszeżenia.
*/
- (CPString)filetype
{
	CPLog.trace(_filetype);
	if (!_filetype)
	{
		_filetype = [[[self filename] pathExtension] lowercaseString];
		if (!_filetype) {
			_filetype = NIDefaultFileType;
		}
	}

	return _filetype;
}

/*
	Scieżka do pliku graficznego
*/
- (CPString)imageFilepath
{
	var filename = [self filetype] + @"." + [self imageExtension];
	filepath = [[CPBundle bundleForClass:[self class]] pathForResource:filename];
	return filepath;
}

@end



var NIFileExplorerFileDataViewImageView = @"NIFileExplorerFileDataViewImageView",
	NIFileExplorerFileDataViewTextField = @"NIFileExplorerFileDataViewTextField",
	NIFileExplorerFileDataViewImageExtension = @"NIFileExplorerFileDataViewImageExtension",
	NIFileExplorerFileDataViewFiletype = @"NIFileExplorerFileDataViewFiletype",
	NIFileExplorerFileDataViewFilename = @"NIFileExplorerFileDataViewFilename";


@implementation NIFileExplorerFileDataView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self setImageView:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewImageView]];
		[self setTextField:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewTextField]];
		[self setImageExtension:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewImageExtension]];
		[self setFiletype:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewFiletype]];
		// [self setFilename:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewFilename]];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[self imageView] forKey:NIFileExplorerFileDataViewImageView];
	[aCoder encodeObject:[self textField] forKey:NIFileExplorerFileDataViewTextField];
	[aCoder encodeObject:[self imageExtension] forKey:NIFileExplorerFileDataViewImageExtension];
	[aCoder encodeObject:[self filetype] forKey:NIFileExplorerFileDataViewFiletype];
	// [aCoder encodeObject:[self filename] forKey:NIFileExplorerFileDataViewFilename];
}

@end