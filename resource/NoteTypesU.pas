unit NoteTypesU;

interface

uses System.JSON;

type
  TNote = record
  private
    FTitle: string;
    FText: string;
  public
    constructor Create(const ATitle, AText: string);
    property Title: string read FTitle write FTitle;
    property Text: string read FText write FText;
  end;

  TNoteJSON = class
  public
    class function JSONToNote(const AJSON: TJSONValue): TNote; static;
    class function JSONToNotes(const AJSON: TJSONArray): TArray<TNote>; static;
    class procedure NotesToJSON(const ANotes: TArray<TNote>; const AJSON: TJSONArray); static;
    class procedure NoteToJSON(const ANote: TNote; const AJSON: TJSONObject); static;
  end;

implementation

uses System.Generics.Collections;

{ TNote }

constructor TNote.Create(const ATitle, AText: string);
begin
  FText := AText;
  FTitle := ATitle;
end;

class function TNoteJSON.JSONToNote(const AJSON: TJSONValue): TNote;
begin
  Result := TNote.Create(AJSON.GetValue<string>('title', ''), AJSON.GetValue<string>('text', ''));
end;

class procedure TNoteJSON.NoteToJSON(const ANote: TNote;
  const AJSON: TJSONObject);
begin
  AJSON.RemovePair('title');
  AJSON.RemovePair('text');
  AJSON.AddPair('title', ANote.Title);
  AJSON.AddPair('text', ANote.Text);
end;

class function TNoteJSON.JSONToNotes(const AJSON: TJSONArray): TArray<TNote>;
var
  LValue: TJSONValue;
  LList: TList<TNote>;
begin
  LList := TList<TNote>.Create;
  try
    for LValue in AJSON do
      LList.Add(TNoteJSON.JSONToNote(LValue));
    Result := LList.ToArray;
  finally
    LList.Free;
  end;
end;

class procedure TNoteJSON.NotesToJSON(const ANotes: TArray<TNote>;
  const AJSON: TJSONArray);
var
  LNote: TNote;
  LJSONObject: TJSONObject;
begin
  for LNote in ANotes do
  begin
    LJSONObject := TJSONObject.Create;
    NoteToJSON(LNote, LJSONObject);
    AJSON.Add(LJSONObject);
  end;
end;

end.
