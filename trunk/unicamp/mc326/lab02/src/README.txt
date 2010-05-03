################################ Lab02 (A B C) ################################################

### Grupo 4
###########
Cristiano J. Miranda  RA: 083382
Gustavo F. Tiengo     RA: 071091
Magda A. Silva        RA: 082070


### Ambiente
#############

 O lab foi desenvolvido em C, utilizando como ambiente de implementacao Eclipse (plugin CDT), tambem
utilizamos o SVN (plugin Subeclipse no Eclipse) para versionar os fontes 
(repositorio: 'http://code.google.com/p/cristianojmiranda/source/browse/#svn/trunk/unicamp/mc326/lab02').
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

 No diretorio tests foi disponibilizado 3 arquivos utilizados para a execucao dos testes, cada arquivo
apresenta um header com informacoes relevantes sobre os dados.


### Consideracoes
#################

	Algumas funcionalidades entregues anteriormente foram reformuladas e melhoradas
afim de atender melhor oque foi proposto, gostaria que fosse levado em consideracao essas 
melhorias na avaliacao do trabalho. Pontos melhorados:

 - Tratando arquivo inexistente de entrada
 - Tratando linhas invalidas no arquivo de entrada
 - Tratando informacoes obrigatorias inexistentes no arquivo de entrada
 - Criada opcao para visualizar a consulta de arquivo fixo e variavel
   tanto pela tela quanto pelo browser (html que o sistema gera e  abre no firefox)
 - Otizacao do mecanismo de debug, para que as configuracoes do mesmo ficassem de forma
   nao programaticamente. Ativacao e desativacao via config.properties, definicao do nome e
   diretorio para o arquivo de log.
 - Remocao da estrutura em memoria para exibicao dos dados, atualmente o sistema suporta
   arquivos que superem o tamanho da memoria RAM da maquina.
 - Otimizacao no mecanismo de delecao de registros via consulta binaria em arquivo, para 
   exibir os dados do aluno a ser deletado, solicitando confirmacao do usuario, e armazenando 
   o index do mesmo para deletar por esse index, nao necessitando que o index seja buscado 
   novamente no arquivo de indexes.
 - Reformulado alguns metodos e parametros afim de melhorar a legibilidade do mesmo em relacao
   a sua funcionalidade.
 - Remocao de metodos redundantes
 - Centralizacao da maneira como eh extraido uma estrutura de aluno tanto do arquivo fixo 
   como variavel, atraves dos metodos: newAluno e newAlunoVariableLine.
 - Todos os metodos estao comentados utilizando o mecanismo de debug, oque permite que seja 
   estraido um trace de todas as acoes do sistema.
 - O arquivo de index foi concebido de maneira que suporte alteracoes no tamanha do ra, como
   estou tratando o RA como um int, o arquivo de index suporta o armazenamento maximo de int,
   tanto para o RA quanto para a posicao (nao atende se o arquivo possuir linhas cujo numero
   ultrapasse a precissao maxima do int)


### Pontos a serem melhorados e Bugs
####################################
 - A consulta gerada via html nao contempla internacionalizacao. Estruturar melhor a maneira 
   como o arquivo de consulta eh gerado.
 - Colocar header na consulta em html para identificar as informacoes
 - Exibir o tempo de cada uma das consultas, utilizando index e nao para verificacao se a tecnica
   realmente melhora o custo da consulta.
 - Criar funcao que verifica no arquivo de index ordenado se existe alguma chave duplicada, isso
   poderia auxiliar o usuario para garantir a integridade dos dados.
 - Otimizar geracao do arquivo de index para suportar arquivos com numero de linhas que ultrapassem
   a precissao maxima do int. Utilizar long.
 - Rever comentario de metodos e parametros
 - Verificar se existem pontos de escoamento de memoria.
 - Fazer teste de stress com um arquivo carregado para ver se a aplicacao suporta (mais de 1000 registro validos)
 - Verificar a necessidade de excluir o arquivo de forma variavel, pode ser que o usuario entre com outro arquivo
   fixo e nao carregue o variavel, ou seja, os dados ficariam inconsistentes. Mas isso depende muito de como
   o sistema será utilizado.
 - Ao acionar a opcão 1 seguidamente depois de 6 ou 7 vezes a aplicacao capota. Provavelmente nao esta desalocando memoria.
 
 


