unit NotesSwaggerU;

interface

const

sYMALBody =
'#' +  sLineBreak +
' entityObject:' +  sLineBreak +
'    required:' +  sLineBreak +
'      - title' +  sLineBreak +
'      - text' +  sLineBreak +
'    properties:' +  sLineBreak +
'      title:' +  sLineBreak +
'        type: string' +  sLineBreak +
'      text:' +  sLineBreak +
'        type: string' +  sLineBreak +
'#' +  sLineBreak +
' updateEntityObject:' +  sLineBreak +
'    required:' +  sLineBreak +
'      - text' +  sLineBreak +
'    properties:' +  sLineBreak +
'      text:' +  sLineBreak +
'        type: string' +  sLineBreak;


sJSONBody =
'{' +
  '"entityObject": {"required": ["title","text"],' +
    '"properties": {"title": {"type": "string"},"text": {"type": "string"}}' +
  '},' +
  '"updateEntityObject": {"required": ["text"],' +
    '"properties": {"text": {"type": "string"}}' +
  '}' +
'}';


implementation

end.
