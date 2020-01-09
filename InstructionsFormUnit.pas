unit InstructionsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXSplit, dfsSplitter, Menus;

const
  gcHelpFilesDir     : string = '.\HelpFiles';
  gcAppInstrFile     : string = 'AppInstructions.txt';
  gcPrinterCodesFile : string = 'PrinterCodes.txt';
type
  TInstructionsForm = class(TForm)
    pnl1: TPanel;
    AppInstrMemo: TMemo;
    Label1: TLabel;
    pnl2: TPanel;
    PrinterCodesMemo: TMemo;
    Label2: TLabel;
    dfsSplitter1: TdfsSplitter;
    AppInstrPopup: TPopupMenu;
    PrinterCodesPopup: TPopupMenu;
    ChangeFont1: TMenuItem;
    ChangeFont2: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ChangeFont1Click(Sender: TObject);
    procedure ChangeFont2Click(Sender: TObject);
  private
    procedure LoadAppInstructions;
    procedure LoadPrinterCodes;
  public
    { Public declarations }
  end;

var
  InstructionsForm: TInstructionsForm;

implementation

{$R *.DFM}

procedure TInstructionsForm.FormShow(Sender: TObject);
begin
  LoadAppInstructions;
  LoadPrinterCodes;
end;

procedure TInstructionsForm.LoadAppInstructions;
var
  lvPath : string;
begin
  lvPath := IncludeTrailingBackslash(gcHelpFilesDir) + gcAppInstrFile;
  if FileExists(lvPath) then
    AppInstrMemo.Lines.LoadFromFile(lvPath)
  else AppInstrMemo.Text := 'File ' + lvPath + ' was not found.';
end;

procedure TInstructionsForm.LoadPrinterCodes;
var
  lvPath : string;
begin
  lvPath := IncludeTrailingBackslash(gcHelpFilesDir) + gcPrinterCodesFile;
  if FileExists(lvPath) then
    PrinterCodesMemo.Lines.LoadFromFile(lvPath)
  else PrinterCodesMemo.Text := 'File ' + lvPath + ' was not found.';

end;

procedure TInstructionsForm.ChangeFont1Click(Sender: TObject);
begin
  with TFontDialog.Create(nil) do
  try
    Font := AppInstrMemo.Font;
    if Execute then
      AppInstrMemo.Font := Font;
  finally
    Free;
  end;
end;

procedure TInstructionsForm.ChangeFont2Click(Sender: TObject);
begin
  with TFontDialog.Create(nil) do
  try
    Font := PrinterCodesMemo.Font;
    if Execute then
      PrinterCodesMemo.Font := Font;
  finally
    Free;
  end;

end;

end.
