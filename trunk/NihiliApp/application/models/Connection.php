<?php
class Application_Model_Connection extends Application_Model_Response
{
	protected $_ftp;
	
	protected $_data = array();

	public function __construct(array $data) 
	{
		$this->_data = $data;

		$protocol = isset($data['protocol']) ? $data['protocol'] : @$data['server'];
		$protocol = strtolower($protocol);
		
		try {
			$this->_ftp = KontorX_Ftp::factory($protocol, $data);
			$this->setStatus(self::SUCCESS);
		} catch(Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);		
		}
	}

	public function test()
	{
		if (!$this->_ftp)
			return;

		$result = array();

		try {
			$result = $this->_ftp->getAdapter()->connect();
			$this->setStatus(self::SUCCESS);
			$this->addMessage('Połączenie zostało nazwiązane', self::INFO);
		} catch(Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);
		}

		$this->setResult($result);
	}

	public function ls()
	{
		if (!$this->_ftp)
			return;

		$result = array();

		try {
			$this->addMessage($this->_data['pathname']);
			$result = $this->_ftp->ls(@$this->_data['pathname'], true);
			$this->setStatus(self::SUCCESS);
		} catch(Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);
		}

		$this->setResult($result);
	}
}

