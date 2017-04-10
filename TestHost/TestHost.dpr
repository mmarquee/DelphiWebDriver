{***************************************************************************}
{                                                                           }
{           DelphiUIAutomation                                              }
{                                                                           }
{           Copyright 2015-16 JHC Systems Limited                              }
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
program TestHost;

uses
  Vcl.Forms,
  HostMain in 'HostMain.pas' {Form1},
  AutomatedCombobox in '..\..\DelphiUIAutomation\controls\AutomatedCombobox.pas',
  UIAutomationCore_TLB in '..\..\DelphiUIAutomation\controls\UIAutomationCore_TLB.pas',
  AutomatedStringGrid in '..\..\DelphiUIAutomation\controls\AutomatedStringGrid.pas',
  StringGridItem in '..\..\DelphiUIAutomation\controls\StringGridItem.pas',
  AutomatedEdit in '..\..\DelphiUIAutomation\controls\AutomatedEdit.pas',
  AutomatedMaskEdit in '..\..\DelphiUIAutomation\controls\AutomatedMaskEdit.pas',
  AutomatedStaticText in '..\..\DelphiUIAutomation\controls\AutomatedStaticText.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
