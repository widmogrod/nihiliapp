<?php
abstract class Application_Model_Response 
{
	// stałe określające rodzaj statusu
	const SUCCESS = "SUCCESS";
	const FAILURE = "FAILURE";
	
	// stałe określające rodzaj wiadomości
	const INFO = "INFO";
	const ERROR = "ERROR";
	const WARNING = "WARNING";

	/**
	 * @var string
	 */	
	protected $_status = self::SUCCESS;
	
	/**
	 * @var mixed
	 */	
	protected $_result;
	
	/**
	 * @var array
	 */	
	protected $_messages = array();

	/**
	 * @param string $status
	 * @return void
	 */
	protected function setStatus($status)
	{
		switch ($status)
		{
			case self::SUCCESS:
			case self::FAILURE:
				$this->_status = $status;
				break;
		}
	}

	/**
	 * @return void
	 */
	protected function setStatusSuccess()
	{
		$this->_status = self::SUCCESS;
	}

	/**
	 * @return void
	 */
	protected function setStatusFailure()
	{
		$this->_status = self::FAILURE;
	}
	
	/**
	 * @return string
	 */
	public function getStatus()
	{
		return $this->_status;
	}

	/**
	 * @param mixed $result
	 * @return void
	 */
	public function setResult($result)
	{
		$this->_result = $result;
	}
	
	/**
	 * @return mixed
	 */
	public function getResult()
	{
		return $this->_result;
	}
	
	/**
	 * @param string $message
	 * @param string $type
	 * @return void
	 */
	public function addMessage($message, $type = self::INFO, $inToMessage = null)
	{
	    $translate = $this->getTranslate();
	    if ($translate instanceof Zend_Translate) 
	    {
	        $message = $translate->_($message);
	        if (null !== $inToMessage) 
	        {
	            $message = vsprintf($message, (array) $inToMessage);
	        }
	    }
	    
	    
		$this->_messages[] = array(
			'type' => (string) $type,
			'message' => (string) $message
		);
	}
	
	/**
	 * @return array
	 */
	public function getMessages()
	{
		return $this->_messages;
	}
	
	/**
	 * @var Zend_Translate
	 */
	protected $_translate;
	
	/**
	 * @return Zend_Translate
	 */
	public function getTranslate()
	{
	    
	    if (null === $this->_translate) {
	        $this->_translate = Zend_Registry::get(Zend_Application_Resource_Translate::DEFAULT_REGISTRY_KEY);
	    }
	    
	    return $this->_translate;
	}

	/**
	 * Logowanie wyjątków
	 * TODO Dodać logowanie na mail lub do logów, obecne działanie jest tymczasowe
	 * 
	 * @param Exception $e
	 */
	public function logException(Exception $e) 
	{
	    $this->addMessage($e->getMessage(), self::ERROR);
	}
	
	/**
	 * @return array
	 */
	public function toArray()
	{
		return array(
			'status' => $this->getStatus(),
			'messages' => $this->getMessages(),
			'result' => $this->getResult()
		);
	}
	
	/**
	 * @return string
	 */
	public function toJSON()
	{
		return Zend_Json::encode($this->toArray());
	}

	/**
	 * @return string
	 */
	public function __toString()
	{
		return $this->toJSON();
	}
}
