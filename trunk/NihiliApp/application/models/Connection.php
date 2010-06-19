<?php
class Application_Model_Connection extends Application_Model_Response
{
	protected $_ftp;
	
	protected $_data = array();

	public function __construct(array $data) 
	{
		$connectionType = isset($data['connectionType']) ? $data['connectionType'] : @$data['server'];
		
		try {
			$this->_ftp = KontorX_Ftp::factory($connectionType, $data);
			$this->setStatus(self::SUCCESS);
		} catch(KontorX_Ftp_Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);		
		}
	}

	public function ls()
	{
		$resutl = array();

		try {
			$resutl = $this->_ftp->ls(@$this->_data['path']);
			$this->setStatus(self::SUCCESS);
		} catch(KontorX_Ftp_Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);
		}

		$this->setResult($result);
	}
}

