unit NotesResourceU;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, NotesManagerU,
  NoteTypesU, NotesSwaggerU;

type
  // Swagger for request and response body
  [EndPointObjectsYAMLDefinitions(sYMALBody)]
  [EndPointObjectsJSONDefinitions(sJSONBody)]

  [ResourceName('Notes')]
  TNotesResource1 = class(TDataModule)
  private
    FNotesManager: TNotesManager;
    procedure CheckNotesManager(const AContext: TEndpointContext);
    procedure HandleException;
    procedure RespondWithNote(const AResponse: TEndpointResponse;
      const ATitle: string);
  public
    destructor Destroy; override;
  public

    // Swagger for GetAll
    // Add session token parameter because EMS does not automatically add
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Header, 'X-Embarcadero-Session-Token', 'Session Token', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestSummary('Notes', 'Get all', 'Get all notes', 'application/json', '')]
    [EndPointResponseDetails(200, 'OK', TAPIDoc.TPrimitiveType.spArray, TAPIDoc.TPrimitiveFormat.None, '', '#/definitions/entityObject')]
    [EndPointResponseDetails(401, 'Login required', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]

    procedure GetAll(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    // Swagger for GetNote
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Header, 'X-Embarcadero-Session-Token', 'Session Token', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestSummary('Notes', 'Get one', 'Get a note', 'application/json', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'title', 'Note title', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'OK', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '#/definitions/entityObject')]
    [EndPointResponseDetails(404, 'Note not found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(401, 'Login required', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]

    [ResourceSuffix('{title}')]
    procedure GetNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    // Swagger for PostNote
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Header, 'X-Embarcadero-Session-Token', 'Session Token', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestSummary('Notes', 'Create', 'Create a new note',  'application/json',  'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'Note title and text', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '#/definitions/entityObject')]
    [EndPointResponseDetails(201, 'Note created', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(409, 'Note already exists', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(401, 'Login required', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Incorrect JSON', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]

    procedure PostNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    // Swagger for PutNote
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Header, 'X-Embarcadero-Session-Token', 'Session Token', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestSummary('Notes', 'Update', 'Update a note', 'application/json', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'title', 'Note title', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'Note text', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '#/definitions/updateEntityObject')]
    [EndPointResponseDetails(200, 'OK', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '#/definitions/entityObject')]
    [EndPointResponseDetails(404, 'Note not found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(401, 'Login required', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]

    [ResourceSuffix('{title}')]
    procedure PutNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    // Swagger for DeleteNote
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Header, 'X-Embarcadero-Session-Token', 'Session Token', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestSummary('Notes', 'Delete', 'Delete a note', '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'title', 'Note title', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, 'application/json', '')]
    [EndPointResponseDetails(200, 'OK', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Note not found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(401, 'Login required', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]

    [ResourceSuffix('{title}')]
    procedure DeleteNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

procedure Register;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function GetModuleDirectory: string;
begin
  Result := ExtractFilePath(StringReplace(GetModuleName(HInstance),'\\?\','',[rfReplaceAll]));
end;

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
      EEMSHTTPError.RaiseDuplicate('', LMessage)   // 409
    else if LException is ENoteNotFound then
      EEMSHTTPError.RaiseNotFound('', LMessage)    // 404
    else if LException is ENoteMissingTitle then
      EEMSHTTPError.RaiseBadRequest('', LMessage)  // 400
    else
    begin
      LException := TObject(AcquireExceptionObject);
      Assert(LException <> nil);  // should be within an except block
      raise LException;
    end;
  end;
end;

procedure TNotesResource1.CheckNotesManager(const AContext: TEndpointContext);
begin
  if AContext.User = nil then
    EEMSHTTPError.RaiseUnauthorized('', 'The operation is only permitted for logged in users'); // 401
  if FNotesManager = nil then
    FNotesManager := TNotesManager.Create(GetModuleDirectory, AContext.User.UserID);
end;

procedure TNotesResource1.GetAll(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
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

procedure TNotesResource1.GetNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LTitle: string;
begin
  try
    CheckNotesManager(AContext);
    LTitle := ARequest.Params.Values['title'];
    RespondWithNote(AResponse, LTitle);
  except
    HandleException;
  end;
end;

procedure TNotesResource1.PostNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
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
      RespondWithNote(AResponse, LNote.Title);
      AResponse.SetCreated(LNote.Title); // 201 response
    end
    else
      AResponse.RaiseBadRequest('JSON expected');  // 400
  except
    HandleException;
  end;
end;

procedure TNotesResource1.PutNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LTitle: string;
  LJSON: TJSONObject;
  LNote: TNote;
begin
  try
    CheckNotesManager(AContext);
    LTitle := ARequest.Params.Values['title'];
    if ARequest.Body.TryGetObject(LJSON) then
    begin
      LNote := TNoteJSON.JSONToNote(LJSON);
      FNotesManager.UpdateNote(LTitle, LNote);
      RespondWithNote(AResponse, LTitle);
    end
    else
      AResponse.RaiseBadRequest('JSON expected');  // 400
  except
    HandleException;
  end;
end;

procedure TNotesResource1.DeleteNote(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LTitle: string;
begin
  try
    CheckNotesManager(AContext);
    LTitle := ARequest.Params.Values['title'];
    FNotesManager.DeleteNote(LTitle);
  except
    HandleException;
  end;
end;

procedure TNotesResource1.RespondWithNote(const AResponse: TEndpointResponse; const ATitle: string);
var
  LNote: TNote;
  LJSON: TJSONObject;
begin
  Assert(FNotesManager <> nil);
  LNote := FNotesManager.GetNote(ATitle);
  LJSON := TJSONObject.Create;
  TNoteJSON.NoteToJSON(LNote, LJSON);
  AResponse.Body.SetValue(LJSON, True);   // AResponse owns LJSONObject and will free it
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TNotesResource1));
end;

end.


