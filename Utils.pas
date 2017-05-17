unit Utils;

interface

uses
  Winapi.Windows,
  Vcl.Graphics;

function isNumber(const s: String): boolean;
function TakeScreenshot(Win: HWND) : Vcl.Graphics.TBitmap;
function BitmapToBase64(ABitmap: Vcl.Graphics.TBitmap): string;

implementation

uses
  System.NetEncoding,
  System.Classes;

function isNumber(const s: String): boolean;
var
  iValue, iCode: Integer;
begin
  val(s, iValue, iCode);
  result := (iCode = 0)
end;

function TakeScreenshot(Win: HWND) : Vcl.Graphics.TBitmap;
var
  Bmp: Vcl.Graphics.TBitmap;
  DC: HDC;
  WinRect: TRect;
  Width: Integer;
  Height: Integer;

begin
  GetWindowRect(Win, WinRect);
  DC := GetWindowDC(Win);

  Width := WinRect.Right - WinRect.Left;
  Height := WinRect.Bottom - WinRect.Top;

  bmp := Vcl.Graphics.TBitmap.Create;
  try
    bmp.width := width;
    bmp.height := height;

    BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SRCCOPY);

    result := Bmp;
  finally
    ReleaseDC(Win, DC);
  end;
end;

function BitmapToBase64(ABitmap: Vcl.Graphics.TBitmap): string;
var
  SS: TMemoryStream;

begin
  SS := TMemoryStream.Create;
  try
    ABitmap.SaveToStream(SS);
    Result := TNetEncoding.Base64.EncodeBytesToString(SS.Memory, SS.Size)
  finally
    SS.Free;
  end;
end;

end.
