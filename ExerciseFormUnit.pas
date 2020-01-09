unit ExerciseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  gcHelpFilesDir     : string = '\HelpFiles';
  gcExerciseFile     : string = 'Exercise.txt';

type
  TExerciseForm = class(TForm)
    ExerciseMemo: TMemo;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public

  end;

var
  ExerciseForm: TExerciseForm;

implementation

{$R *.DFM}

procedure TExerciseForm.btn1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TExerciseForm.FormShow(Sender: TObject);
var
  lvPath : string;
begin
  lvPath := IncludeTrailingBackslash(extractfilepath(application.ExeName) + gcHelpFilesDir) + gcExerciseFile;
  if FileExists(lvPath) then
    ExerciseMemo.Lines.LoadFromFile(lvPath)
  else ExerciseMemo.Text := 'File ' + lvPath + ' was not found.';
end;

end.
