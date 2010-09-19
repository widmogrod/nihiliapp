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
	
	BOOL _imageDidError;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
	if(self)
	{
		_imageDidError = NO;
	
		[self setImageExtension:NIDefaultImageExtension];

		imageView = [[CPImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(aFrame), CGRectGetMinY(aFrame) + 2, 16,16)];
		[imageView setImageScaling: CPScaleProportionally];
		//[imageView setImageAlignment: CPImageAlignLeft];
		[self addSubview: imageView];
		
		textField = [[CPTextField alloc] initWithFrame: CGRectMake(CGRectGetMinX(aFrame) + 20, CGRectGetMinY(aFrame) + 2, CGRectGetWidth(aFrame) - 20, CGRectGetHeight(aFrame))];
		[self addSubview: textField];
	}
	return self;
}

/*
	Inichowanie wyświetlenia komórki w tabeli
*/
- (void)setObjectValue:(CPString)aValue
{	
	CPLog.debug("OutlineView ustawia wartość: " + aValue);
	
	[self setFilename:aValue];
	[[self textField] setObjectValue: aValue];
	[[self textField] sizeToFit];
	[self initImage];
}

- (void)initImage
{
	var image = [[CPImage alloc] initWithContentsOfFile:[self imageFilepath] size:CGSizeMake(16.0, 16.0)];
	[image setDelegate:self];
	[[self imageView] setImage: image];
}

/*
	W przypadku gdy nie została znaleziona ikona reprezentująca rozszeżenie do pliku,
	wczytywana jest domyślna ikona. 
*/
- (void)imageDidError:(id)aImage
{
	CPLog.warn(@"imageDidError, filename: " + [aImage filename]);
	
	if (_imageDidError)
		return;

	_imageDidError = YES;
	
	CPLog.info(@"Wczytaj kolejną grafikę");
		
	[self setFiletype:NIDefaultFileType withImageExtension:NIDefaultImageExtension];
	[self initImage];
}

/*
	Ustawienie typu pliku nie jest wymagane.
	Jeżeli nie zostanie ustawiony typ pliku,
	wartość zostanie określona z jego rozszeżenia.
*/
- (void)setFiletype:(CPString)aFiletype
{
	CPLog.debug(@"Ustawiam wartość setFiletype: " + aFiletype);
	_filetype = aFiletype;
}

- (void)setFiletype:(CPString)aFiletype withImageExtension:(CPString)anImageExtension
{
	CPLog.debug(@"Ustawiam wartość setFiletype: "+ aFiletype +" withImageExtension: " + anImageExtension);
	[self setFiletype:aFiletype];
	[self setImageExtension:anImageExtension];
}

/*
	Pobieranie wartości typu pliku.
	Typ pliku jest określany na podstawie jego rozszeżenia.
*/
- (CPString)filetype
{
	CPLog.debug(@"Pobieram typ pliku: " + _filetype);
	
	if (_imageDidError)
		return _filetype;

	/* 
		tylko pliki mogą mieć dynamiczne ikony
	 	- folder - jest folderem
		- spinner - jest typem specjalnym pokazującym się podczas wczytywania plików
	*/
	if (_filetype != @"folder" && _filetype != @"spinner") 
	{
		_filetype = [[[self filename] pathExtension] lowercaseString];
		if (!_filetype) {
			_filetype = NIDefaultFileType;
		}
	}
	
	CPLog.debug(@"Ostatecznie zwracany typ pliku: " + _filetype);

	return _filetype;
}

/*
	Scieżka do pliku graficznego
*/
- (CPString)imageFilepath
{
	var filename = [self filetype] + @"." + [self imageExtension];
	
	CPLog.debug("Wczytuję grafikę: " + filename);
	
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
		[self setFilename:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewFilename]];
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
	[aCoder encodeObject:[self filename] forKey:NIFileExplorerFileDataViewFilename];
}

@end