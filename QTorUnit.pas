unit QTorUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Gestures, System.Actions, FMX.ActnList, System.ImageList, SyncObjs,
  FMX.ListBox, System.Rtti, FMX.Platform, FMX.Surfaces,
  System.Notification, FMX.Layouts, QTorModule, FMX.ExtCtrls,
  FMX.Advertising, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.ComboTrackBar,
  FMX.ComboEdit, FMX.SpinBox, FMX.MagnifierGlass, FMX.MultiView, FMX.Effects,
  FMX.Filter.Effects, FMX.Objects, FMX.Styles.Objects, FMX.Ani, FMX.Colors,
  FMX.ScrollBox, FMX.Memo;//, FMX.Platform.Android, Androidapi.Helpers, Androidapi.JNI.App;

type
  TQTorWindow = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    ToolBar1: TToolBar;
    lblTitle1: TLabel;
    btn_sockslist: TButton;
    GridPanelLayout1: TGridPanelLayout;
    GridPanelLayout2: TGridPanelLayout;
    Label_Status: TLabel;
    Status_Text: TLabel;
    Panel_NextProxy: TPanel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    Label11: TLabel;
    Panel_Socks_Info: TGridPanelLayout;
    Label_IP: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TabItem2: TTabItem;
    ToolBar2: TToolBar;
    lblTitle2: TLabel;
    btn_main: TButton;
    GridPanelLayout3: TGridPanelLayout;
    Label12: TLabel;
    BoxSites: TComboBox;
    ListSocks: TListBox;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    StyleBook1: TStyleBook;
    GridPanelLayout01: TGridPanelLayout;
    MultiView1: TMultiView;
    Panel2: TPanel;
    SpeedButton3: TSpeedButton;
    PanelProgress: TPanel;
    ProgressBar1: TProgressBar;
    ProgressValue: TLabel;
    GlowValue: TGlowEffect;
    ProgressVision: TAniIndicator;
    Button1: TButton;
    btn_exit: TSpeedButton;
    LabelSox: TLabel;
    GlowEffect1: TGlowEffect;
    LayoutBottom: TLayout;
    LogBox: TListBox;
    Memo1: TMemo;
    btn_Research: TSpeedButton;
    LayoutTop: TLayout;
    Logo: TLabel;
    InfoBox: TListBox;
    GlowEffect2: TGlowEffect;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MultiView1Shown(Sender: TObject);
    procedure MultiView1Hidden(Sender: TObject);
    procedure MultiView1StartShowing(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure ColorPicker1Click(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure IncCountCheckSocks(LinkIndex: Integer);
    procedure btn_ResearchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function UnQuote(S: String): String;

var
  QTorWindow: TQTorWindow;
  RunLevel, CountLink, TimeLeft: Byte;
  eee, RunBaby: Boolean;
  WorkLinks: TStrings;
  Sox: TSocks;

implementation

{$R *.fmx}

function UnQuote(S: String): String;
begin
  Result :=Copy(S,2,Length(S)-2);
end;

procedure TQTorWindow.IncCountCheckSocks(LinkIndex: Integer);
Var S,dS: String;
    i: byte;
begin
  S :=LogBox.ItemByIndex(LinkIndex).ItemData.Detail;
  dS :=Copy(S,Pos(S,'/')+1,Length(S)-Pos(S,'/'));
  S :=Copy(S,1,Pos(S,'/')-1);
  i :=(StrToInt(S))+1;
  LogBox.ItemByIndex(LinkIndex).ItemData.Detail :=IntToStr(i)+'/'+dS;
end;

procedure TQTorWindow.btn_exitClick(Sender: TObject);
begin
  Close;
end;

procedure TQTorWindow.btn_ResearchClick(Sender: TObject);
Var i: Word;
begin
  btn_Research.Visible :=False;
  ProgressVision.Visible :=True;
  ProgressVision.Enabled :=True;
  InfoBox.Visible :=False;
  Logo.Visible :=True;
  FindedSocks :=False;
  TimeLeft :=20;
  ProgressValue.Text:=('приблизительное время поиска носка '+IntToStr(TimeLeft)+' секунд');
  Timer1.Enabled :=True;
  For i:=0 to LogBox.Items.Count-1 do
    if LogBox.ItemByIndex(i).Visible then
      begin
        CheckProxy(i);
        Sleep(200);
      end;
end;

procedure TQTorWindow.ColorPicker1Click(Sender: TObject);
begin
//  ListBoxItem1.
end;

procedure TQTorWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Link.Free;
  SParser.Free;
end;

procedure TQTorWindow.FormCreate(Sender: TObject);
Var i: Word;
begin
//  ListBox1.ItemDown.Font.Size :=6;
  TabControl1.ActiveTab := TabItem4;
  LinksWithSocks :=TStringList.Create;
  Link :=TLink.Create(nil);
  For i:=1 to 10 do Links[i] :=TLink.Create(nil);
  SParser :=TParser.Create;
  n_google :=0; WorkLinks :=TStringList.Create;
  Timer1.Enabled :=True;
  CountLink :=0;
  ParsedLinks :=False; ParsingLinks :=False;
  ParsedLink :=False; ParsingLink :=False;
  FindedSocks :=False; FindingSocks :=False;
  RunLevel :=0;
  ProgressVision.Enabled :=True;
  TimeLeft :=30;
  TThread.CreateAnonymousThread(procedure
    Var i: Word;
    begin
      While not ParsingLink do
        begin
          Sleep(1000);
          Case RunLevel of
              //Уровень парсинга сайтов с прокси
              0:  try
                  If not ParsedLinks then
                      If not ParsingLinks then ParserLinks
                         else else inc(RunLevel);
                  except
                  end;
              //Уровень парсинга прокси с сайтов
              1:  try
                  If not ParsedLink then
                    begin
                      If not ParsingLink then
                        begin
                          If LogBox.Items.Count>0 then
                            begin
                              ParsingLink :=True;
                              For i:=0 to LogBox.Items.Count-1 do
                                begin
                                  ParserSocksInLinks(i);
                                  Sleep(200);
                                end;
                            end;
                        end;
                    end else inc(RunLevel);
                  except
                  end;
            End;
        end;
  end).Start;
end;

procedure TQTorWindow.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (TabControl1.Index>0) and (Key = vkHardwareBack) then
    begin
        PreviousTabAction1.ExecuteTarget(self);
        Key := 0;
    end;
end;

procedure TQTorWindow.GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
          NextTabAction1.ExecuteTarget(Self);
        Handled := True;
      end;
    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          PreviousTabAction1.ExecuteTarget(Self);
        Handled := True;
      end;
  end;
end;

procedure TQTorWindow.MultiView1Hidden(Sender: TObject);
begin
  SpeedButton3.StyleLookup :='arrowrighttoolbutton';
//  MultiView1.MasterButton :=SpeedButton4;
  Panel2.Visible :=False;
end;

procedure TQTorWindow.MultiView1Shown(Sender: TObject);
begin
  SpeedButton3.StyleLookup :='arrowlefttoolbutton';
  SpeedButton3.ResetFocus;
end;

procedure TQTorWindow.MultiView1StartShowing(Sender: TObject);
begin
  Panel2.Visible :=True;
  MultiView1.Size.Width :=330;
  MultiView1.MasterButton :=SpeedButton3;
end;

procedure TQTorWindow.SpeedButton7Click(Sender: TObject);
begin
//  try
//  Application.Terminate;
//  FreeAndNil(QTorWindow);
//  QTorWindow.Destroy;
//  except
//  end;
//  {$IFDEF ANDROID}
//  SharedActivity.finish;
//  MainActivity.finish;
  Close;
//  {$ENDIF}
end;

procedure TQTorWindow.Timer1Timer(Sender: TObject);
Var i: Word;
    Svc: IFMXClipboardService;
    R: TRegExp;
    S: String;
begin
  If not FindedSocks then
    begin
      dec(TimeLeft);
      if TimeLeft=0 then
        begin
          inc(TimeLeft,10);
        end;
      ProgressValue.Text:=('приблизительное время поиска носка '+IntToStr(TimeLeft)+' секунд');
    end else
    begin
      TThread.CreateAnonymousThread(procedure
        begin
          ProgressVision.Enabled :=False;
          ProgressVision.Visible :=False;
          btn_Research.Visible :=True;
          S :=Sox.IP+':'+Sox.PORT;
          If TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then
            Svc.SetClipboard(S);
          ProgressValue.Text :='носок типа '+Sox.STYPE+' скопирован в буффер обмена !';
          R.RMathes :=R.RegEx.Matches(Sox.PAGE, RE_GL_INFO);
          InfoBox.Items.Clear;
          If R.RMathes.Count>0 then
          begin
            InfoBox.Items.Add(Sox.IP+':'+Sox.PORT);
            InfoBox.Items.Add(UnQuote(R.RMathes.Item[3].Value));
            InfoBox.Items.Add(UnQuote(R.RMathes.Item[5].Value));
            InfoBox.Items.Add(UnQuote(R.RMathes.Item[7].Value));
            InfoBox.Items.Add(UnQuote(R.RMathes.Item[9].Value));
            InfoBox.Items.Add(UnQuote(R.RMathes.Item[11].Value));
            InfoBox.ItemByIndex(0).ItemData.Detail :=Sox.STYPE;
            InfoBox.ItemByIndex(0).IsSelected :=True;
  //          InfoBox.ItemByIndex(1).ItemData.Detail :='провайдер';
  //          InfoBox.ItemByIndex(2).ItemData.Detail :='город';
  //          InfoBox.ItemByIndex(3).ItemData.Detail :='регион';
  //          InfoBox.ItemByIndex(4).ItemData.Detail :='страна';
  //          InfoBox.ItemByIndex(5).ItemData.Detail :='координаты';
            Logo.Visible :=False;
            InfoBox.Visible :=True;
          end;
          LogBox.UpdateEffects;
          LogBox.Repaint;
        end).Start;
      Timer1.Enabled :=False;
    end;
end;

procedure TQTorWindow.Timer2Timer(Sender: TObject);
begin
    Timer2.Enabled :=False;
//  FloatAnimation1.Enabled :=True;
//  FloatAnimation1.Start;
//  ProgressBar1.Value :=ProgressBar1.Value+1;
//  i :=Round(ProgressBar1.Value);
//  ProgressValue.Text :='готовность , '+IntToStr(i)+'%';
//  if i = 100 then
//    begin
//      timer2.Enabled :=False;
//      PanelProgress.Visible :=False;
//      Logo.Visible :=False;
//    end
end;

end.

