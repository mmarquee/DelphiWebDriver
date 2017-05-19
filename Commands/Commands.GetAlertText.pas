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
unit Commands.GetAlertText;

interface

uses
  Sessions,
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TGetAlertTextCommand = class(TRESTCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

implementation

procedure TGetAlertTextCommand.Execute(AOwner: TForm);
begin
  ResponseJSON(self.Params[1]);
end;

class function TGetAlertTextCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetAlertTextCommand.GetRoute: String;
begin
  result := '/session/(.*)/alert_text';
end;

end.
