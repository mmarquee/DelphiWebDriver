{***************************************************************************}
{                                                                           }
{           DelphiWebDriver                                                 }
{                                                                           }
{           Copyright 2017 inpwtepydjuf@gmail.com                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
unit Commands.GetText;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'GET' '/session/(.*)/element/(.*)/text'
  ///  </summary>
  TGetTextCommand = class(TRESTCommand)
  private
    function OKResponse(const handle, value: String): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.JSON,
  System.JSON.Types,
  Vcl.Controls,
  Vcl.Grids,
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  utils;

procedure TGetTextCommand.Execute(AOwner: TForm);
var
  comp: TComponent;
  ctrl: TWinControl;
  handle: Integer;
  parent: TComponent;
  values : TStringList;
  value: String;

const
  Delimiter = '.';

begin
  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);

    if (ctrl <> nil) then
    begin
      if (ctrl is TEdit) then
        value := (ctrl as TEdit).Text
      else if (ctrl is TStaticText) then
        value := (ctrl as TStaticText).Caption
      else if (ctrl is TCheckBox) then
        value := (ctrl as TCheckBox).Caption
      else if (ctrl is TLinkLabel) then
        value := (ctrl as TLinkLabel).Caption
      else if (ctrl is TRadioButton) then
        value := (ctrl as TRadioButton).Caption;

      ResponseJSON(OKResponse(self.Params[2], value));
    end
    else
      Error(440);
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
        else if (parent is TStringGrid) then
        begin
          value := (parent as TStringGrid).Cells[StrToInt(values[1]),StrToInt(values[2])];
        end
        else if (parent is TPageControl) then
        begin
          value := (parent as TPageControl).Pages[StrToInt(values[1])].Caption;
        end
        else if (parent is TCombobox) then
        begin
          value := (parent as TCombobox).items[StrToInt(values[1])];
        end;

        // Now send it back please
        ResponseJSON(OKResponse(self.Params[2], value));
      finally
        values.free;
      end;
    end
    else
    begin
      comp := AOwner.FindComponent(self.Params[2]);

      if (comp <> nil) then
      begin
        if (comp is TSpeedButton) then
          Value := (comp as TSpeedButton).Caption
        else if (comp is TLabel) then
          Value := (comp as TLabel).Caption;

        ResponseJSON(OKResponse(self.Params[2], value));
      end
      else
        Error(404);
    end;
  end;
end;

function TGetTextCommand.OKResponse(const handle, value: String): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('id', handle));
  jsonObject.AddPair(TJSONPair.Create('value', value));

  result := jsonObject.ToString;
end;

end.
