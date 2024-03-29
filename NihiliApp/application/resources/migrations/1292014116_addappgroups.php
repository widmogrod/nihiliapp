<?php
/**
 * This class has been auto-generated by the Doctrine ORM Framework
 */
class Addappgroups extends Doctrine_Migration_Base
{
    public function up()
    {
        $this->createTable('app_groups', array(
             'group_id' => 
             array(
              'type' => 'integer',
              'length' => 8,
              'fixed' => false,
              'unsigned' => false,
              'primary' => true,
              'sequence' => 'app_groups_group_id',
             ),
             'name' => 
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
             ), array(
             'indexes' => 
             array(
             ),
             'primary' => 
             array(
              0 => 'group_id',
             ),
             ));
    }

    public function down()
    {
        $this->dropTable('app_groups');
    }
}