package br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.cliente;

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Exemplar;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.rmi.servidor.MiniAmazonLivraria;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ExemplarNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioSemPermissaoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.IOUtils;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.LoggerUtils;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.StringUtils;

/**
 * @author Cristiano
 * 
 */
public class MiniAmazonCliente {

	private final int OBTER_TODOS_ISBNS = 1;
	private final int OBTER_DESCRICAO_POR_ISBN = 2;
	private final int OBTER_LIVRO_POR_ISBN = 3;
	private final int OBTER_TODOS_LIVROS = 4;
	private final int ALTERAR_NR_EXEMPLARES_ESTOQUE = 5;
	private final int OBTER_NR_EXEMPLARES_ESTOQUE = 6;
	private final int SAIR = 7;

	private void imprimirMenu() {

		StringBuffer buffer = new StringBuffer();
		buffer.append("\n");
		buffer.append("\n===== MENU =====\n");
		buffer.append(" 1 - OBTER TODOS ISBNS\n");
		buffer.append(" 2 - OBTER DESCRICAO POR_ISBN\n");
		buffer.append(" 3 - OBTER LIVRO POR ISBN\n");
		buffer.append(" 4 - OBTER TODOS LIVROS\n");
		buffer.append(" 5 - ALTERAR NR EXEMPLARES ESTOQUE\n");
		buffer.append(" 6 - OBTER NR EXEMPLARES ESTOQUE\n");
		buffer.append(" 7 - SAIR\n\n");

		System.out.println(buffer);
	}

	private String obterIsbn() {

		String isbn = null;
		while (StringUtils.estaNulloOuVazio(isbn)) {
			isbn = IOUtils.getString("Entre com ISBN: ");
		}

		return isbn;

	}

	/**
	 * @param exemplar
	 */
	private void imprimirLivro(Exemplar exemplar) {

		System.out.println("\n--- Dados do Livro ---");
		System.out.println("\tISBN: " + exemplar.getIsbn());
		System.out.println("\tTitulo: " + exemplar.getTitulo());
		System.out.println("\tAutores: " + exemplar.getAutores());
		System.out.println("\tEditora: " + exemplar.getEditora());
		System.out.println("\tAno Publicacao: " + exemplar.getAnoPublicacao());
		System.out.println("\tDescricao: " + exemplar.getDescricao());
		System.out.println("\tEstoque: " + exemplar.getQuantidadeEstoque());

	}

	public void executar(String registryAddress) throws RemoteException,
			NotBoundException {

		System.out.println("Iniciando cliente...");

		if (System.getSecurityManager() == null) {
			System.setSecurityManager(new SecurityManager());
		}

		Registry registry = LocateRegistry.getRegistry(registryAddress);
		MiniAmazonLivraria rmiService = (MiniAmazonLivraria) registry
				.lookup(MiniAmazonLivraria.RMI_SERVER_NAME);

		// Obtem o usuario do cliente
		Usuario usuario = login(rmiService);

		int operacao = -1;
		while (operacao != SAIR) {

			operacao = -1;
			imprimirMenu();

			while (operacao < 1 || operacao > 6) {
				operacao = IOUtils.getInt("Entre com uma operacao: ");
			}

			tratarOperacao(rmiService, usuario, operacao);
		}
	}

	private void tratarOperacao(MiniAmazonLivraria rmiService, Usuario usuario,
			int operacao) throws RemoteException {

		if (operacao == OBTER_TODOS_ISBNS) {

			obtetTodosIsbns(rmiService);

		} else if (operacao == OBTER_DESCRICAO_POR_ISBN) {

			obterDescricaoPorIsbn(rmiService);

		} else if (operacao == OBTER_LIVRO_POR_ISBN) {

			obterExemplearPorIsbn(rmiService);

		} else if (operacao == OBTER_TODOS_LIVROS) {

			obterTodosExemplares(rmiService);

		} else if (operacao == ALTERAR_NR_EXEMPLARES_ESTOQUE) {

			alterarEstoque(rmiService, usuario);

		} else if (operacao == OBTER_NR_EXEMPLARES_ESTOQUE) {

			obterEstoque(rmiService);

		}
	}

	private Usuario login(MiniAmazonLivraria rmiService) throws RemoteException {
		Usuario usuario = null;
		while (usuario == null) {

			String login = IOUtils.getString("Entre com seu login: ");

			try {
				usuario = rmiService.obterUsuarioPorLogin(login);
			} catch (UsuarioNaoEncontradoException e1) {
				System.err.println(e1.getMessage());
			}
		}
		return usuario;
	}

	private void obterEstoque(MiniAmazonLivraria rmiService)
			throws RemoteException {

		String isbn = obterIsbn();
		long inicio = System.currentTimeMillis();

		try {
			System.out.println("NR EXEMPLARES: "
					+ rmiService.obterQuantidadeExemplarEmEstoquePorIsbn(isbn));
		} catch (ExemplarNaoEncontradoException e) {
			System.err.println(e.getMessage());
		}

		LoggerUtils.logger("clienttimer.csv", "CLIENTE",
				"OBTER_NR_EXEMPLARES_ESTOQUE", inicio);
	}

	private void alterarEstoque(MiniAmazonLivraria rmiService, Usuario usuario)
			throws RemoteException {
		String isbn = obterIsbn();

		Long quantidadeEstoque = -1L;
		while (quantidadeEstoque < 0) {
			quantidadeEstoque = IOUtils
					.getLong("Entre com a nova quantidade para atualizar o estoque: ");
		}

		long inicio = System.currentTimeMillis();
		try {
			rmiService.alterarQuantidadeEstoqueExemplar(isbn,
					quantidadeEstoque, usuario);
		} catch (ExemplarNaoEncontradoException e) {
			System.err.println(e.getMessage());
		} catch (UsuarioSemPermissaoException e) {
			System.err.println(e.getMessage());
		}

		LoggerUtils.logger("clienttimer.csv", "CLIENTE",
				"ALTERAR_NR_EXEMPLARES_ESTOQUE", inicio);
	}

	private void obterTodosExemplares(MiniAmazonLivraria rmiService)
			throws RemoteException {

		long inicio = System.currentTimeMillis();

		List<Exemplar> exemplares = rmiService.obterTodosExemplares();

		LoggerUtils.logger("clienttimer.csv", "CLIENTE", "OBTER_TODOS_LIVROS",
				inicio);

		for (Exemplar exemplar : exemplares) {
			imprimirLivro(exemplar);
		}
	}

	private void obterExemplearPorIsbn(MiniAmazonLivraria rmiService)
			throws RemoteException {

		String isbn = obterIsbn();
		long inicio = System.currentTimeMillis();
		try {

			// Obtem o exemplar
			imprimirLivro(rmiService.obterExemplarPorIsbn(isbn));

		} catch (ExemplarNaoEncontradoException e) {
			System.err.println(e.getMessage());
		}

		LoggerUtils.logger("clienttimer.csv", "CLIENTE",
				"OBTER_LIVRO_POR_ISBN", inicio);
	}

	private void obterDescricaoPorIsbn(MiniAmazonLivraria rmiService)
			throws RemoteException {

		String isbn = obterIsbn();
		long inicio = System.currentTimeMillis();

		try {
			System.out.println("DESCRICAO: "
					+ rmiService.obterDescricaoExemplarPorIsbn(isbn));
		} catch (ExemplarNaoEncontradoException e) {
			System.err.println(e.getMessage());
		}

		LoggerUtils.logger("clienttimer.csv", "CLIENTE",
				"OBTER_DESCRICAO_POR_ISBN", inicio);
	}

	private void obtetTodosIsbns(MiniAmazonLivraria rmiService)
			throws RemoteException {

		long inicio = System.currentTimeMillis();

		System.out.println(" ISBN     - TITULO\n");
		System.out.println(rmiService.obterTodosIsbns());

		LoggerUtils.logger("clienttimer.csv", "CLIENTE", "OBTER_TODOS_ISBNS",
				inicio);
	}

	/**
	 * @param args
	 * @throws NotBoundException
	 * @throws RemoteException
	 */
	public static void main(String... args) throws RemoteException,
			NotBoundException {

		new MiniAmazonCliente().executar(args.length == 0 ? "localhost"
				: args[0]);
	}

}
