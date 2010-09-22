<?php
/**
 * Kontroler odpowiada za dostarczenie API do nawiązywania połączenia z serwerem zewnętrznym.
 * Należy przekazać do tego kontrolera parametry:
 * - server (*)
 * - username (*)
 * - password 
 * - protocol
 * - pathname
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
		$this->_helper->json($this->_connectionApi->toArray());
	}

	/**
	 * Proste sprawdzenie czy można nawiązać połączenie
	 */
	public function testAction()
	{
		$this->_connectionApi->test();
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
    public function lsAction()
	{
		$this->_connectionApi->ls();
	}
	
    /**
     * Odczytywanie pliku z serwera
     * 
     * @response JSON
     */
    public function getAction()
	{
		$this->_connectionApi->get();
	}
	
    /**
     * Zapisywanie pliku na serwerze
     * 
     * @response JSON
     */
    public function putAction()
	{
		$this->_connectionApi->put();
	}
}
