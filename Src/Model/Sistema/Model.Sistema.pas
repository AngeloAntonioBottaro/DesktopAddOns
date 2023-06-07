unit Model.Sistema;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  Model.Sistema.Interfaces,
  Common.Utils.MyLibrary,
  Common.Utils.MyIniLibrary,
  Common.Utils.MyTxtLibrary;

type
  TModelSistema = class(TInterfacedObject, IModelSistema)
  private
    FOnStatus: TProc<String>;
    FParar: Boolean;
    FIniFile: iMyIniLibrary;
    FLinksFile: iMyTxtLibrary;
    FPastaDownload: string;
    FPastaExtrair: string;
    FBrowser: string;
    FLinksCounter: Integer;
    FFechar: Boolean;
    FTempoFechamento: Integer;

    procedure DoStatus(AMsg: string);
    function Parar: Boolean;
    function PastaDownload: string;
    function PastaExtrair: string;
    function Browser: string;
    procedure CreateConfFile;
    procedure VerifyInternet;
    procedure ClearDownloadRepository;
    procedure ProcessFilesDownlod;
    procedure WaitDownloadFinish;
  protected
    function OnStatus(AValue: TProc<String>): IModelSistema;

    function ConfigurationLoad: IModelSistema;
    function LinksLoad: Boolean;
    function DownloadFiles: IModelSistema;
    function ExtractDownloadedFiles: IModelSistema;
    function CloseBrowser: IModelSistema;
    function CloseSystem: IModelSistema;

    function Fechar: Boolean;
    function TempoFechamento: Integer;
  public
    class function New: IModelSistema;
    constructor Create;
  end;

implementation

uses
  MyVclLibrary,
  Model.Utils;

class function TModelSistema.New: IModelSistema;
begin
   Result := Self.Create;
end;

constructor TModelSistema.Create;
begin
   FIniFile         := TMyIniLibrary.New.Path(TMyVclLibrary.GetAppPath).Name(TMyVclLibrary.GetAppName).Section('CONFIGURATION');
   FLinksFile       := TMyTxtLibrary.New.Caminho(TMyVclLibrary.GetAppPath).Nome(TMyVclLibrary.GetAppName);
   FParar           := False;
   FFechar          := False;
   FLinksCounter    := 0;
   FTempoFechamento := 20000;
end;

function TModelSistema.OnStatus(AValue: TProc<String>): IModelSistema;
begin
   Result    := Self;
   FOnStatus := AValue;
end;

procedure TModelSistema.DoStatus(AMsg: string);
begin
   if(Assigned(FOnStatus))then
     FOnStatus(AMsg);
end;

function TModelSistema.PastaDownload: string;
begin
   if(FPastaDownload = EmptyStr)then
     FPastaDownload := TMyVclLibrary.SelectDirectory('Selecione a pasta onde os arquivos baixados estão');

   Result := IncludeTrailingPathDelimiter(FPastaDownload);
end;

function TModelSistema.PastaExtrair: string;
begin
   if(FPastaExtrair = EmptyStr)then
     FPastaExtrair := TMyVclLibrary.SelectDirectory('Selecione a pasta para qual os arquivos serão extraidos');

   Result := IncludeTrailingPathDelimiter(FPastaExtrair);
end;

function TModelSistema.Browser: string;
begin
   if(FBrowser = EmptyStr)then
     FBrowser := Model.Utils.CDefaultBrowser;

   Result := FBrowser;
end;

function TModelSistema.Parar: Boolean;
begin
   Result := FParar;
end;

function TModelSistema.Fechar: Boolean;
begin
   Result := FFechar;
end;

function TModelSistema.ConfigurationLoad: IModelSistema;
begin
   Result := Self;
   Self.DoStatus('Carregando configurações');

   if(not FileExists(FIniFile.Path + FIniFile.Name))then
     Self.CreateConfFile;

   FPastaDownload := FIniFile.Identifier(Model.Utils.CIdentPastaDownload).ReadIniFileStr;
   FPastaExtrair  := FIniFile.Identifier(Model.Utils.CIdentPastaExtrair).ReadIniFileStr;
   FBrowser       := FIniFile.Identifier(Model.Utils.CIdentBrowser).ReadIniFileStr;
end;

procedure TModelSistema.CreateConfFile;
begin
   FIniFile
    .Identifier(Model.Utils.CIdentPastaDownload).WriteIniFile(Self.PastaDownload)
    .Identifier(Model.Utils.CIdentPastaExtrair).WriteIniFile(Self.PastaExtrair)
    .Identifier(Model.Utils.CIdentBrowser).WriteIniFile(Model.Utils.CDefaultBrowser);
end;

function TModelSistema.LinksLoad: Boolean;
begin
   Result := False;

   if(not FileExists(FLinksFile.Caminho + FLinksFile.Nome))then
     Exit;

   if(FLinksFile.ReadTxtFile.IsEmpty)then
     Exit;

   Result := True;
end;

function TModelSistema.DownloadFiles: IModelSistema;
begin
   Result := Self;
   Self.VerifyInternet;
   Self.ClearDownloadRepository;
   Self.ProcessFilesDownlod;
end;

procedure TModelSistema.VerifyInternet;
begin
   if(Self.Parar)then
     Exit;

   if(not TMyLibrary.IsInternetConnected)then
   begin
      Self.DoStatus('Sem conexão com a internet');
      FParar := True;
      Exit;
   end;
end;

procedure TModelSistema.ClearDownloadRepository;
var
  LListaArquivos: TStrings;
  I: Integer;
begin
   if(Self.Parar)then
     Exit;

   Self.DoStatus('Limpando a pasta de downloads');

   LListaArquivos := TStringList.Create;
   try
     TMyLibrary.GetFilesList(Self.PastaDownload, '*', LListaArquivos);

     for I := 0 to LListaArquivos.Count - 1 do
       DeleteFile(Self.PastaDownload + LListaArquivos[I]);
   finally
     LListaArquivos.Free;
   end;

   Self.DoStatus('Pasta de downloads limpa');
end;

procedure TModelSistema.ProcessFilesDownlod;
var
  LListaLinks: TStrings;
  I: Integer;
begin
   if(Self.Parar)then
     Exit;

   Self.DoStatus('Fazendo download dos arquivos');

   FLinksCounter := 0;
   LListaLinks := TStringList.Create;
   try
     FLinksFile.ReadTxtFile(LListaLinks);

     if(LListaLinks.Count = 0)then
     begin
        Self.DoStatus('Nenhum link informado');
        FParar := True;
        Exit;
     end;

     for I := 0 to LListaLinks.Count - 1 do
     begin
        if(Self.Parar)then
          Exit;

        Inc(FLinksCounter);
        TMyVclLibrary.OpenLink(LListaLinks[I].Trim);
        Self.WaitDownloadFinish;
     end;

     Self.DoStatus('Realizado download dos arquivos');
   finally
     LListaLinks.Free;
   end;
end;

function TModelSistema.TempoFechamento: Integer;
begin
   Result := FTempoFechamento;
end;

procedure TModelSistema.WaitDownloadFinish;
var
  LListaArquivos: TStrings;
begin
   if(Self.Parar)then
     Exit;

   LListaArquivos := TStringList.Create;
   try
     repeat
       Sleep(1000);
       TMyLibrary.GetFilesList(Self.PastaDownload, 'zip', LListaArquivos);
     until(LListaArquivos.Count >= FLinksCounter);
   finally
     LListaArquivos.Free;
   end;
end;

function TModelSistema.ExtractDownloadedFiles: IModelSistema;
var
  LListaArquivos: TStrings;
  I: Integer;
  LFile: string;
begin
   Result := Self;

   if(Self.Parar)then
     Exit;

   Self.DoStatus('Extraindo arquivos baixados para pasta: ' + Self.PastaExtrair);

   LListaArquivos := TStringList.Create;
   try
     TMyLibrary.GetFilesList(Self.PastaDownload, 'zip', LListaArquivos);

     for I := 0 to LListaArquivos.Count - 1 do
     begin
        LFile := Self.PastaDownload + LListaArquivos[I];
        TMyVclLibrary.DescompactFile(LFile, Self.PastaExtrair);
     end;
   finally
     LListaArquivos.Free;
   end;

   Self.DoStatus('Arquivos extraidos com sucesso');

   Self.ClearDownloadRepository;
end;

function TModelSistema.CloseBrowser: IModelSistema;
begin
   Result := Self;

   Self.DoStatus('Fechando o navegador');
   TMyLibrary.CloseApplication(Self.Browser);
end;

function TModelSistema.CloseSystem: IModelSistema;
begin
   Result  := Self;
   FFechar := True;
end;

end.
