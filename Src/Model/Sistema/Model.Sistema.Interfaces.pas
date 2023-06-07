unit Model.Sistema.Interfaces;

interface

uses
  System.SysUtils;

type
  IModelSistema = interface
   ['{B365D427-0377-4867-8834-5C3CF5B90F62}']
   //Model.Sistema
   function Fechar: Boolean;
   function TempoFechamento: Integer;
   function OnStatus(AValue: TProc<String>): IModelSistema;
   function ConfigurationLoad: IModelSistema;
   function LinksLoad: Boolean;
   function DownloadFiles: IModelSistema;
   function ExtractDownloadedFiles: IModelSistema;
   function CloseBrowser: IModelSistema;
   function CloseSystem: IModelSistema;
  end;

implementation

end.
