<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class Version9 extends Doctrine_Migration_Base
{
    public function up()
    {
        $this->changeColumn('app_connection', 'protocol', 'enum', '', array(
             'values' => 
             array(
              0 => 'ftp',
             ),
             ));
    }

    public function down()
    {

    }
}