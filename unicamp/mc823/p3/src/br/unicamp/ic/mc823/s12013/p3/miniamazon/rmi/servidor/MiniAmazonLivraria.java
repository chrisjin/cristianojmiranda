package br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Exemplar;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ExemplarNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioSemPermissaoException;

/**
 * @author Cristiano
 * 
 */
public interface MiniAmazonLivraria extends Remote {

	public static final String RMI_SERVER_NAME = "miniAmazonRmi";

	/**
	 * Obtem todos os isbns e titulos da livraria.
	 * 
	 * @return
	 */
	String obterTodosIsbns() throws RemoteException;

	/**
	 * Obtem a descrição de um exemplar na livraria por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	String obterDescricaoExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException;

	/**
	 * Obtem a quantidade de um exemplar em estoque por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	Long obterQuantidadeExemplarEmEstoquePorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException;

	/**
	 * Obtem um exemplar por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	Exemplar obterExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException;

	/**
	 * Retorna a lista de exemplares.
	 * 
	 * @return
	 */
	List<Exemplar> obterTodosExemplares() throws RemoteException;

	/**
	 * Altera a quantidade de exemplares em estoque. Apenas usuarios livrarias
	 * tem permissao para realizar essa operação.
	 * 
	 * @param isbn
	 * @param quantidadeEstoque
	 * @param usuario
	 * @throws ExemplarNaoEncontradoException
	 * @throws UsuarioSemPermissaoException
	 */
	void alterarQuantidadeEstoqueExemplar(String isbn, Long quantidadeEstoque,
			Usuario usuario) throws ExemplarNaoEncontradoException,
			UsuarioSemPermissaoException, RemoteException;

	/**
	 * Retorna um usuario por login.
	 * 
	 * @param login
	 * @return
	 * @throws RemoteException
	 * @throws UsuarioNaoEncontradoException
	 */
	Usuario obterUsuarioPorLogin(String login)
			throws UsuarioNaoEncontradoException, RemoteException;

}