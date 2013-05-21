package br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor.impl;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Exemplar;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor.MiniAmazonLivraria;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ControleAcesso;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ExemplarNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.Livraria;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioSemPermissaoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.impl.ControleAcessoImpl;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.impl.LivrariaImpl;

public class MiniAmazonLivrariaImpl extends UnicastRemoteObject implements
		MiniAmazonLivraria {

	/**
	 * 
	 */
	private static final long serialVersionUID = 104138932990750969L;

	private Livraria livrariaService;

	private ControleAcesso controleAcessoService;

	public MiniAmazonLivrariaImpl() throws RemoteException {
		super();
		livrariaService = new LivrariaImpl();
		controleAcessoService = new ControleAcessoImpl();
	}

	@Override
	public String obterTodosIsbns() throws RemoteException {
		return livrariaService.obterTodosIsbns();
	}

	@Override
	public String obterDescricaoExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException {
		return livrariaService.obterDescricaoExemplarPorIsbn(isbn);
	}

	@Override
	public Long obterQuantidadeExemplarEmEstoquePorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException {
		return livrariaService.obterQuantidadeExemplarEmEstoquePorIsbn(isbn);
	}

	@Override
	public Exemplar obterExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException, RemoteException {
		return livrariaService.obterExemplarPorIsbn(isbn);
	}

	@Override
	public List<Exemplar> obterTodosExemplares() throws RemoteException {
		return livrariaService.obterTodosExemplares();
	}

	@Override
	public void alterarQuantidadeEstoqueExemplar(String isbn,
			Long quantidadeEstoque, Usuario usuario)
			throws ExemplarNaoEncontradoException,
			UsuarioSemPermissaoException, RemoteException {
		livrariaService.alterarQuantidadeEstoqueExemplar(isbn,
				quantidadeEstoque, usuario);
	}

	@Override
	public Usuario obterUsuarioPorLogin(String login)
			throws UsuarioNaoEncontradoException, RemoteException {
		return controleAcessoService.obterUsuarioPorLogin(login);
	}

}
