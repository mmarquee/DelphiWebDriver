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
unit Commands.CreateSession;

interface

uses
  CommandRegistry,
  Vcl.Forms,
  HttpServerCommand;

type
  ///  <summary>
  ///  Handles 'POST' '/session'
  ///  </summary>
  TCreateSessionCommand = class(TRESTCommand)
  public
    class function GetCommand: String; override;
    class function GetRoute: String; override;

    procedure Execute(AOwner: TForm); override;
  end;

implementation

uses
  Commands,
  Session;

class function TCreateSessionCommand.GetCommand: String;
begin
  result := 'POST';
end;

class function TCreateSessionCommand.GetRoute: String;
begin
  result := '/session';
end;

procedure TCreateSessionCommand.Execute(AOwner: TForm);
var
  request : String;
  session : TSession;
begin
  request := self.StreamContents;

  session := TSession.Create(request);

  Commands.Sessions.Add(session);

  ResponseJSON(session.GetSessionDetails);
end;

end.
