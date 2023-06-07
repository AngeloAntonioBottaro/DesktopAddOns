unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.ImgList,
  Controller.Interfaces,
  Vcl.Menus,
  Vcl.Imaging.pngimage;

type
  TViewPrincipal = class(TForm)
    TimerShow: TTimer;
    TrayIcon: TTrayIcon;
    PopupMenu: TPopupMenu;
    Exit1: TMenuItem;
    pnTela: TPanel;
    N1: TMenuItem;
    About1: TMenuItem;
    StatusBar: TStatusBar;
    TimerTerminate: TTimer;
    Linksconf1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure TimerTerminateTimer(Sender: TObject);
    procedure Linksconf1Click(Sender: TObject);
  private
    FController: IController;
    procedure DoStatus(AMessage: string);
    procedure TerminateSystem;
  public
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

uses
  Controller.Factory,
  Model.Utils,
  View.Sobre,
  View.NewLink;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
   ReportMemoryLeaksOnShutdown := True;
   Self.Caption                := Self.Caption + Model.Utils.SystemVersion;
   FController                 := TController.New;
end;

procedure TViewPrincipal.TimerShowTimer(Sender: TObject);
begin
   TimerShow.Enabled := False;
   Self.Hide;

   FController
    .Sistema
     .OnStatus(Self.DoStatus)
     .VerifyApplicationOpen
     .ConfigurationLoad
     .LinksLoad
     .DownloadFiles
     .ExtractDownloadedFiles
     .CloseBrowser
     .CloseSystem;

   if(FController.Sistema.Fechar)then
   begin
      TimerTerminate.Interval := FController.Sistema.TempoFechamento;
      TimerTerminate.Enabled  := True;
      Self.DoStatus('Fechando sistema ...');
      Exit;
   end;

   TimerShow.Interval := 5000;
   TimerShow.Enabled  := True;
   Self.DoStatus('Tentando novamente em 5 segundos...');
end;

procedure TViewPrincipal.TimerTerminateTimer(Sender: TObject);
begin
   Self.TerminateSystem;
end;

procedure TViewPrincipal.About1Click(Sender: TObject);
var
  LEnabled: Boolean;
begin
   LEnabled := TimerTerminate.Enabled;
   TimerTerminate.Enabled := False;
   Application.CreateForm(TViewSobre, ViewSobre);
   try
     ViewSobre.ShowModal;
   finally
     FreeAndNil(ViewSobre);
   end;
   TimerTerminate.Enabled := LEnabled;
end;

procedure TViewPrincipal.Linksconf1Click(Sender: TObject);
var
  LEnabled: Boolean;
begin
   LEnabled := TimerTerminate.Enabled;
   TimerTerminate.Enabled := False;
   Application.CreateForm(TViewNewLink, ViewNewLink);
   try
     ViewNewLink.ShowModal;
   finally
     FreeAndNil(ViewNewLink);
   end;
   TimerTerminate.Enabled := LEnabled;
end;

procedure TViewPrincipal.DoStatus(AMessage: string);
begin
   if(AMessage.Trim.IsEmpty)then
     Exit;

   StatusBar.Panels[0].Text := AMessage.Trim;
   TrayIcon.Hint            := AMessage.Trim;
end;

procedure TViewPrincipal.Exit1Click(Sender: TObject);
begin
   Self.TerminateSystem;
end;

procedure TViewPrincipal.TerminateSystem;
begin
   TrayIcon.Visible := False;
   Application.Terminate;
   Abort;
end;

end.
