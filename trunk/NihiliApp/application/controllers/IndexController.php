<?php

class IndexController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        
    }

	public function infoAction()
	{
		phpinfo();
		$this->_helper->viewRenderer->setNoRender(true);
	}
}

