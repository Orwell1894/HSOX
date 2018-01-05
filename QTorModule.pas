unit QTorModule;

interface

uses
    System.Classes, System.Variants, System.SysUtils,
    idHTTP, IdSSL, IdSSLOpenSSL, IdCookieManager,
    IdCustomTransparentProxy, IdSocks, IdTCPClient,
    SyncObjs, RegularExpressions;

//Регулярные Выражения для поиска
Const
  RE_GL2 = '(?ism-x)(<h3)(.*?)((http|https)(.*?)(?=&amp;))';
  RE_GL5 = '(http|https)(.*)\w';
  RE_GL4 = '(?ism-x)(([0-9]{1,3}\.){3}([0-9]{1,3}))(.*?)((\d){2,5})';
  RE_GL_IP = '(?ism-x)(([0-9]{1,3}\.){3}([0-9]{1,3}))';
  RE_GL_PORT = '(?sim-x)[0-9]{2,5}$';
  RE_GL_INFO = '(?sim-x)"(.*?)"';

Const
  TextL1 = 'Проверяем доступ в интренет';
  TextL2 = 'Получаем список сайтов с носками';
  TextL3 = 'Собираем Прокси';
  TextL4 = 'Проверяем Прокси';
  TextL5 = 'Найден рабочий Прокси';
  TextL6 = 'Прокси Скопирован !';


//Строка поиска по носкам
Const google_search = 'https://www.google.com/search?q=free+socks5+proxy&start=';
      check_url1 = 'https://google.com';
      check_url2 = 'check2ip.com';
      check_url3 = 'https://ipinfo.io/';
      check_url4 = 'https://whoer.net';
      check_url5 = 'https://www.iplocation.net/';
      check_url6 = 'https://www.ip2location.com/';

//Тип регулярных выражений
type TRegExp = record
  RegEx: TRegEx;
  Option: TRegExOptions;
  Pattern: String;
  RMath: TMatch;
  RMathes: TMatchCollection;
end;

//Парсер на основе Indy
type TParser = Class(TObject)
  var
    FHTTP: TIdHTTP;
    FSSL: TIdSSLIOHandlerSocketOpenSSL;
    FCookie: TIdCookieManager;
    RegExp: TRegExp;
  constructor Create;
  destructor Destroy; override;
  function AsHTML(Url: String): String;
end;

//Тип Прокси
type TSocks = record
  ID: Integer;
  IP, PORT, STYPE, LOGIN, PASSW, STATUS, PAGE: String;
  LASTCHECK: TDateTime;
  Checking: Boolean;
  function InStrings: TStrings;
end;

//Объек сайт с прокси
type TLink = Class(TObject)
  public
    Url: String;
    CountSocks, PosSearch: Integer;
    Sockses: Array of TSocks;
    procedure SocksRandomize;
    procedure AddS(IP,PORT: String; STYPE: String=''; LOGIN: String=''; PASSW: String=''); overload;
    procedure AddS(Socks: TSocks); overload;
    procedure DelS; overload;
    constructor Create(Sender: TObject);
    Destructor Destroy; override;
End;

//Возвращает строку с уровнем директории выше
function UpDir(S: String; level: byte=1): String;
//Запускаем поток поиска сайтов с прокси
procedure ParserLinks;
//Запуск потока поиска проксей на текущем сайте
procedure ParserSocksInLinks(IndexLink: Word);
//Запуск потока проверки работоспособности прокси
procedure CheckProxy(LinkIndex: Integer);
//Загружаем настройки из param.qtr
procedure LoadParam;
//Сохраняем настройки в param.qtr
procedure SaveParam;

Var
    LinksWithSocks: TStrings;//Список сайтов с прокси
    Link: TLink;//Сайт с проксями
    Links: array[1..10] of TLink;
    SParser: TParser;//Чекер прокси
    n_google: Integer = 0;//Номер страницы в поиске
    IndexLink: Integer = 0;//Номер текущего сайта с прокси в LinksWithSocks
    CountLinks: Integer = 0;
    IndexSocks: Integer = 0;//Номер текущей прокси в Link
    FindTorDir, FindingTorDir, ParsedLinks, ParsingLinks, ParsedLink,
    ParsingLink, NeedSocks, FindedSocks, FindingSocks, InstalledSocks,
    InstallingSocks, RunChecking, InRunChecking, FindSocksEnable,
    InstallSocksEnable: Boolean;//Логические переменные состояний потоков
    ProxyInCheck, UrlInCheck, Inc_Word: String;
    Socks: TSocks;

implementation
uses QTorUnit;

//Запуск потока проверки работоспособности прокси
procedure CheckProxy(LinkIndex: Integer);
begin
  FindingSocks :=True;
  TThread.CreateAnonymousThread(procedure
        Var SocksInfo: TIdSocksInfo;
        Resp,Old_IP,S,dS: String;
        Live: Boolean;
        Count,i,j,IndexSocks: Integer;
        UrlInCheck: String;
        SParser: TParser;
        Socks: TSocks;
    begin
      For IndexSocks :=Links[LinkIndex].PosSearch to Length(Links[LinkIndex].Sockses)-1 do
      if not FindedSocks then try
          Links[LinkIndex].PosSearch :=IndexSocks+1;
          SParser :=TParser.Create;
          Live :=False;
          Socks :=Links[LinkIndex].Sockses[IndexSocks];
          UrlInCheck :=check_url3+Links[LinkIndex].Sockses[IndexSocks].IP+'/json';
          Inc_Word :=Links[LinkIndex].Sockses[IndexSocks].IP;
          With SParser do
              try
                FHTTP.Disconnect;
                SocksInfo :=TIdSocksInfo.Create();
                  With SocksInfo do
                    try
                      Enabled :=True;
                      Host :=Links[LinkIndex].Sockses[IndexSocks].IP;
                      Port :=StrToInt(Links[LinkIndex].Sockses[IndexSocks].PORT);
                      Authentication :=saNoAuthentication;
                    except
                    end;
                If Links[LinkIndex].Sockses[IndexSocks].STYPE='SOCKS5' then
                  try
                    SocksInfo.Version :=svSocks5;
                    FSSL.TransparentProxy :=SocksInfo;
                    FHTTP.IOHandler :=FSSL;
                    Resp :=FHTTP.Get(UrlInCheck);
                    If Pos(inc_word,Resp)>0 then Live :=True;
                   except
                    Live :=False;
                   end else
                If Links[LinkIndex].Sockses[IndexSocks].STYPE='SOCKS4' then
                  try
                    SocksInfo.Version :=svSocks4;
                    FSSL.TransparentProxy :=SocksInfo;
                    FHTTP.IOHandler :=FSSL;
                    Resp :=FHTTP.Get(UrlInCheck);
                    If Pos(Inc_Word,Resp)>0 then Live :=True;
                  except
                    Live :=False;
                  end else
                If Links[LinkIndex].Sockses[IndexSocks].STYPE='HTTPS' then
                  try
                    FHTTP.IOHandler :=nil;
                    FHTTP.ProxyParams.ProxyServer :=Links[LinkIndex].Sockses[IndexSocks].IP;
                    FHTTP.ProxyParams.ProxyPort :=StrToInt(Links[LinkIndex].Sockses[IndexSocks].PORT);
                    Resp :=FHTTP.Get(UrlInCheck);
                    If Pos(Inc_Word,Resp)>0 then Live :=True;
                  except
                    Live :=False;
                  end else
                try
                  SocksInfo.Version :=svSocks5;
                  FSSL.TransparentProxy :=SocksInfo;
                  FHTTP.IOHandler :=FSSL;
                  Resp :=FHTTP.Get(UrlInCheck);
                  If Pos(Inc_Word,Resp)>0 then
                    begin
                      Links[LinkIndex].Sockses[IndexSocks].STYPE :='SOCKS5';
                      Live :=True;
                    end;
                except
                  try
                    SocksInfo.Version :=svSocks4;
                    FSSL.TransparentProxy :=SocksInfo;
                    FHTTP.IOHandler :=FSSL;
                    Resp :=FHTTP.Get(UrlInCheck);
                    If Pos(Inc_Word,Resp)>0 then
                      begin
                        Links[LinkIndex].Sockses[IndexSocks].STYPE :='SOCKS4';
                        Live :=True;
                      end;
                  except
                    try
                      FHTTP.IOHandler :=nil;
                      FHTTP.ProxyParams.ProxyServer :=Links[LinkIndex].Sockses[IndexSocks].IP;
                      FHTTP.ProxyParams.ProxyPort :=StrToInt(Links[LinkIndex].Sockses[IndexSocks].PORT);
                      Resp :=FHTTP.Get(UrlInCheck);
                      If Pos(Inc_Word,Resp)>0 then
                        begin
                          Links[LinkIndex].Sockses[IndexSocks].STYPE :='HTTPS';
                          Live :=True;
                        end;
                    except
                      Live :=False;
                    end;
                  end;
                end;
                SocksInfo.Free;
                if FHTTP.Connected then FHTTP.Disconnect;
                FHTTP.ProxyParams.ProxyServer :='';
                FHTTP.ProxyParams.ProxyPort :=0;
              finally
              end;
                S :=QTorWindow.LogBox.ItemByIndex(LinkIndex).ItemData.Detail;
                dS :=Copy(S,Pos('/',S)+1,Length(S)-Pos('/',S));
                S :=Copy(S,1,Pos('/',S)-1);
                i :=(StrToInt(S))+1;
                QTorWindow.LogBox.ItemByIndex(LinkIndex).ItemData.Detail :=IntToStr(i)+'/'+dS;
          If Live and (not FindedSocks) then
            begin
               begin
                Links[LinkIndex].Sockses[IndexSocks].STATUS :='LIVE';
                Links[LinkIndex].Sockses[IndexSocks].PAGE :=Resp;
                FindedSocks :=True;
                QTorWindow.LogBox.ItemByIndex(LinkIndex).IsSelected :=True;
                Sox :=Links[LinkIndex].Sockses[IndexSocks];
               end;
            end else
            begin
              Links[LinkIndex].Sockses[IndexSocks].STATUS :='DEAD';
            end;
        SParser.Free;
      except
      end else Break;
    end).Start;
end;

//Запуск потока поиска проксей на текущем сайте
procedure ParserSocksInLinks(IndexLink: Word);
begin
  TThread.CreateAnonymousThread(procedure
    Var i,j: Word;
        R: TRegExp;
        Parser: TParser;
        dSocks: TSocks;
    begin
      Parser :=TParser.Create;
      With R do
        try
          RMathes :=RegEx.Matches(Parser.AsHTML(QTorWindow.LogBox.Items[IndexLink]),RE_GL4);
          if RMathes.Count>0 then
            begin
              //Увеличиваем кол-во рабочих ссылок
              inc(CountLinks);
              Links[IndexLink].CountSocks :=RMathes.Count;
              j :=Round((RMathes.Count div 5)*5-1);
              //Парсим носки с ссылки
              For i:=0 to j do
                begin
                  dSocks.IP :=RegEx.Match(RMathes[i].Value,RE_GL_IP).Value;
                  dSocks.PORT :=RegEx.Match(RMathes[i].Value,RE_GL_PORT).Value;
                  Links[IndexLink].AddS(dSocks.IP, dSocks.PORT);
                end;
              //Перемешиваем все прокси для рандомизации
              Links[IndexLink].SocksRandomize;
              Links[IndexLink].PosSearch :=0;
              //Если не найден рабочий носок то парсим носки с первого найденного сайта с носками
              CheckProxy(IndexLink);
              QTorWindow.LogBox.ItemByIndex(IndexLink).ItemData.Detail :='0/'+IntToStr(RMathes.Count);
            end else QTorWindow.LogBox.ItemByIndex(IndexLink).Visible :=False;
            ParsedLink :=True;
            ParsingLinks :=False;
        finally
        end;
      Parser.Free;
    end).Start;
end;

//Запускаем поток поиска сайтов с прокси
procedure ParserLinks;
begin
  ParsingLinks :=True;
  TThread.CreateAnonymousThread(procedure
    Var i: Word;
        dS: String;
        R: TRegExp;
        Parser: TParser;
    begin
      Parser :=TParser.Create;
      With R do
        try
          QTorWindow.LogBox.BeginUpdate;
          RMathes :=RegEx.Matches(Parser.AsHTML(google_search+IntToStr(n_google)),RE_GL2);
          For i:=0 to RMathes.Count-1 do
            begin
              dS :=RMathes.Item[i].Value;
              Links[i+1].Url :=RegEx.Match(dS,(RE_GL5)).Value;
              QTorWindow.LogBox.Items.Add(Links[i+1].Url);
              QTorWindow.LogBox.ItemByIndex(QTorWindow.LogBox.Items.Count-1).ItemData.Detail :='.../...';
            end;
          QTorWindow.LogBox.EndUpdate;
          QTorWindow.LogBox.UpdateEffects;
        except
        end;
      inc(n_google);
      Parser.Free;
      ParsedLinks :=True;
      ParsingLinks :=False;
    end).Start;
end;

//Загружаем настройки из param.qtr
procedure LoadParam;
Var S: TStrings;
begin
  S :=TStringList.Create;
  if FileExists('param.qtr') then
    begin
      S.LoadFromFile('param.qtr');
      try
//        If FileExists(S[0]+TOR_exe) then
//          begin
//            TorDir :=S[0];
//            torrc :=TorDir+'TorBrowser\Data\Tor\torrc';
//            FindTorDir :=True;
//          end else FindTorDir :=False;
//        If S[1]='0' then QTorWindow.AutoSeachProxy.Checked :=False;
//        If S[2]='0' then QTorWindow.AutoInstallProxy.Checked :=False;
      except
        FindTorDir :=False;
      end;
    end;
end;

//Сохраняем настройки в param.qtr
procedure SaveParam;
Var S: TStrings;
begin
  S :=TStringList.Create;
//  S.Add(TorDir);
//  With QTorWindow do
//    begin
//      if AutoSeachProxy.Checked then S.Add('1') else S.Add('0');
//      If AutoInstallProxy.Checked then S.Add('1') else S.Add('0');
//    end;
  S.SaveToFile('param.qtr');
end;

//Возвращает строку с уровнем директории выше
function UpDir(S: String; level: byte=1): String;
Var i,j: byte;
begin
  i :=Length(S);
  For j:=1 to level do
  try
    While S[i]<>'\' do
    try
      Delete(S,i,1);
      dec(i);
    except
    end;
    Delete(S,i,1);
  except
  end;
  Result :=S+'\';
end;

//Находит путь к папке с TOR путем поиска процессов tor.exe или firefox.exe и извлечением пути к процессу
{ TParser }
constructor TParser.Create;
begin
  inherited;
  FSSL :=TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FSSL.ConnectTimeout:=5000;
  FSSL.ReadTimeout:=5000;
  FHTTP :=TIdHTTP.Create(nil);
  FCookie := TIdCookieManager.Create(nil);
  FHTTP.CookieManager :=FCookie;
  FHTTP.IOHandler :=FSSL;
  FHTTP.HandleRedirects :=True;
  FHTTP.AllowCookies :=True;
  FHTTP.ReadTimeout:=5000;
  FHTTP.ConnectTimeout :=5000;
end;
destructor TParser.Destroy;
begin
  FCookie.Free;
  FHTTP.Free;
  FSSL.Free;
  inherited;
end;
//Получаем ответ по Url запросу в String
function TParser.AsHTML(Url: string): String;
begin
  try
  Result :=FHTTP.Get(Url);
  FHTTP.Disconnect;
  except
  end;
end;

{ TSocks }
//Представляем прокси в виде строки для записи в torrc
function TSocks.InStrings;
begin
  Result :=TStringList.Create;
  if STYPE = 'SOCKS4' then
    begin
      Result.Add('Socks4Proxy '+IP+':'+PORT);
    end else
  if STYPE = 'SOCKS5' then
    begin
      Result.Add('Socks5Proxy '+IP+':'+PORT);
      if Login<>'' then
        begin
          Result.Add('Socks5ProxyUsername '+Login);
          Result.Add('Socks5ProxyPassword '+Passw);
        end;
    end else
  if STYPE = 'HTTPS' then
    begin
      Result.Add('HTTPSProxy '+IP+':'+PORT);
      if Login<>'' then Result.Add('HTTPSProxyAuthenticator '+Login+':'+Passw);
    end;
end;

{ TLink }
constructor TLink.Create(Sender: TObject);
begin
  Url :='';
end;
destructor TLink.Destroy;
begin
  SetLength(Sockses,0);
end;
//Добавляем запись прокси в массив с прокси
procedure TLink.AddS(IP,PORT: String; STYPE: String=''; LOGIN: String=''; PASSW: String='');
begin
  SetLength(Sockses, Length(Sockses)+1);
  Sockses[Length(Sockses)-1].IP :=IP;
  Sockses[Length(Sockses)-1].PORT :=PORT;
  Sockses[Length(Sockses)-1].STYPE :=STYPE;
  Sockses[Length(Sockses)-1].LOGIN :=LOGIN;
  Sockses[Length(Sockses)-1].PASSW :=PASSW;
end;
procedure TLink.AddS(Socks: TSocks);
begin
  SetLength(Sockses, Length(Sockses)+1);
  Sockses[Length(Sockses)-1].IP :=Socks.IP;
  Sockses[Length(Sockses)-1].PORT :=Socks.PORT;
  Sockses[Length(Sockses)-1].STYPE :=Socks.STYPE;
  Sockses[Length(Sockses)-1].LOGIN :=Socks.LOGIN;
end;
//Удаляем прокси из ссылки
procedure TLink.DelS;
Var i: Integer;
begin
  if Length(Sockses)>1 then
    begin
      for i:=1 to Length(Sockses)-1 do
          Sockses[i-1] :=Sockses[i];
      SetLength(Sockses,Length(Sockses)-1);
    end else SetLength(Sockses,0);
end;
//Перемешивание прокси, рандомизация
procedure TLink.SocksRandomize;
Var i,j,x: Word;
    dSocks: TSocks;
begin
  j :=Length(Sockses);
  Randomize;
  If j>0 then
    try
      For i:=0 to j-1 do
        begin
          dSocks :=Sockses[i];
          x :=Random(j);
          Sockses[i] :=Sockses[x];
          Sockses[x] :=dSocks;
        end;
    except
    end;
end;

end.

