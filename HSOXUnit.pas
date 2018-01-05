unit HSOXUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Gestures, System.Actions, FMX.ActnList, System.ImageList, SyncObjs,
  FMX.ListBox, System.Rtti, FMX.Platform, FMX.Surfaces,
  System.Notification, FMX.Layouts, HSOXModule, FMX.ExtCtrls,
  FMX.Advertising, FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.ComboTrackBar,
  FMX.ComboEdit, FMX.SpinBox, FMX.MagnifierGlass, FMX.MultiView, FMX.Effects,
  FMX.Filter.Effects, FMX.Objects, FMX.Styles.Objects, FMX.Ani, FMX.Colors,
  FMX.ScrollBox, FMX.Memo;//, FMX.Platform.Android, Androidapi.Helpers, Androidapi.JNI.App;

type
  TWHSOX = class(TForm)
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    StyleBook1: TStyleBook;
    MultiView1: TMultiView;
    Panel2: TPanel;
    SpeedButton3: TSpeedButton;
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
    TabItem4: TTabItem;
    TabItem2: TTabItem;
    ToolBar2: TToolBar;
    lblTitle2: TLabel;
    btn_main: TButton;
    GridPanelLayout3: TGridPanelLayout;
    Label12: TLabel;
    BoxSites: TComboBox;
    ListSocks: TListBox;
    GridPanelLayout01: TGridPanelLayout;
    PanelProgress: TPanel;
    ProgressValue: TLabel;
    GlowEffect2: TGlowEffect;
    ProgressVision: TAniIndicator;
    LabelSox: TLabel;
    GlowValue: TGlowEffect;
    btn_Research: TSpeedButton;
    GlowEffect1: TGlowEffect;
    Button1: TButton;
    btn_exit: TSpeedButton;
    LayoutBottom: TLayout;
    LogBox: TListBox;
    LayoutTop: TLayout;
    Logo: TLabel;
    InfoBox: TListBox;
    LabelBottom: TLabel;
    Timer1: TTimer;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MultiView1Shown(Sender: TObject);
    procedure MultiView1Hidden(Sender: TObject);
    procedure MultiView1StartShowing(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure IncCountCheckSocks(LinkIndex: Integer);
    procedure btn_ResearchClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure StartParsing;
  public
    { Public declarations }
  end;

function UnQuote(S: String): String;

var
  WHSOX: TWHSOX;
  RunLevel, CountLink, TimeLeft: Byte;
  Sox: TSocks;

implementation

{$R *.fmx}

function UnQuote(S: String): String;
begin
  Result :=Copy(S,2,Length(S)-2);
end;

procedure TWHSOX.IncCountCheckSocks(LinkIndex: Integer);
Var S,dS: String;
    i: byte;
begin
  S :=LogBox.ItemByIndex(LinkIndex).ItemData.Detail;
  dS :=Copy(S,Pos(S,'/')+1,Length(S)-Pos(S,'/'));
  S :=Copy(S,1,Pos(S,'/')-1);
  i :=(StrToInt(S))+1;
  LogBox.ItemByIndex(LinkIndex).ItemData.Detail :=IntToStr(i)+'/'+dS;
end;

procedure TWHSOX.btn_exitClick(Sender: TObject);
begin
  Close;
end;

procedure TWHSOX.btn_ResearchClick(Sender: TObject);
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
  LabelBottom.Text :='Поиск носка продолжается ...';
  Timer1.Enabled :=True;
  For i:=0 to LogBox.Items.Count-1 do
    if LogBox.ItemByIndex(i).Visible then
      begin
        CheckProxy(i);
        Sleep(200);
      end;
end;

procedure TWHSOX.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Link.Free;
//  SParser.Free;
end;

procedure TWHSOX.StartParsing;
begin
  TThread.CreateAnonymousThread(procedure
      Var i: Word;
      begin
        While not ParsingLink do
          begin
            Sleep(1000);
            Case RunLevel of
                //Уровень парсинга сайтов с прокси
                0:  try
                      If not ParsedLinks then If not ParsingLinks then ParserLinks
                        else else inc(RunLevel);
                    except
                    end;
                //Уровень парсинга прокси с сайтов
                1:  try
                    If not ParsedLink then
                      begin
                        If LogBox.Items.Count>0 then
                          begin
                            ParsingLink :=True;
                            For i:=0 to LogBox.Items.Count-1 do
                              begin
                                ParserSocksInLinks(i);
                                Sleep(50);
                              end;
                          end else ParsedLinks :=False;
                      end else inc(RunLevel);
                    except
                    end;
              End;
          end;
    end).Start;
end;

procedure TWHSOX.Timer1Timer(Sender: TObject);
Var i: Word;
    Svc: IFMXClipboardService;
    R: TRegExp;
    S: String;
begin
  If not FindedSocks then
    begin
      dec(TimeLeft);
      if TimeLeft=0 then inc(TimeLeft,10);
      ProgressValue.Text:=('приблизительное время поиска носка '+IntToStr(TimeLeft)+' секунд');
      LogBox.UpdateEffects;
      LogBox.Repaint;
    end else
    begin
      ProgressVision.Enabled :=False;
      ProgressVision.Visible :=False;
      btn_Research.Visible :=True;
      S :=Sox.IP+':'+Sox.PORT;
      If TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc) then
        Svc.SetClipboard(S);
      ProgressValue.Text :='носок типа '+Sox.STYPE+' скопирован в буффер обмена !';
      LabelBottom.Text :='буффер обмена: '+Sox.IP+':'+Sox.PORT+' ('+Sox.STYPE+')';
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
        Logo.Visible :=False;
        InfoBox.Visible :=True;
      end;
      LogBox.UpdateEffects;
      LogBox.Repaint;
      Timer1.Enabled :=False;
    end;
end;

procedure TWHSOX.FormCreate(Sender: TObject);
Var i: Word;
begin
//  Link :=TLink.Create(nil);
  For i:=1 to 10 do Links[i] :=TLink.Create(nil);
//  SParser :=TParser.Create;
  TimeLeft :=30;  RunLevel :=0;  CountLink :=0;  n_google :=0;
  ParsedLinks :=False; ParsingLinks :=False;
  ParsedLink :=False; ParsingLink :=False;
  FindedSocks :=False; FindingSocks :=False;
  StartParsing;
  ProgressVision.Enabled :=True;
end;

procedure TWHSOX.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (TabControl1.Index>0) and (Key = vkHardwareBack) then
    begin
        PreviousTabAction1.ExecuteTarget(self);
        Key := 0;
    end;
end;

procedure TWHSOX.GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
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

procedure TWHSOX.MultiView1Hidden(Sender: TObject);
begin
  SpeedButton3.StyleLookup :='arrowrighttoolbutton';
//  MultiView1.MasterButton :=SpeedButton4;
  Panel2.Visible :=False;
end;

procedure TWHSOX.MultiView1Shown(Sender: TObject);
begin
  SpeedButton3.StyleLookup :='arrowlefttoolbutton';
  SpeedButton3.ResetFocus;
end;

procedure TWHSOX.MultiView1StartShowing(Sender: TObject);
begin
  Panel2.Visible :=True;
  MultiView1.Size.Width :=330;
  MultiView1.MasterButton :=SpeedButton3;
end;

procedure TWHSOX.SpeedButton7Click(Sender: TObject);
begin
//  {$IFDEF ANDROID}
//  SharedActivity.finish;
//  MainActivity.finish;
  Close;
//  {$ENDIF}
end;

end.

