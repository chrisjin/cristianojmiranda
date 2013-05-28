package br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.impl;

import java.util.ArrayList;
import java.util.List;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Exemplar;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo.Usuario;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.ExemplarNaoEncontradoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.Livraria;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.servicos.UsuarioSemPermissaoException;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.LoggerUtils;
import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.StringUtils;

/**
 * @author Cristiano
 * 
 */
public class LivrariaImpl implements Livraria {

	/**
	 * Lista com os exemplares disponibilizados pela livraria.
	 */
	private List<Exemplar> exemplaresDb;

	/**
	 * 
	 */
	public LivrariaImpl() {

		// Monta a lista com os exemplares da livraria
		exemplaresDb = new ArrayList<Exemplar>();

		for (int i = 0; i < 100; i++) {
			exemplaresDb.add(Exemplar.criarExemplarFake(i));
		}

	}

	@Override
	public String obterTodosIsbns() {

		long inicio = System.currentTimeMillis();

		StringBuffer buffer = new StringBuffer();
		for (Exemplar exemplar : obterTodosExemplares()) {

			if (buffer.length() > 0) {
				buffer.append("\n");
			}

			buffer.append(exemplar.getIsbn());
			buffer.append(" - ");
			buffer.append(exemplar.getTitulo());
		}

		LoggerUtils.logger("servertimer.csv", "SERVER", "OBTER_TODOS_ISBNS",
				inicio);
		return buffer.toString();
	}

	@Override
	public String obterDescricaoExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException {

		long inicio = System.currentTimeMillis();

		try {
			Exemplar exemplar = obterExemplarPorIsbn(isbn);
			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_DESCRICAO_POR_ISBN", inicio);
			return exemplar.getDescricao();
		} catch (ExemplarNaoEncontradoException e) {
			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_DESCRICAO_POR_ISBN", inicio);
			throw e;
		}

	}

	@Override
	public Long obterQuantidadeExemplarEmEstoquePorIsbn(String isbn)
			throws ExemplarNaoEncontradoException {

		long inicio = System.currentTimeMillis();

		try {
			Exemplar exemplar = obterExemplarPorIsbn(isbn);
			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_QUANTIDADE_POR_ISBN", inicio);
			return exemplar.getQuantidadeEstoque();
		} catch (ExemplarNaoEncontradoException e) {
			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_QUANTIDADE_POR_ISBN", inicio);
			throw e;
		}
	}

	@Override
	public Exemplar obterExemplarPorIsbn(String isbn)
			throws ExemplarNaoEncontradoException {

		long inicio = System.currentTimeMillis();

		// Verifica os parametros
		if (StringUtils.estaNulloOuVazio(isbn)) {

			LoggerUtils.logger("servertimer.csv", "SERVER",
					"OBTER_EXEMPLAR_POR_ISBN", inicio);
			throw new IllegalArgumentException(
					"O parametro isbn é obrigatório.");
		}

		for (Exemplar exemplar : obterTodosExemplares()) {

			if (exemplar.getIsbn().equals(isbn)) {
				LoggerUtils.logger("servertimer.csv", "SERVER",
						"OBTER_EXEMPLAR_POR_ISBN", inicio);
				return exemplar;
			}

		}

		LoggerUtils.logger("servertimer.csv", "SERVER",
				"OBTER_EXEMPLAR_POR_ISBN", inicio);
		throw new ExemplarNaoEncontradoException("Exemplar com ISBN '" + isbn
				+ "' não encontrado na livraria.");
	}

	@Override
	public List<Exemplar> obterTodosExemplares() {
		LoggerUtils.logger("servertimer.csv", "SERVER",
				"OBTER_EXEMPLAR_POR_ISBN", System.currentTimeMillis());
		return this.exemplaresDb;
	}

	@Override
	public void alterarQuantidadeEstoqueExemplar(String isbn,
			Long quantidadeEstoque, Usuario usuario)
			throws ExemplarNaoEncontradoException, UsuarioSemPermissaoException {

		long inicio = System.currentTimeMillis();

		// Valida parametros obrigatorios
		if (usuario == null || quantidadeEstoque == null || isbn == null) {

			LoggerUtils.logger("servertimer.csv", "SERVER",
					"ALTERAR_ESTOQUE_POR_ISBN", inicio);

			throw new IllegalArgumentException(
					"Os parametros isb, quantidadeEstoque e  usuario são obrigatórios.");
		}

		// Verifica se o usuario tem permissao para alterar o estoque
		if (usuario.getTipoUsuario() != Usuario.TIPO_USUARIO_LIVRARIA) {

			LoggerUtils.logger("servertimer.csv", "SERVER",
					"ALTERAR_ESTOQUE_POR_ISBN", inicio);

			throw new UsuarioSemPermissaoException(
					"Apenas usuarios livrarias podem alterar o estoque");
		}

		// Atualiza a quantidade em estoque
		obterExemplarPorIsbn(isbn).setQuantidadeEstoque(quantidadeEstoque);

		LoggerUtils.logger("servertimer.csv", "SERVER",
				"ALTERAR_ESTOQUE_POR_ISBN", inicio);
	}

}
