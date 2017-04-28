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
unit Commands.DeleteSession;

interface

uses
  Sessions,
  Vcl.Forms,
  CommandRegistry,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'DELETE' '/session/(.*)'
  ///  </summary>
  TDeleteSessionCommand = class(TRestCommand)
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  System.SysUtils,
  Commands;

procedure TDeleteSessionCommand.Execute(AOwner: TForm);
begin
  try
    // Need to delete it!
    Commands.Sessions.DeleteSession(self.Params[1]);

  except on e: Exception do
    Error(404);
  end;
end;

class function TDeleteSessionCommand.GetCommand: String;
begin
  result := 'DELETE';
end;

class function TDeleteSessionCommand.GetRoute: String;
begin
  result := '/session/(.*)';
end;

end.
