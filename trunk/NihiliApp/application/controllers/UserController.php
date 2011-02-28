<?php

class UserController extends Zend_Controller_Action
{
	/**
	 * @var Application_Model_User
	 */
	protected $_userApi;
	
	/**
	 * Wyłącz widok i utwórz obiekt Application_Model_Connection
	 */
	public function init()
	{
	    $data = file_get_contents('php://input');
	    $data = urldecode($data);
	    $data = Zend_Json::decode($data);

		$this->_userApi = new Application_Model_User($data);

		$this->_helper->viewRenderer->setNoRender(true);
	}
	
	public function postDispatch()
	{
		$this->_helper->json($this->_userApi->toArray());
	}

    public function loginAction()
    {
        if ($this->_userApi->hasLogin()) 
        {
            $this->_userApi->login();
        }
        else
        {
            $this->_userApi->register();
        }
    }
}