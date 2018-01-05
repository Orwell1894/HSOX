program HSOX;

uses
  System.StartUpCopy,
  FMX.Forms,
  HSOXUnit in 'HSOXUnit.pas' {WHSOX},
  HSOXModule in 'HSOXModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TWHSOX, WHSOX);
  Application.Run;
end.
