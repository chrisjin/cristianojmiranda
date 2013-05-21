package br.unicamp.ic.mc823.s12013.p3.miniamazon.modelo;

import java.io.Serializable;
import java.util.Random;

import br.unicamp.ic.mc823.s12013.p3.miniamazon.utils.StringUtils;

/**
 * 
 * 
 * @author Cristiano
 * 
 */
public class Exemplar implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 856917830229432898L;

	private String isbn;
	private String titulo;
	private String autores;
	private String editora;
	private String descricao;
	private Integer anoPublicacao;
	private Long quantidadeEstoque;

	/**
	 * @param isbn
	 * @param titulo
	 * @param autores
	 * @param editora
	 * @param descricao
	 * @param anoPublicacao
	 * @param quantidadeEstoque
	 */
	public Exemplar(String isbn, String titulo, String autores, String editora,
			String descricao, Integer anoPublicacao, Long quantidadeEstoque) {
		super();
		this.isbn = isbn;
		this.titulo = titulo;
		this.autores = autores;
		this.editora = editora;
		this.descricao = descricao;
		this.anoPublicacao = anoPublicacao;
		this.quantidadeEstoque = quantidadeEstoque;
	}

	public Long getQuantidadeEstoque() {
		return quantidadeEstoque;
	}

	public void setQuantidadeEstoque(Long quantidadeEstoque) {
		this.quantidadeEstoque = quantidadeEstoque;
	}

	public String getIsbn() {
		return isbn;
	}

	public String getTitulo() {
		return titulo;
	}

	public String getAutores() {
		return autores;
	}

	public String getEditora() {
		return editora;
	}

	public String getDescricao() {
		return descricao;
	}

	public Integer getAnoPublicacao() {
		return anoPublicacao;
	}

	/**
	 * @return
	 */
	public static Exemplar criarExemplarFake() {

		Random rdm = new Random();

		int anoPublicacao = -1;
		while (anoPublicacao < 1800 || anoPublicacao > 2013) {
			anoPublicacao = rdm.nextInt(2013);
		}

		int isbnNr = rdm.nextInt(999999999);
		String isbn = StringUtils.completarEsquerda(String.valueOf(isbnNr),
				"0", 10);

		String[] titulos = new String[] {
				"carlota joaquina a princesa do brasil", "central do brasil",
				"o quatrilho", "aaaa", "bbbb", "cccc", "dddd", "eeee",
				"xxxxxxxxxxxxx", "yyyyyyyyyyyyyyyyy", "wwwwwwwwwwwwwww",
				"eles nao usam black-tie" };

		String[] autores = new String[] { " Carla camurati",
				"Machado de Assis", "Eça de Queiros", "chico", "samual morse",
				"james watt", "gianfrancesco guarnieri" };

		String[] editoras = new String[] { "Ed Unicamp", "Cia das Letras",
				"Abril" };

		String[] descricoes = new String[] { "arte", "cinema", "biologia",
				"cultura pop", "HQ", "ciencias", "mundo", "geografia",
				"historia" };

		return new Exemplar(isbn, titulos[rdm.nextInt(titulos.length)],
				autores[rdm.nextInt(autores.length)],
				editoras[rdm.nextInt(editoras.length)],
				descricoes[rdm.nextInt(descricoes.length)], anoPublicacao,
				new Long(rdm.nextInt(100)));
	}
}
