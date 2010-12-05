<?php
class Application_Model_Connection extends Application_Model_Response
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
	
	public function get() 
	{
		$localFile  = tempnam(sys_get_temp_dir(),'kx_ftp');
		$remoteFile = $this->_data['pathname'];
		
		$result = $this->_ftp->get($localFile, $remoteFile);
		if (!$result) 
		{
		    $this->addMessage('Nie można pobrać pliku z serwera');
			$this->setStatus(self::FAILURE);
			return;
		}

		$content = file_get_contents($localFile);
		$this->setResult($content);
		$this->setStatus(self::SUCCESS);
	}
	
	public function put()
	{
		$localFile  = tempnam(sys_get_temp_dir(), 'kx_ftp');
		$remoteFile = $this->_data['pathname'];
		$data	    = get_magic_quotes_gpc() ? stripslashes($this->_data['content']) : $this->_data['content'];
//$data = $this->_data['content'];

		if (!file_put_contents($localFile, $data)) {
			$this->addMessage('Wystąpił błąd podczas zapisu pliku na dysku');
			$this->setStatus(self::FAILURE);
			return;
		}
		
		if (!$this->_ftp->put($remoteFile, $localFile)) {
		    $this->addMessage('Wystąpił błąd podczas zapisu pliku na serwerze');
			$this->setStatus(self::FAILURE);
			return;
		}
		
		$this->setStatus(self::SUCCESS);
	}
}

