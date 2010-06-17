<?php
class Api_SiteconfigController extends Zend_Controller_Action
{
	public function init()
	{
		$this->_helper->viewRenderer->setNoRender(true);
	}

	public function testAction()
	{
		$data = array(
			'server'   => $_POST['hostname'],
			'username' => $_POST['username'],
			'password' => $_POST['password']
		);
		
		$connection = KontorX_Ftp::factory('ftp', $data);
		print_r($connection->ls());
	}
}
