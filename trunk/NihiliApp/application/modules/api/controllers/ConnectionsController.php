<?php
/**
 * Kontroler odpowiada za dostarczenie API do zarządzania połączeniami użytkownika.
 * Należy przekazać do tego kontrolera parametry:
 * - server (*)
 * - username (*)
 * - password 
 * - protocol
 * - pathname
 * - content
 *
 * (*) - oznacza parametr wymagane.
 *
 * Odpowiedź do nadawcy jest w formacie JSON.
 * Precyzyjny opis znajduje się w przy poszczegółnych metodach.
 */
class Api_ConnectionsController extends Zend_Controller_Action
{
	/**
	 * @var Application_Model_Connections
	 */
	protected $_connectionsApi;
	
	/**
	 * Wyłącz widok i utwórz obiekt Application_Model_Connection
	 */
	public function init()
	{
		$this->_connectionsApi = new Application_Model_Connections($_POST);

		$this->_helper->viewRenderer->setNoRender(true);
	}
	
	public function postDispatch()
	{
		$this->_helper->json($this->_connectionsApi->toArray());
	}

	/**
	 * Proste sprawdzenie czy można nawiązać połączenie
	 */
	public function listAction()
	{
		$this->_connectionsApi->connectionsList();
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
	 *			'filename' => '...',
	 *			'filetype' => '...',
	 *			'filesize' => 1234,
	 *			'permissions' => 'drwx-rwx-rwx',
	 *			'user'  => '...',
	 *			'group' => '...',
	 *			'filemtime' => 1233455
	 *		}
	 *  ]
	 * }
	 * </code>
	 *
	 *
	 * @response JSON
	 */
    public function addAction()
	{
		$this->_connectionsApi->add();
	}
	
    public function getAction()
	{
		$this->_connectionsApi->get();
	}

    /**
     * Odczytywanie pliku z serwera
     * 
     * @response JSON
     */
    public function deleteAction()
	{
		$this->_connectionsApi->delete();
	}
}
