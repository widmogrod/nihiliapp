<?php
class Application_Model_Nihili
{
	const QUERY_HTML = '.nihiliapp';
	
	public function __construct()
	{
		
	}

	/**
	 * @var Zend_Dom_Query
	 */
	protected $_domQuery;
	
	/**
	 * @return Zend_Dom_Query
	 */
	public function getDomQuery()
	{
		if(null === $this->_domQuery)
		{
			$this->_domQuery = new Zend_Dom_Query();
		}
		return $this->_domQuery;
	}
	
	/**
	 * @param string $html 
	 * @return array
	 */
	public function parseHtml($html)
	{
		$query = $this->getDomQuery();
		$query->setDocumentHtml($html);

		$elements = $query->query(self::QUERY_HTML);

		$document = $elements->getDocument();

		$result = array();
		
		while ($elements->valid()) 
		{
			$element = $elements->current();

			$data = array(
				'nodePath' => $element->getNodePath(),
				'tagName' => $element->tagName,
				'content' => null
			);

			switch ($element->tagName)
			{
				case 'h1':
				case 'h2':
				case 'h3':
				case 'h4':
				case 'h5':
				case 'h6':
					$data['content'] = $element->textContent;
					break;

				case 'a':
					if ($element->hasAttribute('href'))
					{
						$data['content'] = $element->getAttribute('href');
					}
					break;

				case 'img':
					if ($element->hasAttribute('src'))
					{
						$data['content'] = $element->getAttribute('src');
					}
					break;

				default:
					$data['content'] = $document->saveXML($element);
					break;
			}

			$result[] = $data;

			$elements->next();
		}

		return $result;
	}
}