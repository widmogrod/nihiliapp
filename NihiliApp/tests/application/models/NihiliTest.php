<?php
require_once '../bootstrap.php';
require_once 'PHPUnit/Framework/TestCase.php';

require_once '../../../application/models/Nihili.php';

class ModelNihiliTest extends PHPUnit_Framework_TestCase
{
	public function setUp()
	{
		
	}

	public function tearDown()
	{
		
	}

	public function testConnstruct()
	{
		$html = file_get_contents('resources/site.html');
		$nihili = new Application_Model_Nihili();
		$nihili->parseHtml($html);
	}
}