
// Provide a default path to dwr.engine
if (dwr == null) var dwr = {};
if (dwr.engine == null) dwr.engine = {};
if (DWREngine == null) var DWREngine = dwr.engine;

if (Usuario == null) var Usuario = {};
Usuario._path = '/forum/dwr';
Usuario.listarUsuarios = function(callback) {
  dwr.engine._execute(Usuario._path, 'Usuario', 'listarUsuarios', callback);
}
Usuario.listarUsuariosInject = function(callback) {
  dwr.engine._execute(Usuario._path, 'Usuario', 'listarUsuariosInject', callback);
}
