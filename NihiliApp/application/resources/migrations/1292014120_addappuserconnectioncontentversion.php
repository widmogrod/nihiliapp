<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class Addappuserconnectioncontentversion extends Doctrine_Migration_Base
{
    public function up()
    {
        $this->createTable('app_user_connection_content_version', array(
             'fk_connection_id' => 
             array(
              'type' => 'integer',
              'length' => 8,
              'fixed' => false,
              'unsigned' => false,
              'primary' => true,
             ),
             'content' => 
             array(
              'type' => 'string',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => NULL,
             ),
             'created_at' => 
             array(
              'type' => 'timestamp',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => true,
              'primary' => false,
              'length' => 25,
             ),
             'updated_at' => 
             array(
              'type' => 'timestamp',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => true,
              'primary' => false,
              'length' => 25,
             ),
             'deleted_at' => 
             array(
              'type' => 'timestamp',
              'fixed' => false,
              'unsigned' => false,
              'notnull' => false,
              'primary' => false,
              'length' => 25,
             ),
             'version' => 
             array(
              'type' => 'integer',
              'length' => 8,
              'fixed' => false,
              'unsigned' => false,
              'primary' => true,
             ),
             ), array(
             'indexes' => 
             array(
             ),
             'primary' => 
             array(
              0 => 'fk_connection_id',
              1 => 'version',
             ),
             ));
    }

    public function down()
    {
        $this->dropTable('app_user_connection_content_version');
    }
}