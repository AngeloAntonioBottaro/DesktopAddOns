program AddOns;

uses
  System.SysUtils,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  View.Principal in 'Src\View\View.Principal.pas' {ViewPrincipal},
  Controller.Interfaces in 'Src\Controller\Controller.Interfaces.pas',
  Controller.Factory in 'Src\Controller\Controller.Factory.pas',
  Model.Sistema.Interfaces in 'Src\Model\Sistema\Model.Sistema.Interfaces.pas',
  Model.Sistema in 'Src\Model\Sistema\Model.Sistema.pas',
  Model.Utils in 'Src\Model\Utils\Model.Utils.pas',
  View.Sobre in 'Src\View\View.Sobre.pas' {ViewSobre},
  View.NewLink in 'Src\View\View.NewLink.pas' {ViewNewLink};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Desktop AddOns';
  Application.MainFormOnTaskBar := False;
  TStyleManager.TrySetStyle('Amethyst Kamri');

  ViewPrincipal := TViewPrincipal.Create(nil);
  try
    ViewPrincipal.Update;
    ViewPrincipal.ShowModal;
    repeat
      Application.ProcessMessages;
    until ViewPrincipal.CloseQuery;
  finally
    FreeAndNil(ViewPrincipal);
  end;

  Application.Run;
end.
