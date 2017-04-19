unit Commands.PostElement;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TPostElementCommand = class(TRestCommand )
  private
    procedure GetElementByName(const value:String; AOwner: TForm);
    procedure GetElementByCaption(const value:String; AOwner: TForm);
    procedure GetElementByClassName(const value:String; AOwner: TForm);
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  Vcl.controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.Types,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders;

procedure TPostElementCommand.GetElementByName(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
      comp := AOwner.FindComponent(value);

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(inttostr((comp as TWinControl).Handle));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.GetElementByClassName(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.ClassName = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ControlCount -1 do
        if tForm(AOwner).Controls[i].ClassName = value then
        begin
          comp := tForm(AOwner).Controls[i];
          break;
        end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(inttostr((comp as TWinControl).Handle));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.GetElementByCaption(const value:String; AOwner: TForm);
var
  comp: TComponent;
  i: Integer;

begin
  comp := nil;

  try
    if (AOwner.Caption = value) then
      comp := AOwner
    else
    begin
      for i := 0 to tForm(AOwner).ControlCount -1 do

        // Vcl.ExtCtrls ..
        // TButtonedEdit
        // THeader
        // TPanel

        // Vcl.StdCtrls ..
        // TButton - done
        // TCheckBox
        // TComboBox
        // TEdit
        // TLabel
        // TListBox
        // TRadioButton
        // TStaticText
        // TMemo

        // Specifically from the test host
        // TTreeView
        // TRichEdit
        // TToolbar
        // TToolbarButton
        // TPageControl
        // TTabSheet
        // TStatusBar
        // TMainMenu
        // TMenuItem
        // TPopupMenu
        // TStringGrid
        // TMaskedEdit
        // TLinkLabel

        // TSpeedButton - no window here, need to 'fake' one

        // Need to get each type of control and check the caption / text
        if (tForm(AOwner).Controls[i] is TButton) then
          if (tForm(AOwner).Controls[i] as TButton).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
        if (tForm(AOwner).Controls[i] is TPanel) then
          if (tForm(AOwner).Controls[i] as TPanel).caption = value then
          begin
            comp := tForm(AOwner).Controls[i];
            break;
          end;
    end;

    if comp = nil then
      raise Exception.Create('Control not found');

    ResponseJSON(inttostr((comp as TWinControl).Handle));

  except on e: Exception do
    // Probably should give a different reply
    Error(404);
  end;
end;

procedure TPostElementCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  using: String;
  value: String;

begin
  // Decode request
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('using', using);
    (jsonObj as TJsonObject).TryGetValue<String>('value', value);
  finally
    jsonObj.Free;
  end;

  if (using = 'link text') then
    GetElementByCaption(value, AOwner)
  else if (using = 'name') then
    GetElementByName(value, AOwner)
  else if (using = 'class name') then
    GetElementByClassName(value, AOwner)
  // 'partial link text '
  // 'id'
end;


end.
