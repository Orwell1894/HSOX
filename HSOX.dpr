program HSOX;

uses
  System.StartUpCopy,
  FMX.Forms,
  QTorUnit in 'QTorUnit.pas' {QTorWindow},
  QTorModule in 'QTorModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TQTorWindow, QTorWindow);
  Application.Run;
end.
