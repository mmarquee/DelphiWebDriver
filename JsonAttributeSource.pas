unit JsonAttributeSource;

interface

type
  JsonAttribute = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String read FName;
  end;

implementation


constructor JsonAttribute.Create(const AName: String);
begin
  FName := AName;
end;

end.
