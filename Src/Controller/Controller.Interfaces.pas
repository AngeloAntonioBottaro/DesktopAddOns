unit Controller.Interfaces;

interface

uses
  Model.Sistema.Interfaces;

type
  iController = interface
   ['{7640E6F5-3F6C-4898-A94B-116236ECCD83}']
   //Controller.Factory
   function Sistema: iModelSistema;
  end;

implementation

end.
