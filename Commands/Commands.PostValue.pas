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
unit Commands.PostValue;

interface

uses
  Sessions,
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TPostValueCommand = class(TRestCommand)
  private
    function OKResponse(const sessionId, value: String): String;
  public
    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Vcl.StdCtrls,
  Vcl.Controls,
  System.StrUtils,
  System.SysUtils,
  Utils,
  System.Classes,
  System.JSON;

procedure TPostValueCommand.Execute(AOwner: TForm);
var
  jsonObj : TJSONObject;
  argsObj : TJsonValue;
  value: String;
  handle: integer;
  ctrl: TComponent;

begin
  // Decode the incoming JSON and see what we have
  jsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(self.StreamContents),0) as TJSONObject;
  try
    (jsonObj as TJsonObject).TryGetValue<String>('value', value);
  finally
    jsonObj.Free;
  end;

  try
    if (isNumber(self.Params[2])) then
    begin
      handle := StrToInt(self.Params[2]);
      ctrl := FindControl(handle);

      if (ctrl <> nil) then
      begin
        if (ctrl is TEdit) then
          (ctrl as TEdit).Text := value;
    //    else if (ctrl is TStaticText) then
      //    (ctrl as TStaticText).Caption := value
      //  else if (ctrl is TCheckBox) then
      //    (ctrl as TCheckBox).Caption := value
      //  else if (ctrl is TLinkLabel) then
      //    (ctrl as TLinkLabel).Caption := value
      //  else if (ctrl is TRadioButton) then
      //    (ctrl as TRadioButton).Caption := value;

        ResponseJSON(OKResponse(self.Params[2], value));
      end
      else
        Error(404);
    end
    else
    begin
      // simple controls?
      Error(404);
    end;
  except on e: Exception do
    Error(404);
  end;

end;

function TPostValueCommand.OKResponse(const sessionId, value: String): String;
var
  jsonObject: TJSONObject;

begin
  jsonObject := TJSONObject.Create;

  jsonObject.AddPair(TJSONPair.Create('sessionID', sessionId));
  jsonObject.AddPair(TJSONPair.Create('status', '0'));
  jsonObject.AddPair(TJSONPair.Create('value', value));

  result := jsonObject.ToString;
end;

end.
