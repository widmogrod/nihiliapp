<?php
class ChangesTemplate extends Doctrine_Template
{
    public function setTableDefinition()
    {
        $this->hasColumn('ip', 'ip');

        $this->addListener(new IpListener());
    }
    
    public function setUp()
    {
        $this->addChild('Timestampable');

    }
}