unit SDLUtils;



interface
uses SysUtils,classes,sdl2;

type

 TSDLTicks = class
  private
    FStartTime : UInt32;
    FTicksPerSecond : UInt32;
    FElapsedLastTime : UInt32;
    FFPSLastTime : UInt32;
    FLockFPSLastTime : UInt32;
  public
    constructor Create;
    destructor Destroy; override; // destructor

    {*****************************************************************************
     Init
     If the hi-res timer is present, the tick rate is stored and the function
     returns true. Otherwise, the function returns false, and the timer should
     not be used.
    *****************************************************************************}
    function Init : boolean;

    {***************************************************************************
     GetGetElapsedSeconds
     Returns the Elapsed time, since the function was last called.
    ***************************************************************************}
    function GetElapsedSeconds : Single;

    {***************************************************************************
     GetFPS
     Returns the average frames per second.
     If this is not called every frame, the client should track the number
     of frames itself, and reset the value after this is called.
    ***************************************************************************}
    function GetFPS : single;

    {***************************************************************************
     LockFPS
     Used to lock the frame rate to a set amount. This will block until enough
     time has passed to ensure that the fps won't go over the requested amount.
     Note that this can only keep the fps from going above the specified level;
     it can still drop below it. It is assumed that if used, this function will
     be called every frame. The value returned is the instantaneous fps, which
     will be less than or equal to the targetFPS.
    ***************************************************************************}
    procedure LockFPS( targetFPS : Byte );
  end;



//types
 type
  PByteArray     = ^TByteArray;
  TByteArray     = array[ 0..High(LongWord) shr 1 - 1 ] of Byte;
  PWordArray     = ^TWordArray;
  TWordArray     = array[ 0..High(LongWord) shr 2 - 1 ] of Word;
  PLongWordArray = ^TLongWordArray;
  TLongWordArray = array[ 0..High(LongWord) shr 3 - 1 ] of LongWord;




function GetStr( const Str : String; const d : AnsiChar; const b : Boolean ) : String;
function file_GetName( const FileName : String ) : String;
function file_GetExtension( const FileName : String ) : String;
function file_GetDirectory( const FileName : String ) : String;



function mins( a, b : Single ) : Single;overload;
function maxs( a, b : Single ) : Single;overload;
function mini( a, b : integer ) : integer;overload;
function maxi( a, b : integer ) : integer;overload;


  function FloatToStr( Value : Single; Digits : Integer = 2 ) : String;
  function StrToFloat( const Value : String ) : Single;

function IntToStr( Value : Integer ) : String;
function StrToInt( const Value : String ) : Integer;

function clamp (value,low,high:single):single;


function LoadSDLBMPFromStream( Stream : TStream ) : PSDL_Surface;
procedure SaveSDLBMPToStream( SDL_Surface : PSDL_Surface; stream : TStream );
function SDL_Swap16( D : UInt16 ) : Uint16;
function SDL_Swap32( D : UInt32 ) : Uint32;
function SDLStreamSetup( stream : TStream ) : PSDL_RWops;
procedure SDLStreamCloseRWops( SDL_RWops : PSDL_RWops );
function  CreateStreamFromRWops(filename:string ):TMemoryStream ;



const


  EPS = 0.000001;

  pi      = 3.141592654;
  rad2deg = 57.29578049;
  deg2rad = 0.017453292;

  ORIENTATION_LEFT  = -1;
  ORIENTATION_RIGHT = 1;
  ORIENTATION_ZERO  = 0;



var
  cosTable : array[ 0..360 ] of Single;
  sinTable : array[ 0..360 ] of Single;

implementation
var
  wideStr : PWideChar;
  filePath:string='';


function clamp (value,low,high:single):single;
begin
		result:=mins(maxs(value,low), high);
end;

function ArcTan2( dx, dy : Single ) : Single;
begin
  Result := abs( ArcTan( dy / dx ) * ( 180 / pi ) );
end;

function mins( a, b : Single ) : Single;
begin
  if a > b Then Result := b else Result := a;
end;

function maxs( a, b : Single ) : Single;
begin
  if a > b Then Result := a else Result := b;
end;
function mini( a, b : integer ) : integer;
begin
  if a > b Then Result := b else Result := a;
end;

function maxi( a, b : integer ) : integer;
begin
  if a > b Then Result := a else Result := b;
end;

procedure InitCosSinTables;
  var
    i         : Integer;
    rad_angle : Single;
begin
  for i := 0 to 360 do
    begin
      rad_angle := i * ( pi / 180 );
      cosTable[ i ] := cos( rad_angle );
      sinTable[ i ] := sin( rad_angle );
    end;
end;

function m_Cos( Angle : Integer ) : Single;
begin
  if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := cosTable[ Angle ];
end;

function m_Sin( Angle : Integer ) : Single;
begin
  if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := sinTable[ Angle ];
end;

function m_Distance( x1, y1, x2, y2 : Single ) : Single;
begin
  Result := sqrt( sqr( x1 - x2 ) + sqr( y1 - y2 ) );
end;

function m_FDistance( x1, y1, x2, y2 : Single ) : Single;
begin
  Result := sqr( x1 - x2 ) + sqr( y1 - y2 );
end;

function m_Angle( x1, y1, x2, y2 : Single ) : Single;
  var
    dx, dy : Single;
begin
  dx := ( X1 - X2 );
  dy := ( Y1 - Y2 );

  if dx = 0 Then
    begin
      if dy > 0 Then
        Result := 90
      else
        Result := 270;
      exit;
    end;

  if dy = 0 Then
    begin
      if dx > 0 Then
        Result := 0
      else
        Result := 180;
      exit;
    end;

  if ( dx < 0 ) and ( dy > 0 ) Then
    Result := 180 - ArcTan2( dx, dy )
  else
    if ( dx < 0 ) and ( dy < 0 ) Then
      Result := 180 + ArcTan2( dx, dy )
    else
      if ( dx > 0 ) and ( dy < 0 ) Then
        Result := 360 - ArcTan2( dx, dy )
      else
        Result := ArcTan2( dx, dy )
end;

function m_Orientation( x, y, x1, y1, x2, y2 : Single ) : Integer;
  var
    orientation : Single;
begin
  orientation := ( x2 - x1 ) * ( y - y1 ) - ( x - x1 ) * ( y2 - y1 );

  if orientation > 0 Then
    Result := ORIENTATION_RIGHT
  else
    if orientation < 0 Then
      Result := ORIENTATION_LEFT
    else
      Result := ORIENTATION_ZERO;
end;



procedure m_SinCos( Angle : Single; out s, c : Single );
begin
  s := Sin( Angle );
  c := Cos( Angle );
end;
function tan( x : Single ) : Single;
  var
    _sin,_cos : Single;
begin
  m_SinCos( x, _sin, _cos );
  tan := _sin / _cos;
end;


//*************************************************************************************

procedure Get_Mem( out Mem : Pointer; Size : LongWord );
begin
  if Size > 0 Then
    begin
      GetMem( Mem, Size );
      FillChar( Mem^, Size, 0 );
    end else
      Mem := nil;
end;

procedure Free_Mem( var Mem : Pointer );
begin
  FreeMem( Mem );
  Mem := nil;
end;







function GetStr( const Str : String; const d : AnsiChar; const b : Boolean ) : String;
  var
    i, pos, l : Integer;
begin
  pos := 0;
  l := Length( Str );
  for i := l downto 1 do
    if Str[ i ] = d Then
      begin
        pos := i;
        break;
      end;
  if b Then
    Result := copy( Str, 1, pos )
  else
    Result := copy( Str, l - ( l - pos ) + 1, ( l - pos ) );
end;

function file_GetName( const FileName : String ) : String;
  var
    tmp :String;
begin
  Result := GetStr( FileName, '/', FALSE );
  if Result = FileName Then
    Result := GetStr( FileName, '\', FALSE );
  tmp := GetStr( Result, '.', FALSE );
  if Result <> tmp Then
    Result := copy( Result, 1, Length( Result ) - Length( tmp ) - 1 );
end;

function file_GetExtension( const FileName : String ) : String;
  var
    tmp : String;
begin
  tmp := GetStr( FileName, '/', FALSE );
  if tmp = FileName Then
    tmp := GetStr( FileName, '\', FALSE );
  Result := GetStr( tmp, '.', FALSE );
  if tmp = Result Then
    Result := '';
end;

function file_GetDirectory( const FileName : String ) : String;
begin
  Result := GetStr( FileName, '/', TRUE );
  if Result = '' Then
    Result := GetStr( FileName, '\', TRUE );

end;

function IntToStr( Value : Integer ) : String;
begin
  Str( Value, Result );
end;

function StrToInt( const Value : String ) : Integer;
  var
    e : Integer;
begin
  Val( Value, Result, e );
  if e <> 0 Then
    Result := 0;
end;



function FloatToStr( Value : Single; Digits : Integer = 2 ) : String;
begin
  Str( Value:0:Digits, Result );
end;

function StrToFloat( const Value : String ) : Single;
  var
    e : Integer;
begin
  Val( Value, Result, e );
  if e <> 0 Then
    Result := 0;
end;

function u_BoolToStr( Value : Boolean ) : UTF8String;
begin
  if Value Then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;


{ TSDLTicks }
constructor TSDLTicks.Create;
begin
  inherited;
  FTicksPerSecond := 1000;
end;

destructor TSDLTicks.Destroy;
begin
  inherited;
end;

function TSDLTicks.GetElapsedSeconds : Single;
var
  currentTime       : Cardinal;
begin
  currentTime := SDL_GetTicks;

  result := ( currentTime - FElapsedLastTime ) / FTicksPerSecond;

  // reset the timer
  FElapsedLastTime := currentTime;
end;

function TSDLTicks.GetFPS : Single;
var
  currentTime, FrameTime : UInt32;
  fps               : single;
begin
  currentTime := SDL_GetTicks;

  FrameTime := ( currentTime - FFPSLastTime );

  if FrameTime = 0 then
    FrameTime := 1;

  fps := FTicksPerSecond / FrameTime;

  // reset the timer
  FFPSLastTime := currentTime;
  result := fps;
end;

function TSDLTicks.Init : boolean;
begin
  FStartTime := SDL_GetTicks;
  FElapsedLastTime := FStartTime;
  FFPSLastTime := FStartTime;
  FLockFPSLastTime := FStartTime;
  result := true;
end;

procedure TSDLTicks.LockFPS( targetFPS : Byte );
var
  currentTime       : UInt32;
  targetTime        : single;
begin
  if ( targetFPS = 0 ) then
    targetFPS := 1;

  targetTime := FTicksPerSecond / targetFPS;

  // delay to maintain a constant frame rate
  repeat
    currentTime := SDL_GetTicks;
  until ( ( currentTime - FLockFPSLastTime ) > targetTime );

  // reset the timer
  FLockFPSLastTime := currentTime;
end;



function SDL_Swap16( D : UInt16 ) : Uint16;
begin
  Result := ( D shl 8 ) or ( D shr 8 );
end;

function SDL_Swap32( D : UInt32 ) : Uint32;
begin
  Result := ( ( D shl 24 ) or ( ( D shl 8 ) and $00FF0000 ) or ( ( D shr 8 ) and $0000FF00 ) or ( D shr 24 ) );
end;


function SdlStreamSeek( context: PSDL_RWops; offset: SInt64; whence: SInt32): SInt64; cdecl;
var
  stream : TStream;
  origin : Word;
begin
  stream := TStream( context.unknown );
  if ( stream = nil ) then
    raise EInvalidContainer.Create( 'SDLStreamSeek on nil' );
  case whence of
    0 : origin := soFromBeginning; //	Offset is from the beginning of the resource. Seek moves to the position Offset. Offset must be >= 0.
    1 : origin := soFromCurrent; //	Offset is from the current position in the resource. Seek moves to Position + Offset.
    2 : origin := soFromEnd;
  else
    origin := soFromBeginning; // just in case
  end;
  Result := stream.Seek( offset, origin );
end;

function SDLStreamWrite(context: PSDL_RWops; const ptr: Pointer; size: size_t; num: size_t): size_t cdecl;
var
  stream : TStream;
begin
  stream := TStream( context.unknown );
  if ( stream = nil ) then
    raise EInvalidContainer.Create( 'SDLStreamWrite on nil' );
  try
    Result := stream.Write( Ptr^, Size * num ) div size;
  except
    Result := 0;
  end;
end;

function SdlStreamRead( context: PSDL_RWops; ptr: Pointer; size: size_t; maxnum: size_t): size_t; cdecl;
var
  stream : TStream;
begin
  stream := TStream( context.unknown );
  if ( stream = nil ) then
    raise EInvalidContainer.Create( 'SDLStreamRead on nil' );
  try
    Result := stream.read( Ptr^, Size * maxnum ) div size;
  except
    Result := 0;
  end;
end;

function SDLStreamClose( context : PSDL_RWops ) : Integer; cdecl;
var
  stream : TStream;
begin
  stream := TStream( context.unknown );
  if ( stream = nil ) then
    raise EInvalidContainer.Create( 'SDLStreamClose on nil' );
  stream.Free;
  Result := 1;
end;

function SDLStreamSetup( stream : TStream ) : PSDL_RWops;
begin
  result := SDL_AllocRW;
  if ( result = nil ) then   raise EInvalidContainer.Create( 'could not create SDLStream on nil' );
  result.unknown := TUnknown( stream );
  result.seek := SdlStreamSeek;
  result.read := SDLStreamRead;
  result.write := SDLStreamWrite;
  result.close := SDLStreamClose;
  result._type:=SDL_RWOPS_UNKNOWN;
end;

// this only closes the SDL part of the stream, not the context

procedure SDLStreamCloseRWops( SDL_RWops : PSDL_RWops );
begin
  SDL_FreeRW( SDL_RWops );
end;

function LoadSDLBMPFromStream( stream : TStream ) : PSDL_Surface;
var
  SDL_RWops : PSDL_RWops;
begin
  SDL_RWops := SDLStreamSetup( stream );
  result := SDL_LoadBMP_RW( SDL_RWops, 0 );
  SDLStreamCloseRWops( SDL_RWops );
end;

procedure SaveSDLBMPToStream( SDL_Surface : PSDL_Surface; stream : TStream );
var
  SDL_RWops : PSDL_RWops;
begin
  SDL_RWops := SDLStreamSetup( stream );
  SDL_SaveBMP_RW( SDL_Surface, SDL_RWops, 0 );
  SDLStreamCloseRWops( SDL_RWops );
end;

function StreamRead( context: PSDL_RWops; ptr: Pointer; size: size_t; maxnum: size_t): size_t; cdecl;
var
  stream : TMemoryStream;
begin
  stream := TMemoryStream( context.unknown );
  Result := stream.read( Ptr^, Size * maxnum ) div size;
      writeln('read',  Size * maxnum);
end;
function StreamWrite(context: PSDL_RWops; const ptr: Pointer; size: size_t; num: size_t): size_t cdecl;
var
  stream : TMemoryStream;
begin
    stream := TMemoryStream( context.unknown );
    Result := stream.Write( Ptr^, Size * num ) div size;
    writeln('write', Size * num);
end;

function  CreateStreamFromRWops(filename:string ):TMemoryStream ;
var
  stream:TMemoryStream ;
  SDL_RWops : PSDL_RWops ;
begin
  stream:=TMemoryStream.Create;
  SDL_RWops:=SDL_AllocRW;//
  SDL_RWops.unknown := TUnknown( stream );
  SDL_RWops.write := StreamWrite;
  SDL_RWops.read := StreamRead;
  SDL_RWops._type:=SDL_RWOPS_UNKNOWN;
  SDL_RWops:=SDL_RWFromFile(pchar(filename),'r');

  result:=stream;
end;


end.
