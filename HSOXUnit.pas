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
  FMX.Filter.Effects, FMX.Objects, FMX.Styles.Objects, FMX.Ani,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FMX.ScrollBox,
  FMX.Memo, ceffmx, ceflib, FireDAC.FMXUI.Login, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.SQLiteVDataSet,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI;
  //, FMX.Platform.Android, Androidapi.Helpers, Androidapi.JNI.App;

type
  TWHSOX = class(TForm)
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
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
    btn_exit: TSpeedButton;
    LayoutBottom: TLayout;
    LogBox: TListBox;
    LayoutTop: TLayout;
    Logo: TLabel;
    InfoBox: TListBox;
    LabelBottom: TLabel;
    Timer1: TTimer;
    FDConnection1: TFDConnection;
    TabItem3: TTabItem;
    Button1: TButton;
    MultiView1: TMultiView;
    GridPanelLayout4: TGridPanelLayout;
    TabControl2: TTabControl;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    GridPanelLayout6: TGridPanelLayout;
    Label13: TLabel;
    SOX_Dalay: TNumberBox;
    Label14: TLabel;
    NumberBox1: TNumberBox;
    Label17: TLabel;
    GridPanelLayout5: TGridPanelLayout;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label19: TLabel;
    NumberBox2: TNumberBox;
    Label16: TLabel;
    ComboBoxSearchSystems: TComboBox;
    Label15: TLabel;
    ComboBox2: TComboBox;
    Label18: TLabel;
    ComboBox4: TComboBox;
    Label20: TLabel;
    Switch1: TSwitch;
    Label21: TLabel;
    ComboBox3: TComboBox;
    TabItem7: TTabItem;
    ChromiumFMX1: TChromiumFMX;
    TabItem8: TTabItem;
    Memo1: TMemo;
    Label22: TLabel;
    NumberBox3: TNumberBox;
    FDGUIxLoginDialog1: TFDGUIxLoginDialog;
    FDTable1: TFDTable;
    FDQuery1: TFDQuery;
    FDLocalSQL1: TFDLocalSQL;
    FDTransaction1: TFDTransaction;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure MultiView1Shown(Sender: TObject);
    procedure MultiView1Hidden(Sender: TObject);
    procedure MultiView1StartShowing(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure btn_ResearchClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ChromiumFMX1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    function Loggy(S: String): String;
  private
    procedure StartParsing;
  public
    { Public declarations }
  end;

function UnQuote(S: String): String;
//procedure VeiwSource1(const src: string);

var
  WHSOX: TWHSOX;
  RunLevel, CountLink, TimeLeft, CurLinkIndex: Byte;
  Sox: TSocks;

implementation

{$R *.fmx}

function TWHSOX.Loggy(S: string): String;
begin
  Result :=TimeToStr(Time)+'>>'+S;
  Memo1.Lines.Add(Result);
end;

procedure ViewSource1(const src: string);
Var source: String;
begin
  source :=src;
  WHSOX.Memo1.Lines.Add(source);
end;

//Убирает ковычки
function UnQuote(S: String): String;
begin
  Result :=Copy(S,2,Length(S)-2);
end;

//Выход
procedure TWHSOX.btn_exitClick(Sender: TObject);
begin
//  Chromium1.LoadURL('https://google.com');
//  Chromium1.
//  ChromiumFMX1.DefaultUrl :='https://google.com';
//  ChromiumFMX1.Load('https://google.com');
//  ChromiumFMX1.Visible :=True;
//  {$IFDEF ANDROID}
//  SharedActivity.finish;
//  MainActivity.finish;
//  {$ENDIF}
//  Close;
end;

//Продолжение поиска
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
  ProgressValue.Text:=('Идет поиск прокси для соединения...');
  LabelBottom.Text :='Идет поиск прокси для соединения...';
  Timer1.Enabled :=True;
  For i:=0 to LogBox.Items.Count-1 do
    if LogBox.ItemByIndex(i).Visible then
      begin
        CheckProxy(i);
        Sleep(200);
      end;
end;

procedure TWHSOX.Button1Click(Sender: TObject);
begin
//  ChromiumFMX1.Load('https://google.com');
end;


procedure TWHSOX.FDConnection1BeforeConnect(Sender: TObject);
var DBPath: string;
begin
  {$IFDEF ANDROID}
//     DBPath:=TPath.GetSharedDocumentsPath + PathDelim + 'lbase.db';
  {$ELSE}
     DBPath:='d:\test\lbase.db';
  {$ENDIF}
//  if TFile.Exists(DBPath) then
//    ShowMessage('File exist') else
//    ShowMessage('File not exist');
  FDConnection1.Params.Values['Database']:= DBPath;
end;

procedure StringVisitor(const str: ustring);
begin
  case RunLevel of
    0:  if not ParsedLinks then ParserLinks(str);
    1:  begin
          ParseSox(str, CurLinkIndex);
          ParsingLink :=False;
    end;
  end;
end;


procedure TWHSOX.ChromiumFMX1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
Var  CefStringVisitor: ICefStringVisitor;
begin
  Loggy('Страница загружена, парсим ссылки');
  CefStringVisitor := TCefFastStringVisitor.Create(StringVisitor);
  WHSOX.ChromiumFMX1.Browser.MainFrame.GetSource(CefStringVisitor);
end;

//Поток поиска сайтов с прокси и парсинг прокси на сайтах
procedure TWHSOX.StartParsing;
begin
  TThread.CreateAnonymousThread(procedure
      Var i: Word;
      begin
        While not ParsingLink do
          try
            Sleep(1000);
            Case RunLevel of
                //Уровень парсинга сайтов с прокси
                0:  try
                      If not ParsedLinks then If not ParsingLinks then
                        try
                          ParsingLinks :=True;
                          Loggy('Загрузка страницы');
                          Loggy('https://duckduckgo.com/?q=free+socks+5+proxy&t=h_&ia=web0');
                          ChromiumFMX1.Load('https://duckduckgo.com/?q=free+socks+5+proxy&t=h_&ia=web0')
                        finally
                        end
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
                            WHSOX.LabelBottom.Text :=TextL3;
                            For i:=0 to LogBox.Items.Count-1 do
                              begin
                                Links[i] :=TLink.Create(nil);
                                Loggy('Загрузка страницы');
                                CurLinkIndex :=i;
                                Loggy(LogBox.Items[i]);
                                WHSOX.ChromiumFMX1.Load(LogBox.Items[i]);
//                                ParserSocksInLinks(i);
                                while ParsingLink do Sleep(500);
                                If FindedSocks then break;
                              end;
                          end else ParsedLinks :=False;
                      end else inc(RunLevel);
                    except
                    end;
              End;
          except
          end;
    end).Start;
  Loggy('Запущен поток парсинга сайтов с прокси');
end;

//Отчет времени поиска прокси и применение эффектов после того, как найден рабочий прокси
procedure TWHSOX.Timer1Timer(Sender: TObject);
Var i: Word;
    Svc: IFMXClipboardService;
    R: TRegExp;
    S: String;
begin
  If not FindedSocks then
    begin
      inc(TimeLeft);
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
      ProgressValue.Text :=TextL6;
      LabelBottom.Text :=TextL6;
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

//Создание формы
procedure TWHSOX.FormCreate(Sender: TObject);
Var i: Word;
begin
  Loggy('Создание формы');
  For i:=1 to 10 do Links[i] :=TLink.Create(nil);
  TimeLeft :=30;  RunLevel :=0;  CountLink :=0;  n_google :=0;
  ParsedLinks :=False; ParsingLinks :=False;
  ParsedLink :=False; ParsingLink :=False;
  FindedSocks :=False; FindingSocks :=False;
  StartParsing;
  ProgressValue.Text:=('Идет поиск прокси для соединения...');
  LabelBottom.Text :='Идет поиск прокси для соединения...';
  ProgressVision.Enabled :=True;
  Loggy('Форма создана');
end;

procedure TWHSOX.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
//  if (TabControl1.Index>0) and (Key = vkHardwareBack) then
//    begin
//        PreviousTabAction1.ExecuteTarget(self);
//        Key := 0;
//    end;
end;

procedure TWHSOX.GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
//  case EventInfo.GestureID of
//    sgiLeft:
//      begin
//        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
//          NextTabAction1.ExecuteTarget(Self);
//        Handled := True;
//      end;
//    sgiRight:
//      begin
//        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
//          PreviousTabAction1.ExecuteTarget(Self);
//        Handled := True;
//      end;
//  end;
end;

procedure TWHSOX.MultiView1Hidden(Sender: TObject);
begin
//  SpeedButton3.StyleLookup :='arrowrighttoolbutton';
//  MultiView1.MasterButton :=SpeedButton4;
//  Panel2.Visible :=False;
end;

procedure TWHSOX.MultiView1Shown(Sender: TObject);
begin
//  SpeedButton3.StyleLookup :='arrowlefttoolbutton';
//  SpeedButton3.ResetFocus;
end;

procedure TWHSOX.MultiView1StartShowing(Sender: TObject);
begin
//  Panel2.Visible :=True;
//  MultiView1.Size.Width :=330;
//  MultiView1.MasterButton :=SpeedButton3;

end;

end.

