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
        $q = $connection->getQueryObject();
        
		try {
			$result = $q->execute(array(), Doctrine_Core::HYDRATE_ARRAY);
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
	
    public function edit() 
	{
	    # sprawdzanie uprawnień użytkownika do edycji
	    # - może Behavior?
	    
	    /* @var $connection Connection */
	    $connection = Doctrine_Core::getTable('Connection')->find($this->_data['connection_id']);
	    if (!$connection) {
	        $this->setStatus(self::FAILURE);
		    $this->addMessage('Połączenie nie istnieje', self::ERROR);
		    return;
	    }
	    
	    $data = $this->_data;
	    unset($data['connection_id']);

        $connection->fromArray($data);

	    try {
	        $connection->save();
	        $this->setStatus(self::SUCCESS);
	    } catch (Exception $e) {
	        $this->setStatus(self::FAILURE);
		    $this->addMessage('Exception: ' . __METHOD__ . ' :: ' . $e->getMessage(), self::ERROR);
	    }
	}
	
	public function delete()
	{
		$this->setStatus(self::FAILURE);
		$this->addMessage('TODO: ' . __METHOD__, self::ERROR);
	}
}

