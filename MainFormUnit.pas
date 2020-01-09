unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TntStdCtrls, ComCtrls, ImgList, ActnList, ToolWin, Gauges,
  Menus;

type
  tLastAction = (
    laKeyPressed,
    laKeyReleased,
    laAltPressed,
    laAltReleased,
    laNone
  );

  tArrayOfByte = array of Byte;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    ToolBar1: TToolBar;
    ActionList: TActionList;
    PrintAction: TAction;
    ImageList: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    SaveToFileAction: TAction;
    ToolButton4: TToolButton;
    OpenFromFileAction: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    AboutAction: TAction;
    InstructionsAction: TAction;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ExitAction: TAction;
    ToolButton10: TToolButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    btnTestCharAction: TToolButton;
    g1: TGauge;
    TestCharAction: TAction;
    pb1: TProgressBar;
    btnExcercicesAction: TToolButton;
    ExcercicesAction: TAction;
    SelectAllAction: TAction;
    Memo1Popup: TPopupMenu;
    ChangeFont1: TMenuItem;
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveToFileActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure OpenFromFileActionExecute(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure PrintActionExecute(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure TestCharActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure InstructionsActionExecute(Sender: TObject);
    procedure SelectAllActionExecute(Sender: TObject);
    procedure ExcercicesActionExecute(Sender: TObject);
    procedure ChangeFont1Click(Sender: TObject);
  private
    fAltPressed     : Boolean;
    fKeysPressed    : Integer;
    fCharNumber     : Integer;
    fChar           : Char;
    fPositionInText : Integer;
    fSelectedChars  : Integer;
    fBlocked        : Boolean;
    fLastAction     : tLastAction;
    fNumPadUsed     : Boolean;

    procedure  PressAlt;
    procedure  ReleaseAlt;
    procedure  FormChar;
    function   InsertChar(aText : string) : string;
//    function   StringToByteArray(aString : string) : TByteArray;
    function   StringToByteArray(aString : string) : tArrayOfByte;
  public
    constructor Create(aOwner : TComponent); override;
    destructor  Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation
uses
  AboutFormUnit,
  InstructionsFormUnit,
  ExerciseFormUnit
  ;
{$R *.DFM}

procedure TMainForm.FormChar;
begin
  fChar := Char(fCharNumber);
end;

function TMainForm.InsertChar(aText: string) : string;
begin
  Result := Copy(aText, 1, fPositionInText);
  Result := Result + fChar;
  Result := Result + Copy(aText, fPositionInText + 1 + fSelectedChars, Length(aText) - fPositionInText);
end;

procedure TMainForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
  begin
    if (Key >= VK_NUMPAD0) and (Key <= VK_NUMPAD9) then
    begin
      Key := Key - 48;
      fNumPadUsed := TRUE;
    end else fNumPadUsed := FALSE;

    if Key = 18 then PressAlt
    else if ((Key >= 48) and (Key <= 57)) then
    begin
      fCharNumber := fCharNumber * 10 + StrToInt(Char(Key));
      fLastAction := laKeyPressed;
//      logmemo.Lines.Add(IntToStr(fCharNumber));
    end
    else begin
      fBlocked := TRUE;
      fLastAction := laKeyPressed;
//      logmemo.Lines.Add('Blocked');
    end;
    Key := 0;
  end;
end;

procedure TMainForm.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 18 then begin
    ReleaseAlt;
    if (fChar <> #0) and not fBlocked then
    begin
      Memo1.Text     := InsertChar(Memo1.Text);
      Memo1.SelStart := fPositionInText + 1;
    end;
    fBlocked := False;
  end
  else begin
    Key := 0;
    fLastAction := laKeyReleased;
  end;
end;

procedure TMainForm.PressAlt;
begin
  if not fAltPressed then begin
    fCharNumber     := 0;
    fKeysPressed    := 0;
    fPositionInText := Memo1.SelStart;
    fSelectedChars  := Memo1.SelLength;
    fAltPressed     := TRUE;
    fLastAction     := laAltPressed;
//    logmemo.Lines.Add('<<< ALT PRESSED >>>');
  end;
end;

procedure TMainForm.ReleaseAlt;
begin
  if fAltPressed then
  begin
    FormChar;
    fAltPressed := False;
    fLastAction := laAltReleased;
//    logmemo.Lines.Add('<<< ALT RELEASED >>>');
  end;
end;

procedure TMainForm.SaveToFileActionExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    Memo1.Lines.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TMainForm.ExitActionExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.OpenFromFileActionExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
    Memo1.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TMainForm.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  if (fLastAction = laAltReleased) and fNumPadUsed then
  begin
    Key := #0;
    fLastAction := laNone;
  end;
end;

constructor TMainForm.Create(aOwner: TComponent);
begin
  inherited;
  fCharNumber := 0;
  fChar       := #0;
  fLastAction := laNone;
  fAltPressed := FALSE;
  fKeysPressed:= 0;
  fNumPadUsed := False;
end;

destructor TMainForm.Destroy;
begin
  inherited;

end;

procedure TMainForm.PrintActionExecute(Sender: TObject);
var
  lvText : string;
  lvlpt  : DWORD;
  lvdw1  : DWORD;
  lvByteArr: tArrayOfByte;
  lvWriten : Boolean;
begin
  lvWriten := FALSE;
  pb1.Max := 100;
  pb1.Min := 0;
  lvText := Memo1.Text;
  pb1.StepBy(25);
  lvByteArr := StringToByteArray(lvText);
  pb1.StepBy(25);
  lvlpt := CreateFile('LPT1:', GENERIC_WRITE or GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_FLAG_WRITE_THROUGH, 0);
  pb1.StepBy(25);
//  WriteFile(lvlpt, PChar(lvText)^, Length(lvText), lvdw1, nil);
//  WriteFile(lvlpt, PChar(StringToByteArray(lvText))^, Length(lvText), lvdw1, nil);
  lvWriten := WriteFile(lvlpt, PChar(lvByteArr)^, Length(lvByteArr), lvdw1, nil);
  pb1.StepBy(25);
  if lvWriten then ShowMessage('Buffer was written to LPT port.')
  else
  begin
    MessageDlg(
      'Error occured. Buffer was not written to LPT port',
      mtError,
      [mbOK],
      0
    );
  end;

  CloseHandle(lvlpt);
  pb1.Position := 0;
end;

procedure TMainForm.btn1Click(Sender: TObject);
var
//  lvByteArray : TByteArray;
  lvByteArray : tArrayOfByte;
//  lvStrStream : TStringStream;
begin
//  ShowMessage(IntToStr(Length(Memo1.Text)));
//  Memo1.Text := Memo1.Text+Char(0)+'%';
//  ShowMessage(IntToStr(Length(Memo1.Text)));

  lvByteArray := StringToByteArray(Memo1.Text);
//  if OpenDialog.Execute then
//  begin
//    with TFileStream.Create(OpenDialog.FileName, fmCreate) do
//    try
//      lvStrStream := TStringStream.Create(PChar(lvByteArray)^);
//      lvStrStream.Position := 0;
//      Position := 0;
//
//      CopyFrom(lvStrStream, lvStrStream.Size);
//      lvStrStream.Free;
//    finally
//      Free;
//    end;
//  end;
  ShowMessage(IntToStr(Length(lvByteArray)));
  ShowMessage(PChar(lvByteArray)^);
end;

//function TForm1.StringToByteArray(aString : string): TByteArray;
function TMainForm.StringToByteArray(aString : string): tArrayOfByte;
var
  lvI : Integer;
begin
  lvI := 1;
  while lvI <= Length(aString) do
  begin
    SetLength(Result, Length(Result) + 1);

    if aString[lvI] = '#' then
    begin
      if (lvI = Length(aString)) then
      begin
        Result[Length(Result)-1] := Ord(aString[lvI]);
      end
      else if (aString[lvI+1] = '0') then
      begin
        Result[Length(Result)-1] := 0;
        lvI := lvI + 2;
        Continue;
      end
      else if aString[lvI + 1] = '#' then begin
        Result[Length(Result)-1] := Ord(aString[lvI]);
        lvI := lvI + 2;
        Continue;
      end
      else begin
        Result[Length(Result)-1] := Ord(aString[lvI]);
      end;
    end
    else begin
      Result[Length(Result)-1] := Ord(aString[lvI]);
    end;

//    if aString[lvI] = 'N' then
//    begin
//      if (aString[lvI+1] = 'U') and
//         (aString[lvI+2] = 'L') and
//         (aString[lvI+3] = 'L') then
//      begin
//        Result[Length(Result)-1] := 0;
//        lvI := lvI + 3;
//      end else Result[Length(Result)-1] := Ord(aString[lvI]);
//    end else Result[Length(Result)-1] := Ord(aString[lvI]);
    lvI := lvI + 1;
  end;
end;

procedure TMainForm.TestCharActionExecute(Sender: TObject);
begin
  if Memo1.SelLength > 0 then
    ShowMessage(IntToStr(Ord(Memo1.SelText[1])))
  else ShowMessage('Please select char(s)');
end;

procedure TMainForm.AboutActionExecute(Sender: TObject);
begin
  with TAboutForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainForm.InstructionsActionExecute(Sender: TObject);
begin
  with TInstructionsForm.Create(Application) do
  try
    Show;
  finally
  end;
end;

procedure TMainForm.SelectAllActionExecute(Sender: TObject);
begin
  Memo1.SelStart  := 0;
  Memo1.SelLength := Length(Memo1.Text);
end;

procedure TMainForm.ExcercicesActionExecute(Sender: TObject);
begin
  with TExerciseForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainForm.ChangeFont1Click(Sender: TObject);
begin
  with TFontDialog.Create(nil) do
  try
    Font := Memo1.Font;
    if Execute then
      Memo1.Font := Font;
  finally
    Free;
  end;
end;

end.
