unit AboutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RxGIF, ExtCtrls;

type
  TAboutForm = class(TForm)
    img1: TImage;
    TitleLabel: TLabel;
    VersionLabel: TLabel;
    CloseButton: TButton;
    Label1: TLabel;
    YearLabel: TLabel;
    Label2: TLabel;
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

procedure TAboutForm.CloseButtonClick(Sender: TObject);
begin
  Self.Close;
end;

end.
