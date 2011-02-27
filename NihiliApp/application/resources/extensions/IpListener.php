<?php
class IpListener extends Doctrine_Record_Listener
{
    public function preInsert(Doctrine_Event $event)
    {
        $event->getInvoker()->ip = getenv('HTTP_X_FORWARDED_FOR')
            ? getenv('HTTP_X_FORWARDED_FOR') 
            : getenv('REMOTE_ADDR');
    }

    public function preUpdate(Doctrine_Event $event)
    {
        $event->getInvoker()->updated = date('Y-m-d', time());
    }
}