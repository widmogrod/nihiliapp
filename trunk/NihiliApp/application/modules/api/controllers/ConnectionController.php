<?php
/**
 * Kontroler odpowiada za dostarczenie API do nawiązywania połączenia z serwerem zewnętrznym.
 * Należy przekazać do tego kontrolera parametry:
 * - server (*)
 * - username (*)
 * - password (*)
 * - port (*)
 * - connectionType (*)
 *
 * (*) - oznacza parametr wymagane.
 *
 * Odpowiedź do nadawcy jest w formacie JSON.
 * Precyzyjny opis znajduje się w przy poszczegółnych metodach.
 */
class Api_ConnectionController extends Zend_Controller_Action
{
	/**
	 * @var Application_Model_Connection
	 */
	protected $_connectionApi;
	
	/**
	 * Wyłącz widok i utwórz obiekt Application_Model_Connection
	 */
	public function init()
	{
		$this->_connectionApi = new Application_Model_Connection($_POST);

		$this->_helper->viewRenderer->setNoRender(true);
	}
	
	public function postDispatch()
	{
		print $this->_connectionApi->toJSON();
	}

	/**
	 * Akcja zwraca listę katalogów na serwerze.
	 * 
	 * Parametry przekazywane poprzez metode POST.
	 * Lista parametrów (+ globalne parametry wymienione w opisie klasy):
	 * - path 		sting 		- scieżka na serwerze, którą przeszukać
	 * - fileType 	FILE|DIR 	- można ograniczyć wynik do plików lub katalogół
	 *
	 * <code>
	 * {
	 *	status: "SUCCESS|FAILURE",
	 *	messages: [
	 *		{
	 *			type: "INFO|ERROR|WARNING",
	 *			message: "Treść wiadomości"
	 *		}
	 *	],
	 *  result: [
	 *		{
	 *			type: "DIR|FILR",
	 *			name: "Nazwa pliku lub katalogu"
	 *			path: "Ścieżka dostępu do pliku",
	 *			info: {
	 *				ctime:123123123,
	 *				mtime:123123123,
	 *				group:"root",
	 *				
	 *			}
	 *		}
	 *  ]
	 * }
	 * </code>
	 *
	 *
	 * @response JSON
	 */
	public function lsAction()
	{
#		$data = array(
#			'server'   => $_POST['server'],
#			'username' => $_POST['username'],
#			'password' => $_POST['password']
#		);
#		
#		$connection = KontorX_Ftp::factory('ftp', $data);
#		print_r($connection->ls());
	}
}
