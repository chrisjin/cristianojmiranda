package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos;

import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Exemplar;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;

/**
 * Interface com os serviços da livraria.
 * 
 * @author Cristiano
 * 
 */
public interface Livraria {

	/**
	 * Obtem todos os isbns e titulos da livraria.
	 * 
	 * @return
	 */
	String obterTodosIsbns();

	/**
	 * Obtem a descrição de um exemplar na livraria por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	String obterDescricaoExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException;

	/**
	 * Obtem a quantidade de um exemplar em estoque por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	Long obterQuantidadeExemplarEmEstoquePorIsbn(String isbn)
			throws ExemplarNaoEncontradoException;

	/**
	 * Obtem um exemplar por isbn.
	 * 
	 * @param isbn
	 * @return
	 */
	Exemplar obterExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException;

	/**
	 * Retorna a lista de exemplares.
	 * 
	 * @return
	 */
	List<Exemplar> obterTodosExemplares();

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
			UsuarioSemPermissaoException;

}