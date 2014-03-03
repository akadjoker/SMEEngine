unit SDLXML;

//TODO: support for CDATA markers
//A CDATA section starts with "<![CDATA[" and ends with "]]>"

//TODO: figure out a way to thoroughly test this.

//ignore these sort of tags:
//<?xml version="1.0" encoding="ISO-8859-1"?>
//<!DOCTYPE note SYSTEM "Note.dtd">


interface

uses Classes;

type TPseudoXMLNode = class
  private
    function Getatrributes(const Name: string): string;
    procedure Setatrributes(const Name, Value: string);
    procedure Setvalue(const Value: String);
    function getChildCount : integer;
    function getChild( const index : integer ): TPseudoXMLNode;
  protected
    FValue      : String;// (read only, contains all text within the node )
    FAttributes : TSTringList;// ( a stringList of all attributes )
    FChildren   : TList;//Children ( a List of all child nodes )
    function  containsXML(text:String):Boolean;
    function  getFirstTagName(text:String;offset:integer=1):String;
    function  getAttributes(var text,tagName:string):TStringList;
    function  extractTextInsideOfTag(var text,tagName:string):String;
    function  makeChildList(var text : String) : TList;
    function  extractFirstTag(var text : string) : String;
    procedure trimText(var text : string);
    procedure escape( var s : String );
    procedure unEscape( var s : String );
    function  recursiveToString(lineIndent:String=''):String;
    procedure removeComments( var text : string );
    procedure setFromCommentlessString(text : String);
  public
    tagName     : String;
    constructor create;
    destructor  destroy; override;
    procedure   addChild(Node : TPseudoXMLNode);
    property    value : String read Fvalue write Setvalue;
    property    atrributes[const Name: string]: string read Getatrributes write Setatrributes;
    property    childCount: Integer read getChildCount;
    property    child[const Index: Integer]: TPseudoXMLNode read GetChild; default;
    function    ToString : String;// (converts the whole thing into a string)
    procedure   LoadFromFile(fileName : String);
    procedure   SaveToFile(fileName : String);
    procedure setFromString(text : String);
end;

type TPseudoXML = class(TPseudoXMLNode)
end;

implementation

uses StrUtils,sysUtils;

{ TPseudoXMLNode }
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.addChild(Node: TPseudoXMLNode);
begin

end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.containsXML(text: String): Boolean;
begin
  result := pos('<',text) > 0;
end;
//------------------------------------------------------------------------------
constructor TPseudoXMLNode.create;
begin

end;
//------------------------------------------------------------------------------
destructor TPseudoXMLNode.destroy;
begin

  if assigned(FAttributes) then
  begin
    FAttributes.free;
  end;

  if assigned(FChildren) then
  begin
    while FChildren.Count > 0 do
    begin
      TPseudoXMLNode(Fchildren.Last).free;
      Fchildren.Remove(Fchildren.Last);
    end;
    FChildren.Free;
  end;
  inherited;
end;
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.escape(var s: String);
begin
  s := stringReplace(s,'&','&amps;',[rfReplaceAll]); //its important to replace ampersands first.
  s := stringReplace(s,'<','&lt;',[rfReplaceAll]);
  s := stringReplace(s,'>','&gt;',[rfReplaceAll]);
  s := stringReplace(s,'"','&quot;',[rfReplaceAll]);
  s := stringReplace(s,'''','&apos;',[rfReplaceAll]);
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.extractFirstTag(var text: string): String;
//extracts the first xml tag in a string, including all sub-tags
//and including the beginning and ending tag markers.
//modifies the input string to remove the extracted text.
type
  TparseState = (inNone,inTag,inQuotes,inText);
var
  tagName : String;
  state : TParseState;
  ct : integer;
  numOpenTagsWithSameName : integer;
  endPos : integer;
begin
  result := '';
  state := inNone;
  tagName := getFirstTagName(text);
  ct := 1;
  numOpenTagsWithSameName := 0;
  while ct <= length(text) do
  begin
    case state of
      inNone: if text[ct] = '<' then state := inTag;
      inTag:
        begin
          if text[ct] = '"' then state := inQuotes
          else if text[ct] = '>' then
          begin
            state := inText;
            continue;
          end
          else if copy(text,ct,2) = '/>' then
          begin
            result := result + '/>';
            ct := ct+1;
            break;
          end;
        end;
      inQuotes: if text[ct] = '"' then state := inTag;
      inText:
      begin
        if (text[ct] = '<') and (copy(text,ct+1,1) <> '/')  then
        begin
          if getFirstTagName(text,ct) = tagName then
          begin
            inc(numOpenTagsWithSameName);
          end;
        end
        else if copy(text,ct,2) = '</' then
        begin
          if getFirstTagName(text,ct) = tagName then
          begin
            dec(numOpenTagsWithSameName);
          end;
          if numOpenTagsWithSameName < 0 then
          begin
            endPos := posEx('>',text,ct);
            while(ct <= endPos )do
            begin
              result := result + text[ct];
              inc(ct);
            end;
            break;
          end;
        end;
      end;
    end;
    result := result + text[ct];
    inc(ct);
  end;

  //delete "ct" characters from the input string.
  delete(text,1,ct);

end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.extractTextInsideOfTag(var text,
  tagName: string): String;
type
  TparseState = (inNone,inTag,inQuotes,inText);
var
  state : TParseState;
  ct : integer;
  numOpenTagsWithSameName : integer;
begin
  result := '';
  state := inNone;
  for ct  := 1 to length(text) do
  begin
    case state of
      inNone: if text[ct] = '<' then state := inTag;
      inTag:
        begin
          if text[ct] = '"' then state := inQuotes
          else if text[ct] = '>' then
          begin
            state := inText;
            continue;
          end
          else if copy(text,ct,2) = '/>' then break;
        end;
      inQuotes: if text[ct] = '"' then state := inTag;
      inText:
      begin

        if (text[ct] = '<') and (copy(text,ct+1,1) <> '/')  then
        begin
          if getFirstTagName(text,ct) = tagName then
          begin
            inc(numOpenTagsWithSameName);
          end;
        end
        else if copy(text,ct,2) = '</' then
        begin
          if getFirstTagName(text,ct) = tagName then
          begin
            dec(numOpenTagsWithSameName);
          end;
          if numOpenTagsWithSameName < 0 then break;
        end;
      end;
    end;

    if state = inText then
    begin
      result := result + text[ct];
    end;
  end;

  //trim off leading and trailing "ignore" charaters
  trimText(result);


end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.Getatrributes(const Name: string): string;
begin
  result := FAttributes.Values[name];
end;
 //------------------------------------------------------------------------------
//values are passed by reference so that they are not duplicated in memory
function TPseudoXMLNode.getAttributes(var text, tagName: string): TStringList;
type
 TattributeParseState = (none,inTag,inQuote,inName);
var
 state : TattributeParseState;
 ct : integer;
 currentName,currentValue : String;
const
 ignoreChars : set of char = [' ',#13,#10,#9,'='];
begin

  result := TStringList.create;
  currentName := '';
  currentValue := '';

  for ct := 1 to length(text) do
  begin
    //if we are not inside a quote, then the '>' character means we are at the end of a tag.
    if state <> inName then
    begin
      if text[ct] = '>' then exit;
    end;

    case state of
      none:
        begin
          if text[ct] = '<'  then
          begin
            state := inTag;
            continue;
          end;
        end;
      inTag:
        begin
          if text[ct] in ignoreChars then continue;

          if text[ct] = '"' then
          begin
            state := inQuote;
            continue;
          end;
          state := inName;
          currentName := text[ct];
          continue;
        end;
      inquote:
        begin
          if text[ct] = '"' then
          begin
            if currentName <> '' then
            begin
              unEscape(currentValue);
              result.Values[currentName] := currentValue;
            end;
            currentValue := '';
            state := inTag;
            continue;
          end;
          currentValue := currentValue + text[ct];
        end;
      inName:
        begin
          if (text[ct] in ignoreChars) or (text[ct] = '>') then
          begin
             if currentName = tagName then
             begin
               currentName := '';
             end;
             state := inTag;
             if text[ct] = '>' then exit;
             continue;
          end;
          currentName := currentName + text[ct];
        end;
    end;
  end;
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.getChild(const index: integer): TPseudoXMLNode;
begin
   result := TPseudoXMLNode(FChildren[index]);
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.getChildCount: integer;
begin
  result := FChildren.Count;
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.getFirstTagName(text: String;offset:integer=1): String;
var
  bracePos : integer;
  ct : integer;
  firstCharFound : Boolean;
const
 ignoreChars : set of char = [' ',#13,#10,#9,'<','>','/'];
begin
  result := '';
  bracePos := posEx('<',text,offset);
  if bracePos < 0 then exit;
  firstCharFound := false;
  for ct := (bracePos+1) to length(text) do
  begin
    if not (text[ct] in ignoreChars) then
    begin
      firstCharFound := true;
    end;

    if firstCharFound then
    begin
       if text[ct] in ignoreChars then
       begin
         exit;
       end;
       result := result + text[ct];
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.LoadFromFile(fileName: String);
var
 sl : TStringList;
begin
  sl := TStringList.create;
  try
  sl.LoadFromFile( fileName);
  self.setFromString( sl.text );
  except
  end;
  sl.free;
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.makeChildList(var text: String): TList;
var
tagText : String;
list : Tlist;
begin
  list := TList.create;
  tagText := extractFirstTag(text);
  while(containsXML(tagText)) do
  begin
    list.Add(
              TPseudoXMLNode.create
            );
    TPseudoXMLNode( list.Last ).setFromCommentlessString(tagText);

    tagText := extractFirstTag(text);
  end;
  result := list;
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.recursiveToString(lineIndent: String = ''): String;
var
  ct: Integer;
  CRLF : String;
  tagEnd : String;
  attributeValue : String;
  contentValue : String;
const
 tab = #9;
begin

  CRLF := #13#10 + lineIndent;

  result := '<' + tagName;

  for ct := 0 to FAttributes.Count - 1 do
  begin
    attributeValue := FAttributes.Values[ FAttributes.Names[ct] ];
    escape(attributeValue);
    result := result
              + CRLF
              + ' '
              + FAttributes.Names[ct]
              + '="'
              + attributeValue
              + '"';
  end;

  if FAttributes.Count > 0 then
  begin
    tagEnd := CRLF;
  end
  else
  begin
    tagEnd := '';
  end;

  if FChildren.Count = 0 then
  begin
    if FValue = '' then
      result := result + tagEnd + '/>'
    else
    begin
      contentValue := FValue;
      escape(contentValue);
      result := result + tagEnd + '>' + CRLF + tab + contentValue + CRLF + '</' + tagName + '>'
    end;
  end
  else
  begin
    result := result + tagEnd + '>';
    for ct := 0 to fChildren.Count - 1 do
    begin
      result := result + CRLF + tab + TPseudoXMLNode(fChildren[ct]).recursiveToString(lineIndent + tab);
    end;
    result := result + CRLF + '</' + tagName + '>'
  end;

end;

procedure TPseudoXMLNode.removeComments(var text: string);
var
 temp : string;
 ct : integer;
 commentDepth : integer;
begin
  //comment depth keeps track of number of comments that have started.
  //we are not out of a comment until we reach the same number of comment
  //ends.  this is a way to handle comments within comments.
  commentDepth := 0;
  for ct := 1 to length(text) do
  begin
    if commentDepth = 0 then
    begin
      if copy(text,ct,4) = '<!--' then
      begin
        inc(commentDepth)
      end
      else
      begin
        temp := temp + text[ct];
      end;
    end
    else
    begin
      if copy(text,ct-2,3) = '-->' then
      begin
        dec(commentDepth)
      end
    end;
  end;
  text := temp;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.SaveToFile(fileName: String);
var
  sl : TSTringList;
begin

  sl := TStringList.create;
  try
  sl.Text := ToString;
  sl.SaveToFile(fileName);
  finally
  sl.free;
  end;

end;

procedure TPseudoXMLNode.Setatrributes(const Name, Value: string);
begin
  FAttributes.values[name] := value;
end;

procedure TPseudoXMLNode.setFromCommentlessString(text: String);
var i : integer;
var node : TPseudoXMLNode;
begin
  //get the tag name
  tagName := getFirstTagName(text);

  //collect the attributes for the tag.
  FAttributes := getAttributes(text,tagName);

  //get the inner text
  FValue := extractTextInsideOfTag(text,tagName);

  //make children, if the tag contains XML
  if containsXML(FValue) then
  begin
    FChildren := makeChildList(FValue);
    FValue := '';
  end
  else
  begin
    FChildren := TList.create;
    unescape(FValue);
  end;
end;

procedure TPseudoXMLNode.setFromString(text: String);
var i : integer;
var node : TPseudoXMLNode;
begin

  //remove comments
  removeComments(text);

  //
  setFromCommentlessString(text);

end;

//------------------------------------------------------------------------------
procedure TPseudoXMLNode.Setvalue(const Value: String);
begin
  Fvalue := Value;
end;
//------------------------------------------------------------------------------
function TPseudoXMLNode.ToString: String;
begin
  result := recursiveToString;
end;
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.trimText(var text: string);
var
  ct : integer;
const
 trimChars : set of char = [' ',#13,#10,#9];
begin

  //removing leading characters..
  ct := 0;
  while ct + 1 < length(text) do
  begin
    if not (text[ct+1] in trimChars) then
    begin
      break
    end
    else
    begin
      inc(ct);
    end;
  end;
  delete(text,1,ct);

  //remove trailing characters
  ct := length(text);
  while ct - 1 > 0 do
  begin
    if not (text[ct-1] in trimChars) then
    begin
      break
    end
    else
    begin
      dec(ct);
    end;
  end;
  delete(text,ct,length(text)-ct);
end;
//------------------------------------------------------------------------------
procedure TPseudoXMLNode.unEscape(var s: String);
begin
  s := stringReplace(s,'&lt;','<',[rfReplaceAll]);
  s := stringReplace(s,'&gt;','>',[rfReplaceAll]);
  s := stringReplace(s,'&quot;','"',[rfReplaceAll]);
  s := stringReplace(s,'&apos;','''',[rfReplaceAll]);
  s := stringReplace(s,'&amps;','&',[rfReplaceAll]); //its important to replace ampersands last.
end;

end.
