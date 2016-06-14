unit NotesManagerU;

interface

uses System.Classes, System.SysUtils,  System.IniFiles, System.Generics.Collections,
  NoteTypesU;

type

  TNotesManager = class
  private
    FIniFile: TIniFile;
    FUserID: string;
    function DecodeMultilineText(const AText: string): string;
    function EncodeMultilineText(const AText: string): string;
  public
    constructor Create(const ADirectory: string; const AUserID: string);
    destructor Destroy; override;
    function GetNotes: TArray<TNote>;
    function GetNote(const ATitle: string; out ANote: TNote): Boolean;
    procedure UpdateNote(const ATitle: string; const ANote: TNote);
    procedure AddNote(const ANote: TNote);
    function DeleteNote(const ATitle: string): Boolean;
    function NoteExists(const ATitle: string): Boolean;
  end;

  ENoteError = class(Exception);
  ENoteNotFound = class(ENoteError);
  ENoteDuplicate = class(ENoteError);
  ENoteMissingTitle = class(ENoteError);

implementation

{ TNotesManager }

procedure TNotesManager.AddNote(const ANote: TNote);
begin
  if ANote.Title = '' then
    raise ENoteMissingTitle.Create('Note title required');
  if NoteExists(ANote.Title) then
    raise ENoteDuplicate.CreateFmt('"%s" already exists', [ANote.Title]);
  FIniFile.WriteString(FUserID, ANote.Title, EncodeMultilineText( ANote.Text));
end;

constructor TNotesManager.Create(const ADirectory: string; const AUserID: string);
var
  LPath: string;
begin
  FUserID := AUserID;
  LPath := IncludeTrailingPathDelimiter(ExpandFileName(ADirectory)) + 'notes.ini';
  FIniFile := TIniFile.Create(LPath);
end;

function TNotesManager.NoteExists(const ATitle: string): Boolean;
begin
  Result := FIniFile.ValueExists(FUserID, ATitle);
end;

function TNotesManager.DeleteNote(const ATitle: string): Boolean;
begin
  Result := NoteExists(ATitle);
  if Result then
    FIniFile.DeleteKey(FUserID, ATitle);
end;

destructor TNotesManager.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TNotesManager.EncodeMultilineText(const AText: string): string;
var
  LBuilder: TStringBuilder;
  S: Char;
begin
  LBuilder := TStringBuilder.Create;
  try
    for S in AText do
    begin
      case S of
      #10:
        LBuilder.Append('\n');
      #13:
        LBuilder.Append('\r');
      '\':
        LBuilder.Append('\\');
      else
        LBuilder.Append(S);
      end;
    end;
    Result := LBuilder.ToString;
  finally
    LBuilder.Free;
  end;
end;

function TNotesManager.DecodeMultilineText(const AText: string): string;
var
  LBuilder: TStringBuilder;
  I: Integer;
  S: Char;
begin
  LBuilder := TStringBuilder.Create;
  try
    I := 0;
    while I < AText.Length do
    begin
      S := AText.Chars[I];
      if (S = '\') and (I+1 < AText.Length) then
        case AText.Chars[I+1] of
          'n':
            begin
              Inc(I);
              S := #10;
            end;
          'r':
            begin
              Inc(I);
              S := #13;
            end;
          '\':
            begin
              Inc(I);
              S := '\';
            end
        end;
      LBuilder.Append(S);
      Inc(I);
    end;
    Result := LBuilder.ToString;
  finally
    LBuilder.Free;
  end;
end;

function TNotesManager.GetNote(const ATitle: string; out ANote: TNote): Boolean;
var
  LText: string;
begin
  Result := NoteExists(ATitle);
  if Result then
  begin
    LText := DecodeMultilineText(FIniFile.ReadString(FUserID, ATitle, ''));
    ANote := TNote.Create(ATitle, LText);
  end;
end;

function TNotesManager.GetNotes: TArray<TNote>;
var
  LList: TList<TNote>;
  LNote: TNote;
  LSection: TStrings;
  I: Integer;
begin
  LSection := nil;
  LList := nil;
  try
    LSection := TStringList.Create;
    LList := TList<TNote>.Create;
    FIniFile.ReadSectionValues(FUserID, LSection);
    for I := 0 to LSection.Count - 1 do
    begin
      LNote := TNote.Create(LSection.Names[I],
        DecodeMultilineText(LSection.ValueFromIndex[I]));
      LList.Add(LNote);
    end;
    Result := LList.ToArray;
  finally
    LList.Free;
    LSection.Free;
  end;
end;

procedure TNotesManager.UpdateNote(const ATitle: string; const ANote: TNote);
begin
  if not NoteExists(ATitle) then
    raise ENoteNotFound.CreateFmt('"%s" not found', [ATitle]);
  FIniFile.WriteString(FUserID, ATitle, EncodeMultilineText(ANote.Text));
end;


end.
