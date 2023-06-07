unit Controller.Factory;

interface

uses
  Controller.Interfaces,
  Model.Sistema.Interfaces;

type
  TController = class(TInterfacedObject, iController)
  private
    FSistema: iModelSistema;
  protected
    function Sistema: iModelSistema;
  public
    class function New: iController;
  end;

implementation

uses
  Model.Sistema;

class function TController.New: iController;
begin
   Result := Self.Create;
end;

function TController.Sistema: iModelSistema;
begin
   if(not Assigned(FSistema))then
     FSistema := TModelSistema.New;
   Result := FSistema;
end;

end.
