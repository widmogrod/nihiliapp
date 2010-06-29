<?php
class Application_Model_Connection extends Application_Model_Response
{
	protected $_ftp;
	
	protected $_data = array();

	public function __construct(array $data) 
	{
		$protocol = isset($data['protocol']) ? $data['protocol'] : @$data['server'];
		
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
			$result = $this->_ftp->ls(@$this->_data['path'], true);
			$this->setStatus(self::SUCCESS);
		} catch(Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);
		}

		$this->setResult($result);
	}
}

