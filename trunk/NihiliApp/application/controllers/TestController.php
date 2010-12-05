<?php

class TestController extends Zend_Controller_Action
{

    public function init()
    {
        $this->_helper->viewRenderer->setNoRender();
    }

    public function testdoctrineversionAction()
    {
        $connection = new Connection();
        $connection->server = 'ftp.widmogrod.info';
        $connection->password = 'for6ba!';
        $connection->username = 'widmogrod';
        $connection->protocol = 22;
        $connection->save();
        
        $content = new ConnectionContent();
        $content->fk_connection_id = $connection->connection_id;
        $content->content = 'To jest przykładowy tekst';
        $content->save();
        
        $content->content = 'Bardzo lubię pączki';
        $content->save();
        
        $connection->delete();
    }
}