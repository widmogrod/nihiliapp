<?php
class Application_Model_Connections extends Application_Model_Response
{
	/**
	 * @var KontorX_Ftp
	 */
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

	public function connectionsList()
	{
		$result = array();

		$connection = Doctrine_Core::getTable('Connection');

		try {
			$result = $connection->findAll(Doctrine_Core::HYDRATE_ARRAY);
			$this->setStatus(self::SUCCESS);
		} catch(Exception $e) {
			$this->setStatus(self::FAILURE);
			$this->addMessage($e->getMessage(), self::ERROR);
		}

		$this->setResult($result);
	}

	public function get()
	{
		$this->setStatus(self::FAILURE);
		$this->addMessage('TODO: ' . __METHOD__, self::ERROR);
	}
	
	public function add() 
	{
		$this->setStatus(self::FAILURE);
		$this->addMessage('TODO: ' . __METHOD__, self::ERROR);
	}
	
	public function delete()
	{
		$this->setStatus(self::FAILURE);
		$this->addMessage('TODO: ' . __METHOD__, self::ERROR);
	}
}

