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
unit Commands.GetEnabled;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'GET' '/session/(.*)/element/(.*)/enabled'
  ///  </summary>
  TGetEnabledCommand = class(TRESTCommand)
  private
    function OKResponse(const SessionID: String; enabled: boolean): String;
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.Controls,
  System.SysUtils,
  System.Classes,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  System.StrUtils,
  System.JSON,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  utils;

procedure TGetEnabledCommand.Execute(AOwner: TForm);
var
  comp: TComponent;
  ctrl: TWinControl;
  handle: Integer;
  values : TStringList;
  value: boolean;
  parent: TComponent;

const
  Delimiter = '.';

begin
  ctrl := nil;
  comp := nil;

  if (isNumber(self.Params[2])) then
  begin
    handle := StrToInt(self.Params[2]);
    ctrl := FindControl(handle);

    ResponseJSON(OKResponse(self.Params[1], ctrl.Enabled))
  end
  else
  if (ContainsText(self.Params[2], Delimiter)) then
    begin
      values := TStringList.Create;
      try
        values.Delimiter := Delimiter;
        values.StrictDelimiter := True;
        values.DelimitedText := self.Params[2];

        // Get parent
        parent := AOwner.FindComponent(values[0]);

        if (parent is TToolBar) then
        begin
          value := (parent as TToolBar).Buttons[StrToInt(values[1])].enabled;
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
          OKResponse(self.Params[1], (comp as TSpeedButton).enabled)
        else if (comp is TLabel) then
          OKResponse(self.Params[1], (comp as TLabel).enabled);

        ResponseJSON(OKResponse(self.Params[2], value));
      end
      else
        Error(404);
    end;
end;

class function TGetEnabledCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetEnabledCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/enabled';
end;

function TGetEnabledCommand.OKResponse(const SessionID: String; enabled: boolean): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;
  value: Variant;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  value := enabled;

  Builder
    .BeginObject()
      .Add('sessionId', sessionId)
      .Add('status', 0)
      .Add('value', value)
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
