CREATE TABLE TipoDocumento (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nm_tipo_documento VARCHAR(255) NOT NULL,
  ds_tipo_documento VARCHAR(255) NOT NULL,
  ds_detalhada_tipo_documento TEXT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE Pais (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  nm_pais VARCHAR(50) NOT NULL,
  ds_pais TEXT NULL,
  PRIMARY KEY(id)
);

CREATE TABLE Lingua (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pais INTEGER UNSIGNED NOT NULL,
  nm_lingua VARCHAR(50) NOT NULL,
  nm_regiao VARCHAR(255) NOT NULL,
  ds_lingua VARCHAR(255) NOT NULL,
  ds_detalhada_lingua TEXT NULL,
  PRIMARY KEY(id),
  INDEX Lingua_FKIndex1(id_pais),
  FOREIGN KEY(id_pais)
    REFERENCES Pais(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE Usuario (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_lingua INTEGER UNSIGNED NOT NULL,
  ds_login VARCHAR(10) NOT NULL,
  ds_senha VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  nm_usuario VARCHAR(255) NULL,
  tp_usuario_acesso INTEGER UNSIGNED NOT NULL DEFAULT 3,
  nm_instituicao VARCHAR(255) NULL,
  tp_usuario CHAR(1) NOT NULL DEFAULT U,
  fl_ativo INTEGER UNSIGNED NOT NULL DEFAULT S,
  PRIMARY KEY(id),
  INDEX Usuario_FKIndex1(id_lingua),
  FOREIGN KEY(id_lingua)
    REFERENCES Lingua(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE Projeto (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario_responsavel INTEGER UNSIGNED NOT NULL,
  nm_projeto VARCHAR(255) NOT NULL,
  ds_projeto VARCHAR(255) NOT NULL,
  ds_detalhada_projeto TEXT NULL,
  dt_inicio DATETIME NOT NULL,
  PRIMARY KEY(id),
  INDEX Projeto_FKIndex1(id_usuario_responsavel),
  FOREIGN KEY(id_usuario_responsavel)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE ParticipantesProjeto (
  id_usuario INTEGER UNSIGNED NOT NULL,
  id_projeto INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(id_usuario, id_projeto),
  INDEX Usuario_has_Projeto_FKIndex1(id_usuario),
  INDEX Usuario_has_Projeto_FKIndex2(id_projeto),
  FOREIGN KEY(id_usuario)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_projeto)
    REFERENCES Projeto(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE Documento (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_projeto INTEGER UNSIGNED NOT NULL,
  id_lingua INTEGER UNSIGNED NOT NULL,
  id_tipo_documento INTEGER UNSIGNED NOT NULL,
  id_usuario_autor INTEGER UNSIGNED NULL,
  id_usuario_responsavel INTEGER UNSIGNED NULL,
  nm_documento VARCHAR(255) NOT NULL,
  documento BLOB NOT NULL,
  dt_criacao DATETIME NOT NULL,
  dt_inclusao DATETIME NOT NULL,
  ds_documento VARCHAR(255) NULL,
  nm_arquivo VARCHAR(255) NULL,
  nm_autor VARCHAR(255) NULL,
  PRIMARY KEY(id),
  INDEX Documento_FKIndex1(id_tipo_documento),
  INDEX Documento_FKIndex2(id_usuario_autor),
  INDEX Documento_FKIndex3(id_usuario_responsavel),
  INDEX Documento_FKIndex4(id_lingua),
  INDEX Documento_FKIndex5(id_projeto),
  FOREIGN KEY(id_tipo_documento)
    REFERENCES TipoDocumento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_usuario_autor)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_usuario_responsavel)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_lingua)
    REFERENCES Lingua(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_projeto)
    REFERENCES Projeto(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE PalavraChave (
  palavra VARCHAR(255) NOT NULL,
  id_documento INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(palavra),
  INDEX PalavraChave_FKIndex1(id_documento),
  FOREIGN KEY(id_documento)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE TraducaoDocumento (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario INTEGER UNSIGNED NOT NULL,
  id_documento INTEGER UNSIGNED NOT NULL,
  ds_traducao VARCHAR(255) NOT NULL,
  traducao TEXT NOT NULL,
  dt_traducao DATETIME NOT NULL,
  PRIMARY KEY(id),
  INDEX TraducaoDocumento_FKIndex1(id_usuario),
  INDEX TraducaoDocumento_FKIndex2(id_documento),
  FOREIGN KEY(id_usuario)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_documento)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE UsuarioDocumentoInteresse (
  id_usuario INTEGER UNSIGNED NOT NULL,
  id_documento INTEGER UNSIGNED NOT NULL,
  PRIMARY KEY(id_usuario, id_documento),
  INDEX Usuario_has_Documento_FKIndex1(id_usuario),
  INDEX Usuario_has_Documento_FKIndex2(id_documento),
  FOREIGN KEY(id_usuario)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_documento)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE DocumentoComentario (
  id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario INTEGER UNSIGNED NULL,
  id_comentario_pai INTEGER UNSIGNED NULL,
  id_documento INTEGER UNSIGNED NULL,
  ds_comentario TEXT NULL,
  dt_post DATETIME NULL,
  fl_ativo CHAR(1) NULL DEFAULT S,
  PRIMARY KEY(id),
  INDEX DocumentoComentario_FKIndex1(id_documento),
  INDEX DocumentoComentario_FKIndex2(id_comentario_pai),
  INDEX DocumentoComentario_FKIndex3(id_usuario),
  FOREIGN KEY(id_documento)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_comentario_pai)
    REFERENCES DocumentoComentario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_usuario)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

CREATE TABLE DocumentoRelacionado (
  id_documento1 INTEGER UNSIGNED NOT NULL,
  id_documento2 INTEGER UNSIGNED NOT NULL,
  id_usuario INTEGER UNSIGNED NOT NULL,
  ds_motivo TEXT NOT NULL,
  PRIMARY KEY(id_documento1, id_documento2),
  INDEX Documento_has_Documento_FKIndex1(id_documento1),
  INDEX Documento_has_Documento_FKIndex2(id_documento2),
  INDEX DocumentoRelacionado_FKIndex3(id_usuario),
  FOREIGN KEY(id_documento1)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_documento2)
    REFERENCES Documento(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION,
  FOREIGN KEY(id_usuario)
    REFERENCES Usuario(id)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);


