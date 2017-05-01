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
unit Commands.GetElementValue;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TGetElementValueCommand = class(TRestCommand)
  private
    procedure ProcessHandle(AOwner: TForm);
    procedure ProcessControlName(AOwner: TForm);
    function OKResponse(const session, value: String): String;
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
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
  System.JSON.Writers,
  System.JSON.Builders,
  utils;

class function TGetElementValueCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetElementValueCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/attribute/(.*)';
end;

procedure TGetElementValueCommand.ProcessHandle(AOwner: TForm);
var
  ctrl: TWinControl;
  handle: Integer;
  value: String;

begin
  handle := StrToInt(self.Params[2]);
  ctrl := FindControl(handle);

  if (ctrl <> nil) then
  begin
    if (ctrl is TCheckBox) then
    begin
      if (self.Params[3] = 'Checked') then
        if (ctrl as TCheckBox).Checked then value := 'True' else value := 'False'
      else
        value := 'Unknown';
    end;

    ResponseJSON(self.OKResponse(self.Params[2], value));
  end
  else
    Error(404);
end;

procedure TGetElementValueCommand.ProcessControlName(AOwner: TForm);
var
  comp: TComponent;
  values : TStringList;

const
  Delimiter = '.';

begin
  Error(404);
(*
  if (ContainsText(self.Params[2], Delimiter)) then
  begin
    values := TStringList.Create;
    try
      values.Delimiter := Delimiter;
      values.StrictDelimiter := True;
      values.DelimitedText := self.Params[2];

      // Find parent
      comp := (AOwner.FindComponent(values[0]));

      if comp <> nil then
      begin
        if comp is TPageControl then
        begin
          (comp as TPageControl).ActivePage :=
            (comp as TPageControl).Pages[StrToInt(values[1])];
        end;
      end
      else
        Error(404);
    finally
      values.Free;
    end
  end
  else
  begin
    comp := (AOwner.FindComponent(self.Params[2]));

    if (comp <> nil) then
    begin
      if (comp is TSpeedButton) then
        (comp as TSpeedButton).click
      else if (comp is TToolButton) then
        (comp as TToolButton).click;
        ResponseJSON(self.OKResponse(self.Params[2]));
    end
    else
      Error(404);
  end;
  *)
end;

procedure TGetElementValueCommand.Execute(AOwner: TForm);
begin
  if (isNumber(self.Params[2])) then
    ProcessHandle(AOwner)
  else
    ProcessControlName(AOwner);
end;

function TGetElementValueCommand.OKResponse(const session, value: String): String;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
  StringBuilder: TStringBuilder;

begin
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);
  Writer := TJsonTextWriter.Create(StringWriter);
  Writer.Formatting := TJsonFormatting.Indented;
  Builder := TJSONObjectBuilder.Create(Writer);

  Builder
    .BeginObject()
      .Add('sessionId', session)
      .Add('status', 0)
      .Add('value', value)
    .EndObject;

  result := StringBuilder.ToString;
end;

end.
