unit Model.Sistema.Interfaces;

interface

uses
  System.SysUtils;

type
  iModelSistema = interface
   ['{B365D427-0377-4867-8834-5C3CF5B90F62}']
   //Model.Sistema
   function Fechar: Boolean;
   function TempoFechamento: Integer;
   function OnStatus(AValue: TProc<String>): iModelSistema;
   function VerifyApplicationOpen: iModelSistema;
   function ConfigurationLoad: iModelSistema;
   function LinksLoad: iModelSistema;
   function DownloadFiles: iModelSistema;
   function ExtractDownloadedFiles: iModelSistema;
   function CloseBrowser: iModelSistema;
   function CloseSystem: iModelSistema;
  end;

implementation

end.
