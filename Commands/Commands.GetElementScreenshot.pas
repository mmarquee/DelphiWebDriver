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
unit Commands.GetElementScreenshot;

interface

uses
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  TGetElementScreenshotCommand = class(TRestCommand)
  public
    procedure Execute(AOwner: TForm); override;

    class function GetCommand: String; override;
    class function GetRoute: String; override;
  end;

implementation

class function TGetElementScreenshotCommand.GetCommand: String;
begin
  result := 'GET';
end;

class function TGetElementScreenshotCommand.GetRoute: String;
begin
  result := '/session/(.*)/element/(.*)/screenshot';
end;

procedure TGetElementScreenshotCommand.Execute(AOwner: TForm);
begin
end;

end.

