unit View.NewLink;

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
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Menus,
  Common.Utils.MyTxtLibrary;

type
  TViewNewLink = class(TForm)
    ListView: TListView;
    pn: TPanel;
    edtLink: TEdit;
    btnAddLink: TButton;
    PopupMenu: TPopupMenu;
    Deletarlink1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnAddLinkClick(Sender: TObject);
    procedure Deletarlink1Click(Sender: TObject);
  private
    FLinksFile: IMyTxtLibrary;
    procedure ListarLinks;
  public
  end;

var
  ViewNewLink: TViewNewLink;

implementation

{$R *.dfm}

uses
  MyVclLibrary;

procedure TViewNewLink.btnAddLinkClick(Sender: TObject);
var
  LLink: string;
begin
   LLink := Trim(edtLink.Text);

   if(not LLink.IsEmpty)then
     FLinksFile.WriteTxtFile(LLink);

   Self.ListarLinks;
end;

procedure TViewNewLink.Deletarlink1Click(Sender: TObject);
var
  LString: string;
begin
   if(ListView.ItemIndex < 0)then
     Exit;

   //ListView.ItemFocused.Caption;
end;

procedure TViewNewLink.FormShow(Sender: TObject);
begin
   FLinksFile := TMyTxtLibrary.New.Caminho(TMyVclLibrary.GetAppPath).Nome(TMyVclLibrary.GetAppName);
   Self.ListarLinks;
end;

procedure TViewNewLink.ListarLinks;
var
  LListaLinks: TStrings;
  I: Integer;
  LItem: TListItem;
begin
   ListView.Items.Clear;
   LListaLinks := TStringList.Create;
   try
     FLinksFile.ReadTxtFile(LListaLinks);

     for I := 0 to LListaLinks.Count - 1 do
     begin
        LItem         := ListView.Items.Add;
        LItem.Caption := LListaLinks[I].Trim;
     end;
   finally
     LListaLinks.Free;
   end;
   edtLink.Clear;
   ListView.Scroll(0, ListView.Items.Count -1);
end;

end.
