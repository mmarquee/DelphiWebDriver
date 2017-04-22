unit Utils;

interface

function isNumber(const s: String): boolean;

implementation

function isNumber(const s: String): boolean;
var
  iValue, iCode: Integer;
begin
  val(s, iValue, iCode);
  result := (iCode = 0)
end;

end.
