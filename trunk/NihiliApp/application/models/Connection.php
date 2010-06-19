<?php
class Application_Model_Connection extends Application_Model_Response
{
	protected $_ftp;

	public function __construct(array $data) 
	{
		$connectionType = isset($data['connectionType']) ? $data['connectionType'] : @$data['server'];
		
		try {
			$this->_ftp = KontorX_Ftp::factory($connectionType, $data);
		} catch(KontroX_Ftp_Exception $e) {
		
		}
	}
}

