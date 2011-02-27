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
		
		$filter = new KontorX_Filter_MagicQuotes();
		$content = $filter->filter($content);
		
		$this->setResult($content);
		$this->setStatus(self::SUCCESS);
	}
	
	public function put()
	{
		$localFile  = tempnam(sys_get_temp_dir(), 'kx_ftp');
		$remoteFile = $this->_data['pathname'];
		$remoteFileBak = $remoteFile.'.nihili.'.time();
		
		$filter = new KontorX_Filter_MagicQuotes();
		$content = $filter->filter($this->_data['content']);
		
		if (!file_put_contents($localFile, $content)) 
		{
			$this->addMessage('Wystąpił błąd podczas zapisu pliku na dysku');
			$this->setStatus(self::FAILURE);
			return;
		}

		/*
		 * ochrona przed nadpisywaniem pliku - gdyby w całości nie został skopiowany 
		 */

		if (!$this->_ftp->put($remoteFileBak, $localFile)) 
		{
			$this->_ftp->delete($remoteFileBak);

		    $this->addMessage('Wystąpił błąd podczas zapisu pliku na serwerze');
			$this->setStatus(self::FAILURE);
			return;
		}
		
		if (!$this->_ftp->rename($remoteFileBak, $remoteFile))
		{
			$this->_ftp->delete($remoteFileBak);

			$this->addMessage('Wystąpił błąd podczas zapisu pliku na serwerze. Błąd przy zmianie nazwy.');
			$this->setStatus(self::FAILURE);

			return;
		}

		$this->setStatus(self::SUCCESS);
	}
}

