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


	protected function setStatusSuccess()
	{
		$this->_status = self::SUCCESS;
	}

	protected function setStatusFailure()
	{
		$this->_status = self::FAILURE;
	}
	
	public function getStatus()
	{
		return $this->_status;
	}

	public function setResult($result)
	{
		$this->_result = $result;
	}
	
	public function getResult()
	{
		return $this->_result;
	}
	
	public function addMessage($message, $type = self::INFO)
	{
		$this->_messages[] = array(
			'type' => (string) $type,
			'message' => (string) $message
		);
	}
	
	public function getMessages()
	{
		return $this->_messages;
	}

	public function toArray()
	{
		return array(
			'status' => $this->getStatus(),
			'messages' => $this->getMessages(),
			'result' => $this->getResult()
		);
	}
	
	public function toJSON()
	{
		return Zend_Json::encode($this->toArray());
	}

	public function __toString()
	{
		return $this->toJSON();
	}
}
