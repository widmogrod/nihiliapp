<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class Addappconnection extends Doctrine_Migration_Base
{
    public function up()
    {
        $this->createTable('app_connection', array(
             'connection_id' => 
             array(
              'type' => 'integer',
              'length' => 8,
              'fixed' => false,
              'unsigned' => false,
              'primary' => true,
              'sequence' => 'app_connection_connection_id',
             ),
             'server' => 
             array(
              'type' => 'string',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => NULL,
             ),
             'username' => 
             array(
              'type' => 'string',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => NULL,
             ),
             'password' => 
             array(
              'type' => 'string',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => NULL,
             ),
             'pathname' => 
             array(
              'type' => 'string',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => NULL,
             ),
             'protocol' => 
             array(
              'type' => 'integer',
              'length' => 8,
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
             ),
             ), array(
             'indexes' => 
             array(
             ),
             'primary' => 
             array(
              0 => 'connection_id',
             ),
             ));
    }

    public function down()
    {
        $this->dropTable('app_connection');
    }
}