unit Commands.GetText;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TGetTextCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.Controls,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.Buttons,
  Vcl.StdCtrls,
  AutomatedStringGrid,
  utils;

procedure TGetTextCommand.Execute(AOwner: TForm);
var
  comp: TComponent;
  ctrl: TWinControl;
  handle: Integer;
  parent: TComponent;
  values : TStringList;
  value: String;
  sent: Boolean;

const
  Delimiter = '.';

begin
  sent := false;
  ctrl := nil;
  comp := nil;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);
  end
  else
  begin
    // This might be a non-WinControl OR a DataItem for a container
    if (ContainsText(self.Params[2], Delimiter)) then
    begin
      values := TStringList.Create;
      try
        values.Delimiter := Delimiter;
        values.StrictDelimiter := True;
        values.DelimitedText := self.Params[2];

        // Get parent
        parent := AOwner.FindComponent(values[0]);

        if (parent is TListBox) then
        begin
          value := (parent as TListBox).items[StrToInt(values[1])];
        end
        else
        if (parent is TAutomationStringGrid) then
        begin
          value := (parent as TAutomationStringGrid).Cells[StrToInt(values[1]),StrToInt(values[2])];
        end;

        // Now send it back please
        ResponseJSON(value);
        sent := true;
      finally
        values.free;
      end;
    end
    else
      comp := AOwner.FindComponent(self.Params[2]);

    if (not sent) then
    begin
      if (ctrl <> nil) then
      begin
        if (ctrl is TEdit) then
          ResponseJSON((ctrl as TEdit).Text)
      end
      else if (comp <> nil) then
      begin
        if (comp is TSpeedButton) then
          ResponseJSON((comp as TSpeedButton).Caption)
      end;
    end
  end; // need to sort out errors
//  else
//    Error(404);
//  end;
end;

end.
