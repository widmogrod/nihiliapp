<?php

class UserController extends Zend_Controller_Action
{
	/**
	 * @var Application_Model_User
	 */
	protected $_userApi;
	
	/**
	 * Wyłącz widok i utwórz obiekt Application_Model_User
	 */
	public function init()
	{
	    // przygotowanie nadesłanych danych
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

    /**
     * Logowanie użytkownika
     */
    public function loginAction()
    {
        $this->_userApi->login();
    }
    
    /**
     * Rejestracja nowego użytkownika
     */
    public function registerAction()
    {
        $this->_userApi->register();
    }
}