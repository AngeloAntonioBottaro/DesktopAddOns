unit Model.Utils;

interface

uses
  System.SysUtils;

const
  CVersion      = 1;
  CSubVersion   = 0;
  CMinorVersion = 0;

  //INI IDENTIFIERS
  CIdentPastaDownload = 'PastaDownload';
  CIdentPastaExtrair  = 'PastaExtrair';
  CIdentBrowser       = 'Browser';

  //DEFAULTS
  CDefaultBrowser = 'msedge.exe';
  CDefaultLink    = 'http/www.exemplo.com/arquivo.rar';

function SystemVersion: string;

implementation

function SystemVersion: string;
begin
   Result := ' - Versão ' + CVersion.Tostring + '.' + CSubVersion.Tostring + '.' + CMinorVersion.Tostring;
end;

end.
