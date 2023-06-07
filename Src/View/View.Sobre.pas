unit View.Sobre;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TViewSobre = class(TForm)
    pnTela: TPanel;
    lbSistema: TLabel;
    pnGithub: TPanel;
    lbGithub: TLabel;
    imgGithub: TImage;
    Panel4: TPanel;
    Label4: TLabel;
    Image3: TImage;
    pnEmail: TPanel;
    lbEmail: TLabel;
    imgEmail: TImage;
    pnTelefone: TPanel;
    lbTelefone: TLabel;
    imgTelefone: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lbGithubMouseEnter(Sender: TObject);
    procedure lbGithubMouseLeave(Sender: TObject);
    procedure lbGithubClick(Sender: TObject);
  private
  public
  end;

var
  ViewSobre: TViewSobre;

implementation

{$R *.dfm}

uses
  Common.Utils.MyConsts,
  MyVclLibrary;

procedure TViewSobre.FormCreate(Sender: TObject);
begin
   lbEmail.Caption    := EMAIL_DESENVOLVEDOR;
   lbTelefone.Caption := TELEFONE_DESENVOLVEDOR;
   lbGithub.Caption   := GITHUB_DESENVOLVEDOR;
end;

procedure TViewSobre.lbGithubClick(Sender: TObject);
begin
   TMyVclLibrary.OpenLink(lbGithub.Caption);
end;

procedure TViewSobre.lbGithubMouseEnter(Sender: TObject);
begin
   lbGithub.StyleElements := [];
   lbGithub.Font.Color := clBlue;
end;

procedure TViewSobre.lbGithubMouseLeave(Sender: TObject);
begin
   lbGithub.StyleElements := [seFont, seClient, seBorder];
   lbGithub.Font.Color := clWindowText;
end;

end.
