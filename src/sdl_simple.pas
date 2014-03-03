unit SDL_Simple;

interface

uses
{$IFDEF  MSWINDOWS}
//opengl,
{$ELSE}
//gles,
jni,log,

{$ENDIF}
sdl2,math;
const

  {$IFDEF  MSWINDOWS		}
  SDLLibName = 'SDLSimple.dll';
  {$ELSE}
   {$DEFINE ANDROID}
  SDLLibName = 'libSDL_Simple.so';
  {$ENDIF}


  //* Primitives */
 smePOINTS                  =             $0000;
 smeLINES                   =             $0001;
 smeLINE_LOOP               =             $0002;
 smeLINE_STRIP              =             $0003;
 smeTRIANGLES               =             $0004;
 smeTRIANGLE_STRIP          =             $0005;
 smeTRIANGLE_FAN            =             $0006;
 smeQUADS                   =             $0007;
 smeQUAD_STRIP              =             $0008;
 smePOLYGON                 =             $0009;

SMEPRIM_POINTS		=1;
SMEPRIM_LINES		  =2;
SMEPRIM_TRIPLES		=3;
SMEPRIM_QUADS		  =4;



  type
    DWORD = LongWord;


IXMLNode=pointer;
IXMLDoc=pointer;
IXmlElement=pointer;




  PSDL_Texture = ^TSDL_Texture;
  TSDL_Texture = record
    	 Glid:integer;
	     pixels:pointer;
       pitch:integer;
       BytesPerPixel:integer;
       width, height:integer;
   	   widthTex, heightTex:integer;
  end;


  
HColor=record
r,g,b,a:single;
end;

 PHVector=^hVector;
 hVector=record
				x, y:single;

end;

const
 VecZero2 : hVector = (x: 0.0; y: 0.0);


// PHGEVertexArray = ^HGEVertexArray;

type


 hgeVertex=record
				x, y,z:single;		// screen position
  			col:Uint32;		// color
				tx, ty:single;		// texture coordinates

end;
PHGEVertex = ^HGEVertex;
hgeVertexArray = array [0..MaxInt div 32 - 1] of hgeVertex;
PhgeVertexArray = ^HGEVertexArray;





phgeTriple=^hgeTriple;
hgeTriple=record
			v:array[0..2] of hgeVertex;
			tex:PSDL_Texture;
      blend:integer;
end;


phgeQuad=^hgeQuad;
 hgeQuad=record
    	v:array[0..3]of hgeVertex;
			tex:PSDL_Texture;
      blend:integer;
end;



const
  BLEND_COLORADD   = 1;
  BLEND_COLORMUL   = 0;
  BLEND_ALPHABLEND = 2;
  BLEND_ALPHAADD   = 0;
  BLEND_ZWRITE     = 4;
  BLEND_NOZWRITE   = 0;

  BLEND_DEFAULT     = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  BLEND_DEFAULT_Z   = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_ZWRITE;
  BLEND_ADD         = BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_NOZWRITE;
  BLEND_SUB         = BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_ZWRITE;





procedure smeInit( w, h:integer);cdecl; external  SDLLibName;
function  smeUpdate():boolean;cdecl; external  SDLLibName;
procedure smeEnd();cdecl; external  SDLLibName;


procedure smeClear();cdecl; external  SDLLibName;
procedure smeClearColor(r,g,b:integer);cdecl; external  SDLLibName;



function smeGetTime():single;cdecl; external  SDLLibName;
function smeGetTicks():integer;cdecl; external  SDLLibName;
function smeGetDelta():single;cdecl; external  SDLLibName;
function smeGetFPS():integer;cdecl; external  SDLLibName;
procedure smeSetFrameRate(value:integer);cdecl; external  SDLLibName;


function  smeCreateSurface( width, height, r, g, b, a:integer):PSDL_Surface;cdecl; external  SDLLibName;
procedure smeFreeSurface(surface:PSDL_Surface);cdecl; external  SDLLibName;
function  smeLoadSurface(const filename:pchar ):PSDL_Surface;cdecl; external  SDLLibName;
function  smeLoadSurfaceMem(buffer:Pointer;size: Integer):PSDL_Surface;cdecl; external  SDLLibName;


function  smeWindowWidth():integer;cdecl; external  SDLLibName;
function  smeWindowHeight():integer;cdecl; external  SDLLibName;







procedure smeSetTransform(x,y,dx,dy,rot,hscale,vscale:single);cdecl; external  SDLLibName;
procedure smeSetCamera( scale, x, y, rot:single);cdecl; external  SDLLibName;
procedure smeSetViewPort(x,y,w,h:single);cdecl; external  SDLLibName;


procedure smeSetBlendMode( blendMode:integer);cdecl; external  SDLLibName;

procedure  smeRenderLine(x1,y1,x2,y2:single;color:UInt32;z:single=0.0);cdecl; external  SDLLibName;
procedure  smeRenderCircle( cx,  cy,  Radius:single;Segments:integer;color:UInt32);cdecl; external  SDLLibName;
procedure  smeRenderTriple(const triple:phgeTriple);cdecl; external SDLLibName;
procedure  smeRenderQuad( quad:phgeQuad);cdecl; external SDLLibName ;
procedure  smeRenderQuadUp( quad:phgeQuad);cdecl; external SDLLibName ;


procedure smeBeginBatch(enableTexture:boolean=true);cdecl; external  SDLLibName;
procedure smeEndBatch;cdecl; external  SDLLibName;


function  smeBeginCloud(prim_type:integer;texture:PSDL_Texture;blend:integer):PHGEVertexArray;cdecl; external  SDLLibName;
procedure smeEndCloud(nprim:integer);cdecl; external  SDLLibName;



procedure smeBlitTexture(texture:PSDL_Texture;clipping:PSDL_Rect; x, y,scalex, scaley, rotation:single);cdecl; external  SDLLibName;

procedure smeBindTexture(texture:PSDL_Texture);cdecl; external  SDLLibName;
procedure smeUnBindTexture;cdecl; external  SDLLibName;


procedure smeFreeTexture(texture:PSDL_Texture);cdecl; external  SDLLibName;
function smeCreateTextureFromSurface(surface:PSDL_Surface):PSDL_Texture;cdecl; external  SDLLibName;
function smeCreateCircleTexture( w, h, r:integer;color:Uint32; solid:boolean):PSDL_Texture;cdecl; external  SDLLibName;
function smeCreateRectangleTexture(w, h:integer;color:Uint32; solid:boolean):PSDL_Texture;cdecl; external  SDLLibName;
function smeLoadTextureFromFile( const  filename:pchar ):PSDL_Texture;cdecl; external  SDLLibName;
function smeLoadTextureFromMem(memory:pointer;memorysize:integer ):PSDL_Texture;cdecl; external  SDLLibName;


procedure smeRenderTexture(texture:PSDL_Texture; X, Y, SrcX, SrcY, Width, Height,ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);



procedure smeBeginRender(primitives:integer);cdecl; external  SDLLibName;
procedure smeEndRender();cdecl; external  SDLLibName;
procedure smeVertex3f (x,y,z:single);cdecl; external  SDLLibName;
procedure smeTexCoord (u,v:single);cdecl; external  SDLLibName;
procedure smeColor4f (r,g,b,a:single);cdecl; external  SDLLibName;

procedure smeRect ( x, y, width, height, r, g, b, a:single);cdecl; external  SDLLibName;
procedure smeCircle ( x, y, radius, r, g, b, a:single; segments:integer=20; fill:boolean=false);cdecl; external  SDLLibName;

procedure smeRenderPoints(mode:integer;const points:pointer;count:integer);cdecl; external  SDLLibName;
procedure smeRenderTexturePoints(mode:integer;const points:pointer;const  uvs:pointer;count:integer);cdecl; external  SDLLibName;
procedure smeRenderColorPoints(mode:integer;const points:pointer;const  colors:pointer;count:integer);cdecl; external  SDLLibName;
procedure smeRenderTextureColorPoints(mode:integer;const points;const uvs:pointer;const colors:pointer;count:integer);cdecl; external  SDLLibName;





function  smeLoadFile(const fname:pchar; data:pointer):integer;cdecl; external  SDLLibName;
function  smeRWread(src:PSDL_RWops; buffer:pointer;size:integer;count:integer):integer;cdecl; external  SDLLibName;
function  smeRWwrite(src:PSDL_RWops; buffer:pointer;size:integer;count:integer):integer;cdecl; external  SDLLibName;
procedure smeRWclose(src:PSDL_RWops );cdecl; external  SDLLibName;
function  smeRWsize(src:PSDL_RWops ):integer;cdecl; external  SDLLibName;
function  smeRWseek(src:PSDL_RWops;offset, whence :integer):integer;cdecl; external  SDLLibName;





procedure smeFreeDoc(doc:IXMLDoc);cdecl; external  SDLLibName;
function smeCreateDoc():IXMLDoc;cdecl; external  SDLLibName;
function smeSaveDocToFile(doc:IXMLDoc;const  fname:pchar):boolean;cdecl; external  SDLLibName;
function smeParseDoc(const buffer:pchar):IXMLDoc;cdecl; external  SDLLibName;
function smeLoadDocFromFile(const filename:pchar):IXMLDoc; cdecl; external  SDLLibName;
function smeRootNode(doc:IXMLDoc):IXMLNode;cdecl; external  SDLLibName;

function smeFirstNodeChildByName(node:IXMLNode;const name:pchar):IXMLNode;cdecl; external  SDLLibName;
function smeFirstNodeChild(node:IXMLNode):IXMLNode;cdecl; external  SDLLibName;

function smeNodeIterateChildrenByName(doc:IXMLNode;previous:IXMLNode;name:pchar):IXMLNode;cdecl; external  SDLLibName;
function smeNodeIterateChildren(node:IXMLNode;root:IXMLNode):IXMLNode;cdecl; external  SDLLibName;

function smeGetNodeValue(node:IXMLNode):pchar;cdecl; external  SDLLibName;
function smeGetNextNodeSibling(node:IXMLNode):IXMLNode;cdecl; external  SDLLibName;

function smeGetNodeElement(node:IXMLNode):IXmlElement;cdecl; external  SDLLibName;
function smeGetAttribute(element:IXmlElement;const name:pchar):pchar;cdecl; external  SDLLibName;
function smeGetAttributeText(element:IXmlElement):pchar;cdecl; external  SDLLibName;
function smeGetIntAttribute(element:IXmlElement;const  name:pchar;var value:integer):pchar;cdecl; external  SDLLibName;
function smeGetDoubleAttribute(element:IXmlElement;const  name:pchar;var value:double):pchar;cdecl; external  SDLLibName;

function smeTriangulate(const vertexs:pointer;count:integer;return :pointer):integer;cdecl; external  SDLLibName;


  {$IFDEF ANDROID}
    procedure SDL_Android_Init(env:JNIEnv;cls:jclass);cdecl; external  SDLLibName;
    procedure SDL_SetMainReady;cdecl; external  SDLLibName;
    procedure Android_JNI_GetAccelerometerValues(v:pointer);cdecl; external  SDLLibName;

   {$ENDIF}


function vector(x,y:single):HVector;


function Max(const A, B: integer): integer;overload;
function Max(const A, B: Single): Single;overload;
function Min(const A, B: integer): integer;overload;
function Min(const A, B: Single): Single;overload;




function IntToStr(n : Integer):string;

function StoF(str : string):Single;
function FtoS(f:single):string;
function StoI(s:string):Integer;


function RandomS( lo, hi : Single ) : Single;
function RandomI( lo, hi : integer ) : integer;


function  HGEColor(a,r,g,b:single):HColor;
function ARGB(const A, R, G, B: Byte): Longword;
function COLOR_ARGB(a,r,g,b: single): DWORD;

function Random_Float(const Min, Max: Single): Single;

  function deg2rad(deg:single):single;
  function rad2deg(rad:single):single;

function  CreateHGEVertex(sx, sy,sz:single; color:DWORD; tu ,tv:single):HGEVertex;
function SDL_Rect(x,y,w,h:integer):TSDL_Rect;

procedure glGenTextures(n: integer ; textures: pointer); stdcall; external 'opengl32.dll';
procedure glBindTexture(target: integer ; texture: integer); stdcall;external 'opengl32.dll';



implementation



var
  GSeed: Longword = 0;

  function deg2rad(deg:single):single;
    begin
        result:= deg / 180.0 * PI;
    end;
   function rad2deg(rad:single):single;
   begin
        result:= rad / PI * 180.0;
   end;



function SDL_Rect(x,y,w,h:integer):TSDL_Rect;
begin
result.x:=x;
result.y:=y;
result.h:=h;
result.w:=w;
end;

function  CreateHGEVertex(sx, sy,sz:single; color:DWORD; tu ,tv:single):HGEVertex;
begin
result.x:=sx;
result.y:=sy;
result.z:=sz;
result.col:=color;
result.tx:=tu;
result.ty:=tv;
end;


  procedure COLOR_UnRGB(color : LongWord; var R, G, B : Byte);
begin
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;
function COLOR_ARGB(a,r,g,b: single): DWORD;
begin
Result :=
    (round(a * 255) shl 24) or
    (round(r * 255) shl 16) or
    (round(g * 255) shl 8) or
    (round(b * 255));
end;
function ARGB(const A, R, G, B: Byte): Longword;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;
procedure COLOR_UnRGBA(color : LongWord; var R, G, B,A : Byte);
begin
           A:= color shr 24;
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;

{
procedure  smeRenderQuad( quad:phgeQuad);
var
i:integer;
vertex:HGEVertex;
r,g,b,a:byte;
color:longword;
begin

  for i:=0 to 3 do
         begin
          vertex:=Quad.v[i];
          color:=vertex.Col;
          COLOR_UnRGBA(color,r,g,b,a);
          vertex.Col:=ARGB(a,b,g,r);
          Quad.v[i]:=vertex;
         end;

         RenderQuad(quad);

end;
}


function Random_Float(const Min, Max: Single): Single;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + (GSeed shr 16) * (1.0 / 65535.0) * (Max - Min);
end;

function Random_Int(const Min, Max: Integer): Integer;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + Integer((GSeed xor GSeed shr 15) mod Cardinal(Max - Min + 1));
end;

procedure Random_Seed(const Seed: Integer);
begin
  if (Seed = 0) then
    GSeed := smeGetTicks
  else
    GSeed := Seed;
end;

function     HGEColor(a,r,g,b:single):HColor;
begin
result.r:=r;
result.g:=g;
result.b:=b;
result.a:=a;
end;
function vector(x,y:single):HVector;
begin
result.x:=x;
result.y:=y;
end;




function CreateVertex(x,y,z:single;col:Longword;u,v:single):hgeVertex;
begin
result.x:=x;
result.y:=y;
result.z:=z;
result.tx:=u;
result.ty:=v;
result.col:=col;
end;



function DoThouthens(n:Integer):Integer;
var
  i:Integer;
begin
  Result := 1;
  for i := 0 to n-1 do
    Result := Result * 10;
end;


function StoI(s:string):Integer;
var
  e:Integer;
begin
  Val(s, Result, e);
end;

function StoF(str : string):Single;
var
  f,p:string;
  fi,ps:Integer;
begin
  if pos('.', str)<>0 then
  begin
    f := Copy(str, 1, pos('.', str)-1);
    delete(str, 1, pos('.', str));
    p := str;
    fi := StoI(f);
    ps := StoI(p);
    Result := fi + ps/DoThouthens(length(p));
  end else
    Result := StoI(str);

end;
function FtoS(f:single):string;
begin
  Str(f:4:3, Result);
end;

function IntToStr(n : Integer):string;
begin
  Str(n, Result);
end;


function Rect(Left, Top, Right, Bottom: Integer): PSDL_Rect;
begin
  Result.x := Left;
  Result.y := Top;
  Result.w := Bottom;
  Result.h := Right;
end;
function RoundNormal(Value : Extended) : Integer;
var
  CurrencyValue : Currency;
begin
  if Value < 0 then begin
    CurrencyValue := Value - 0.5;
    Result := Trunc(CurrencyValue);
  end else begin
    CurrencyValue := Value + 0.5;
    Result := Trunc(CurrencyValue);
  end;
end;

function Power(const Base, Exponent: Extended): Extended;
begin
  if Exponent = 0.0 then
    Result := 1.0               { n**0 = 1 }
  else if (Base = 0.0) and (Exponent > 0.0) then
    Result := 0.0               { 0**n = 0, n > 0 }
  else if (Frac(Exponent) = 0.0) and (Abs(Exponent) <= MaxInt) then
    Result := IntPower(Base, Integer(Trunc(Exponent)))
  else
    Result := Exp(Exponent * Ln(Base))
end;




function RandomS( lo, hi : Single ) : Single;
begin
  result := ( random * ( hi - lo ) + lo );
end;
function RandomI( lo, hi : integer ) : integer;
begin
  result := ( random  ( hi - lo ) + lo );
end;


function Max(const A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;



function Max(const A, B: Single): Single;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: integer): integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Min(const A, B: Single): Single;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;







procedure BltQuad( Quad: hgeQuad;Src,Dest:TSDL_Rect;z:single;Color:Longword; Angle : Single;VFlip,HFlip:boolean);
function swap(a,b:single;isswap:boolean):single;
begin
if isswap then
result:=b else result:=a;
end;
var
 Verts:array[0..3]of hgeVertex;
SurfW,
SurfH,
XCenter ,
YCenter,

XCor ,
YCor:single;
  pvb:pbyte;
  w,h:integer;
begin

w:=Quad.tex.width;
h:=Quad.tex.height;


SurfW := w+2;
SurfH := h+2;

XCenter := Dest.x + (Dest.w - Dest.x + 1) / 2;
YCenter := Dest.y  + (Dest.h - Dest.y + 1) / 2;


If Angle = 0 Then
begin
    XCor := Dest.x;
    YCor := Dest.h;
end Else
begin
    XCor := XCenter + (Dest.x - XCenter) * Sin(Angle) + (Dest.h - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.h - YCenter) * Sin(Angle) - (Dest.x - XCenter) * Cos(Angle);
End;



Quad.V[0]:=CreateVertex(XCor,YCor,z,color,
swap(Src.x / SurfW,(Src.w + 1) / SurfW,VFlip),
swap((Src.h + 1) / SurfH,Src.y / SurfH,HFlip));

If Angle = 0 Then
begin
    XCor := Dest.x;
    YCor := Dest.y;
end Else
begin

    XCor := XCenter + (Dest.x - XCenter) * Sin(Angle ) + (Dest.y - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.h - YCenter) * Sin(Angle) - (Dest.x - XCenter) * Cos(Angle);
End;


//1 - Top left vertex
Quad.V[1]:=CreateVertex(XCor,YCor,z,color,
swap(Src.x / SurfW,(Src.w + 1) / SurfW,VFlip),
swap(Src.y/ SurfH,(Src.h + 1) / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.w;
    YCor := Dest.h;
end Else
begin
    XCor := XCenter + (Dest.w - XCenter) * Sin(Angle) + (Dest.h - YCenter) * Cos(Angle) ;
    YCor := YCenter + (Dest.h - YCenter) * Sin(Angle) - (Dest.w - XCenter) * Cos(Angle);
End;



//2 - Bottom right vertex
Quad.V[3]:=CreateVertex(XCor,YCor,z,color,
swap((Src.w + 1) / SurfW,Src.x / SurfW,VFlip),
swap((Src.h + 1) / SurfH,Src.y / SurfH,HFlip)


);

If Angle = 0 Then
begin
    XCor := Dest.w;
    YCor := Dest.y;
end Else
begin
    XCor := XCenter + (Dest.w - XCenter) * Sin(Angle) + (Dest.h - YCenter) * Cos(Angle);
    YCor := YCenter + (Dest.h - YCenter) * Sin(Angle) - (Dest.w - XCenter) * Cos(Angle);
End;



//3 - Top right vertex
Quad.V[2]:=CreateVertex (XCor,YCor,z,color,
swap((Src.w + 1) / SurfW,Src.x / SurfW,VFlip),
swap(Src.h / SurfH,(Src.h + 1) / SurfH,HFlip)
);



smeRenderQuad(@Quad);



end;


procedure smeRenderTexture(texture:PSDL_Texture; X, Y, SrcX, SrcY, Width, Height,ScaleX, ScaleY, CenterX, CenterY: Single; MirrorX, MirrorY: Boolean; Color: Cardinal; BlendMode: Integer);

var
      FQuad: HGEQuad;
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
    FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Integer;
    texw,texh,  TX, TY: Single;
begin
  FWidth := Width;
  FHeight := Height;


  FTexWidth := Texture.width;
  FTexHeight := Texture.height;

  FQuad.Tex := Texture;

     texw :=  texture.width / texture.widthTex;
     texh :=  texture.height / texture.heightTex;



  TexX1 := SrcX / FTexWidth;
  TexX1:=TexX1*texw;
  TexY1 := SrcY / FTexHeight;
  TexY1:=TexY1*texh;
  TexX2 := (SrcX + Width) / FTexWidth;
  TexX2:=TexX2*texw;
  TexY2 := (SrcY + Height) / FTexHeight;
  TexY2:=TexY2*texh;


  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.0;
  FQuad.V[1].Z := 0.0;
  FQuad.V[2].Z := 0.0;
  FQuad.V[3].Z := 0.0;

  FQuad.V[0].Col := Color;
  FQuad.V[1].Col := Color;
  FQuad.V[2].Col := Color;
  FQuad.V[3].Col := Color;
  TempX1 := X - CenterX * ScaleX;
  TempY1 := Y - CenterY * ScaleY;
  TempX2 := (X + FWidth * ScaleX) - CenterX * ScaleX;
  TempY2 := (Y + FHeight* ScaleY) - CenterY * ScaleY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;



  if (MirrorX) then
  begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[1].TX; FQuad.V[1].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[1].TY; FQuad.V[1].TY := TY;
    TX := FQuad.V[3].TX; FQuad.V[3].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[3].TY; FQuad.V[3].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
  end;

  if(MirrorY) then
  begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[3].TX; FQuad.V[3].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[3].TY; FQuad.V[3].TY := TY;
    TX := FQuad.V[1].TX; FQuad.V[1].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[1].TY; FQuad.V[1].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
  end;


  FQuad.Blend := BlendMode;
  smeRenderQuad(@FQuad);
 // smeRenderQuadUp(@FQuad);

end;

procedure smeRenderTextureClip(texture:PSDL_Texture; X, Y:single;src:TSDL_Rect);
begin


// smeRenderTexture(texture,x,y,src.x,src.y,src.x+src.w,src.y+src.h,1,1,0,0,false,false,$FFFFFFFF,BLEND_DEFAULT);
 smeRenderTexture(texture,x,y,src.x,src.y,src.w,src.h,1,1,0,0,false,false,$FFFFFFFF,BLEND_DEFAULT);
end;



procedure BltImage(texture:PSDL_Texture;rDest:TSDL_Rect;z:single;Color:longword;blend:integer);
var
Quad: hgeQuad;
begin
Quad.tex:=texture;
Quad.blend:=blend;
Quad.V[0]:=CreateVertex(rDest.x  ,rDest.y     ,z,color,0.0,0.0);
Quad.V[1]:=CreateVertex(rDest.w ,rDest.y     ,z,color,1.0,0.0);
Quad.V[2]:=CreateVertex(rDest.w ,rDest.h  ,z,color,1.0,1.0);
Quad.V[3]:=CreateVertex(rDest.x  ,rDest.h  ,z,color,0.0,1.0);
smeRenderQuad(@Quad);


end;



end.
