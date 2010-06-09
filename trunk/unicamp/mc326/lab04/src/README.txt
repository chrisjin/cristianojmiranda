################################ Lab03 (A) ################################################

### Grupo 4
###########
Cristiano J. Miranda  RA: 083382
Gustavo F. Tiengo     RA: 071091
Magda A. Silva        RA: 082070


### Ambiente
#############

 O lab foi desenvolvido em C, utilizando como ambiente de implementacao Eclipse (plugin CDT), tambem
utilizamos o SVN (plugin Subeclipse no Eclipse) para versionar os fontes 
(repositorio: 'http://code.google.com/p/cristianojmiranda/source/browse/#svn/trunk/unicamp/mc326/lab03').
Tambem foi criado um make file para compilacao rapida da aplicacao. Para compilar basta digitar 'make' no 
diretorio dos fontes e para forcar a compilacao, caso já esteja compilado, 'make clean;make'.


### Componentes 
################
 Para facilitar a implementacao foi criado algums componentes de facil reuso:
  - utils.o   : biblioteca com fucoes uteis, exemplo: manipulacao de arquivo e string
  - io.o      : biblioteca para manipulacao de entrada de dados
  - aluno.o   : biblioteca com a implementacao do lab referente a todo o gerenciamente de 
                alunos e arquivos de dados destes.
  - bundle.o  : biblioteca para manipulcacao de arquivos de properties e mensagens da aplicacao
  - hashmap.o : biblioteca para manipular tabela hash, utilizada pelo bundle.o
  - log.o     : biblioteca para gerar arquivo de log da aplicacao, todos os comentarios da aplicacao
                sao logados, garantindo restreabilidade das operacoes.
  - mylist.o  : biblioteca para trabalhar com lista encadeada, esta no projeto mas nao esta sendo utilzado
  - mem.o     : biblioteca para facilicar alocacao de memoria.

  - config.properties : arquivo com todas as configuracoes externas a aplicacao, esta devidamente comentado para
                        facilitar a manutencao.
  - resources_<language>_<locale>.properties: arquivo de mensagem e labels da aplicacao em conforme lingua e locale.


### Testes
###########

 Utilizar os arquivos gerado pelos alunos dados100.txt dados1000.txt e dados10000.txt.


