unit NotesResourceU;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, NotesManagerU,
  NoteTypesU;

type
  [ResourceName('Notes')]
  TNotesResource1 = class(TDataModule)
  private
    FNotesManager: TNotesManager;
    procedure CheckNotesManager(const AContext: TEndpointContext);
    procedure HandleException;
  public
    destructor Destroy; override;
  published
    procedure Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [ResourceSuffix('{item}')]
    procedure GetItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    procedure Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [ResourceSuffix('{item}')]
    procedure PutItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [ResourceSuffix('{item}')]
    procedure DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

procedure Register;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

destructor TNotesResource1.Destroy;
begin
  FNotesManager.Free;
  inherited;
end;

// Call this from within an exception block
procedure TNotesResource1.HandleException;
var
  LException: TObject;
  LMessage: string;
begin
  LException := ExceptObject;
  Assert(LException <> nil); // should be within an except block
  if LException is Exception then
  begin
    LMessage := Exception(LException).Message;
    if LException is ENoteDuplicate then
      EEMSHTTPError.RaiseDuplicate(LMessage)
    else if LException is ENoteNotFound then
      EEMSHTTPError.RaiseNotFound(LMessage)
    else if LException is ENoteMissingTitle then
      EEMSHTTPError.RaiseBadRequest(LMessage)
    else
    begin
      LException := TObject(AcquireExceptionObject);
      Assert(LException <> nil);  // should be within an except block
      raise LException;
    end;
  end;
end;

procedure TNotesResource1.Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LNotes: TArray<TNote>;
  LJSON: TJSONArray;
begin
  LJSON := nil;
  try
    CheckNotesManager(AContext);
    LNotes := FNotesManager.GetNotes;
    LJSON := TJSONArray.Create;
    TNoteJSON.NotesToJSON(LNotes, LJSON);
    AResponse.Body.SetValue(LJSON, True)  // AResponse owns LJSONArray and will free it
  except
    LJSON.Free;
    HandleException;
  end;
end;

procedure TNotesResource1.GetItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  LNote: TNote;
  LJSON: TJSONObject;
begin
  try
    LItem := ARequest.Params.Values['item'];
    CheckNotesManager(AContext);
    if FNotesManager.GetNote(LItem, LNote) then
    begin
      LJSON := TJSONObject.Create;
      TNoteJSON.NoteToJSON(LNote, LJSON);
      AResponse.Body.SetValue(LJSON, True);   // AResponse owns LJSONObject and will free it
    end;
  except
    HandleException;
  end;
end;

procedure TNotesResource1.Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LJSON: TJSONObject;
  LNote: TNote;
begin
  try
    if ARequest.Body.TryGetObject(LJSON) then
    begin
      CheckNotesManager(AContext);
      LNote := TNoteJSON.JSONToNote(LJSON);
      FNotesManager.AddNote(LNote);
    end
    else
      AResponse.RaiseBadRequest('JSON expected');
  except
    HandleException;
  end;
end;

procedure TNotesResource1.PutItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  LJSON: TJSONObject;
  LNote: TNote;
begin
  try
    LItem := ARequest.Params.Values['item'];
    if ARequest.Body.TryGetObject(LJSON) then
    begin
      CheckNotesManager(AContext);
      LNote := TNoteJSON.JSONToNote(LJSON);
      FNotesManager.UpdateNote(LItem, LNote);
    end
    else
      AResponse.RaiseBadRequest('JSON expected');
  except
    HandleException;
  end;
end;

function GetModuleDirectory: string;
begin
  Result := ExtractFilePath(StringReplace(GetModuleName(HInstance),'\\?\','',[rfReplaceAll]));
end;

procedure TNotesResource1.CheckNotesManager(const AContext: TEndpointContext);
begin
  if AContext.User = nil then
    AContext.Response.RaiseUnauthorized('The operation is only permitted for logged in users');
  if FNotesManager = nil then
    FNotesManager := TNotesManager.Create(GetModuleDirectory, AContext.User.UserID);
end;

procedure TNotesResource1.DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
begin
  try
    LItem := ARequest.Params.Values['item'];
    CheckNotesManager(AContext);
    FNotesManager.DeleteNote(LItem);
  except
    HandleException;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TNotesResource1));
end;

end.


