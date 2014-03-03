

unit HGEClasses;



interface

uses
Classes, opengl, math, SysUtils,sdl2,sdl_simple,sdl2_image;





const
  M_PI   = 3.14159265358979323846;
  M_PI_2 = 1.57079632679489661923;
  M_PI_4 = 0.785398163397448309616;
  M_1_PI = 0.318309886183790671538;
  M_2_PI = 0.636619772367581343076;
  EPSILON = 0.00000001;


CFushia=4294443256;
CBlack=4278452224;

const
  HGESLIDER_BAR         = 0;
  HGESLIDER_BARRELATIVE = 1;
  HGESLIDER_SLIDER      = 2;

const
  MAX_PARTICLES  = 500;
  MAX_PSYSTEMS  = 100;



const
  HGEANIM_FWD = 0;
  HGEANIM_REV = 1;
  HGEANIM_PINGPONG = 2;
  HGEANIM_NOPINGPONG = 0;
  HGEANIM_LOOP = 4;
  HGEANIM_NOLOOP = 0;

  const
  HGETEXT_LEFT     = 0;
  HGETEXT_RIGHT    = 1;
  HGETEXT_CENTER   = 2;
  HGETEXT_HORZMASK = $03;

  HGETEXT_TOP      = 0;
  HGETEXT_BOTTOM   = 4;
  HGETEXT_MIDDLE   = 8;
  HGETEXT_VERTMASK = $0C;


const
  HGEDISP_NODE = 0;
  HGEDISP_TOPLEFT = 1;
  HGEDISP_CENTER = 2;

   LEFT = $000100;
	 RIGHT = $001000;
	 UP = $010000;
	 DOWN = $100000;
	 NONE = 0;
	 CEILING = UP;
	 FLOOR = DOWN;
	 WALL = LEFT or RIGHT;
	 ANY	= LEFT or RIGHT or UP or DOWN;



type


  tpoint=record
    x,y:integer;
  end;


  TQuad = array [0..3] of TPoint;


  TGlip=record
      TX, TY, Width, Height: Single;
      TexWidth, TexHeight: Single;
      TexX1, TexY1, TexX2, TexY2: Single;
  end;

  PRect = ^TRect;
  TRect = packed record
    case Integer of
      0: (Left, Top, Right, Bottom: Longint);
      1: (TopLeft, BottomRight: TPoint);
  end;


Point=record
x,y:single
end;

Rectangle=object
public
x,y, Width,Height:single;
procedure setBound(setx,sety,setw,seth:single);
function contains(inX,inY:single):boolean;overload;
function contains(r:Rectangle):boolean;overload;
function intersection(toIntersect:Rectangle):Rectangle;
function intersects(other:Rectangle):Boolean;
function Overlap(other:Rectangle):Boolean;
procedure draw(r,g,b:single;z:single=0.0);
end;


TSMEPoint=class
public
x,y:single;
constructor Create(x,y:single);
function lengt:single ;
function toString ():String ;
function sub (v:TSMEPoint):TSMEPoint;
function mul (v:TSMEPoint):TSMEPoint;
function add (v:TSMEPoint):TSMEPoint;
function distance (pt1:TSMEPoint; pt2:TSMEPoint):single ;
function equals (toCompare:TSMEPoint):Boolean;
function interpolate (pt1:TSMEPoint; pt2:TSMEPoint; f:single):TSMEPoint;
procedure normalize (thickness:single);
procedure offset (dx,dy:Single);
function  polar (len, angle:Single):TSMEPoint;
procedure setTo (x,y:single);

end;

TSMEMatrix=class
public
    a:Single;
	  b:Single;
	  c:Single;
	  d:Single;
	  tx:Single;
	  ty:Single;


constructor Create(a:Single = 1; b:Single = 0; c:Single = 0; d:Single = 1; tx:Single = 0; ty:Single = 0); overload;


function mult(m:TSMEMatrix):TSMEMatrix;
function invert ():TSMEMatrix;
procedure skew(skewX, skewY:single);
procedure identity;
procedure  rotate (angle:Single);
procedure scale (x:Single; y:Single);
procedure  setTo (a:Single; b:Single; c:Single; d:Single; tx:Single; ty:Single);
procedure translate (x:Single; y:Single);
procedure setRotation (angle:Single; scale:Single = 1);
function toString ():String;
function transformPoint (point:TSMEPoint):TSMEPoint;overload;
function transformPoint (point:hvector):hvector;overload;
procedure copyFrom (other:TSMEMatrix);
function clone ():TSMEMatrix ;
procedure concat (m:TSMEMatrix);
end;

TSMERect = object
  private
    FClean: Boolean;
  public
    X1, Y1, X2, Y2: Single;
    procedure init(const Clean: Boolean); overload;
    procedure init(const AX1, AY1, AX2, AY2: Single); overload;
    procedure Clear;
    function IsClean: Boolean;
    procedure SetRect(const AX1, AY1, AX2, AY2: Single);
    procedure SetRadius(const X, Y, R: Single);
    procedure Encapsulate(const X, Y: Single);
    function TextPoint(const X, Y: Single): Boolean;
    function Intersect(const Rect: TSMERect): Boolean; overload;
    function Intersect(const Rect: TSDL_rect): Boolean;overload;
    procedure draw(color:integer);
  end;
  PHGERect = ^TSMERect;

  TSMERegion=class
  public
   name:string;
   x,y,width,height,frameX,frameY,frameWidth,Frameheight:single;
   clip:TSDL_Rect;
   texture:PSDL_Texture;
   procedure Load(fname:string);
   procedure setFromTexture(tex:PSDL_Texture);
  end;



  TSMEParticle = record
    Location: hVector;
    Velocity: hVector;

    Gravity: Single;
    RadialAccel: Single;
    TangentialAccel: Single;

    Spin: Single;
    SpinDelta: Single;

    Size: Single;
    SizeDelta: Single;

    Color: HColor;
    ColorDelta: HColor;

    Age: Single;
    TerminalAge: Single;
  end;
  PHGEParticle = ^TSMEParticle;


  TSMESprite = class
 public

    procedure Render(const X, Y: Single);
    procedure RenderEx(const X, Y, Rot: Single; const HScale: Single = 1.0; VScale: Single = 0.0);
    procedure RenderStretch(const X1, Y1, X2, Y2: Single);
    procedure Render4V(const X0, Y0, X1, Y1, X2, Y2, X3, Y3: Single);

    procedure SetTexture(const Tex: PSDL_Texture);
    procedure SetTextureRect(const X, Y, W, H: Single; const AdjSize: Boolean = True);
    procedure SetColor(const Col: dword; const I: Integer = -1);
    procedure SetZ(const Z: Single; const I: Integer = -1);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetHotSpot(const X, Y: Single);
    procedure SetFlip(const X, Y: Boolean; const HotSpot: Boolean = False);

    function GePSDL_Texture: PSDL_Texture;
    procedure GePSDL_TextureRect(out X, Y, W, H: Single);
    function GetColor(const I: Integer = 0): dword;
    function GetZ(const I: Integer = -0): Single;
    function GetBlendMode: Integer;
    procedure GetHotSpot(out X, Y: Single);
    procedure GetFlip(out X, Y: Boolean);

    function GetBoundingBox(const X, Y: Single; var Rect: TSMERect): TSMERect;
    function GetBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single; var Rect: TSMERect): TSMERect;overload;
    function GetBoundingBoxEx(const X, Y,bx,by,bw,bh, Rot, HScale, VScale: Single): TSMERect;overload;

    procedure DrawBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single);overload;
    procedure DrawBoundingBoxEx(const X, Y,bx,by,bw,bh, Rot, HScale, VScale: Single);overload;


    function GetWidth: Single;
    function GetHeight: Single;


  public
       FQuad: hgeQuad;

  private
    Rect:TSMERect;
    FTX, FTY, FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Single;
    FHotX, FHotY: Single;
    FXFlip, FYFlip, FHSFlip: Boolean;
    FType:String;
    FAnimted:Boolean;
 published

    property TX: Single read FTX;
    property TY: Single read FTY;
    property Width: Single read FWidth;
    property Height: Single read FHeight;
    property TexWidth: Single read FTexWidth;
    property TexHeight: Single read FTexHeight;
    property HotX: Single read FHotX;
    property HotY: Single read FHotY;
    property XFlip: Boolean read FXFlip write FXFlip;
    property YFlip: Boolean read FYFlip write FYFlip;
    property HSFlip: Boolean read FHSFlip write FHSFlip;
    property SpriteType:string read FType write Ftype;
    property Animated:Boolean read FAnimted  write FAnimted;
  public
    constructor Create(const Texture: PSDL_Texture; const TexX, TexY, W, H: Single);

  end;
   TSMEAnimation = class(TSMESprite)
  private
    procedure AnimationSetTextureRect(const X, Y, W, H: Single);
 public
    { IHGEAnimation }
    procedure Play;
    procedure Stop;
    procedure Resume;
    procedure Update(const DeltaTime: Single);
    function  IsPlaying: Boolean;

    procedure SetTexture(const Tex: PSDL_Texture);
    procedure SetMode(const Mode: Integer);
    procedure SetSpeed(const FPS: Single);
    procedure SetFrame(const N: Integer);
    procedure SetFrames(const N: Integer);

    function GetMode: Integer;
    function GetSpeed: Single;
    function GetFrame: Integer;
    function GetFrames: Integer;
  private
    FOrigWidth: Integer;
    FPlaying: Boolean;
    FSpeed: Single;
    FSinceLastFrame: Single;
    FMode: Integer;
    FDelta: Integer;
    FFrames: Integer;
    FCurFrame: Integer;
  public
    constructor Create(const Texture: PSDL_Texture; const NFrames: Integer; const FPS: Single; const X, Y, W, H: Single); overload;

  end;


  TSMEFont = class
  protected
    { IHGEFont }

    function GetSprite(const Chr: Char): TSDL_Rect;
    function GetHeight: Single;
    function GetStringWidth(const S: String;const FirstLineOnly: Boolean = True): Single;

  private
  private
    FTexture: PSDL_Texture;
  //  FLetters: array [0..255] of TSMESprite;
    FClips  : array [0..255] of TSDL_Rect;
    FPre, FPost: array [0..255] of Single;
    FHeight, FScale, FProportion, FRot, FTracking, FSpacing, FZ: Single;
    FCol: Longword;
    FBlend: Integer;
           SkewX,
        SkewY:single;
    function GetLine(const FromFile, Line: PChar): PChar;
  public

    constructor Create(const Filename: String);overload;
    constructor Create(data:pointer;size:longword);overload;

    destructor Destroy;


    procedure Render(const X, Y: Single; const Algn: Integer; const S: String);
    procedure PrintF(const X, Y: Single; const Align: Integer;const Format: String; const Args: array of const);
    procedure PrintFB(const X, Y, W, H: Single; const Align: Integer;const Format: String; const Args: array of const);

    procedure SetSkew(const sX,sY: Single);

    procedure SetColor(const Col: Longword);
    procedure SetZ(const Z: Single);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetScale(const Scale: Single);
    procedure SetProportion(const Prop: Single);
    procedure SetRotation(const Rot: Single);
    procedure SetTracking(const Tracking: Single);
    procedure SetSpacing(const Spacing: Single);

    function GetColor: Longword;
    function GetZ: Single;
    function GetBlendMode: Integer;
    function GetScale: Single;
    function GetProportion: Single;
    function GetRotation: Single;
    function GetTracking: Single;
    function GetSpacing: Single;

  end;

   TSMEDistortionMesh= Class
  protected


    function GePSDL_Texture: PSDL_Texture;
    procedure GePSDL_TextureRect(out X, Y, W, H: Single);
    function GetBlendMode: Integer;
    function GetZ(const Col, Row: Integer): Single;
    function GetColor(const Col, Row: Integer): Longword;
    procedure GetDisplacement(const Col, Row: Integer; out DX, DY: Single;const Ref: Integer);

    function GetRows: Integer;
    function GetCols: Integer;

  private
    FDispArray:array of hgeVertex;
    FRows, FCols: Integer;
    FCellW, FCellH: Single;
    FTX, FTY, FWidth, FHeight: Single;
    FQuad: HGEQuad;
  public
    destructor Destroy; override;
    constructor Create(const Cols, Rows: Integer);

     procedure Render(const X, Y: Single);
    procedure Clear(const Col: Longword = $FFFFFFFF; const Z: Single = 0.5);

    procedure SetTexture(const Tex: PSDL_Texture);
    procedure SetTextureRect(const X, Y, W, H: Single);
    procedure SetBlendMode(const Blend: Integer);
    procedure SetZ(const Col, Row: Integer; const Z: Single);
    procedure SetColor(const Col, Row: Integer; const Color: Longword);
    procedure SetDisplacement(const Col, Row: Integer; const DX, DY: Single; const Ref: Integer);

  end;





  TSMEParticleSystemInfo = record

    Emission: Integer;
    Lifetime: Single;

    ParticleLifeMin: Single;
    ParticleLifeMax: Single;

    Direction: Single;
    Spread: Single;
    Relative: Boolean;

    SpeedMin: Single;
    SpeedMax: Single;

    GravityMin: Single;
    GravityMax: Single;

    RadialAccelMin: Single;
    RadialAccelMax: Single;

    TangentialAccelMin: Single;
    TangentialAccelMax: Single;

    SizeStart: Single;
    SizeEnd: Single;
    SizeVar: Single;

    SpinStart: Single;
    SpinEnd: Single;
    SpinVar: Single;

    ColorStart: HColor;
    ColorEnd: HColor;
    ColorVar: Single;
    AlphaVar: Single;
  end;
  PHGEParticleSystemInfo = ^TSMEParticleSystemInfo;


  TSMEParticleSystem = class
  protected
    { IHGEParticleSystem }
    function GetInfo: TSMEParticleSystemInfo;

    procedure Transpose(const X, Y: Single);
    function GetParticlesAlive: Integer;
    function GetAge: Single;
    procedure GetPosition(out X, Y: Single);
    procedure GetTransposition(out X, Y: Single);



  private
    fRegion:TSMERegion;
    FAge: Single;
    FEmissionResidue: Single;
    FPrevLocation: hVector;
    FLocation: hVector;
    FTX, FTY: Single;
    FParticlesAlive: Integer;
    spaw:integer;
    FParticles: array [0..MAX_PARTICLES - 1] of TSMEParticle;
  public
      FInfo: TSMEParticleSystemInfo;

    procedure Render;
    procedure FireAt(const X, Y: Single);
    procedure Fire;
    procedure Stop(const KillParticles: Boolean = False);
    procedure Update(const DeltaTime: Single);
    procedure MoveTo(const X, Y: Single; const MoveParticles: Boolean = False);

    constructor Create(data:pointer;size:longword); overload;
    constructor Create(const Filename: String;Region:TSMERegion); overload;
    constructor Create(const PSI: TSMEParticleSystemInfo); overload;
    procedure Save(const Filename: String);

    procedure setLifetime(value:single);

   published
   property ParticlesAlive:integer read FParticlesAlive;
   property Emission: Integer read FInfo.emission write FInfo.emission;
  end;



  TSMEParticleManager = class
  protected
    procedure Update(const DT: Single);
    procedure Render;

    function SpawnPS(const PSI: TSMEParticleSystemInfo;const X, Y: Single): TSMEParticleSystem;
    function IsPSAlive(const PS: TSMEParticleSystem): Boolean;
    procedure Transpose(const X, Y: Single);
    procedure GetTransposition(out DX, DY: Single);
    procedure KillPS(const PS: TSMEParticleSystem);
    procedure KillAll;
  private
    FNPS: Integer;
    FTX: Single;
    FTY: Single;
    FPSList: array [0..MAX_PSYSTEMS - 1] of TSMEParticleSystem;
  public
    destructor Destroy; override;
  end;

  TColorArgb=class
  public
  r,g,b,a:single;
  end;

  
//------------------------------------------------------------------------------
const
  MAX_PARTICLES_DEF = 5000;

  FORCE_KOEF: Single = 10.0;

  PI_2 = 1.57079632;

  PSS_EXT = '.pss';

//------------------------------------------------------------------------------
type
  TAnimType = (atNone, atForward, atBackward);

//------------------------------------------------------------------------------
  TXParticleSprite = record
    Pattern: integer;
    FrameEnd: integer;
    AnimType: TAnimType;
    DrawFx: cardinal;
  end;

//------------------------------------------------------------------------------
  PXParticle = ^TXParticle;
  TXParticle = record
    Frame,
    FrameDelta: Single;

    Location,
    Displacement: hVector; // From system position to particle spaw point

    Velocity: hVector;
    Gravity: Single;

    Accel,
    TangentialAccel: Single;

    Angle,
    AngleDelta: Single;

    Scale,
    ScaleDelta: Single;

    Color,
    ColorDelta: hColor;

    Age,
    MidAge,
    TerminalAge: Single;
  end;

    PXParticleSettings = ^TXParticleSettings;
  TXParticleSettings = record
    Sprite: TXParticleSprite; // Particle texture settings
    EmissionRate: integer; // Particles per second
    LifeTime: Single;

    ParticleLifeMin,
    ParticleLifeMax: Single;

    Direction,
    Spread: Single;
    Relative: boolean;

    VelMin,
    VelMax: Single;

    GravityMin,
    GravityMax: Single;

    AccelMin,
    AccelMax: Single;

    TangentialAccelMin,
    TangentialAccelMax: Single;

    ScaleStart,
    ScaleMid,
    ScaleEnd,
    ScaleRnd: Single;

    SpinStart,
    SpinMid,
    SpinEnd,
    SpinRnd: Single;

    ColorStart,
    ColorMid,
    ColorEnd: Cardinal;
    ColorRnd,
    AlphaRnd: Single;

    // "Middle" of particle LifeTime (in %)
    Middle: Single;
    InverseRender: Boolean;
  end;
  
//------------------------------------------------------------------------------
  TEmitters = array of TPoint;

//------------------------------------------------------------------------------
  TEmittersFileHeader = record
    Count: Cardinal;
  end;

//------------------------------------------------------------------------------
  TXParticleSystem = class
  private
    FTexture: PSDL_Texture;

    FParticles: array of TXParticle;
    FCapacity: Integer;
    FSettings: TXParticleSettings;
    FEmitters: TEmitters;
    FUpdSpeed,
    FResidue: Single;
    FAge,
    FEmissionResidue: Single;
    FPosition,FPrevLocation: hvector;
    FAngle: Single;
    FParticlesAlive: integer;

    procedure SetCapacity(Value: Integer);
  protected
    procedure UpdateSys(DeltaTime: Single);
    procedure RenderParticle( Tex: PSDL_Texture; X, Y, Angle, Scale, Pattern: Single; Color: hColor; DrawFx: Cardinal);

  public
    constructor Create(Tex: PSDL_Texture;Capacity_: Integer = MAX_PARTICLES_DEF);
    destructor Destroy(); override;

    procedure Render( dx: Integer = 0; dy: Integer = 0);
    procedure Update(const DeltaTime: Single);

    function Load(const PSS: TXParticleSettings): boolean;
    function LoadFromStream(Stream: TStream): boolean;
    function SaveToStream(Stream: TStream): boolean;
    function LoadFromFile(const FileName: string): boolean;
    procedure NullSettings();

    procedure StartAt(x,y:single);
    procedure Start();
    procedure Stop(KillParticles: boolean = false);
    procedure Move(x,y:single; MoveParticles: boolean = false);
    procedure MoveTo(x,y:single; MoveParticles: boolean = false);

    procedure AddParticle(x, y: integer);

    // Return the ID of new emitter
    function EmitterAdd(const NewEmitter: TPoint): integer;

    procedure EmittersAdd(const NewEmitters: array of TPoint);
    procedure EmittersAddFromImage(Image: PSDL_Surface; Color: Cardinal);
    procedure EmittersSaveToFile(const FileName: string);
    function EmittersLoadFromFile(const FileName: string): boolean;

    procedure RemoveEmitter(Index: Integer);
    procedure RemoveAllEmitters();
    procedure ScaleEmitters(Scale: Single);

    property Capacity: Integer read FCapacity write SetCapacity;
    property Texture: PSDL_Texture read FTexture write FTexture;
    property Emitters: TEmitters read FEmitters;
    property Settings: TXParticleSettings read FSettings write FSettings;
    property ParticlesAlive: integer read FParticlesAlive;
    property Age: Single read FAge;
    property Angle: Single read FAngle write FAngle;
  end;

//------------------------------------------------------------------------------
  TXParticleManager = class
  private

    FTexture: PSDL_Texture;

    FSysCount: integer;

    // Alive particle systems
    FSystems: array[0..MAX_PSYSTEMS - 1] of TXParticleSystem;
    // Settings list
    FSettings: array of TXParticleSettings;
    FNameList: array of ShortString;

    function GetSystem(Index: Integer): TXParticleSystem;
    function GetSettings(Index: Integer): PXParticleSettings;
    function GetSettingsCount(): integer;
    function GetParticlesAlive(): integer;
  public
    constructor Create();
    destructor Destroy(); override;

    // in sec
    procedure Update(const DeltaTime: Single);
    procedure Render(dx: integer = 0; dy: integer = 0);

    function Add(const PSS: TXParticleSettings; const Name: string): integer;

    // Return settings Index by Name
    function IndexOf(Name: string): integer;

    function Launch(Index: Integer; x,y:single): TXParticleSystem; overload;
    function Launch(const Name: string; x,y:single): TXParticleSystem; overload;
    function LaunchEx(const PSS: TXParticleSettings;pTexture: PSDL_Texture; x,y:single): TXParticleSystem;

    procedure StopAll();

    function IsPSAlive(PS: TXParticleSystem): boolean;
    
    procedure KillPS(PS: TXParticleSystem);
    procedure KillAll();

    property Systems[Index: Integer]: TXParticleSystem read GetSystem;
    property Settings[Index: Integer]: PXParticleSettings read GetSettings;
    property SystemCount: Integer read FSysCount;
    property SettingsCount: Integer read GetSettingsCount;
    property ParticlesAlive: Integer read GetParticlesAlive;
  published

  end;

//------------------------------------------------------------------------------
var
  RRSeed: integer = 0;

//------------------------------------------------------------------------------
function RandomSingle(const Min, Max: Single): Single;

type

   TSMERegionList = class( TList )
  protected
    function Get( Index : Integer ) : TSMERegion;
    procedure Put( Index : Integer; Item : TSMERegion );
  public
    property Items[ Index : Integer ] : TSMERegion read Get write Put; default;

    procedure Del(Idx: Integer);
    procedure Clear; override;

    function Add(obj: TSMERegion): TSMERegion;

    function Exists(name:string):boolean;
    function GetContains(Name: String): Boolean;
    function IndexOf(Item: TSMERegion): Integer; overload;
    function IndexOf(const Name: String): Integer;     overload;
    function Find   (const Name: string): TSMERegion;

     destructor Destroy();

  end;


  TSMESpriteSheet=class
  private
   regions:TSMERegionList;
   texture:PSDL_Texture;
     matrix:TSMEMatrix;
   public
   constructor Create();
   destructor Destory();

   function addRegion(region:TSMERegion):integer;

   procedure load(fname:string);



   function get(index:integer):TSMERegion; overload;
   function get(serch:string):TSMERegion;overload;

   function getList(name:string):TSMERegionList;

   procedure splite(tileWidth,tileHeight:integer);

   function getImage:PSDL_Texture;

   procedure draw(
        graph:integer;
        x,y,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);


   function count:integer;

  end;

      TSMEModel=class;


TSMEModelList = class( TList )
  protected
    function Get( Index : Integer ) : TSMEModel;
    procedure Put( Index : Integer; Item : TSMEModel );
  public
    property Items[ Index : Integer ] : TSMEModel read Get write Put; default;

    procedure Del(Idx: Integer);
    procedure Clear; override;

    function Add(obj: TSMEModel): TSMEModel;

    function Exists(name:string):boolean;
    function GetContains(Name: String): Boolean;
    function IndexOf(Item: TSMEModel): Integer; overload;
    function IndexOf(const Name: String): Integer;     overload;
    function Find   (const Name: string): TSMEModel;
    destructor Destroy();

  end;

TSMECamera=class
private
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    ftarget:TSMEModel;

public
x,y,zoom:single;
   bound:TSMERect;
constructor Create(width,heigth:integer;worldWidth,worldHeigth:single);
procedure setFollow(target:TSMEModel);

procedure setWorldBound(minx,miny,maxx,maxy:single);
procedure setView(screenWidth,screenHeight:integer);

procedure Update();
end;


TSMEModel=class
protected
  AbsoluteTransformation, Fmatrix:TSMEMatrix;
  FParent:TSMEModel;
  sx,sy,cx,cy:single;

 procedure updateAbsolutePosition();

 function getX:single;
 function getY:single;


public
      Visible:boolean;
  Alive:boolean;
  Active:boolean;
  Remove:Boolean;
  Layer:integer;
  camera:TSMECamera;

      fchilds:TSMEModelList;
       Name:string;
         Bound:TSMERect;
        x,y:single;
        PivotX,
        PivotY:single;
        offsetx,offsety:single;
        width,
        height,
        ScaleX,
        ScaleY,
        scrollX,
        scrollY,
        Rotation,
        SkewX,
        SkewY:single;

constructor Create();
destructor Destroy();

procedure OnCreate();virtual;
procedure OnRemove();virtual;




 function getRelativeTransformation:TSMEMatrix;
 function getAbsoluteTransformation:TSMEMatrix;

procedure setCamera(  _camera:TSMECamera);

procedure Draw;virtual;
procedure Update(dt:single);virtual;

procedure addChild(child:TSMEModel;parentToState:boolean=true);
procedure removeChild(Entity:TSMEModel);
procedure setParent(parent:TSMEModel);

end;

TTexture=class
public
texture:PSDL_texture;
name:string;
end;



   TSMETextureList = class(TList)
  protected
   function  Get(Index: Integer): TTexture;
   procedure Put(Index: Integer; Item:TTexture);
   function IndexOf(Item: TTexture): Integer; overload;

  public

    destructor Destroy;override;
    constructor Create;
    procedure BindTexture(Name : String ); overload;
    procedure BindTexture(Index: Integer); overload;
    procedure EnableTexturing;
    procedure DisableTexturing;
    procedure Del(Idx: Integer);
    procedure Clear; override;
    function Add(Obj: TTexture): TTexture;
    function LoadTexture(fname:string):PSDL_texture;

    function Exists(name:string):boolean;
    function GetContains(Name: String): Boolean;
    function IndexOf(const Name: String): Integer;     overload;
    function Find   (const Name: string): PSDL_texture;
    property Items[Index: Integer]: TTexture read Get write Put; default;
  end;

  
 type

  PDParticle=class
        colorArgb:TColorArgb;
        colorArgbDelta:TColorArgb;
        startX:Single;
         startY:Single;
        velocityX:Single;
         velocityY:Single;
        radialAcceleration:Single;
        tangentialAcceleration:Single;
        emitRadius:Single;
         emitRadiusDelta:Single;
        emitRotation:Single;
         emitRotationDelta:Single;
        rotationDelta:Single;
        scaleDelta:Single;
           x:Single;
        y:Single;
        scale:Single;
        rotation:Single;
        color:dword;
        alpha:Single;
        currentTime:Single;
        totalTime:Single;
   constructor Create();
   procedure draw(texture:PSDL_Texture);
  end;


const
 EMITTER_TYPE_GRAVITY = 0;
 EMITTER_TYPE_RADIAL  = 1;
 PATICLESPRIMITIVES=500;


        type
  TSMEEmitter=class(TSMEModel)
  private
   texture:PSDL_Texture;
         mEmitterX:Single;
         mEmitterY:Single;

         mParticles:TList;

            Vertices:array[0..PATICLESPRIMITIVES * 4 - 1] of HGEVertex;
            numPrims :integer;
           invTexWidth,invTexHeight:single;


         mNumParticles:integer;
         mMaxCapacity:integer;
         mEmissionRate:Single; // emitted particles per second
         mEmissionTime:Single;

         mFrameTime:single;
       // emitter configuration                            // .pex element name
         mEmitterType:Integer;                // emitterType
         mEmitterXVariance:Single;               // sourcePositionVariance x
         mEmitterYVariance:Single;               // sourcePositionVariance y

        // particle configuration
         mMaxNumParticles:Integer;                   // maxParticles
         mLifespan:Single;                       // particleLifeSpan
         mLifespanVariance:Single;               // particleLifeSpanVariance
         mStartSize:Single;                      // startParticleSize
         mStartSizeVariance:Single;              // startParticleSizeVariance
         mEndSize:Single;                        // finishParticleSize
         mEndSizeVariance:Single;                // finishParticleSizeVariance
         mEmitAngle:Single;                      // angle
         mEmitAngleVariance:Single;              // angleVariance
         mStartRotation:Single;                  // rotationStart
         mStartRotationVariance:Single;          // rotationStartVariance
         mEndRotation:Single;                    // rotationEnd
         mEndRotationVariance:Single;            // rotationEndVariance
        
        // gravity configuration
         mSpeed:Single;                          // speed
         mSpeedVariance:Single;                  // speedVariance
         mGravityX:Single;                       // gravity x
         mGravityY:Single;                       // gravity y
         mRadialAcceleration:Single;             // radialAcceleration
         mRadialAccelerationVariance:Single;     // radialAccelerationVariance
         mTangentialAcceleration:Single;         // tangentialAcceleration
         mTangentialAccelerationVariance:Single; // tangentialAccelerationVariance
        
        // radial configuration 
         mMaxRadius:Single;                      // maxRadius
         mMaxRadiusVariance:Single;              // maxRadiusVariance
         mMinRadius:Single;                      // minRadius
         mRotatePerSecond:Single;                // rotatePerSecond
         mRotatePerSecondVariance:Single;        // rotatePerSecondVariance

        // color configuration
         mStartColor:TColorArgb;                  // startColor
         mStartColorVariance:TColorArgb;          // startColorVariance
         mEndColor:TColorArgb;                    // finishColor
         mEndColorVariance:TColorArgb;            // finishColorVariance
         procedure  initParticle(Particle:PDParticle);
         procedure  advanceParticle(Particle:PDParticle; passedTime:Single);
         procedure  raiseCapacity(byAmount:integer);
        procedure updateEmissionRate();
        procedure setmaxNumParticles(value:integer);
        procedure draw(particle:PDParticle);
        procedure  drawParticle (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;  srcX,  srcY,  srcWidth,  srcHeight:integer; flipX,flipY:boolean;color:Uint32);

  public

        constructor Create (fname:string);
        destructor Destory();
        procedure  RenderCloud(passedTime:Single);
        procedure  RenderBatch(passedTime:Single);
        procedure stop(clearParticles:Boolean);

        procedure  start(duration:single);

        procedure moveTo(x,y:single);

  end;



TSMEGroup=class
protected
 fchilds:TSMEModelList;
   NeedSort:boolean;

   procedure Sort;
public

constructor Create;
destructor Destroy;

procedure Update(dt:single);virtual;
procedure Draw;

procedure add(md:TSMEModel;parentToState:boolean=false);
procedure remove(md:TSMEModel);


end;

TSMEGame=class;
TSMEEntity=class;

TSMEState=class(TSMEGroup)
protected
game:TSMEGame;
public
procedure Render();virtual;
procedure startState;virtual;
procedure endState();virtual;
procedure separeteEntitys();
procedure onColide(a,b:TSMEEntity);virtual;
end;




TSMEGame=class
private
     frequestedState,fstate:TSMEState;
     requestedReset:boolean;

     procedure requestNewState(newState:TSMEState);
     procedure switchState();
     procedure resetGame();
protected

public



constructor Create(width,heigth:integer;world_width,worldheigth:single;gameState:TSMEState);
procedure Destroy();
procedure setState(state:TSMEState);

procedure Update(dt:single);
procedure Render();

procedure UpdateGame();virtual;
procedure LoadGame();virtual;
procedure EndGame();virtual;
end;

TAnimPlayMode = (pmForward, pmBackward, pmPingPong);


TSMEEntity=class(TSMEModel)
protected
  texture:PSDL_Texture;
  clipping:TSDL_Rect;
  region:TSMERegion;
  Color:dword;
  blend:integer;
   FQuad: hgeQuad;

  //bound
    originX,originY:single;
     originWidth,originHeight:single;
     colider:boolean;

//  fisica

      FDoAnimate: Boolean;
      FAnimLooped: Boolean;
      FAnimStart: Integer;
      FAnimCount: Integer;
      FAnimSpeed: Single;
      FAnimPos: Single;
      FAnimEnded: Boolean;
      FDoFlag1, FDoFlag2: Boolean;
      FAnimPlayMode: TAnimPlayMode;
      FPatternIndex:integer;

     procedure Animate(const MoveCount: Single);
public
     mass:single;
     name:string;

     last,velocity:Point;
		 elasticity:single;
		 center,pvelocity,previous,acceleration:Point;
		 drag:Point;
		 maxVelocity:Point;
		 angle:single;
		 angularVelocity:single;
		 angularAcceleration:single;
		 angularDrag:single;
		 maxAngular:single;
     onFloor:boolean;
     fixed,moves:boolean;
     touching:integer;
     wasTouching:integer;
     flipX,flipY:boolean;
     immovable:boolean;
     id:integer;


procedure Draw();override;


    procedure OnAnimStart; virtual;
    procedure OnAnimEnd; virtual;
   procedure SetAnim( AniStart, AniCount: Integer; AniSpeed: Single; AniLooped: Boolean;  PlayMode: TAnimPlayMode=pmForward);


procedure OnColide(other:TSMEEntity);virtual;

function Colide(newx,newy:single;e:TSMEEntity):boolean;
procedure setHitbox(newwidth,newheight:integer;neworiginX:integer = 0;neworiginY:integer = 0);

procedure Update(dt:single);override;
constructor Create(x,y,w,h:integer); overload;
constructor Create(region:TSMERegion);overload;
procedure setRegion(reg:TSMERegion;setorigin:boolean=false);

procedure SetMirror(MirrorX, MirrorY: Boolean);


   function separate(Object2:TSMEEntity):Boolean;
   function Bounce( Object2:TSMEEntity):Boolean;

    function  isTouching(Direction:integer):boolean;
    function  justTouched( Direction:integer):Boolean;

    procedure Motion(dt:single);
    procedure Reset();


  procedure hitTop(v:single);virtual;
  procedure hitBottom(v:single);virtual;
  procedure hitLeft(v:single);virtual;
  procedure hitRight(v:single);virtual;



end;

TMapObject=class
public
x,y,w,h:integer;
name:string;
end;

const
TILESPRIMITIVES=500;

type

 TSMETileMap = class(TSMEModel)
 private
      FCollisionMap: array of boolean;
      FMap: array of integer;
      MapObject:Tlist;
      FMapW:Integer;
      FMapH: Integer;
      FMapWidth: Integer;
      FMapHeight: Integer;
      FDoTile: Boolean;
      Ftexture:PSDL_Texture;
//      FClips:array of TSDL_Rect;
      ColCount,FCountTiles:integer;
      OfsX, OfsY:integer;
      last,velocity:Point;
     frameWidth,FrameHeight:integer;
     Vertices:array[0..TILESPRIMITIVES * 4 - 1] of HGEVertex;
     invTexWidth,invTexHeight:single;
     numPrims :integer;
   
      procedure SetMapHeight(Value: Integer);
      procedure SetMapWidth(Value: Integer);
      procedure drawTile(  px,  py:single;clip:TSDL_Rect;color:Uint32) ;

 protected

 public
      constructor Create(  texture:PSDL_Texture;frameWidth,FrameHeight,MapWidth,MapHeight:integer);overload;
      constructor Create(  fname:string);overload;

      destructor Destroy;
      procedure renderCloud;
      procedure RenderBatch;


      function numObjs:integer;
      function getOBJ(index:integer):TMapObject;

      procedure addOBJ(name:string;ox,oy,ow,oh:integer);

      function GetCollisionMapItem(X, Y: Integer): Boolean;
      function GetCell(X, Y: Integer): Integer;
      procedure SetCell(X, Y: Integer; Value: Integer);
      procedure SetCollisionMapItem(X, Y: Integer; Value: Boolean);

      function getClip(frame:integer):TSDL_Rect;
      function GetBoundsRect: TSDL_Rect;

      function TestCollision(Sprite: TSMEEntity): Boolean;

      function place_meeting(posx,posy:single;Sprite: TSMEEntity): Boolean;
      function colide(Sprite: TSMEEntity): Boolean;

      function Collision(Sprite: TSMEEntity;out bound:TSDL_Rect): Boolean;

      procedure Bounce(entity:TSMEEntity);

      procedure SetMapSize(AMapWidth, AMapHeight: Integer);
      property Cells[X, Y: Integer]: Integer read GetCell write SetCell;
      property CollisionMap[X, Y: Integer]: Boolean read GetCollisionMapItem write SetCollisionMapItem;
      property MapHeight: Integer read FMapHeight write SetMapHeight;
      property MapWidth: Integer read FMapWidth write SetMapWidth;
      property DoTile: Boolean read FDoTile write FDoTile;
 end;


TSMEImage=class
private
  matrix:TSMEMatrix;
  texture:PSDL_Texture;
  clipping:TSDL_Rect;
  region:TSMERegion;

public
        parent:TSMEImage;
        x,y:single;
        PivotX,
        PivotY:single;
        width,
        height,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;
        Color:dword;
        blend:integer;
        name:string;
Constructor Create(region:TSMERegion);
procedure setRegion(reg:TSMERegion;setorigin:boolean=false);
procedure Render();

end;


const
CLOUDPRIMITIVES=500;
type

  TSMECloud = class
  private
     fspriteSheet:TSMESpriteSheet;
     Vertices:array[0..CLOUDPRIMITIVES * 4 - 1] of HGEVertex;
     invTexWidth,invTexHeight:single;
     numPrims :integer;
     buffer: PHGEVertexArray;
  protected



  public
     constructor Create(spriteSheet:string);
     destructor Destroy;

     procedure BeginRender(blend:integer);
     procedure EndRender();

     procedure draw (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;r:tsdl_rect; flipX,flipY:boolean;color:Uint32);overload;
     procedure draw (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;  srcX,  srcY,  srcWidth,  srcHeight:integer; flipX,flipY:boolean;color:Uint32);overload;
     procedure draw(  x,  y,  width,  height:single;srcX, srcY, srcWidth, srcHeight:single; flipX, flipY:boolean;color:Uint32);overload;
     procedure draw(  x,  y,  width,  height:single;r:TSDL_Rect; flipX, flipY:boolean;color:Uint32) ;overload;
     procedure draw(  x,  y,  width,  height:single;r:TSDL_Rect;color:Uint32) ;overload;
     procedure draw(  x,  y,width,height:single;color:Uint32) ;overload;

  end;

  
{@exclude}
Const MAX_VERTICES = 2000;



  type

  Vector2f= record
  x,y:single
  end;
  Vector3f= record
  x,y,z:single
  end;

  Color4f=record
  r,g,b,a:single;
  end;

TSMEShapeRender=class
private
   index:integer;
    Vertices  : array of Vector3f;
    Colors    : array of Color4f;
    countvertex:integer;
	 idxCols,idxPos, maxVertices, numVertices:integer;
    primitiveType:cardinal;

 procedure SetMaxVertices(count:integer);


public

    procedure BeginBatch(primitive: Cardinal);
    procedure EndBatch;

    procedure Render(count:integer;Mode: Cardinal);
    constructor Create(maxSprites:integer);
    Destructor Destroy;

    procedure  color (r,g,b,a:single);
    procedure vertex (x,y,z:single);

end;





      procedure DrawImage(texture:PSDL_Texture;
        x,y,
        Width,Height,
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;

procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        Dst,clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;


procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;

        
procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;Color:dword;blend:integer);overload;

procedure DrawImage(texture:PSDL_Texture;
        x,y,
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;
    function Resource_Load(const Filename: String;out data:pointer; var Size: integer):boolean;

    function separateoBJECT(Object1:TSMEEntity; Object2:TSMEEntity;gamestate:TSMEState):Boolean;


procedure smeTerminate(msg:string);

function Random_Float(const Min, Max: Single): Single;
function Random_Int(const Min, Max: Integer): Integer;
procedure Random_Seed(const Seed: Integer);



function Timer_GetFPS: Integer;
function Timer_GetTime: Single;
function TimerUpdate: Boolean;


///globals
var
GameCamera:TSMECamera;
images:TSMETextureList;
font:TSMEFont;


   realw,realh:integer;
   winw,winh:integer;
   window:PSDL_Window;
   glcontext:TSDL_GLContext;
   mousex,mousey:single;
   lastmousex,lastmousey:single;

   toutch:boolean=false;
   lGame:boolean;


    GSeed,FPSCount,lastFPSCount : Integer;            // Counter for FPS
     _ms_prev,_last,_time,_gameTime:integer;
     passedTime, elapsed,rate,maxElapsed:single;


     globalmatrix:TSMEMatrix;


implementation
uses
SDLUtils;




procedure smeTerminate(msg:string);
begin
SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SME Fail!',pchar(msg),window);
lGame:=false;
end;


function Timer_GetDelta: Single;
begin
  Result := elapsed;
end;

function Timer_GetFPS: Integer;
begin
 Result :=maxi( lastFPSCount,FPSCount);
end;

function Timer_GetTime: Single;
begin
  Result := elapsed;
end;
function TimerUpdate: Boolean;
var
    finished : Boolean;
begin
      _time := smeGetTicks();
			 elapsed := (_time - _last) / 1000;
			if (elapsed > maxElapsed) then elapsed := maxElapsed;
			elapsed :=elapsed* rate;
			_last := _time;
      inc(FPSCount);
			if( _time - 1000 > _ms_prev ) then
      begin
      _ms_prev := _time;
      lastFPSCount:=FPSCount;
      FPSCount:=0;
      end;
  Result := True;
end;
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





procedure Rectangle.setBound(setx,sety,setw,seth:single);
begin
self.x:=setx;
self.y:=sety;
self.Width:=setw;
self.Height:=seth;
end;

function Rectangle.contains(inX,inY:single):boolean;
begin
result:= (self.x < inX) and (self.x + self.width > inX) and (self.y < inY) and (self.y + self.height > inY);
end;
function Rectangle.contains(r:Rectangle):boolean;
var
xmin,xmax,ymin,ymax:single;
begin
 xmin := r.x;
 xmax := xmin + r.width;
 ymin := r.y;
 ymax := ymin + r.height;

result:=  (xmin > self.x) and (xmin < self.x + self.width) and (xmax > self.x) and (xmax < self.x + self.width)
			and (ymin > self.y) and (ymin < self.y + self.height) and (ymax > self.y) and (ymax < self.y + self.height);
end;
function Rectangle.intersection(toIntersect:Rectangle):Rectangle ;
var
x1,y1,x2,y2:single;
return:Rectangle;
begin
x1 :=maxs(x, toIntersect.x);
y1 :=maxs(y, toIntersect.y);
x2 :=mins(x+width, toIntersect.x+toIntersect.Width);
y2 :=mins(y+Height,toIntersect.y+toIntersect.Height);
return.setBound(x1,y1,(x2-x1),(y2-y1));
result:=return;
end;



procedure Gfx_RenderRect( x,  y,  width,  height:single;r,g,b:single;depth:single);
begin

		smeRenderLine(x,y,x+width,y,COLOR_ARGB(1,r,g,b),depth);
		smeRenderLine(x+width,y,x+width,y+height,COLOR_ARGB(1,r,g,b),depth);
		smeRenderLine(x+width,y+height,x,y+height,COLOR_ARGB(1,r,g,b),depth);
		smeRenderLine(x,y+height,x,y,COLOR_ARGB(1,r,g,b),depth);
end;

procedure Gfx_RenderSDLRect(bound:TSDL_rect;r,g,b:single);
begin
  Gfx_RenderRect(bound.x,bound.y,bound.w,bound.h,r,g,b,0);

end;

procedure Rectangle.draw(r,g,b:single;z:single=0.0);
begin
  Gfx_RenderRect(x,y,Width,Height,r,g,b,z);
end;
function Rectangle.Overlap(other:Rectangle):Boolean;
begin
Result:= (self.x< other.Width)and(self.Width > other.x) and
         (self.y < other.Height)and(self.Height > other.y);
end;

function Rectangle.intersects(other:Rectangle):Boolean;
begin
// Result:= (self.x >= toIntersect.x)and(self.width <= toIntersect.width)and
//  (self.y >= toIntersect.y)and(self.Height <= toIntersect.Height);

if ((self.x > (other.x + other.width)) and ((self.x + width) < other.x))  then
begin
		result:=false;
    exit;
end;
		if ((self.y > (other.y + other.height)) and ((self.y + height) < other.y))  then
    begin
			result:=false;
      exit;
		end;

    result:=true;


end;



function computeVelocity(dt,Velocity:single; Acceleration:single=0; Drag:Single=0; Max:Single=10000):single;
var
_drag:single;
begin

			if(Acceleration <> 0) then
				Velocity :=	Velocity+ Acceleration*dt
			else if(Drag <> 0) then
      begin
				_drag:= Drag*dt;
				if(Velocity - _drag > 0) then
					Velocity := Velocity - _drag
				else if(Velocity + _drag < 0) then
					Velocity :=Velocity+ _drag
				else
					Velocity := 0;
			end;
			if((Velocity <> 0) and (Max <> 10000)) then
			begin
				if(Velocity > Max) then	Velocity := Max
				else if(Velocity < -Max) then	Velocity := -Max;
			end;
			result:= Velocity;
end;
//*************************************************************************************************
 function calculateVelocity(velocity, acceleration, drag, terminal,dt:single):single;
 var
 dragEffect:single;
 begin
			if (acceleration <> 0) then
      begin
				velocity :=velocity+ acceleration * dt;
			end else
      begin
				 dragEffect:= drag * dt;
				if (velocity - dragEffect > 0) then
					velocity :=velocity- dragEffect
				 else if (velocity + dragEffect < 0) then
					velocity :=velocity+ dragEffect
				 else
					velocity := 0;

			end;
			
			if (velocity > terminal) then
				velocity := terminal
			 else if (velocity < -terminal) then
				velocity := -terminal;


		result:=velocity;
end;

         {
 function calculateVelocity(velocity, acceleration, drag, terminal,dt:single):single;
 var
 dragEffect:single;
 begin
			if (acceleration <> 0.0) then
      begin
				velocity :=velocity+ acceleration * dt;
			end else
       begin
	   		  dragEffect:= drag * dt;
			  	if (velocity - dragEffect > 0) then
				 	velocity :=velocity- dragEffect
				  else if (velocity + dragEffect < 0) then
					 velocity :=velocity+ dragEffect
				  else
					 velocity := 0;
				end;

			
			if (velocity > terminal) then
				velocity := terminal
			 else if (velocity < -terminal) then
				velocity := -terminal;


		result:= velocity;
end;

//*************************************************************************************************
function solveXCollision(source:TSMEEntity;target:TSMEEntity):Boolean;
var
overlap,sfx,tfx:single;
sourceAxisFrame,targetAxisFrame:Rectangle;
begin

			 sfx:= source.x - source.previous.x;
			 tfx:= target.x - target.previous.x;

       if (source.x>source.previous.x) then sourceAxisFrame.x:= source.previous.x else   sourceAxisFrame.x:=source.x;
			sourceAxisFrame.y := source.previous.y;
			sourceAxisFrame.width := source.width + abs(sfx);
			sourceAxisFrame.height := source.height;

      if (target.x > target.previous.x) then targetAxisFrame.x:=target.previous.x  else targetAxisFrame.x:=target.x;
			targetAxisFrame.y := target.previous.y;
			targetAxisFrame.width := target.width + abs(tfx);
			targetAxisFrame.height := target.height;

      overlap:= 0;
		 //	if ((sourceAxisFrame.x + sourceAxisFrame.width - EPSILON > targetAxisFrame.x) and (sourceAxisFrame.x + EPSILON < targetAxisFrame.x + targetAxisFrame.width) and (sourceAxisFrame.y + sourceAxisFrame.height - EPSILON > targetAxisFrame.y) and (sourceAxisFrame.y + EPSILON < targetAxisFrame.y + targetAxisFrame.height)) then
     if source.Bound.Intersect(target.Bound) then
      begin
				if (sfx > tfx) then
        begin
					overlap := source.x + source.width - target.x;
					//source.touching |= AxEntity.RIGHT;
					//target.touching |= AxEntity.LEFT;
				end;
				if (sfx < tfx) then
        begin
					overlap := source.x - target.width - target.x;
					//target.touching |= AxEntity.RIGHT;
					//source.touching |= AxEntity.LEFT;
				end;
			end;

			if (overlap <> 0) then
      begin
				source.x :=source.x- overlap;
				source.velocity.x := 0;
				target.velocity.x := 0;
				result:=true;
        exit;
			end;

result:=false;
end;
function solveYCollision(source:TSMEEntity;target:TSMEEntity):Boolean;
var
overlap,sfy,tfy:single;
sourceAxisFrame,targetAxisFrame:Rectangle;
begin

			 sfy:= source.y - source.previous.y;
			 tfy:= target.y - target.previous.y;

			sourceAxisFrame.x := source.x;
      if (source.y>source.previous.y) then sourceAxisFrame.y:= source.previous.y else   sourceAxisFrame.y:=source.y;
			sourceAxisFrame.width := source.width;
			sourceAxisFrame.height := source.height + abs(sfy);

			targetAxisFrame.x := target.x;
      if (target.y > target.previous.y) then targetAxisFrame.y:=target.previous.y  else targetAxisFrame.y:=target.y;
			targetAxisFrame.width := target.width;
			targetAxisFrame.height := target.height + abs(tfy);

			overlap:= 0;
//			if ((sourceAxisFrame.x + sourceAxisFrame.width - EPSILON > targetAxisFrame.x) and (sourceAxisFrame.x + EPSILON < targetAxisFrame.x + targetAxisFrame.width) and (sourceAxisFrame.y + sourceAxisFrame.height - EPSILON > targetAxisFrame.y) and (sourceAxisFrame.y + EPSILON < targetAxisFrame.y + targetAxisFrame.height)) then
     if source.Bound.Intersect(target.Bound) then
      begin
				if (sfy > tfy) then
        begin
					overlap := source.y + source.height - target.y;
				 //	source.touching |= AxEntity.DOWN;
				 //	target.touching |= AxEntity.UP;
         source.hitBottom(overlap);
         target.hitTop(overlap);

				end;
				if (sfy < tfy) then
        begin
					overlap := source.y - target.height - target.y;

          		  	target.hitBottom(overlap);
					        source.hitTop(overlap);

				 //	target.touching |= AxEntity.DOWN;
				 //	source.touching |= AxEntity.UP;
				end
			end;

			if (overlap <> 0.0) then
      begin
				source.y :=source.y- overlap;
				source.velocity.y := 0;
				target.velocity.y := 0;
				result:= true;
        exit;
			end;

result:=false;
end;
}
//*************************************************************************************************
function separateX(Object1:TSMEEntity;Object2:TSMEEntity;gamestate:TSMEState):Boolean ;
var
obj1immovable,obj2immovable:boolean;
overlap,obj1delta,obj2delta:single;
obj1deltaAbs,obj2deltaAbs:single;
obj1rect,obj2rect:Rectangle;
maxOverlap:single;
obj1v,obj2v:single;
obj1velocity,obj2velocity,average:single;
dir1,dir2:integer;
begin

			//can't separate two immovable objects
			 obj1immovable:= Object1.immovable;
			 obj2immovable:= Object2.immovable;
			if(obj1immovable and obj2immovable) then
      begin
      result:=false;
      exit;
      end;


			//First, get the two object deltas
			 overlap:= 0;
			 obj1delta:= Object1.x - Object1.last.x;
			 obj2delta:= Object2.x - Object2.last.x;

			if(obj1delta <> obj2delta) then
			begin
				//Check if the X hulls actually overlap
				 if (obj1delta > 0) then obj1deltaAbs:=obj1delta else obj1deltaAbs:=-obj1delta;
         if (obj2delta > 0) then obj2deltaAbs:=obj2delta else obj2deltaAbs:=-obj2delta;


         if (obj1delta>0) then
         obj1rect.x:=Object1.x-obj1delta else obj1rect.x:=Object1.x;
         if (obj1delta>0) then
         obj1rect.Width:=Object1.originWidth+obj1delta else obj1rect.Width:=Object1.originWidth-obj1delta;
        obj1rect.y:=Object1.last.y;
         obj1rect.Height:=Object1.originHeight;


         if (obj2delta>0) then
         obj2rect.x:=Object2.x-obj2delta else obj2rect.x:=Object2.x;
         if (obj2delta>0) then
         obj2rect.Width:=Object2.originWidth+obj2delta else obj2rect.Width:=Object2.originWidth-obj2delta;
        obj2rect.y:=Object2.last.y;
         obj2rect.Height:=Object2.originHeight;


				if((obj1rect.x + obj1rect.width > obj2rect.x)
        and (obj1rect.x < obj2rect.x + obj2rect.width)
        and (obj1rect.y + obj1rect.height > obj2rect.y)
        and (obj1rect.y < obj2rect.y + obj2rect.height)) then
      begin
					 maxOverlap:= obj1deltaAbs + obj2deltaAbs + 4;

					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta) then
					begin
						overlap := Object1.x + Object1.originWidth - Object2.x;
						if(overlap > maxOverlap) then
           		overlap := 0 else
              begin
              Object1.OnColide(Object2);
              Object2.OnColide(Object1);
         			Object1.hitRight(overlap);
							Object2.hitLeft(overlap);
              if assigned(gamestate) then gamestate.onColide(Object1,Object2);

              Object1.touching:=Object1.touching or Right;
              Object2.touching:=Object2.touching or Left;

             end;
					end
					else if(obj1delta < obj2delta) then
					begin
						overlap := Object1.x - Object2.originWidth - Object2.x;
						if(-overlap > maxOverlap) then

							overlap := 0 else
              begin
							Object2.hitRight(overlap);
    					Object1.hitLeft(overlap);
              Object1.OnColide(Object2);
              Object2.OnColide(Object1);
              Object2.touching:=Object2.touching or RIGHT;
              Object1.touching:=Object1.touching or LEFT;
              if assigned(gamestate) then gamestate.onColide(Object2,Object1);
   				   end;
				end;
			end;
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap <> 0) then
      begin

				 obj1v:= Object1.velocity.x;
				 obj2v:= Object2.velocity.x;

				if(not obj1immovable) and (not obj2immovable) then
				begin
					overlap :=overlap* 0.5;
					Object1.x := Object1.x - overlap;
					Object2.x :=Object2.x+ overlap;


          if (obj2v>0) then dir2:=1 else dir2:=-1;
          if (obj1v>0) then dir1:=1 else dir1:=-1;


					 obj1velocity:= sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * dir2;
					 obj2velocity:= sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * dir1;
					 average:= (obj1velocity + obj2velocity)*0.5;
					obj1velocity :=obj1velocity- average;
					obj2velocity :=obj2velocity- average;
					Object1.velocity.x := average + obj1velocity * Object1.elasticity;
					Object2.velocity.x := average + obj2velocity * Object2.elasticity;
				end
				else if(not obj1immovable) then
				begin
					Object1.x := Object1.x - overlap;
					Object1.velocity.x := obj2v - obj1v*Object1.elasticity;
				end
				else if(not obj2immovable) then
        begin

					Object2.x :=Object2.x+ overlap;
					Object2.velocity.x := obj1v - obj2v*Object2.elasticity;
				end;
				result:=true;
        exit;
			end
			else
   result:=false;
   exit;
  end;
end;

function separateY(Object1:TSMEEntity;Object2:TSMEEntity;gamestate:TSMEState):Boolean ;
var
obj1immovable,obj2immovable:boolean;
overlap,obj1delta,obj2delta:single;
obj1deltaAbs,obj2deltaAbs:single;
obj1rect,obj2rect:Rectangle;
maxOverlap:single;
obj1v,obj2v:single;
obj1velocity,obj2velocity,average:single;
dir1,dir2:integer;
begin


			//can't separate two immovable objects
			 obj1immovable:= Object1.immovable;
			 obj2immovable:= Object2.immovable;
			if(obj1immovable and obj2immovable) then
      begin
      result:=false;
      exit;
      end;

			//First, get the two object deltas
			 overlap:= 0;
			 obj1delta:= Object1.y - Object1.last.y;
			 obj2delta:= Object2.y - Object2.last.y;
			if(obj1delta <> obj2delta) then
      begin
  			//Check if the Y hulls actually overlap
    		 if (obj1delta > 0) then obj1deltaAbs:=obj1delta else obj1deltaAbs:=-obj1delta;
           if (obj2delta > 0) then obj2deltaAbs:=obj2delta else obj2deltaAbs:=-obj2delta;

				obj1rect.x:=Object1.x;
        if (obj1delta>0) then          obj1rect.y:=Object1.y-obj1delta else obj1rect.y:=Object1.y;
        obj1rect.Width:= Object1.originWidth;
        obj1rect.Height:= Object1.originHeight+obj1deltaAbs;


        	obj2rect.x:=Object2.x;
        if (obj2delta>0) then          obj2rect.y:=Object2.y-obj1delta else obj2rect.y:=Object2.y;
        obj2rect.Width:= Object2.originWidth;
        obj2rect.Height:= Object2.originHeight+obj2deltaAbs;



				  if((obj1rect.x + obj1rect.width > obj2rect.x)
         and (obj1rect.x < obj2rect.x + obj2rect.width)
         and (obj1rect.y + obj1rect.height > obj2rect.y)
         and (obj1rect.y < obj2rect.y + obj2rect.height)) then
       begin
				  maxOverlap:= obj1deltaAbs + obj2deltaAbs + 4;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta) then
					begin


						overlap := Object1.y + Object1.originHeight - Object2.y;

            	if (overlap > maxOverlap) then
              overlap := 0 else
              begin
    				  	Object1.hitBottom(overlap);
					     	Object2.hitTop(overlap);
                Object1.OnColide(Object2);
                Object2.OnColide(Object1);
                Object1.touching:=Object1.touching or down;
                Object2.touching:=Object2.touching or UP;
               if assigned(gamestate) then gamestate.onColide(Object1,Object2);
          end;




					end else if(obj1delta < obj2delta) then
					begin



						overlap := Object1.y - Object2.originHeight - Object2.y;
						if (-overlap > maxOverlap) then
       						overlap := 0 else
            begin
						Object2.hitBottom(overlap);
						Object1.hitTop(overlap);
            Object1.OnColide(Object2);
            Object2.OnColide(Object1);
            Object2.touching:=Object2.touching or down;
            Object1.touching:=Object1.touching or UP;
            if assigned(gamestate) then gamestate.onColide(Object2,Object1);

    			 end;
  			end;
			end;

			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap <> 0) then
      begin

				 obj1v:= Object1.velocity.y;
				 obj2v:= Object2.velocity.y;
				
				if(not obj1immovable) and ( not obj2immovable) then
        begin

					overlap :=overlap* 0.5;
					Object1.y := Object1.y - overlap;
					Object2.y :=Object2.y+ overlap;

          if (obj2v>0) then dir2:=1 else dir2:=-1;
          if (obj1v>0) then dir1:=1 else dir1:=-1;

					 obj1velocity:= sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * dir2;
					 obj2velocity:= sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * dir1;
					 average:= (obj1velocity + obj2velocity)*0.5;
					obj1velocity :=obj1velocity- average;
					obj2velocity :=obj2velocity- average;
					Object1.velocity.y := average + obj1velocity * Object1.elasticity;
					Object2.velocity.y := average + obj2velocity * Object2.elasticity;
				end
				else if(not obj1immovable) then
				begin
					Object1.y := Object1.y - overlap;
					Object1.velocity.y := obj2v - obj1v*Object1.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if((Object2.active) and (Object2.moves) and (obj1delta > obj2delta)) then
						Object1.x :=Object1.x+ Object2.x - Object2.last.x;
				end
				else if(not obj2immovable) then
				begin
					Object2.y :=Object2.y+ overlap;
					Object2.velocity.y := obj1v - obj2v*Object2.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object1.active and Object1.moves and (obj1delta < obj2delta)) then
						Object2.x :=Object2.x+ Object1.x - Object1.last.x;
				end;
				result:=true; exit;
			end
			else
				result:=false;
		end;
end;

function separateoBJECT(Object1:TSMEEntity; Object2:TSMEEntity;gamestate:TSMEState):Boolean;
var
separatedX,separatedY:boolean;
begin
		 	 separatedX:= separateX(Object1,Object2,gamestate);
			 separatedY:= separateY(Object1,Object2,gamestate);
			 result:= (separatedX and separatedY);
    
end;



function stopY(Object1:TSMEEntity;Object2:TSMETileMap):Boolean ;
var
obj1immovable,obj2immovable:boolean;
overlap,obj1delta,obj2delta:single;
obj1deltaAbs,obj2deltaAbs:single;

maxOverlap:single;
obj1v,obj2v:single;
obj1velocity,obj2velocity,average:single;
dir1,dir2:integer;


begin




			//can't separate two immovable objects
			 obj1immovable:= Object1.immovable;
			 obj2immovable:= true;


			//First, get the two object deltas
			 overlap:= 0;
			 obj1delta:= Object1.y - Object1.last.y;
			 obj2delta:= Object2.y - Object2.last.y;

       writeln(obj1delta,'<>',obj2delta);
			if(obj1delta <> obj2delta) then
      begin
  			//Check if the Y hulls actually overlap
    		 if (obj1delta > 0) then obj1deltaAbs:=obj1delta else obj1deltaAbs:=-obj1delta;
         if (obj2delta > 0) then obj2deltaAbs:=obj2delta else obj2deltaAbs:=-obj2delta;


       if (Object2.colide(Object1)) then
       begin
       writeln('colide');
				  maxOverlap:= obj1deltaAbs + obj2deltaAbs + 4;

					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta) then
					begin
        			overlap := Object1.y + Object1.height - Object2.y;
            	if (overlap > maxOverlap) then  overlap := 0 else 	Object1.hitBottom(overlap);
    			end else
        if(obj1delta < obj2delta) then
					begin
						overlap := Object1.y - Object2.height - Object2.y;
						if (-overlap > maxOverlap) then overlap := 0 else	Object1.hitTop(overlap);


				end;
			end;

			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap <> 0) then
      begin

			 //	 obj1v:= Object1.velocity.y;
			 //	 obj2v:= 0;


				//	Object1.y := Object1.y - overlap;
				 //	Object1.velocity.y := obj2v - obj1v*Object1.elasticity;

				result:=true; exit;
			end
			else
     result:=false; exit;
		end;
end;




function TSMEEntity.Bounce( Object2:TSMEEntity):Boolean;
var
separatedX,separatedY:boolean;
begin
//result:=bounceBJECT(self,Object2);
end;



function TSMEEntity.separate( Object2:TSMEEntity):Boolean;
var
separatedX,separatedY:boolean;
begin
			 separatedX:= separateX(SELF,Object2,nil);
			 separatedY:= separateY(SELF,Object2,nil);
			result:= (separatedX and separatedY);
end;




procedure DrawImage(texture:PSDL_Texture;
        x,y,
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;
   vect:hvector;


begin
  TempX1 := 0 ;
  TempY1 := 0 ;
  TempX2 :=  texture.width ;
  TempY2 :=  texture.height;



  TexX1 := 0;
  TexY1 := 0;
  TexX2 := 1;
  TexY2 := 1;

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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;


  globalmatrix.identity;
  globalmatrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   globalmatrix.skew(SkewX,SkewY);
  end;
  globalmatrix.rotate(rotation);
  globalmatrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     globalmatrix.tx := x - globalmatrix.a * PivotX  - globalmatrix.c * PivotY;
     globalmatrix.ty := y - globalmatrix.b * PivotX  - globalmatrix.d * PivotY;
  end;



  for i:=0 to 3 do
  begin
   vect.x:=FQuad.V[i].X;
   vect.y:=FQuad.V[i].y;
   vect:=globalmatrix.transformPoint(vect);
   FQuad.V[i].X:=vect.x;
   FQuad.V[i].Y:=vect.y;
  end;

  smeRenderQuad(@fquad);
 
end;





procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;Color:dword;blend:integer);overload;


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;


l,t,r,b,   texw,texh:single;

begin



    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


    if (assigned(clipping)) then
    begin
		l := clipping.x / texture.widthtex;//l:=l*texw;
		t := clipping.y / texture.heighttex;//t:=t*texh;
		r := (clipping.x + clipping.w) / texture.widthtex;//t:=t*texw;
		b := (clipping.y + clipping.h) / texture.heighttex;//b:=b*texh;


    TempX1 := x;
    TempY1 := y;
    TempX2 := x+clipping.w ;
    TempY2 := y+clipping.H ;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;

       {
     TexX1 := clipping.x / texture.widthtex;
     TexY1 := clipping.y / texture.heighttex;
     TexX2 := (clipping.x + clipping.w) / texture.widthtex;
     TexY2 := (clipping.y + clipping.h) / texture.heighttex;
        }

    end else
    begin
     TempX1 := x ;
     TempY1 := y ;
     TempX2 := x+ texture.width ;
     TempY2 := y+ texture.height;
     TexX1 := 0;
     TexY1 := 0;
     TexX2 := 1;
     TexY2 := 1;
    end;

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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;


   smeRenderQuad(@fquad);

end;


procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;

vect:hvector;

l,t,r,b,   texw,texh:single;

begin



    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


    if (assigned(clipping)) then
    begin
		l := clipping.x / texture.widthtex;//l:=l*texw;
		t := clipping.y / texture.heighttex;//t:=t*texh;
		r := (clipping.x + clipping.w) / texture.widthtex;//t:=t*texw;
		b := (clipping.y + clipping.h) / texture.heighttex;//b:=b*texh;


    TempX1 := 0;
    TempY1 := 0;
    TempX2 := clipping.w ;
    TempY2 := clipping.H ;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;

       {
     TexX1 := clipping.x / texture.widthtex;
     TexY1 := clipping.y / texture.heighttex;
     TexX2 := (clipping.x + clipping.w) / texture.widthtex;
     TexY2 := (clipping.y + clipping.h) / texture.heighttex;
        }

    end else
    begin
     TempX1 := 0 ;
     TempY1 := 0 ;
     TempX2 :=  texture.width ;
     TempY2 :=  texture.height;
     TexX1 := 0;
     TexY1 := 0;
     TexX2 := 1;
     TexY2 := 1;
    end;

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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;


  globalmatrix.identity;
  globalmatrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   globalmatrix.skew(SkewX,SkewY);
  end;
  globalmatrix.rotate(rotation);
  globalmatrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     globalmatrix.tx := x - globalmatrix.a * PivotX  - globalmatrix.c * PivotY;
     globalmatrix.ty := y - globalmatrix.b * PivotX  - globalmatrix.d * PivotY;
  end;



  for i:=0 to 3 do
  begin
   vect.x:=FQuad.V[i].X;
   vect.y:=FQuad.V[i].y;
   vect:=globalmatrix.transformPoint(vect);
   FQuad.V[i].X:=vect.x;
   FQuad.V[i].Y:=vect.y;
  end;
  smeRenderQuad(@fquad);


end;

procedure DrawImage(texture:PSDL_Texture;
        x,y:single;
        Dst,clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;
 vect:hvector;

l,t,r,b,   texw,texh:single;

begin



    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;

    if (assigned(clipping)) then
    begin
		l := clipping.x / texture.width;l:=l*texw;
		t := clipping.y / texture.height;t:=t*texh;
		r := (clipping.x + clipping.w) / texture.width;t:=t*texw;
		b := (clipping.y + clipping.h) / texture.height;b:=b*texh;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;
    end else
    begin
     TempX1 := 0 ;
     TempY1 := 0 ;
     TempX2 :=  texture.width ;
     TempY2 :=  texture.height;
    end;

    if assigned(Dst) then
    begin
    TempX1 := Dst.x ;
    TempY1 := dst.y ;
    TempX2 := dst.w ;
    TempY2 := dst.H ;
    end else
    begin
     TempX1 := 0 ;
     TempY1 := 0 ;
     TempX2 :=  texture.width ;
     TempY2 :=  texture.height;
    end;


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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  
  globalmatrix.identity;
  globalmatrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   globalmatrix.skew(SkewX,SkewY);
  end;
  globalmatrix.rotate(rotation);
  globalmatrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     globalmatrix.tx := x - globalmatrix.a * PivotX  - globalmatrix.c * PivotY;
     globalmatrix.ty := y - globalmatrix.b * PivotX  - globalmatrix.d * PivotY;
  end;



  for i:=0 to 3 do
  begin
   vect.x:=FQuad.V[i].X;
   vect.y:=FQuad.V[i].y;
   vect:=globalmatrix.transformPoint(vect);
   FQuad.V[i].X:=vect.x;
   FQuad.V[i].Y:=vect.y;
  end;

  smeRenderQuad(@fquad);

end;

procedure DrawImage(texture:PSDL_Texture;
        x,y,
        Width,Height,
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);overload;


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;
 vect:hvector;


begin
  TempX1 := 0 ;
  TempY1 := 0 ;
  TempX2 := width ;
  TempY2 := height;



  TexX1 := 0;
  TexY1 := 0;
  TexX2 := 1;
  TexY2 := 1;

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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  globalmatrix.identity;
  globalmatrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   globalmatrix.skew(SkewX,SkewY);
  end;
  globalmatrix.rotate(rotation);
  globalmatrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     globalmatrix.tx := x - globalmatrix.a * PivotX  - globalmatrix.c * PivotY;
     globalmatrix.ty := y - globalmatrix.b * PivotX  - globalmatrix.d * PivotY;
  end;



  for i:=0 to 3 do
  begin
   vect.x:=FQuad.V[i].X;
   vect.y:=FQuad.V[i].y;
   vect:=globalmatrix.transformPoint(vect);
   FQuad.V[i].X:=vect.x;
   FQuad.V[i].Y:=vect.y;
  end;

  smeRenderQuad(@fquad);

end;


function Resource_Load(const Filename: String;out data:pointer; var Size: integer):boolean;

var
  Done, I: Integer;
  F: THandle;
  BytesRead: Cardinal;
  uncompressed_size : integer;
  RWops:PSDL_RWops;
begin
Result := false;
Data := nil;
if (Filename = '') then      Exit;
RWops:= SDL_RWFromFile(pchar(filename),'r');
if assigned(RWops) then
 begin
 uncompressed_size := smeRWsize(RWops);
 GetMem(Data,uncompressed_size);
 BytesRead:= smeRWread(RWops,Data,1,uncompressed_size);
 Size := BytesRead;
 SDL_FreeRW(RWops);
end;
  result:=true;
end;



(****************************************************************************
 * HGEFont.h, HGEFont.cpp
 ****************************************************************************)

const
  FNTHEADERTAG = '[HGEFONT]';
  FNTBITMAPTAG = 'Bitmap';
  FNTCHARTAG = 'Char';

{ TSMEFont }

function setglip(Texture:PSDL_Texture;TexX, TexY, W, H: Single):TGlip;
begin
  result.TX := TexX;
  result.TY := TexY;
  result.Width := W;
  result.Height := H;



  if (Texture<>nil) then
  begin
    result.TexWidth := Texture.width;
    result.TexHeight :=Texture.height;
  end else begin
    result.TexWidth := 1;
    result.TexHeight := 1;
  end;


  result.TexX1 := TexX / result.TexWidth;
  result.TexY1 := TexY / result.TexHeight;
  result.TexX2 := (TexX + W) / result.TexWidth;
  result.TexY2 := (TexY + H) / result.TexHeight;

end;

constructor TSMEFont.Create(data:pointer;size:longword);
var
  Desc, PDesc, PBuf: PChar;
  LineBuf: array [0..255] of Char;
  S: String;
  Chr: Char;
  I, X, Y, W, H, A, C: Integer;

  function GetParam: Integer;
  var
    Start: PChar;
    C: Char;
  begin
    while (PBuf^ in [' ',',']) do
      Inc(PBuf);
    Start := PBuf;
    while (PBuf^ in ['0'..'9']) do
      Inc(PBuf);
    if (PBuf = Start) then
      Result := 0
    else begin
      C := PBuf^;
      PBuf^ := #0;
      Result := StrToInt(Start);
      PBuf^ := C;
    end;
  end;


begin
  FScale := 1.0;
  FProportion := 1;
  FSpacing := 1.0;
  FZ := 0.0;
  FBlend := BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  FCol := $FFFFFFFF;


  if (Data = nil) then
    Exit;

  GetMem(Desc,Size + 1);
  Move(Data^,Desc^,Size);
  Desc[Size] := #0;
  Data := nil;

  PDesc := GetLine(Desc,LineBuf);
  if (StrComp(LineBuf,FNTHEADERTAG) <> 0) then
  begin
  // System_Log('Font %s has incorrect format.');
    FreeMem(Desc);
    Exit;
  end;

  // Parse font description
  PDesc := GetLine(PDesc,LineBuf);
  while Assigned(PDesc) do
  begin
    if (StrLComp(LineBuf,FNTBITMAPTAG,Length(FNTBITMAPTAG)) = 0) then
    begin
//      S := image;

      PBuf := StrScan(LineBuf,'=');
      if (PBuf <> nil) then
       begin
        Inc(PBuf);
        S := Trim(PBuf);
      end;
     //  writeln(s);



     FTexture := images.LoadTexture(s);
      if (FTexture = nil) then
      begin
        FreeMem(Desc);
        Exit;
      end;
    end else if (StrLComp(LineBuf,FNTCHARTAG,Length(FNTCHARTAG)) = 0) then
    begin
      PBuf := StrScan(LineBuf,'=');

      if (PBuf = nil) then
        Continue;
      Inc(PBuf);
      while (PBuf^ = ' ') do
        Inc(PBuf);
      if (PBuf^ = '"') then
      begin
        Inc(PBuf);
        I := Ord(PBuf^);
        Inc(PBuf,2);
      end else begin
        I := 0;
        while (PBuf^ in ['0'..'9','A'..'F','a'..'f']) do
        begin
          Chr := PBuf^;
          if (Chr >= 'a') then
            Dec(Chr,Ord(Ord('a') - Ord(':')));
          if (Chr >= 'A') then
            Dec(Chr,Ord(Ord('A') - Ord(':')));
          Dec(Chr,Ord('0'));
          if (Chr > #$F) then
            Chr := #$F;
          I := (I shl 4) or Ord(Chr);
          Inc(PBuf);
        end;
        if (I < 0) or (I > 255) then
          Continue;
      end;
      X := GetParam;
      Y := GetParam;
      W := GetParam;
      H := GetParam;
      A := GetParam;
      C := GetParam;
//      FLetters[I] := TSMESprite.Create(FTexture,X,Y,W,H);
           FClips[i]:=sdl_rect(trunc(x),trunc(y),trunc(w),trunc(h));


      FPre[I] := A;
      FPost[I] := C;
      if (H > FHeight) then
        FHeight := H;
    end;
    PDesc := GetLine(PDesc,LineBuf);
  end;
  FreeMem(Desc);
end;



constructor TSMEFont.Create(const Filename: String);
var
  Data: Pointer;
  Size: integer;
  Desc, PDesc, PBuf: PChar;
  LineBuf: array [0..255] of Char;
  S: String;
  Chr: Char;
  I, X, Y, W, H, A, C: Integer;

  function GetParam: Integer;
  var
    Start: PChar;
    C: Char;
  begin
    while (PBuf^ in [' ',',']) do
      Inc(PBuf);
    Start := PBuf;
    while (PBuf^ in ['0'..'9']) do
      Inc(PBuf);
    if (PBuf = Start) then
      Result := 0
    else begin
      C := PBuf^;
      PBuf^ := #0;
      Result := StrToInt(Start);
      PBuf^ := C;
    end;
  end;


begin
  FScale := 1.0;
  FProportion := 1;
  FSpacing := 1.0;
  FZ := 0.0;
  FBlend := BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  FCol := $FFFFFFFF;





 Resource_Load(Filename,data,Size);



  if (Data = nil) then      Exit;

  GetMem(Desc,Size + 1);
  Move(Data^,Desc^,Size);
  Desc[Size] := #0;
  Data := nil;
  FreeMem(Data);


  PDesc := GetLine(Desc,LineBuf);
  if (StrComp(LineBuf,FNTHEADERTAG) <> 0) then
  begin
    FreeMem(Desc);
    Exit;
  end;

  // Parse font description
  PDesc := GetLine(PDesc,LineBuf);
  while Assigned(PDesc) do
  begin
    if (StrLComp(LineBuf,FNTBITMAPTAG,Length(FNTBITMAPTAG)) = 0) then begin
      S := Filename;
      PBuf := StrScan(LineBuf,'=');
      if (PBuf <> nil) then begin
        Inc(PBuf);
        S := Trim(PBuf);
      end;



      s:=file_GetDirectory(filename)+s;

      if (not assigned(images)) then
      begin
      smeTerminate('image list not created');
      exit;
      end;

      FTexture := images.LoadTexture(S);
      if (FTexture = nil) then
      begin
        FreeMem(Desc);
        FTexture:=smeCreateRectangleTexture(256,256,$FF00FFFF,true);
       // Exit;
      end;
    end else if (StrLComp(LineBuf,FNTCHARTAG,Length(FNTCHARTAG)) = 0) then
    begin
      PBuf := StrScan(LineBuf,'=');
      if (PBuf = nil) then
        Continue;
      Inc(PBuf);
      while (PBuf^ = ' ') do
        Inc(PBuf);
      if (PBuf^ = '"') then
      begin
        Inc(PBuf);
        I := Ord(PBuf^);
        Inc(PBuf,2);
      end else begin
        I := 0;
        while (PBuf^ in ['0'..'9','A'..'F','a'..'f']) do
        begin
          Chr := PBuf^;
          if (Chr >= 'a') then
            Dec(Chr,Ord(Ord('a') - Ord(':')));
          if (Chr >= 'A') then
            Dec(Chr,Ord(Ord('A') - Ord(':')));
          Dec(Chr,Ord('0'));
          if (Chr > #$F) then
            Chr := #$F;
          I := (I shl 4) or Ord(Chr);
          Inc(PBuf);
        end;
        if (I < 0) or (I > 255) then
          Continue;
      end;
      X := GetParam;
      Y := GetParam;
      W := GetParam;
      H := GetParam;
      A := GetParam;
      C := GetParam;
//      FLetters[I] := TSMESprite.Create(FTexture,X,Y,W,H);
      FClips[i]:=sdl_rect(trunc(x),trunc(y),trunc(w),trunc(h));
      FPre[I] := A;
      FPost[I] := C;
      if (H > FHeight) then
        FHeight := H;
    end;
    PDesc := GetLine(PDesc,LineBuf);
  end;
  FreeMem(Desc);


end;

destructor TSMEFont.Destroy;
var
  I: Integer;
begin
 // for I := 0 to 255 do
  ///  FLetters[I] := nil;
    if assigned(FTexture) then
    begin
     smeFreeTexture(FTexture);
     FTexture:= nil;
     end;
  inherited;
end;

function TSMEFont.GetBlendMode: Integer;
begin
  Result := FBlend;
end;

function TSMEFont.GetColor: Longword;
begin
  Result := FCol;
end;

function TSMEFont.GetHeight: Single;
begin
  Result := FHeight;
end;

function TSMEFont.GetLine(const FromFile, Line: PChar): PChar;
var
  I: Integer;
begin
  I := 0;
  if (FromFile[I] = #0) then begin
    Result := nil;
    Exit;
  end;

  while (not (FromFile[I] in [#0,#10,#13])) do begin
    Line[I] := FromFile[I];
    Inc(I);
  end;
  Line[I] := #0;

  while (FromFile[I] <> #0) and (FromFile[I] in [#10,#13]) do
    Inc(I);

  Result := @FromFile[I];
end;

function TSMEFont.GetProportion: Single;
begin
  Result := FProportion;
end;

function TSMEFont.GetRotation: Single;
begin
  Result := FRot;
end;

function TSMEFont.GetScale: Single;
begin
  Result := FScale;
end;

function TSMEFont.GetSpacing: Single;
begin
  Result := FSpacing;
end;

function TSMEFont.GetSprite(const Chr: Char): TSDL_Rect;
begin
  Result := FClips[Ord(Chr)];
end;

function TSMEFont.GetStringWidth(const S: String;
  const FirstLineOnly: Boolean = True): Single;
var
  I: Integer;
  LineW: Single;
  P: PChar;
begin
  Result := 0;
  P := PChar(S);
  while (P^ <> #0) do begin
    LineW := 0;
    while (not (P^ in [#0,#10,#13])) do begin
      I := Ord(P^);
       LineW := LineW + FClips[I].w + FPre[I] + FPost[I] + FTracking;
      Inc(P);
    end;
    if (LineW > Result) then
      Result := LineW;
    if (FirstLineOnly and (P^ in [#10,#13])) then
      Break;
    while (P^ in [#10,#13]) do
      Inc(P);
  end;
  Result := Result * FScale * FProportion;
end;

function TSMEFont.GetTracking: Single;
begin
  Result := FTracking;
end;

function TSMEFont.GetZ: Single;
begin
  Result := FZ;
end;


procedure TSMEFont.PrintF(const X, Y: Single; const Align: Integer;
  const Format: String; const Args: array of const);
begin
  Render(X,Y,Align,SysUtils.Format(Format,Args));
end;

procedure TSMEFont.PrintFB(const X, Y, W, H: Single; const Align: Integer;
  const Format: String; const Args: array of const);
var
  I, Lines: Integer;
  LineStart, PrevWord: PChar;
  Buf: String;
  PBuf: PChar;
  Chr: Char;
  TX, TY, WW, HH: Single;
begin
  Buf := SysUtils.Format(Format,Args);
  PBuf := PChar(Buf);
  Lines := 0;
  LineStart := PBuf;
  PrevWord := nil;
  while (True) do begin
    I := 0;
    while (not (PBuf[I] in [#0,#10,#13,' '])) do
      Inc(I);
    Chr := PBuf[I];
    PBuf[I] := #0;
    WW := GetStringWidth(LineStart);
    PBuf[I] := Chr;

    if (WW > W) then begin
      if (PBuf = LineStart) then begin
        PBuf[I] := #13;
        LineStart := @PBuf[I + 1];
      end else begin
        PrevWord^ := #13;
        LineStart := PrevWord + 1;
      end;
      Inc(Lines);
    end;

    if (PBuf[I] = #13) then begin
      PrevWord := @PBuf[I];
      LineStart := @PBuf[I + 1];
      PBuf := LineStart;
      Inc(Lines);
      Continue;
    end;

    if (PBuf[I] = #0) then begin
      Inc(Lines);
      Break;
    end;

    PrevWord := @PBuf[I];
    PBuf := @PBuf[I + 1];
  end;

  TX := X;
  TY := Y;
  HH := FHeight * FSpacing * FScale * Lines;

  case (Align and HGETEXT_HORZMASK) of
    HGETEXT_RIGHT:
      TX := TX + W;
    HGETEXT_CENTER:
      TX := TX + Trunc(W / 2);
  end;

  case (Align and HGETEXT_VERTMASK) of
    HGETEXT_BOTTOM:
      TY := TY + (H - HH);
    HGETEXT_MIDDLE:
      TY := TY + Trunc((H - HH) / 2);
  end;

  Render(TX,TY,Align,Buf);
end;

procedure TSMEFont.Render(const X, Y: Single; const Algn: Integer;const S: String);
var
  I, J, Align: Integer;
  FX, FY: Single;
begin
  FX := X;
  FY := Y;
  Align := Algn and HGETEXT_HORZMASK;
  if (Align = HGETEXT_RIGHT) then
    FX := FX - GetStringWidth(S);
  if (Align = HGETEXT_CENTER) then
    FX := FX - Trunc(GetStringWidth(S) / 2);

  for J := 1 to Length(S) do
  begin
    if (S[J] in [#10,#13]) then
     begin
      FY := FY + Trunc(FHeight * FScale * FSpacing);
      FX := X;
      if (Align = HGETEXT_RIGHT) then
        FX := FX - GetStringWidth(Copy(S,J + 1,MaxInt));
      if (Align = HGETEXT_CENTER) then
        FX := FX - Trunc(GetStringWidth(Copy(S,J + 1,MaxInt)) / 2);
    end else
    begin
      I := Ord(S[J]);
        FX := FX + FPre[I] * FScale * FProportion;
        DrawImage(FTexture,fx,fy,
        @FClips[i],
       0,0,// FClips[i].w/2,FClips[i].h/2,
        FScale * FProportion,FScale,
        FRot,
       SkewX,SkewY,FCol,FBlend);
       FX := FX + (FClips[i].w + FPost[I] + FTracking) * FScale * FProportion;
    end;
  end;
end;

procedure TSMEFont.SetBlendMode(const Blend: Integer);
var
  I: Integer;
begin
  FBlend := Blend;
end;

procedure TSMEFont.SetColor(const Col: Longword);
var
  I: Integer;
begin
  FCol := Col;
end;

procedure TSMEFont.SetProportion(const Prop: Single);
begin
  FProportion := Prop;
end;

procedure TSMEFont.SetRotation(const Rot: Single);
begin
  FRot := Rot;
end;
procedure TSMEFont.SetSkew(const sX,sY: Single);
begin
    skewx := sx;
    skewy := sy;
end;
procedure TSMEFont.SetScale(const Scale: Single);
begin
  FScale := Scale;
end;

procedure TSMEFont.SetSpacing(const Spacing: Single);
begin
  FSpacing := Spacing;
end;

procedure TSMEFont.SetTracking(const Tracking: Single);
begin
  FTracking := Tracking;
end;

procedure TSMEFont.SetZ(const Z: Single);
var
  I: Integer;
begin
  FZ := Z;
end;

Constructor TSMEImage.Create(region:TSMERegion);
begin
        self.region:=region;
        x:=0;
        y:=0;
        texture:=region.texture;
        clipping:=region.clip;
        width:=region.width;
        height:=region.height;
        PivotX:=region.frameX;
        PivotY:=region.frameY;
        ScaleX:=1;
        ScaleY:=1;
        Rotation:=0;
        SkewX:=0;
        SkewY:=0;
        Color:=$FFFFFFFF;
        blend:=BLEND_DEFAULT;
        matrix:=TSMEMatrix.Create;


end;
procedure TSMEImage.setRegion(reg:TSMERegion;setorigin:boolean=false);
begin
        region:=reg;
        texture:=region.texture;
        clipping:=region.clip;
        width:=region.width;
        height:=region.height;
        if(setorigin) then
        begin
        PivotX:=region.frameX;
        PivotY:=region.frameY;
        end;
end;
procedure TSMEImage.Render();
var

  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;
  pa,pb:TSMEPoint;

l,t,r,b,   texw,texh:single;

begin


    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


		l := clipping.x / texture.widthtex;//l:=l*texw;
		t := clipping.y / texture.heighttex;//t:=t*texh;
		r := (clipping.x + clipping.w) / texture.widthtex;//t:=t*texw;
		b := (clipping.y + clipping.h) / texture.heighttex;//b:=b*texh;


    TempX1 := 0;
    TempY1 := 0;
    TempX2 := clipping.w ;
    TempY2 := clipping.H ;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;



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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;


  matrix.identity;
  matrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   matrix.skew(SkewX,SkewY);
  end;

  matrix.rotate(rotation/rad2deg);
  matrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     Matrix.tx := x - Matrix.a * PivotX  - Matrix.c * PivotY;
     Matrix.ty := y - Matrix.b * PivotX  - Matrix.d * PivotY;
  end;

    if assigned(parent) then
    begin
    matrix:=matrix.mult(parent.matrix);
    end;

  for i:=0 to 3 do
  begin
   pa:=TSMEPoint.Create(FQuad.V[i].X,FQuad.V[i].Y);
   pb:=matrix.transformPoint(pa);
   FQuad.V[i].X:=pb.x;
   FQuad.V[i].Y:=pb.y;
  end;

  smeRenderQuad(@fquad);
end;
constructor TSMEModel.Create();
begin

Fmatrix:=TSMEMatrix.Create();
AbsoluteTransformation:=TSMEMatrix.Create();
fmatrix.identity;
fchilds:=TSMEModelList.Create;

  Visible:=true;
  Alive:=true;
  Active:=true;
  Remove:=true;

   scrollx:=1;
   scrolly:=1;

        offsetx:=0;
        offsety:=0;
        Layer:=0;
        x:=0;
        y:=0;
        width:=1;
        height:=1;
        PivotX:=0;
        PivotY:=0;
        ScaleX:=1;
        ScaleY:=1;
        Rotation:=0;
        SkewX:=0;
        SkewY:=0;
       if assigned(GameCamera) then   camera:=GameCamera;

name:='Object';

end;
destructor TSMEModel.Destroy();
begin
fchilds.Clear;
fchilds.Destroy;
Fmatrix.Free;
OnRemove;
end;
function CompareLayer( Item1, Item2 : TSMEModel ) : Integer;
begin
  if Item1.layer < Item2.layer then
    Result := -1
  else if Item1.layer > Item2.layer then
    Result := 1
  else
    Result := 0;
end;

function TSMEModel.getX:single;
begin
result:=x;
end;
function TSMEModel.getY:single;
begin
result:=y;
end;


procedure TSMEModel.Draw;
var
  i, max : integer;
 tmpobj, TempSpr : TSMEModel;
begin
  if fchilds.Count > 0 then
  begin
    i := 0;
    max := fchilds.Count;
    repeat
         tmpobj:=fchilds[ i ];
       if(tmpObj.Visible) then tmpObj.Draw;
        inc( i );
    until i >= Max;
  end;
end;

function TSMEModel.getAbsoluteTransformation:TSMEMatrix;
begin
result:=AbsoluteTransformation;
end;

procedure TSMEModel.updateAbsolutePosition();
begin
if assigned(fParent) then
begin
	     	AbsoluteTransformation := getRelativeTransformation().mult(fparent.getRelativeTransformation);
end else
				AbsoluteTransformation := getRelativeTransformation();
end;

function TSMEModel.getRelativeTransformation:TSMEMatrix;

begin
  fmatrix.identity;


		  	if (rotation <> 0) then fmatrix.rotate(rotation/rad2deg);

       	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
        begin
        fmatrix.skew(SkewX,SkewY);
        end;

			 sx := x - offsetx;
			 sy := y - offsety;
       if assigned(camera) then
       begin
       cx := camera.x;
			 cy := camera.y;
       end else
       begin
			 cx := 0;
			 cy := 0;
       end;
			if ((scaleX <> 1) or (scaleY <> 1))  then
      begin
        fmatrix.translate(-PivotX,-PivotY);
        fmatrix.scale(scaleX,scaleY);
        fmatrix.translate(pivotx + sx - cx * scrollx, pivoty + sy - cy * scrolly);
			end else
      fmatrix.translate(sx - cx * scrollx, sy - cy * scrolly);

  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     fMatrix.tx := sx - cx * scrollx - fMatrix.a * PivotX  - fMatrix.c * PivotY;
     fMatrix.ty := sy - cy * scrolly - fMatrix.b * PivotX  - fMatrix.d * PivotY;
  end;


          {
       if assigned(camera) then
       begin
       cx := camera.x;
			 cy := camera.y;
       end else
       begin
			 cx := 0;
			 cy := 0;
       end;

   	 sx := x - cx * scrollx;
     sy := y - cy * scrollY;

 	if ((scaleX <> 1) or (scaleY <> 1)) then
  begin
  fmatrix.scale(scaleX,scaleY);
  end;

 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   fmatrix.skew(SkewX,SkewY);
  end;

  fmatrix.rotate(rotation/rad2deg);
  fmatrix.translate(sx,sy);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     fMatrix.tx := sx - fMatrix.a * PivotX  - fMatrix.c * PivotY;
     fMatrix.ty := sy - fMatrix.b * PivotX  - fMatrix.d * PivotY;
  end;
   }

  result:=fMatrix;
end;

procedure TSMEModel.RemoveChild(Entity:TSMEModel);
begin
   fchilds.Remove( Entity );
end;



procedure TSMEModel.Update(dt:single);
var
  i, max : integer;
 tmpobj, TempSpr : TSMEModel;
begin

  if fchilds.Count > 0 then
  begin
    i := 0;
    max := fchilds.Count;
    repeat
      if not fchilds[ i ].Alive then
      begin
      if (fchilds[ i ].Remove) then
      begin
        TempSpr := fchilds[ i ];
        RemoveChild( TempSpr );
        TempSpr.Destroy;
        dec( Max );
       end;
      end
      else
      begin
       tmpobj:=fchilds[ i ];
        if(tmpObj.Active) then
        begin
         tmpObj.Update(dt);
        end;
        inc( i );
      end;
    until i >= Max;
  end;




end;
procedure TSMEModel.addChild(child:TSMEModel;parentToState:boolean=true);
begin
if(parentToState) then child.setParent(self);
fchilds.Add(child);
end;

procedure TSMEModel.OnCreate();
begin
end;
procedure TSMEModel.OnRemove();
begin
end;


procedure TSMEModel.setParent(parent:TSMEModel);
begin
fparent:=parent;
end;

procedure TSMEModel.setCamera(  _camera:TSMECamera);
begin
camera:=_camera;
end;


procedure TSMEGroup.add(md:TSMEModel;parentToState:boolean=false);
begin

md.OnCreate();
fchilds.Add(md);
end;
procedure TSMEGroup.Draw;
var
  i, max : integer;
 tmpobj, TempSpr : TSMEModel;
begin
  if fchilds.Count > 0 then
  begin
    i := 0;
    max := fchilds.Count;
    repeat
         tmpobj:=fchilds[ i ];
          if(tmpObj.Visible) then tmpObj.Draw;
        inc( i );
    until i >= Max;
  end;
end;
procedure TSMEGroup.Update(dt:single);
var
  i, max : integer;
 tmpobj, TempSpr : TSMEModel;
begin

  if fchilds.Count > 0 then
  begin
    i := 0;
    max := fchilds.Count;
    repeat
      if not fchilds[ i ].Alive then
      begin
      if (fchilds[ i ].Remove) then
      begin
        TempSpr := fchilds[ i ];
        Remove( TempSpr );
        TempSpr.Destroy;
        dec( Max );
       end;
      end
      else
      begin
        tmpobj:=fchilds[ i ];
        if(tmpObj.Active) then
        begin
         tmpObj.Update(dt);
         tmpObj.updateAbsolutePosition;
        end;
        inc( i );
      end;
    until i >= Max;
  end;


  if NeedSort then
  begin
    Sort;
    NeedSort := false;
  end;


end;
procedure TSMEGroup.Sort;
begin
fchilds.Sort( @CompareLayer );
end;
procedure TSMEGroup.remove(md:TSMEModel);
begin
   md.OnRemove;
   fchilds.Remove( md );
end;
constructor TSMEGroup.Create;
begin
fchilds:=TSMEModelList.Create;

end;
destructor TSMEGroup.Destroy;
begin
fchilds.Clear;
fchilds.Destroy;
end;


procedure TSMEState.startState;
begin
end;

procedure TSMEState.endState;
begin
end;
procedure TSMEState.Render();
begin
draw;
end;
procedure TSMEState.onColide(a,b:TSMEEntity);
begin
end;
procedure TSMEState.separeteEntitys();
var
numEntities,j,i:integer;
a,b:TSMEEntity;
sourceFrame,targetFrame:Rectangle;
begin
numEntities:=fchilds.Count-1;

for i:=0 to numEntities do
begin
  for j:=i+1 to numEntities do
  begin
       A:=TSMEEntity(fchilds[ i ]);
       b:=TSMEEntity(fchilds[ J ]);
      IF (A<>B) THEN
      BEGIN
     separateoBJECT(A,B,self);
     separateoBJECT(b,a,self);

      END;
  end;
END;




end;

                

constructor TSMEGame.Create(width,heigth:integer;world_width,worldheigth:single;gameState:TSMEState);
begin
globalmatrix:=TSMEMatrix.Create();
images:=TSMETextureList.Create;
requestedReset := false;
requestNewState(gameState);
GameCamera:=TSMECamera.Create(width,heigth,world_width,worldheigth);
LoadGame();
end;
procedure TSMEGame.Destroy();
begin
globalmatrix.Destroy;
EndGame();
images.Destroy;
end;
procedure TSMEGame.resetGame();
var
i:integer;
begin
switchState();
end;
procedure TSMEGame.requestNewState(newState:TSMEState);
begin
    requestedReset:=true;
		frequestedState := newState;
end;

procedure TSMEGame.setState(state:TSMEState);
begin
requestNewState(state);
end;
procedure TSMEGame.switchState();
begin
		if assigned(fstate) then
    begin
      fstate.endState;
      fstate.destroy();
      fstate:=nil;
		end;
		fstate := frequestedState;
    fstate.game:=self;
		fstate.startState;
end;
procedure TSMEGame.Render();
begin
	if(requestedReset) then
  begin
			resetGame();
			requestedReset := false;
  end;



	if assigned(fstate) then
   begin
      fstate.Render;
 		end;
end;

procedure TSMEGame.Update(dt:single);
begin
   GameCamera.Update;

   if assigned(fstate) then
   begin
    	fstate.update(dt);
                     fstate.separeteEntitys;
 		end;
end;

procedure TSMEGame.UpdateGame();
begin
end;
procedure TSMEGame.LoadGame();
begin
end;
procedure TSMEGame.EndGame();
begin
end;





constructor TSMESprite.Create(const Texture:PSDL_Texture; const TexX, TexY, W, H: Single);
var
  TexX1, TexY1, TexX2, TexY2: Single;
begin
  FTX := TexX;
  FTY := TexY;
  FWidth  := W;
  FHeight := H;

   Animated:=false;

  if (Texture<>nil) then
  begin
    FTexWidth := Texture.widthtex;
    FTexHeight :=Texture.heighttex;
  end else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;

  FQuad.Tex := Texture;

  TexX1 := TexX / FTexWidth;
  TexY1 := TexY / FTexHeight;
  TexX2 := (TexX + W) / FTexWidth;
  TexY2 := (TexY + H) / FTexHeight;

  FQuad.V[0].TX := TexX1; FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2; FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2; FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1; FQuad.V[3].TY := TexY2;

  FQuad.V[0].Z := 0.0;
  FQuad.V[1].Z := 0.0;
  FQuad.V[2].Z := 0.0;
  FQuad.V[3].Z := 0.0;

  FQuad.V[0].Col := $ffffffff;
  FQuad.V[1].Col := $ffffffff;
  FQuad.V[2].Col := $ffffffff;
  FQuad.V[3].Col := $ffffffff;

  FQuad.Blend := BLEND_DEFAULT;
end;


function TSMESprite.GetBlendMode: Integer;
begin
  Result := FQuad.Blend;
end;

function TSMESprite.GetBoundingBox(const X, Y: Single;var Rect: TSMERect): TSMERect;
begin
  Rect.SetRect(X - FHotX,Y - FHotY,X - FHotX + FWidth,Y - FHotY + FHeight);
  Result := Rect;
end;

procedure TSMESprite.DrawBoundingBoxEx(const X, Y,bx,by,bw,bh, Rot, HScale, VScale: Single);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;

begin

  TX1 := -bx * HScale;
  TY1 := -by * VScale;
  TX2 := (bw - bx) * HScale;
  TY2 := (bh - by) * VScale;

  if (Rot <> 0.0) then
  begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    smeRenderLine(TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y,
    TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y,
    $FFFFFFFF);

    smeRenderLine(TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y,
    TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y,
     $FFFFFFFF);


    smeRenderLine(
    TX1 * CosT - TY1 * SinT + X,
    TX1 * SinT + TY1 * CosT + Y,
    TX1 * CosT - TY2 * SinT + X,
    TX1 * SinT + TY2 * CosT + Y,
    $FFFFFFFF);

    smeRenderLine(
    TX2 * CosT - TY1 * SinT + X,
    TX2 * SinT + TY1 * CosT + Y,
    TX2 * CosT - TY2 * SinT + X,
    TX2 * SinT + TY2 * CosT + Y,
     $FFFFFFFF);




  end else begin

    smeRenderLine(TX1 + X, TY1 + Y,TX2 + X, TY1 + Y,$FF00FFFF);
    smeRenderLine(TX2 + X, TY2 + Y,TX1 + X, TY2 + Y,$FF00FFFF);


     smeRenderLine(TX1 + X, TY1 + Y,TX1 + X, TY2 + Y,$FF00FFFF);
     smeRenderLine(TX2 + X, TY1 + Y,TX2 + X, TY2 + Y,$FF00FFFF);


  end;

end;


procedure TSMESprite.DrawBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;

begin

  TX1 := -FHotX * HScale;
  TY1 := -FHotY * VScale;
  TX2 := (FWidth - FHotX) * HScale;
  TY2 := (FHeight - FHotY) * VScale;

  if (Rot <> 0.0) then
  begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    smeRenderLine(TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y,
    TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y,
    $FFFFFFFF);

    smeRenderLine(TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y,
    TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y,
     $FFFFFFFF);


    smeRenderLine(
    TX1 * CosT - TY1 * SinT + X,
    TX1 * SinT + TY1 * CosT + Y,
    TX1 * CosT - TY2 * SinT + X,
    TX1 * SinT + TY2 * CosT + Y,
    $FFFFFFFF);

    smeRenderLine(
    TX2 * CosT - TY1 * SinT + X,
    TX2 * SinT + TY1 * CosT + Y,
    TX2 * CosT - TY2 * SinT + X,
    TX2 * SinT + TY2 * CosT + Y,
     $FFFFFFFF);




  end else begin

    smeRenderLine(TX1 + X, TY1 + Y,TX2 + X, TY1 + Y,$FF00FFFF);
    smeRenderLine(TX2 + X, TY2 + Y,TX1 + X, TY2 + Y,$FF00FFFF);


     smeRenderLine(TX1 + X, TY1 + Y,TX1 + X, TY2 + Y,$FF00FFFF);
     smeRenderLine(TX2 + X, TY1 + Y,TX2 + X, TY2 + Y,$FF00FFFF);


  end;

end;

function TSMESprite.GetBoundingBoxEx(const X, Y,bx,by,bw,bh, Rot, HScale, VScale: Single): TSMERect;
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  Rect.Clear;

  TX1 := -bx * HScale;
  TY1 := -by * VScale;
  TX2 := (bw - bx) * HScale;
  TY2 := (bh - by) * VScale;

  if (Rot <> 0.0) then
  begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    Rect.Encapsulate(TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y);
    Rect.Encapsulate(TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y);


  end else begin
    Rect.Encapsulate(TX1 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY2 + Y);
    Rect.Encapsulate(TX1 + X, TY2 + Y);


  end;

  Result := Rect;
end;


function TSMESprite.GetBoundingBoxEx(const X, Y, Rot, HScale, VScale: Single;var Rect: TSMERect): TSMERect;
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  Rect.Clear;

  TX1 := -FHotX * HScale;
  TY1 := -FHotY * VScale;
  TX2 := (FWidth - FHotX) * HScale;
  TY2 := (FHeight - FHotY) * VScale;

  if (Rot <> 0.0) then
  begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    Rect.Encapsulate(TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y);
    Rect.Encapsulate(TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y);
    Rect.Encapsulate(TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y);


  end else begin
    Rect.Encapsulate(TX1 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY1 + Y);
    Rect.Encapsulate(TX2 + X, TY2 + Y);
    Rect.Encapsulate(TX1 + X, TY2 + Y);


  end;

  Result := Rect;
end;

function TSMESprite.GetColor(const I: Integer): Longword;
begin
  Result := FQuad.V[I].Col;
end;

procedure TSMESprite.GetFlip(out X, Y: Boolean);
begin
  X := FXFlip;
  Y := FYFlip;
end;

function TSMESprite.GetHeight: Single;
begin
  Result := FHeight;
end;

procedure TSMESprite.GetHotSpot(out X, Y: Single);
begin
  X := FHotX;
  Y := FHotY;
end;

function TSMESprite.GePSDL_Texture: PSDL_Texture;
begin
  Result := FQuad.Tex;
end;

procedure TSMESprite.GePSDL_TextureRect(out X, Y, W, H: Single);
begin
  X := FTX;
  Y := FTY;
  W := FWidth;
  H := FHeight;
end;

function TSMESprite.GetWidth: Single;
begin
  Result := FWidth;
end;

function TSMESprite.GetZ(const I: Integer): Single;
begin
  Result := FQuad.V[I].Z;
end;


procedure TSMESprite.Render(const X, Y: Single);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  TempX1 := X - FHotX;
  TempY1 := Y - FHotY;
  TempX2 := X + FWidth - FHotX;
  TempY2 := Y + FHeight - FHotY;

  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

 smeRenderQuad(@FQuad);
end;

procedure TSMESprite.Render4V(const X0, Y0, X1, Y1, X2, Y2, X3, Y3: Single);
begin
  FQuad.V[0].X := X0; FQuad.V[0].Y := Y0;
  FQuad.V[1].X := X1; FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2; FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X3; FQuad.V[3].Y := Y3;

 smeRenderQuad(@FQuad);
end;

procedure TSMESprite.RenderEx(const X, Y, Rot, HScale: Single; VScale: Single);
var
  TX1, TY1, TX2, TY2, SinT, CosT: Single;
begin
  if (VScale=0) then
    VScale := HScale;

  TX1 := -FHotX * HScale;
  TY1 := -FHotY * VScale;
  TX2 := (FWidth - FHotX) * HScale;
  TY2 := (FHeight - FHotY) * VScale;

  if (Rot <> 0.0) then begin
    CosT := Cos(Rot);
    SinT := Sin(Rot);

    FQuad.V[0].X := TX1 * CosT - TY1 * SinT + X;
    FQuad.V[0].Y := TX1 * SinT + TY1 * CosT + Y;

    FQuad.V[1].X := TX2 * CosT - TY1 * SinT + X;
    FQuad.V[1].Y := TX2 * SinT + TY1 * CosT + Y;

    FQuad.V[2].X := TX2 * CosT - TY2 * SinT + X;
    FQuad.V[2].Y := TX2 * SinT + TY2 * CosT + Y;

    FQuad.V[3].X := TX1 * CosT - TY2 * SinT + X;
    FQuad.V[3].Y := TX1 * SinT + TY2 * CosT + Y;
  end else begin
    FQuad.V[0].X := TX1 + X; FQuad.V[0].Y := TY1 + Y;
    FQuad.V[1].X := TX2 + X; FQuad.V[1].Y := TY1 + Y;
    FQuad.V[2].X := TX2 + X; FQuad.V[2].Y := TY2 + Y;
    FQuad.V[3].X := TX1 + X; FQuad.V[3].Y := TY2 + Y;
  end;

  smeRenderQuad(@FQuad);
end;

procedure TSMESprite.RenderStretch(const X1, Y1, X2, Y2: Single);
begin
  FQuad.V[0].X := X1; FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2; FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2; FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X1; FQuad.V[3].Y := Y2;

  smeRenderQuad(@FQuad);
end;

procedure TSMESprite.SetBlendMode(const Blend: Integer);
begin
  FQuad.Blend := Blend;
end;

procedure TSMESprite.SetColor(const Col: dword; const I: Integer);
begin
  if (I <> -1) then
    FQuad.V[I].Col := Col
  else begin
    FQuad.V[0].Col := Col;
    FQuad.V[1].Col := Col;
    FQuad.V[2].Col := Col;
    FQuad.V[3].Col := Col;
  end;
end;

procedure TSMESprite.SetFlip(const X, Y: Boolean; const HotSpot: Boolean = False);
var
  TX, TY: Single;
begin
  if (FHSFlip and FXFlip) then
    FHotX := Width - FHotX;
  if (FHSFlip and FYFlip) then
    FHotY := Height - FHotY;

  FHSFlip := HotSpot;

  if (FHSFlip and FXFlip) then
    FHotX := Width - FHotX;
  if (FHSFlip and FYFlip) then
    FHotY := Height - FHotY;

  if (X <> FXFlip) then begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[1].TX; FQuad.V[1].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[1].TY; FQuad.V[1].TY := TY;
    TX := FQuad.V[3].TX; FQuad.V[3].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[3].TY; FQuad.V[3].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
    FXFlip := not FXFlip;
  end;

  if(Y <>  FYFlip) then begin
    TX := FQuad.V[0].TX; FQuad.V[0].TX := FQuad.V[3].TX; FQuad.V[3].TX := TX;
    TY := FQuad.V[0].TY; FQuad.V[0].TY := FQuad.V[3].TY; FQuad.V[3].TY := TY;
    TX := FQuad.V[1].TX; FQuad.V[1].TX := FQuad.V[2].TX; FQuad.V[2].TX := TX;
    TY := FQuad.V[1].TY; FQuad.V[1].TY := FQuad.V[2].TY; FQuad.V[2].TY := TY;
    FYFlip := not FYFlip;
  end;
end;

procedure TSMESprite.SetHotSpot(const X, Y: Single);
begin
  FHotX := X;
  FHotY := Y;
end;

procedure TSMESprite.SetTexture(const Tex: PSDL_Texture);
var
  TX1, TY1, TX2, TY2, TW, TH: Single;
begin
  FQuad.Tex := Tex;

  if (Tex<>nil) then begin
    TW := Tex.widthtex;
    TH := Tex.heighttex;
  end else begin
    TW := 1.0;
    TH := 1.0;
  end;

  if (TW <> FTexWidth) or (TH <> FTexHeight) then begin
    TX1 := FQuad.V[0].TX * FTexWidth;
    TY1 := FQuad.V[0].TY * FTexHeight;
    TX2 := FQuad.V[2].TX * FTexWidth;
    TY2 := FQuad.V[2].TY * FTexHeight;

    FTexWidth := TW;
    FTexHeight := TH;

    TX1 := TX1 / TW; TY1 := TY1 / TH;
    TX2 := TX2 / TW; TY2 := TY2 / TH;

    FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
    FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
    FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
    FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;
  end;
end;

procedure TSMESprite.SetTextureRect(const X, Y, W, H: Single;
  const AdjSize: Boolean = True);
var
  TX1, TY1, TX2, TY2: Single;
  BX, BY, BHS: Boolean;
begin
  FTX := X;
  FTY := Y;
  if (AdjSize) then
  begin
    FWidth := W;
    FHeight := H;
  end;

  TX1 := FTX / FTexWidth; TY1 := FTY / FTexHeight;
  TX2 := (FTX + W) / FTexWidth; TY2 := (FTY + H) / FTexHeight;

  FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
  FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
  FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
  FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;

  BX := FXFlip; BY := FYFlip; BHS := FHSFlip;
  FXFlip := False; FYFlip := False;
  SetFlip(BX,BY,BHS);
end;

procedure TSMESprite.SetZ(const Z: Single; const I: Integer);
begin
  if (I <> -1) then
    FQuad.V[I].Z := Z
  else begin
    FQuad.V[0].Z := Z;
    FQuad.V[1].Z := Z;
    FQuad.V[2].Z := Z;
    FQuad.V[3].Z := Z;
  end;
end;

procedure TSMEAnimation.AnimationSetTextureRect(const X, Y, W, H: Single);
begin
  inherited;
  SetFrame(FCurFrame);
end;

constructor TSMEAnimation.Create(const Texture: PSDL_Texture;const NFrames: Integer; const FPS, X, Y, W, H: Single);
begin
  inherited Create(Texture,X,Y,W,H);
  FOrigWidth :=Texture.widthtex;
  FSinceLastFrame := -1;
  FSpeed := 1 / FPS;
  FFrames := NFrames;
  FMode := HGEANIM_FWD or HGEANIM_LOOP;
  FDelta := 1;
  SetFrame(0);
  Animated:=true;
end;



function TSMEAnimation.GetFrame: Integer;
begin
  Result := FCurFrame;
end;

function TSMEAnimation.GetFrames: Integer;
begin
  Result := FFrames;
end;

function TSMEAnimation.GetMode: Integer;
begin
  Result := FMode;
end;

function TSMEAnimation.GetSpeed: Single;
begin
  Result := 1 / FSpeed;
end;

function TSMEAnimation.IsPlaying: Boolean;
begin
  Result := FPlaying;
end;

procedure TSMEAnimation.Play;
begin
  FPlaying := True;
  FSinceLastFrame := -1;
  SetMode(FMode);
end;

procedure TSMEAnimation.Resume;
begin
  FPlaying := True;
end;

procedure TSMEAnimation.SetFrame(const N: Integer);
var
  TX1, TY1, TX2, TY2: Single;
  XF, YF, HS: Boolean;
  NCols, I: Integer;
begin
  NCols := FOrigWidth div Trunc(Width);
  FCurFrame := N mod FFrames;
  if (FCurFrame < 0) then
    FCurFrame := FFrames + FCurFrame;


  TY1 := TY;
  TX1 := TX + FCurFrame * Width;
  if (TX1 > FOrigWidth - Width) then
  begin
    I := FCurFrame - (Trunc(FOrigWidth - TX) div Trunc(Width));
    TX1 := Width * (I mod NCols);
    TY1 := TY1 + (Height * (1 + (I div NCols)));
  end;

  TX2 := TX1 + Width;
  TY2 := TY1 + Height;

  TX1 := TX1 / TexWidth;
  TY1 := TY1 / TexHeight;
  TX2 := TX2 / TexWidth;
  TY2 := TY2 / TexHeight;

  FQuad.V[0].TX := TX1; FQuad.V[0].TY := TY1;
  FQuad.V[1].TX := TX2; FQuad.V[1].TY := TY1;
  FQuad.V[2].TX := TX2; FQuad.V[2].TY := TY2;
  FQuad.V[3].TX := TX1; FQuad.V[3].TY := TY2;

  XF := XFlip; YF := YFlip; HS := HSFlip;
  XFlip := False; YFlip := False;
  SetFlip(XF,YF,HS);
end;

procedure TSMEAnimation.SetFrames(const N: Integer);
begin
  FFrames := N;
end;

procedure TSMEAnimation.SetMode(const Mode: Integer);
begin
  FMode := Mode;
  if ((FMode and HGEANIM_REV) <> 0) then begin
    FDelta := -1;
    SetFrame(FFrames - 1);
  end else begin
    FDelta := 1;
    SetFrame(0);
  end;
end;

procedure TSMEAnimation.SetSpeed(const FPS: Single);
begin
  FSpeed := 1 / FPS;
end;

procedure TSMEAnimation.SetTexture(const Tex: PSDL_Texture);
begin
  inherited;
  FOrigWidth := Tex.width;
end;

procedure TSMEAnimation.Stop;
begin
  FPlaying := False;
end;

procedure TSMEAnimation.Update(const DeltaTime: Single);
begin
  if (not FPlaying) then
    Exit;

  if (FSinceLastFrame = -1) then
    FSinceLastFrame := 0
  else
    FSinceLastFrame := FSinceLastFrame + DeltaTime;

  while (FSinceLastFrame >= FSpeed) do
  begin
    FSinceLastFrame := FSinceLastFrame - FSpeed;

    if (FCurFrame + FDelta = FFrames) then begin
      case FMode of
        HGEANIM_FWD,
        HGEANIM_REV or HGEANIM_PINGPONG:
          FPlaying := False;
        HGEANIM_FWD or HGEANIM_PINGPONG,
        HGEANIM_FWD or HGEANIM_PINGPONG or HGEANIM_LOOP,
        HGEANIM_REV or HGEANIM_PINGPONG or HGEANIM_LOOP:
          FDelta := -FDelta;
      end;
    end else if (FCurFrame + FDelta < 0) then begin
      case FMode of
        HGEANIM_REV,
        HGEANIM_FWD or HGEANIM_PINGPONG:
          FPlaying := False;
        HGEANIM_REV or HGEANIM_PINGPONG,
        HGEANIM_REV or HGEANIM_PINGPONG or HGEANIM_LOOP,
        HGEANIM_FWD or HGEANIM_PINGPONG or HGEANIM_LOOP:
          FDelta := -FDelta;
      end;
    end;

    if (FPlaying) then
      SetFrame(FCurFrame + FDelta);
  end;
end;



procedure TSMEDistortionMesh.Clear(const Col: Longword; const Z: Single);
var
  I, J: Integer;
begin
  for J := 0 to FRows - 1 do
    for I := 0 to FCols - 1 do begin
      FDispArray[J * FCols + I].X := I * FCellW;
      FDispArray[J * FCols + I].Y := J * FCellH;
      FDispArray[J * FCols + I].Col := Col;
      FDispArray[J * FCols + I].Z := Z;
    end;
end;

constructor TSMEDistortionMesh.Create(const Cols, Rows: Integer);
var
  I: Integer;
begin
  inherited Create;

  FRows := Rows;
  FCols := Cols;
  FQuad.Blend := BLEND_DEFAULT;
  //GetMem(FDispArray,Rows * Cols * SizeOf(HGEVertex));
  setlength(FDispArray,Rows * Cols * SizeOf(HGEVertex));
  for I := 0 to Rows * Cols - 1 do begin
    FDispArray[I].X := 0;
    FDispArray[I].Y := 0;
    FDispArray[I].TX := 0;
    FDispArray[I].TY := 0;
    FDispArray[I].Z := 0.0;
    FDispArray[I].Col := $FFFFFFFF;
  end;
end;


destructor TSMEDistortionMesh.Destroy;
begin
  FreeMem(FDispArray);
  inherited;
end;

function TSMEDistortionMesh.GetBlendMode: Integer;
begin
  Result := FQuad.Blend;
end;

function TSMEDistortionMesh.GetColor(const Col, Row: Integer): Longword;
begin
  if (Row < FRows) and (Col < FCols) then
    Result := FDispArray[Row * FCols + Col].Col
  else
    Result := 0;
end;

function TSMEDistortionMesh.GetCols: Integer;
begin
  Result := FCols;
end;

procedure TSMEDistortionMesh.GetDisplacement(const Col, Row: Integer; out DX,
  DY: Single; const Ref: Integer);
begin
  if (Row < FRows) and (Col < FCols) then begin
    case Ref of
      HGEDISP_NODE:
        begin
          DX := FDispArray[Row * FCols + Col].X - Col * FCellW;
          DY := FDispArray[Row * FCols + Col].Y - Row * FCellH;
        end;
      HGEDISP_CENTER:
        begin
          DX := FDispArray[Row * FCols + Col].X - (FCellW * (FCols - 1) / 2);
          DY := FDispArray[Row * FCols + Col].Y - (FCellH * (FRows - 1) / 2);
        end;
    else
      begin
        DX := FDispArray[Row * FCols + Col].X;
        DY := FDispArray[Row * FCols + Col].Y;
      end;
    end;
  end;
end;

function TSMEDistortionMesh.GetRows: Integer;
begin
  Result := FRows;
end;

function TSMEDistortionMesh.GePSDL_Texture: PSDL_Texture;
begin
  Result := FQuad.Tex;
end;

procedure TSMEDistortionMesh.GePSDL_TextureRect(out X, Y, W, H: Single);
begin
  X := FTX;
  Y := FTY;
  W := FWidth;
  H := FHeight;
end;

function TSMEDistortionMesh.GetZ(const Col, Row: Integer): Single;
begin
  if (Row < FRows) and (Col < FCols) then
    Result := FDispArray[Row * FCols + Col].Z
  else
    Result := 0;
end;


procedure TSMEDistortionMesh.Render(const X, Y: Single);
var
  I, J, Idx: Integer;
begin
  for J := 0 to FRows - 2 do
    for I := 0 to FCols - 2 do begin
      Idx := J * FCols + I;

      FQuad.V[0].TX := FDispArray[Idx].TX;
      FQuad.V[0].TY := FDispArray[Idx].TY;
      FQuad.V[0].X := X+FDispArray[Idx].X;
      FQuad.V[0].Y := Y+FDispArray[Idx].Y;
      FQuad.V[0].Z := FDispArray[Idx].Z;
      FQuad.V[0].Col := FDispArray[Idx].Col;

      FQuad.V[1].TX := FDispArray[Idx+1].TX;
      FQuad.V[1].TY := FDispArray[Idx+1].TY;
      FQuad.V[1].X := X+FDispArray[Idx+1].X;
      FQuad.V[1].Y := Y+FDispArray[Idx+1].Y;
      FQuad.V[1].Z := FDispArray[Idx+1].Z;
      FQuad.V[1].Col := FDispArray[Idx+1].Col;

      FQuad.V[2].TX := FDispArray[Idx+FCols+1].TX;
      FQuad.V[2].TY := FDispArray[Idx+FCols+1].TY;
      FQuad.V[2].X := X+FDispArray[Idx+FCols+1].X;
      FQuad.V[2].Y := Y+FDispArray[Idx+FCols+1].Y;
      FQuad.V[2].Z := FDispArray[Idx+FCols+1].Z;
      FQuad.V[2].Col := FDispArray[Idx+FCols+1].Col;

      FQuad.V[3].TX := FDispArray[Idx+FCols].TX;
      FQuad.V[3].TY := FDispArray[Idx+FCols].TY;
      FQuad.V[3].X := X+FDispArray[Idx+FCols].X;
      FQuad.V[3].Y := Y+FDispArray[Idx+FCols].Y;
      FQuad.V[3].Z := FDispArray[Idx+FCols].Z;
      FQuad.V[3].Col := FDispArray[Idx+FCols].Col;

      smeRenderQuad(@FQuad);
    end;
end;

procedure TSMEDistortionMesh.SetBlendMode(const Blend: Integer);
begin
  FQuad.Blend := Blend;
end;

procedure TSMEDistortionMesh.SetColor(const Col, Row: Integer;
  const Color: Longword);
begin
  if (Row < FRows) and (Col < FCols) then
    FDispArray[Row * FCols + Col].Col := Color;
end;

procedure TSMEDistortionMesh.SetDisplacement(const Col, Row: Integer; const DX,
  DY: Single; const Ref: Integer);
var
  XDelta, YDelta: Single;
begin
  if (Row < FRows) and (Col < FCols) then begin
    case Ref of
      HGEDISP_NODE:
        begin
          XDelta := DX + Col * FCellW;
          YDelta := DY + Row * FCellH;
        end;
      HGEDISP_CENTER:
        begin
          XDelta := DX + (FCellW * (FCols - 1) / 2);
          YDelta := DY + (FCellH * (FRows - 1) / 2);
        end;
    else
      begin
        XDelta := DX;
        YDelta := DY;
      end;
    end;
    FDispArray[Row * FCols + Col].X := XDelta;
    FDispArray[Row * FCols + Col].Y := YDelta;
  end;
end;

procedure TSMEDistortionMesh.SetTexture(const Tex: PSDL_Texture);
begin
  FQuad.Tex := Tex;
end;

procedure TSMEDistortionMesh.SetTextureRect(const X, Y, W, H: Single);
var
  I, J: Integer;
  TW, TH: Single;
begin
  FTX := X;
  FTY := Y;
  FWidth := W;
  FHeight := H;
  if FQuad.Tex<>nil then
  begin
     TW :=FQuad.Tex.width;
    TH := FQuad.Tex.height;


  end else
  begin
    TW := W;
    TH := H;
  end;



  FCellW := W / (FCols - 1);
  FCellH := H / (FRows - 1);

  for J := 0 to FRows - 1 do
    for I := 0 to FCols - 1 do
    begin
      FDispArray[J * FCols + I].TX := (X + I * FCellW) / TW;
      FDispArray[J * FCols + I].TY := (Y + J * FCellH) / TH;

      FDispArray[J * FCols + I].X := I * FCellW;
      FDispArray[J * FCols + I].Y := J * FCellH;
    end;
end;

procedure TSMEDistortionMesh.SetZ(const Col, Row: Integer; const Z: Single);
begin
  if (Row < FRows) and (Col < FCols) then
    FDispArray[Row * FCols + Col].Z := Z;
end;

function InvSqrt(const X: Single): Single;
var
  I: Integer;
  F: Single absolute I;
begin
  F := X;
  I := $5f3759df - (I div 2);
  Result := F * (1.5 - 0.4999  * X * F * F);
end;

function HVDot(const A,B: hVector): Single;
begin
  Result := (A.X * B.X) + (A.Y * B.Y);
end;

function VectorMagnitude(v: hVector) : Single;
begin
  result := sqrt((v.x*v.x) + (v.y*v.y));
end;

function VectorDivS(const v: hVector; s: Single) : hVector;
begin
  result.x := v.x/s;
  result.y := v.y/s;

end;

function VectorScale( v: hVector;const Scalar: Single):hVector;
begin
  v.X := v.X * Scalar;
  v.Y := v.Y * Scalar;
  result:= v;
end;
function VectorIncrement( a,b: hVector):hVector;
begin
  a.X := a.X + b.x;
  a.Y := a.Y + b.y;
  result:= a;
end;




function VectorNormalize(const v: hVector) : hVector;
begin
  result := VectorDivS(v,VectorMagnitude(v));
end;


function VectorAngle(a,b: hVector): Single;
var
  S, T: HVector;
begin
    S := a;
    T := b;
    S:=VectorNormalize(s);
    T:=VectorNormalize(t);;
    Result := ArcCos(HVDot(s,T));
  //end else
   // Result := ArcTan2(Y,X);
end;

function VectorAngle1(a: hVector): Single;
var
  S, T: HVector;
begin
Result := ArcTan2(a.y,a.x);
end;

constructor TSMEParticleSystem.Create(data:pointer;size:longword);
var
  P: PByte;
begin

  if (data = nil) then      Exit;
  P := data;
  Inc(P,4);
  Move(P^,FInfo.Emission,SizeOf(TSMEParticleSystemInfo) - 4);
//  FInfo.Sprite := FSprite;
  FAge := -2;
  spaw:=0;
end;


constructor TSMEParticleSystem.Create(const Filename: String;Region:TSMERegion);
var
  PSI: pointer;
  P: PByte;
  size:integer;
begin
  Resource_Load(Filename,PSI,size);
  if (PSI = nil) then      Exit;
  P := PSI;
  Inc(P,4);
  Move(P^,FInfo.Emission,SizeOf(TSMEParticleSystemInfo) - 4);
  PSI := nil;
  FAge := -2;
  spaw:=0;
  fregion:=Region;
 // writeln(FInfo.Lifetime);




end;


constructor TSMEParticleSystem.Create(const PSI: TSMEParticleSystemInfo);
begin
  Move(PSI.Emission,FInfo.Emission,SizeOf(TSMEParticleSystemInfo) - 4);
//  FInfo.Sprite := PSI.Sprite;
  FAge := -2;
end;

procedure TSMEParticleSystem.Save(const Filename: String);
begin

end;

procedure TSMEParticleSystem.Fire;
begin
  if (FInfo.Lifetime = -1) then
    FAge := -1
  else
    FAge := 0;
end;

procedure TSMEParticleSystem.FireAt(const X, Y: Single);
begin
  Stop;
  MoveTo(X,Y);
  Fire;
end;

function TSMEParticleSystem.GetAge: Single;
begin
  Result := FAge;
end;



function TSMEParticleSystem.GetInfo: TSMEParticleSystemInfo;
begin
  Result := FInfo;
end;

function TSMEParticleSystem.GetParticlesAlive: Integer;
begin
  Result := FParticlesAlive;
end;

procedure TSMEParticleSystem.GetPosition(out X, Y: Single);
begin
  X := FLocation.X;
  Y := FLocation.Y;
end;

procedure TSMEParticleSystem.GetTransposition(out X, Y: Single);
begin
  X := FTX;
  Y := FTY;
end;


procedure TSMEParticleSystem.MoveTo(const X, Y: Single;const MoveParticles: Boolean);
var
  I: Integer;
  DX, DY: Single;
begin
  if (MoveParticles) then begin
    DX := X - FLocation.X;
    DY := Y - FLocation.Y;
    for I := 0 to FParticlesAlive - 1 do begin
      FParticles[I].Location.X := FParticles[I].Location.X + DX;
      FParticles[I].Location.Y := FParticles[I].Location.Y + DY;
    end;
    FPrevLocation.X := FPrevLocation.X + DX;
    FPrevLocation.Y := FPrevLocation.Y + DY;
  end else begin
    if (FAge = -2) then begin
      FPrevLocation.X := X;
      FPrevLocation.Y := Y;
    end else begin
      FPrevLocation.X := FLocation.X;
      FPrevLocation.Y := FLocation.Y;
    end;
  end;
  FLocation.X := X;
  FLocation.Y := Y;
end;

function SetARGBColor(const Col: dword):HColor;
begin
  result.A := (Col shr 24) / 255;
  result.R := ((Col shr 16) and $FF) / 255;
  result.G := ((Col shr 8) and $FF) / 255;
  result.B := (Col and $FF) / 255;
end;

function GetColor(col:HColor):dword;
var
  R, G, B, XH, P1, P2, P3: Single;
  I: Integer;
begin
  Result :=
    Trunc(col.A * 255) shl 24 +
    Trunc(col.R * 255) shl 16 +
    Trunc(col.G * 255) shl 8 +
    Trunc(col.B * 255);
end;


procedure RenderRect( x,  y,  width,  height:single;r,g,b,a:single);
begin

		smeRenderLine(x,y,x+width,y,COLOR_ARGB(a,r,g,b),0);
		smeRenderLine(x+width,y,x+width,y+height,COLOR_ARGB(a,r,g,b),0);
		smeRenderLine(x+width,y+height,x,y+height,COLOR_ARGB(a,r,g,b),0);
		smeRenderLine(x,y+height,x,y,COLOR_ARGB(a,r,g,b),0);
end;

procedure TSMEParticleSystem.setLifetime(value:single);
begin
FInfo.Lifetime:=value;
end;

procedure TSMEParticleSystem.Render;
var
  I: Integer;
  Col: dword;
  Par: PHGEParticle;
begin
  Par := @FParticles[0];
 // Col := FInfo.Sprite.GetColor();
  for I := 0 to FParticlesAlive - 1 do
  begin
  DrawImage(fregion.texture,
  Par.Location.X + FTX,Par.Location.Y + FTY,
  @fregion.clip,
  fregion.clip.w/2,fregion.clip.h/2,
  Par.Size,Par.Size,
  Par.Spin * Par.Age,
  0,0,GetColor(Par.Color),BLEND_DEFAULT);

  Inc(Par);
  end;
end;

procedure TSMEParticleSystem.Stop(const KillParticles: Boolean);
begin
  FAge := -2;
  if (KillParticles) then
  begin
    FParticlesAlive := 0;
   end;
end;


procedure TSMEParticleSystem.Transpose(const X, Y: Single);
begin
  FTX := X;
  FTY := Y;
end;


function RandomS( lo, hi : Single ) : Single;
begin
  result := ( random * ( hi - lo ) + lo );
end;
function RandomI( lo, hi : integer ) : integer;
begin
  result := ( random  ( hi - lo ) + lo );
end;


procedure TSMEParticleSystem.Update(const DeltaTime: Single);
var
  I, ParticlesCreated: Integer;
  Ang, ParticlesNeeded: Single;
  Par: PHGEParticle;
  Accel, Accel2, V: hVector;
begin

  if (FAge >= 0) then
  begin
    FAge := FAge + DeltaTime;
    if (FAge >= FInfo.Lifetime) then
      FAge := -2;
  end;

  Par := @FParticles;

  I := 0;
  while (I < FParticlesAlive) do
  begin
    Par.Age := Par.Age + DeltaTime;
    if (Par.Age >= Par.TerminalAge)  then
    begin
      Dec(FParticlesAlive);
      Move(FParticles[FParticlesAlive],Par^,SizeOf(TSMEParticle));
      Continue;
    end;

    if (par.Color.a<0.0) then
    begin
    par.Age:=-2;
    end;

    Accel.x := Par.Location.x - FLocation.x;
    Accel.y := Par.Location.y - FLocation.y;




    Accel:=VectorNormalize(Accel);
    Accel2 := Accel;
    Accel.x:=Accel.x*Par.RadialAccel;
    Accel.y:=Accel.y*Par.RadialAccel;


    Ang := Accel2.X;
    Accel2.X := -Accel2.Y;
    Accel2.Y := Ang;




    Accel2.x:=Accel2.x*Par.TangentialAccel;
    Accel2.y:=Accel2.y*Par.TangentialAccel;

    Par.Velocity.x:=Par.Velocity.x+(Accel.x + Accel2.x) * DeltaTime;
    Par.Velocity.y:=Par.Velocity.y+(Accel.y + Accel2.y) * DeltaTime;

    Par.Velocity.Y := Par.Velocity.Y + (Par.Gravity * DeltaTime);

    Par.Location.x:=Par.Location.x+(Par.Velocity.x * DeltaTime);
    Par.Location.y:=Par.Location.y+(Par.Velocity.y * DeltaTime);


    Par.Spin := Par.Spin + (Par.SpinDelta * DeltaTime);

    Par.Size := Par.Size + (Par.SizeDelta * DeltaTime);

    Par.Color.r := Par.Color.r + (Par.ColorDelta.r * DeltaTime);
    Par.Color.g := Par.Color.g + (Par.ColorDelta.g * DeltaTime);
    Par.Color.b := Par.Color.b + (Par.ColorDelta.b * DeltaTime);
    Par.Color.a := Par.Color.a + (Par.ColorDelta.a * DeltaTime);


    Inc(Par);
    Inc(I);
  end;


	// generate new particles
  if (FAge <> -2) then
   begin
    ParticlesNeeded := FInfo.Emission * DeltaTime + FEmissionResidue;
    ParticlesCreated := Trunc(ParticlesNeeded);
    FEmissionResidue := ParticlesNeeded - ParticlesCreated;

    Par := @FParticles[FParticlesAlive];

    for I := 0 to ParticlesCreated - 1 do
    begin
      if (FParticlesAlive >= MAX_PARTICLES) then
        Break;



      Par.Age := 0;
      Par.TerminalAge := RandomS(FInfo.ParticleLifeMin,FInfo.ParticleLifeMax);

      Par.Location.x := FPrevLocation.x + (FLocation.x - FPrevLocation.x)* RandomS(0.0,1.0);
      Par.Location.y := FPrevLocation.y + (FLocation.y - FPrevLocation.y)* RandomS(0.0,1.0);


      Par.Location.X := Par.Location.X + Randoms(-2.0,2.0);
      Par.Location.Y := Par.Location.Y + Randoms(-2.0,2.0);

      Ang := FInfo.Direction - M_PI_2 + randoms(0,FInfo.Spread)- FInfo.Spread / 2;

      if (FInfo.Relative) then
      begin
        V.x := FPrevLocation.x - FLocation.x;
        V.y := FPrevLocation.y - FLocation.y;
        Ang := Ang + (VectorAngle1(V) + M_PI_2);
      end;
      Par.Velocity.X := Cos(Ang);
      Par.Velocity.Y := Sin(Ang);
      Par.Velocity.x:=Par.Velocity.x*RandomS(FInfo.SpeedMin,FInfo.SpeedMax);
      Par.Velocity.y:=Par.Velocity.y*RandomS(FInfo.SpeedMin,FInfo.SpeedMax);


      Par.Gravity := RandomS(FInfo.GravityMin,FInfo.GravityMax);
      Par.RadialAccel :=RandomS(FInfo.RadialAccelMin,FInfo.RadialAccelMax);
      Par.TangentialAccel := RandomS(FInfo.TangentialAccelMin,FInfo.TangentialAccelMax);

      Par.Size := RandomS(FInfo.SizeStart,FInfo.SizeStart+ (FInfo.SizeEnd - FInfo.SizeStart) * FInfo.SizeVar);
      Par.SizeDelta := (FInfo.SizeEnd - Par.Size) / Par.TerminalAge;

      Par.Spin := RandomS(FInfo.SpinStart,FInfo.SpinStart+ (FInfo.SpinEnd - FInfo.SpinStart) * FInfo.SpinVar);
      Par.SpinDelta := (Finfo.SpinEnd - Par.Spin) / Par.TerminalAge;

      Par.Color.R := RandomS(FInfo.ColorStart.R,FInfo.ColorStart.R+ (FInfo.ColorEnd.R - FInfo.ColorStart.R) * FInfo.ColorVar);
      Par.Color.G := RandomS(FInfo.ColorStart.G,FInfo.ColorStart.G+ (FInfo.ColorEnd.G - FInfo.ColorStart.G) * FInfo.ColorVar);
      Par.Color.B := RandomS(FInfo.ColorStart.B,FInfo.ColorStart.B+ (FInfo.ColorEnd.B - FInfo.ColorStart.B) * FInfo.ColorVar);
      Par.Color.A := RandomS(FInfo.ColorStart.A,FInfo.ColorStart.A+ (FInfo.ColorEnd.A - FInfo.ColorStart.A) * FInfo.ColorVar);

      Par.ColorDelta.R := (FInfo.ColorEnd.R - Par.Color.R) / Par.TerminalAge;
      Par.ColorDelta.G := (FInfo.ColorEnd.G - Par.Color.G) / Par.TerminalAge;
      Par.ColorDelta.B := (FInfo.ColorEnd.B - Par.Color.B) / Par.TerminalAge;
      Par.ColorDelta.A := (FInfo.ColorEnd.A - Par.Color.A) / Par.TerminalAge;


      Inc(FParticlesAlive);
      Inc(Par);
    end;
  end;
  FPrevLocation := FLocation;
end;


destructor TSMEParticleManager.Destroy;
begin
  KillAll;
  inherited;
end;

procedure TSMEParticleManager.GetTransposition(out DX, DY: Single);
begin
  DX := FTX;
  DY := FTY;
end;

function TSMEParticleManager.IsPSAlive(const PS: TSMEParticleSystem): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to FNPS - 1 do
    if (FPSList[I] = PS) then
      Exit;
  Result := False;
end;

procedure TSMEParticleManager.KillAll;
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I] := nil;
  FNPS := 0;
end;

procedure TSMEParticleManager.KillPS(const PS: TSMEParticleSystem);
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do begin
    if (FPSList[I] = PS) then begin
      FPSList[I] := FPSList[FNPS - 1];
      Dec(FNPS);
      Exit;
    end;
  end;
end;

procedure TSMEParticleManager.Render;
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I].Render;
end;

function TSMEParticleManager.SpawnPS(const PSI: TSMEParticleSystemInfo; const X,  Y: Single): TSMEParticleSystem;
begin
  if (FNPS = MAX_PSYSTEMS) then
    Result := nil
  else begin
    FPSList[FNPS] := TSMEParticleSystem.Create(PSI);
    FPSList[FNPS].FireAt(X,Y);
    FPSList[FNPS].Transpose(FTX,FTY);
    Result := FPSList[FNPS];
    Inc(FNPS);
  end;
end;

procedure TSMEParticleManager.Transpose(const X, Y: Single);
var
  I: Integer;
begin
  for I := 0 to FNPS - 1 do
    FPSList[I].Transpose(X,Y);
  FTX := X;
  FTY := Y;
end;

procedure TSMEParticleManager.Update(const DT: Single);
var
  I: Integer;
begin
  I := 0;
  while (I < FNPS) do begin
    FPSList[I].Update(DT);
    if (FPSList[I].GetAge = -2) and (FPSList[I].GetParticlesAlive = 0) then
    begin
      FPSList[I] := FPSList[FNPS - 1];
      Dec(FNPS);
      Dec(I);
    end;
    Inc(I);
  end;
end;


constructor TSMECloud.Create;
begin
numPrims :=0;
fspriteSheet:=TSMESpriteSheet.Create;
fspriteSheet.load(spriteSheet);
invTexWidth :=1.0/fSpriteSheet.getImage.widthTex;
invTexHeight:=1.0/fSpriteSheet.getImage.heightTex;
//setlength(Vertices,numRenders+1);
FillChar(Vertices,SizeOf(Vertices),0);



end;
destructor TSMECloud.Destroy;
begin
fspriteSheet.Destory;
buffer:=nil;
FillChar(Vertices,0,0);
end;
procedure TSMECloud.BeginRender(blend:integer);
begin
numPrims:=0;
buffer:=smeBeginCloud(SMEPRIM_QUADS, FSpriteSheet.texture,blend);

end;
procedure TSMECloud.EndRender();
begin
Move(Vertices,buffer^,numPrims * 4 * SizeOf(HGEVertex));
smeEndCloud(numPrims  );
buffer:=nil;
end;


//***************************

procedure  TSMECloud.draw (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;r:tsdl_rect; flipX,flipY:boolean;color:Uint32);
var
u,v,u2,v2,fx2,fy2,tmp:single;
worldOriginX,worldOriginY,fx,fy:single;
    p1x,p1y,p2x,p2y,
    p3x,p3y,p4x,p4y:single;
    x1,y1,x2,y2,x3,y3,x4,y4:single;
   acos,asin:single;
begin
		 u := r.x * invTexWidth;
		 v := (r.y + r.h) * invTexHeight;
		 u2 := (r.x + r.w) * invTexWidth;
		 v2 := r.y * invTexHeight;

		// bottom left and top right corner points relative to origin
	 worldOriginX := x + originX;
	 worldOriginY := y + originY;
	 fx := -originX;
	 fy := -originY;
	 fx2 := width - originX;
	 fy2 := height - originY;

		// scale
		if (scaleX <> 1) or (scaleY <> 1) then
    begin
			fx :=fx* scaleX;
			fy :=fy* scaleY;
			fx2 :=fx2* scaleX;
			fy2 :=fy* scaleY;
		end;


		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


		// rotate
		if (rotation <>0) then
    begin
			 acos := cos(rotation);
			 asin := sin(rotation);

			x1 := acos * p1x - asin * p1y;
			y1 := asin * p1x + acos * p1y;

			x2 := acos * p2x - asin * p2y;
			y2 := asin * p2x + acos * p2y;

			x3 := acos * p3x - asin * p3y;
			y3 := asin * p3x + acos * p3y;

			x4 := x1 + (x3 - x2);
			y4 := y3 - (y2 - y1);
		end else
    begin
			x1 := p1x;
			y1 := p1y;

			x2 := p2x;
			y2 := p2y;

			x3 := p3x;
			y3 := p3y;

			x4 := p4x;
			y4 := p4y;
		end;

		x1 :=x1+ worldOriginX;
		y1 :=y1+ worldOriginY;
		x2 :=x2+ worldOriginX;
		y2 :=y2+ worldOriginY;
		x3 :=x3+ worldOriginX;
		y3 :=y3+ worldOriginY;
		x4 :=x4+ worldOriginX;
		y4 :=y4+ worldOriginY;

		if (flipX) then
    begin
			 tmp := u;
			u := u2;
			u2 := tmp;
		end;

		if (flipY) then
    begin
			 tmp := v;
			v := v2;
			v2 := tmp;
		end;

		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x2;
		vertices[numPrims*4+1].y := y2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;



procedure  TSMECloud.draw (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;  srcX,  srcY,  srcWidth,  srcHeight:integer; flipX,flipY:boolean;color:Uint32);
var
u,v,u2,v2,fx2,fy2,tmp:single;
worldOriginX,worldOriginY,fx,fy:single;
    p1x,p1y,p2x,p2y,
    p3x,p3y,p4x,p4y:single;
    x1,y1,x2,y2,x3,y3,x4,y4:single;
   acos,asin:single;
begin
		 u := srcX * invTexWidth;
		 v := (srcY + srcHeight) * invTexHeight;
		 u2 := (srcX + srcWidth) * invTexWidth;
		 v2 := srcY * invTexHeight;

		// bottom left and top right corner points relative to origin
	 worldOriginX := x + originX;
	 worldOriginY := y + originY;
	 fx := -originX;
	 fy := -originY;
	 fx2 := width - originX;
	 fy2 := height - originY;

		// scale
		if (scaleX <> 1) or (scaleY <> 1) then
    begin
			fx :=fx* scaleX;
			fy :=fy* scaleY;
			fx2 :=fx2* scaleX;
			fy2 :=fy* scaleY;
		end;


		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


		// rotate
		if (rotation <>0) then
    begin
			 acos := cos(rotation);
			 asin := sin(rotation);

			x1 := acos * p1x - asin * p1y;
			y1 := asin * p1x + acos * p1y;

			x2 := acos * p2x - asin * p2y;
			y2 := asin * p2x + acos * p2y;

			x3 := acos * p3x - asin * p3y;
			y3 := asin * p3x + acos * p3y;

			x4 := x1 + (x3 - x2);
			y4 := y3 - (y2 - y1);
		end else
    begin
			x1 := p1x;
			y1 := p1y;

			x2 := p2x;
			y2 := p2y;

			x3 := p3x;
			y3 := p3y;

			x4 := p4x;
			y4 := p4y;
		end;

		x1 :=x1+ worldOriginX;
		y1 :=y1+ worldOriginY;
		x2 :=x2+ worldOriginX;
		y2 :=y2+ worldOriginY;
		x3 :=x3+ worldOriginX;
		y3 :=y3+ worldOriginY;
		x4 :=x4+ worldOriginX;
		y4 :=y4+ worldOriginY;

		if (flipX) then
    begin
			 tmp := u;
			u := u2;
			u2 := tmp;
		end;

		if (flipY) then
    begin
			 tmp := v;
			v := v2;
			v2 := tmp;
		end;

		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x2;
		vertices[numPrims*4+1].y := y2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;


procedure TSMECloud.draw(  x,  y,  width,  height:single;srcX, srcY, srcWidth, srcHeight:single; flipX, flipY:boolean;color:Uint32);
var
u,v,u2,v2,fx2,fy2,tmp:single;
begin
		 u := srcX * invTexWidth;
		 v := (srcY + srcHeight) * invTexHeight;
		 u2 := (srcX + srcWidth) * invTexWidth;
		 v2 := srcY * invTexHeight;
	   fx2 := x + width;
		 fy2 := y + height;

		if (flipX) then
    begin
			 tmp := u;
			u := u2;
			u2 := tmp;
		end;

		if (flipY) then
    begin
			 tmp := v;
			v := v2;
			v2 := tmp;
		end;

		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x;
		vertices[numPrims*4+1].y := fy2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;

procedure TSMECloud.draw(  x,  y,  width,  height:single;r:TSDL_Rect; flipX, flipY:boolean;color:Uint32);
var
u,v,u2,v2,fx2,fy2,tmp:single;
begin
		 u  := r.x * invTexWidth;
		 v2 := r.y * invTexHeight;
  	 u2 := (r.x + r.w) * invTexWidth;
		 v  := (r.y + r.h) * invTexHeight;




	   fx2 := x + width;
		 fy2 := y + height;

		if (flipX) then
    begin
			 tmp := u;
			u := u2;
			u2 := tmp;
		end;

		if (flipY) then
    begin
			 tmp := v;
			v := v2;
			v2 := tmp;
		end;

		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x;
		vertices[numPrims*4+1].y := fy2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;
procedure TSMECloud.draw(  x,  y,  width,  height:single;r:TSDL_Rect;color:Uint32) ;
var
u,v,u2,v2,fx2,fy2,tmp:single;
begin
		 u  := r.x * invTexWidth;
		 v2 := r.y * invTexHeight;
  	 u2 := (r.x + r.w) * invTexWidth;
		 v  := (r.y + r.h) * invTexHeight;




	   fx2 := x + width;
		 fy2 := y + height;



		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x;
		vertices[numPrims*4+1].y := fy2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;
procedure TSMECloud.draw(  x,  y,width,height:single;color:Uint32) ;
var
u,v,u2,v2,fx2,fy2,tmp:single;
begin
		 u  := 0;
		 v2 := 1;
  	 u2 := 1;
		 v  := 0;




	   fx2 := x + width;
		 fy2 := y + height;



		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x;
		vertices[numPrims*4+1].y := fy2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;







constructor TSMEPoint.Create(x,y:single);
begin
self.x:=x;
self.y:=y;
end;
function TSMEPoint.lengt:single ;
begin
		result:=sqrt (x * x + y * y);
end;
function TSMEPoint.toString ():String ;
begin
		result:= '(' + ftos(x) + ', ' + ftos(y) + ')';
end;
function TSMEPoint.sub (v:TSMEPoint):TSMEPoint;
begin
		result:=TSMEPoint.Create(x - v.x, y - v.y);
end;
function TSMEPoint.add (v:TSMEPoint):TSMEPoint;
begin
	result:=TSMEPoint.Create(v.x + x, v.y + y);
end;
function TSMEPoint.Mul (v:TSMEPoint):TSMEPoint;
begin
	result:=TSMEPoint.Create(v.x * x, v.y * y);
end;

function TSMEPoint.distance (pt1:TSMEPoint; pt2:TSMEPoint):single;
var
dx,dy:single;
begin
		 dx := pt1.x - pt2.x;
		 dy := pt1.y - pt2.y;
		result:=sqrt (dx * dx + dy * dy);
end;
function TSMEPoint.equals (toCompare:TSMEPoint):Boolean;
begin
		result:= (toCompare.x = x) and  (toCompare.y = y);
end;
function TSMEPoint.interpolate (pt1:TSMEPoint; pt2:TSMEPoint; f:single):TSMEPoint;
begin
		result:= TSMEPoint.Create (pt2.x + f * (pt1.x - pt2.x), pt2.y + f * (pt1.y - pt2.y));
end;
procedure TSMEPoint.normalize (thickness:single);
var
norm:single;
begin

		if (x = 0) and  (y= 0) then exit else
    begin
			 norm := thickness / sqrt (x * x + y * y);
			x :=x* norm;
			y :=y* norm;

		end;
end;
procedure  TSMEPoint.offset (dx,dy:Single);
begin
		x :=x+ dx;
		y :=y+ dy;
end;
function TSMEPoint.polar (len, angle:Single):TSMEPoint;
begin
		result:=TSMEPoint.Create(len * cos (angle), len * sin (angle));
end;
procedure  TSMEPoint.setTo (x,y:single);
begin
		self.x := x;
		self.y := y;
end;

constructor TSMEMatrix.Create(a:Single = 1; b:Single = 0; c:Single = 0; d:Single = 1; tx:Single = 0; ty:Single = 0);
begin
    self.a := a;
		self.b := b;
		self.c := c;
		self.d := d;
		self.tx := tx;
		self.ty := ty;
end;

procedure TSMEMatrix.identity;
begin

		a := 1;
		b := 0;
		c := 0;
		d := 1;
		tx := 0;
		ty := 0;
end;
function TSMEMatrix.mult(m:TSMEMatrix):TSMEMatrix;
begin

result := TSMEMatrix.Create();

		result.a := a * m.a + b * m.c;
		result.b := a * m.b + b * m.d;
		result.c := c * m.a + d * m.c;
		result.d := c * m.b + d * m.d;

		result.tx := tx * m.a + ty * m.c + m.tx;
		result.ty := tx * m.b + ty * m.d + m.ty;

end;

procedure  TSMEMatrix.rotate (angle:Single);
var
tx1,c1,a1,acos,asin:single;

begin

		 acos := cos (angle);
		 asin := sin (angle);

		 a1 := a * acos - b * asin;
	   b  := a * asin + b * acos;
	   	a := a1;

		  c1 := c * acos - d * asin;
	  	d := c * asin + d * acos;
		  c := c1;

		 tx1 := tx * acos - ty * asin;
		 ty := tx * asin + ty * acos;
		 tx := tx1;
		
end;
procedure TSMEMatrix.setRotation (angle:Single; scale:Single = 1);
 begin
		a := cos (angle) * scale;
		c := sin (angle) * scale;
		b := -c;
		d := a;
	end;
	
	
procedure  TSMEMatrix.setTo (a:Single; b:Single; c:Single; d:Single; tx:Single; ty:Single);
 begin
		self.a := a;
		self.b := b;
		self.c := c;
		self.d := d;
		self.tx := tx;
		self.ty := ty;
	end;


 function TSMEMatrix.toString ():String;
 begin

		result:= '(a:=' + ftos(a) + ', b:=' + ftos(b) + ', c:=' + ftos(c) + ', d:=' + ftos(d) + ', tx:=' + ftos(tx) + ', ty:=' + ftos(ty) + ')';

	end;

   function TSMEMatrix.transformPoint (point:hvector):hvector;
   begin
 	  result.x:=(point.x * a + point.y * c + tx);
    result.y:=(point.x * b + point.y * d + ty);
    //result.setTo(point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
	 end;

	 function TSMEMatrix.transformPoint (point:TSMEPoint):TSMEPoint;
   begin
 	  result:=TSMEPoint.Create (point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
    //result.setTo(point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
	 end;

	 procedure TSMEMatrix.copyFrom (other:TSMEMatrix);
   begin

		self.a := other.a;
		self.b := other.b;
		self.c := other.c;
		self.d := other.d;
		self.tx := other.tx;
		self.ty := other.ty;
		
	end;
	 procedure TSMEMatrix.translate (x:Single; y:Single);
   begin

		tx :=tx+ x;
		ty :=ty+ y;
		
	end;
	

	

procedure TSMEMatrix.scale (x:Single; y:Single);
begin

		a :=a* x;
		b :=b* y;

		c :=c* x;
		d :=d* y;

		tx :=tx* x;
		ty :=ty* y;



	end;

procedure TSMEMatrix.skew(skewX, skewY:single);
var
sinx,siny,cosx,cosy:single;
begin

             sinX:= sin(skewX);
             cosX:= cos(skewX);
             sinY:= sin(skewY);
             cosY:= cos(skewY);
            
            setTo(a  * cosY - b  * sinX,
                         a  * sinY + b  * cosX,
                         c  * cosY - d  * sinX,
                         c  * sinY + d  * cosX,
                         tx * cosY - ty * sinX,
                         tx * sinY + ty * cosX);
end;
	
  function TSMEMatrix.invert ():TSMEMatrix;
  var
  a1,tx1,norm:single;
   begin

		norm := a * d - b * c;

		if (norm = 0) then
    begin

			a :=0;
      b := 0;
      c := 0;
      d := 0;
			tx := -tx;
			ty := -ty;

		end else
    begin
			
			norm := 1.0 / norm;
			 a1 := d * norm;
			d := a * norm;
			a := a1;
			b :=b* -norm;
			c :=c* -norm;

			 tx1 := - a * tx - c * ty;
			ty := - b * tx - d * ty;
			tx := tx1;

		end;

		result:= self;
		
	end;

  function TSMEMatrix.clone ():TSMEMatrix ;
  begin

		result:= TSMEMatrix.Create(a, b, c, d, tx, ty);

	end;

   	
	procedure TSMEMatrix.concat (m:TSMEMatrix);
  var
  a1,c1,tx1:single;
  begin
		
		 a1 := a * m.a + b * m.c;
		 b := a * m.b + b * m.d;
		 a := a1;

		 c1 := c * m.a + d * m.c;
		d := c * m.b + d * m.d;

		c := c1;

	 tx1 := tx * m.a + ty * m.c + m.tx;
		ty := tx * m.b + ty * m.d + m.ty;
		tx := tx1;

	end;

procedure TSMERect.Clear;
begin
  FClean := True;
end;

procedure TSMERect.init(const AX1, AY1, AX2, AY2: Single);
begin
  SetRect(AX1,AY1,AX2,AY2);
end;

procedure TSMERect.init(const Clean: Boolean);
begin
  SetRect(0,0,0,0);
  FClean := Clean;
end;

procedure TSMERect.Encapsulate(const X, Y: Single);
begin
  if (FClean) then begin
    X1 := X;
    X2 := X;
    Y1 := Y;
    Y2 := Y;
    FClean := False;
  end else begin
    if (X < X1) then
      X1 := X;
    if (X > X2) then
      X2 := X;
    if (Y < Y1) then
      Y1 := Y;
    if (Y > Y2) then
      Y2 := Y;
  end;
end;

function TSMERect.Intersect(const Rect: TSMERect): Boolean;
begin
  Result := (Abs(X1 + X2 - Rect.X1 - Rect.X2) < (X2 - X1 + Rect.X2 - Rect.X1))
        and (Abs(Y1 + Y2 - Rect.Y1 - Rect.Y2) < (Y2 - Y1 + Rect.Y2 - Rect.Y1));
end;
function TSMERect.Intersect(const Rect: TSDL_rect): Boolean;
begin
  Result := (Abs(X1 + X2 - Rect.X - Rect.w) < (X2 - X1 + Rect.w - Rect.X))
        and (Abs(Y1 + Y2 - Rect.Y - Rect.h) < (Y2 - Y1 + Rect.h - Rect.Y));
end;
procedure TSMERect.draw(color:integer);
begin

 smeRenderLine(x1,y1,x2,y1,color);
 smeRenderLine(x1,y2,x2,y2,color);

 smeRenderLine(x1,y1,x1,y2,color);
 smeRenderLine(x2,y1,x2,y2,color);

 // Gfx_RenderRect(x1,y1,x2,y2,1,0,0,0);

end;


function TSMERect.IsClean: Boolean;
begin
  Result := FClean;
end;

procedure TSMERect.SetRadius(const X, Y, R: Single);
begin
  X1 := X - R;
  X2 := X + R;
  Y1 := Y - R;
  Y2 := Y + R;
  FClean := False;
end;

procedure TSMERect.SetRect(const AX1, AY1, AX2, AY2: Single);
begin
  X1 := AX1;
  Y1 := AY1;
  X2 := AX2;
  Y2 := AY2;
  FClean := False;
end;

function TSMERect.TextPoint(const X, Y: Single): Boolean;
begin
  Result := (X >= X1) and (X < X2) and (Y >= Y1) and (Y < Y2);
end;

constructor TSMESpriteSheet.Create();
begin
regions:=TSMERegionList.Create;
matrix:=TSMEMatrix.Create;
end;
destructor TSMESpriteSheet.Destory();
begin
matrix.Destroy;
regions.Destroy;
if (assigned(texture)) then smeFreeTexture(texture);
end;
function TSMESpriteSheet.getImage:PSDL_Texture;
begin
if assigned(texture) then result:= texture else result:=nil;
end;
function TSMESpriteSheet.count:integer;
begin
result:=regions.Count;
end;
procedure TSMESpriteSheet.draw(
        graph:integer;
        x,y,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword;blend:integer);
var
TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;
  pa,pb:TSMEPoint;

l,t,r,b,   texw,texh:single;
        PivotX,
        PivotY:single;
clipping:TSdl_rect;
region:TSMERegion;
begin

        region:=get(graph);

        Pivotx:=region.frameX;
        PivotY:=region.frameY;
        clipping:=region.clip;


    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


		l := clipping.x / texture.widthtex;//l:=l*texw;
		t := clipping.y / texture.heighttex;//t:=t*texh;
		r := (clipping.x + clipping.w) / texture.widthtex;//t:=t*texw;
		b := (clipping.y + clipping.h) / texture.heighttex;//b:=b*texh;


    TempX1 := 0;
    TempY1 := 0;
    TempX2 := clipping.w ;
    TempY2 := clipping.H ;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;



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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  matrix:=TSMEMatrix.Create();
  matrix.identity;
  matrix.scale(scaleX,scaleY);
 	if ((SkewX <> 0.0) or (SkewY <> 0.0)) then
  begin
   matrix.skew(SkewX,SkewY);
  end;
  matrix.rotate(rotation);
  matrix.translate(x,y);
  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     Matrix.tx := x - Matrix.a * PivotX  - Matrix.c * PivotY;
     Matrix.ty := y - Matrix.b * PivotX  - Matrix.d * PivotY;
  end;



  for i:=0 to 3 do
  begin
   pa:=TSMEPoint.Create(FQuad.V[i].X,FQuad.V[i].Y);
   pb:=matrix.transformPoint(pa);
   FQuad.V[i].X:=pb.x;
   FQuad.V[i].Y:=pb.y;
  end;

  smeRenderQuad(@fquad);
end;



procedure TSMESpriteSheet.load(fname:string);
var
 region:TSMERegion;
child,node,doc:pointer;
value:integer;
s:string;
begin
      if (not assigned(images)) then
      begin
      smeTerminate('image list not created');
      exit;
      end;

  doc:=smeLoadDocFromFile(pchar(fname));
  if assigned(doc) then
  begin
  node:=smeFirstNodeChildByName(doc,'TextureAtlas');
  s:=smeGetAttribute(node,'imagePath');
  s:=file_GetDirectory(fname)+s;
  texture :=images.LoadTexture(s);


  child:=smeFirstNodeChildByName(node,'SubTexture');
  while (child<>nil) do
  begin
   region:=TSMERegion.Create;
   region.texture:=texture;
   region.name:=file_GetName(smeGetAttribute(child,'name'));
   smeGetIntAttribute(child,'x',value);
   region.x:=value;
   region.clip.x:=value;
   smeGetIntAttribute(child,'y',value);
   region.y:=value;
   region.clip.y:=value;
   smeGetIntAttribute(child,'width',value);
   region.width:=value;
   region.clip.w:=value;
   smeGetIntAttribute(child,'height',value);
   region.height:=value;
   region.clip.h:=value;
   smeGetIntAttribute(child,'frameX',value);
   region.frameX:=value;
   smeGetIntAttribute(child,'frameY',value);
   region.frameY:=value;
   smeGetIntAttribute(child,'frameWidth',value);
   region.frameWidth:=value;
   smeGetIntAttribute(child,'frameHeight',value);
   region.frameHeight:=value;
   addRegion(region);
   child:=smeGetNextNodeSibling(child);
  end;
  smeFreeDoc(doc);
 end;

end;

function TSMESpriteSheet.addRegion(region:TSMERegion):integer;
begin
regions.Add(region);
result:=regions.Count-1;
//writeln(result);
end;
function TSMESpriteSheet.get(index:integer):TSMERegion;
begin
result:=regions.Get(index);
end;
function TSMESpriteSheet.get(serch:string):TSMERegion;
begin
if (regions.Exists(serch)) then
begin
result:=regions.Find(serch);
end else
result :=nil;
end;
procedure TSMESpriteSheet.splite(tileWidth,tileHeight:integer);
begin
end;




Function FindWordInString(sWordToFind, sTheString : String): Integer;
var
i : Integer;
begin
Result := 0;

for i:=1 to Length(sTheString) do
 begin
if Copy(sTheString,i,Length(sWordToFind)) = sWordToFind then
begin
if (NOT (sTheString[i-1] IN ['a'..'z','A'..'Z','0'..'9'])) and
   (NOT (sTheString[i+Length(sWordToFind)] IN ['a'..'z','A'..'Z','0'..'9'])) then
begin
Result := i;
break;
end;
end;
end;
end;

function TSMESpriteSheet.getList(name:string):TSMERegionList;
var
i:integer;
region:TSMERegion;
begin
result:=TSMERegionList.Create;
for i:=0 to regions.Count-1 do
begin
Region:=regions.Get(i);
if (FindWordInString(name,region.name)>=1) then
begin
//writeln(region.name);
result.Add(region);
end;
end;

end;

procedure TSMERegion.Load(fname:string);
begin
      if (not assigned(images)) then
      begin
      smeTerminate('image list not created');
      exit;
      end;

      
name:=fname;
 x:=0;
 y:=0;
 texture:=   images.LoadTexture(name);
 width:=texture.width;
 height:=texture.height;
 frameX:=0;
 frameY:=0;
 frameWidth:=width;
 Frameheight:=height;
 clip:=SDL_Rect(0,0,texture.width,texture.height);

end;
procedure TSMERegion.setFromTexture(tex:PSDL_Texture);
begin
 name:='create';
 x:=0;
 y:=0;
 texture:=tex;
 width:=texture.width;
 height:=texture.height;
 frameX:=0;
 frameY:=0;
 frameWidth:=width;
 Frameheight:=height;
 clip:=SDL_Rect(0,0,texture.width,texture.height);
end;



function TSMERegionList.Get( Index : Integer ) : TSMERegion;
begin
  Result := inherited Get( Index );
end;

procedure TSMERegionList.Put( Index : Integer; Item : TSMERegion );
begin
  inherited Put( Index, Item );
end;
function TSMERegionList.Add(Obj: TSMERegion): TSMERegion;
begin
//writeln(obj.name);
  Result := TSMERegion(inherited Add(Pointer(Obj)));
end;

procedure TSMERegionList.Del(Idx: Integer);
begin
  TSMERegion(Items[Idx]).Free;
  inherited;
end;
function TSMERegionList.Exists(name:string):boolean;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
  result:=true;
  end else
  begin
  result:=false;
  end;
end;
function TSMERegionList.Find(const Name: string): TSMERegion;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
    result:=Items[Index]
  end ;
end;
function TSMERegionList.GetContains(Name: String): Boolean;
begin
  Result:=IndexOf(Name) <> -1 ;
end;

procedure TSMERegionList.Clear;
var
  i : Integer;
begin
  for i := 0 to Count - 1 do
    TSMERegion(Items[i]).Destroy;
  inherited;
end;
destructor TSMERegionList.Destroy();
begin
clear;
inherited;
end;


//------------------------------------------------------------------------------
function TSMERegionList.IndexOf(Item: TSMERegion): Integer;
begin
  Result:=inherited IndexOf(Item);
end;

//------------------------------------------------------------------------------
function TSMERegionList.IndexOf(const Name: String): Integer;
var x: Integer;
begin
  Result:=-1;
  For x:=0 to Count - 1 do
  IF Items[x].Name = Name then
   begin
    Result:=x;
    Exit;
  end;
end;

//*****************************************************************

function TSMEModelList.Get( Index : Integer ) : TSMEModel;
begin
  Result := inherited Get( Index );
end;

procedure TSMEModelList.Put( Index : Integer; Item : TSMEModel );
begin
  inherited Put( Index, Item );
end;
function TSMEModelList.Add(Obj: TSMEModel): TSMEModel;
begin
//writeln(obj.name);
  Result := TSMEModel(inherited Add(Pointer(Obj)));
end;

procedure TSMEModelList.Del(Idx: Integer);
begin
  TSMEModel(Items[Idx]).Free;
  inherited;
end;
function TSMEModelList.Exists(name:string):boolean;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
  result:=true;
  end else
  begin
  result:=false;
  end;
end;
function TSMEModelList.Find(const Name: string): TSMEModel;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
    result:=Items[Index]
  end ;
end;
function TSMEModelList.GetContains(Name: String): Boolean;
begin
  Result:=IndexOf(Name) <> -1 ;
end;

procedure TSMEModelList.Clear;
var
  i : Integer;
begin
  for i := 0 to Count - 1 do
  TSMEModel(Items[i]).Destroy;
  inherited;
end;
destructor TSMEModelList.Destroy();
begin
clear;
inherited;
end;



function TSMEModelList.IndexOf(Item: TSMEModel): Integer;
begin
  Result:=inherited IndexOf(Item);
end;

//------------------------------------------------------------------------------
function TSMEModelList.IndexOf(const Name: String): Integer;
var x: Integer;
begin
  Result:=-1;
  For x:=0 to Count - 1 do
  IF Items[x].Name = Name then
   begin
    Result:=x;
    Exit;
  end;
end;


procedure  TSMEShapeRender.color (r,g,b,a:single);
begin
		colors[idxCols].r := r;
    		colors[idxCols].g := g;
        		colors[idxCols].b := b;
            		colors[idxCols].a := a;
    inc(idxCols);
end;
procedure TSMEShapeRender.vertex (x,y,z:single);
begin
Vertices[numVertices].x := x;
Vertices[numVertices].y := y;
Vertices[numVertices].z := z;
inc(numVertices);
end;


constructor TSMEShapeRender.Create(maxSprites:integer);
begin
SetMaxVertices(maxSprites);
maxVertices := maxSprites;
end;

//------------------------------------------------------------------------------
destructor TSMEShapeRender.Destroy;
begin
     setlength(Vertices ,0);
     setlength(Colors,0);
end;

procedure TSMEShapeRender.BeginBatch(primitive: Cardinal);
begin
		primitiveType := primitive;
		numVertices := 0;
		idxPos := 0;
		idxCols := 0;

end;
procedure TSMEShapeRender.EndBatch;
begin
{    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer    (3, GL_FLOAT, sizeof(Vector3f), @Vertices[0]);
    glColorPointer     (4, GL_FLOAT, sizeof(Color4f), @Colors[0]);
    glDrawArrays(primitiveType, 0, numVertices);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    }
end;

procedure TSMEShapeRender.Render(count:integer;Mode: Cardinal);
begin
   { glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer    (3, GL_FLOAT, sizeof(Vector3f), @Vertices[0]);
    glColorPointer     (4, GL_FLOAT, sizeof(Color4f), @Colors[0]);
    glDrawArrays(Mode, 0, count);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    }
end;


//------------------------------------------------------------------------------
procedure TSMEShapeRender.SetMaxVertices(count:integer);
begin
    countvertex :=count;
     setlength(Vertices ,countvertex*sizeof(Vector3f));
     setlength(Colors   ,countvertex*sizeof(Color4f));

end;

//**************************************************
constructor TSMECamera.Create(width,heigth:integer;worldWidth,worldHeigth:single);
begin
bound.SetRect(0,0,worldWidth,worldHeigth);
FScreenWidth:=width;
FScreenHeight:=heigth;
x:=0;
y:=0;
zoom:=1;
ftarget:=nil;
end;



procedure TSMECamera.Update();
begin
    if assigned(ftarget) then
    begin

			 	x := (ftarget.x + ftarget.width / 2 - FScreenWidth / (2 * zoom));
			 	y := (ftarget.y + ftarget.height /2 - FScreenHeight / (2 * zoom));

		 		x := clamp(x, bound.X1, bound.x2 - FScreenWidth / zoom);
		 		y := clamp(y, bound.y1, bound.y2 - FScreenHeight / zoom);

  //  	 	x := (ftarget.x + (ftarget.width / 2) - (FScreenWidth  / 2));
	 //		 	y := (ftarget.y + (ftarget.height /2) - (FScreenHeight / 2));

		 //		x := clamp(x, bound.X1, bound.x2 + FScreenWidth );
		 //		y := clamp(y, bound.y1, bound.y2 + FScreenHeight );

    end else
    begin
     	 		x := clamp(x, bound.X1, bound.x2 - FScreenWidth / zoom);
		 	  	y := clamp(y, bound.y1, bound.y2 - FScreenHeight / zoom);

    end;


   // Gfx_RenderRect(bound.x1,bound.y1,bound.x2,bound.y2,1,0,1,0);

end;
procedure TSMECamera.setFollow(target:TSMEModel);
begin
ftarget:=target;
end;
procedure TSMECamera.setView(screenWidth,screenHeight:integer);
begin
self.FScreenWidth:=screenWidth;
self.FScreenHeight:=screenHeight;
end;
procedure TSMECamera.setWorldBound(minx,miny,maxx,maxy:single);
begin
self.bound.SetRect(minx,miny,maxx,maxy);
end;
//************************************
Constructor TSMEEntity.Create(region:TSMERegion);
begin
        inherited create();
        self.region:=region;
        x:=0;
        y:=0;
        if (not Assigned(region)) then smeTerminate(region.name+' is null');
        if (not Assigned(region.texture)) then smeTerminate(region.name+' texture is null');

        texture:=region.texture;
        clipping:=region.clip;
        width:=region.width;
        height:=region.height;
        PivotX:=region.frameX;
        PivotY:=region.frameY;
        ScaleX:=1;
        ScaleY:=1;
        Rotation:=0;
        SkewX:=0;
        SkewY:=0;
        flipX:=false;
        flipY:=false;
        Color:=$FFFFFFFF;
        blend:=BLEND_DEFAULT;
        immovable:=false;
        Reset();
        updateAbsolutePosition();
        setHitbox(trunc(width),trunc(height));
        colider:=false;
        name:=region.name;
        id:=0;

end;
constructor TSMEEntity.Create(x,y,w,h:integer);
begin
        inherited create();

        self.region:=nil;
        self.x:=x;
        self.y:=y;
        texture:=nil;
        width:=w;
        height:=h;
        PivotX:=0;
        PivotY:=0;
        ScaleX:=1;
        ScaleY:=1;
        Rotation:=0;
        SkewX:=0;
        SkewY:=0;
        Reset();
        immovable:=true;
        updateAbsolutePosition();
        setHitbox(trunc(width),trunc(height));
        colider:=true;
        name:='solid';
        id:=0;
        FDoAnimate:=false;
        FAnimLooped:=true;
        SetAnim(0,100,12,true);
end;


procedure TSMEEntity.setRegion(reg:TSMERegion;setorigin:boolean=false);
begin
        region:=reg;
        texture:=region.texture;
        clipping:=region.clip;
       // width:=region.width;
       // height:=region.height;
        if(setorigin) then
        begin
        PivotX:=region.frameX;
        PivotY:=region.frameY;
        end ;
     //   originWidth:=width;
    //    originHeight:=height;
       colider:=false;
end;
procedure TSMEEntity.setHitbox(newwidth,newheight:integer;neworiginX:integer = 0;neworiginY:integer = 0);
begin
			originWidth := newwidth;
			originheight := newheight;
			originX := neworiginX;
			originY := neworiginY;
end;
function  TSMEEntity.isTouching(Direction:integer):boolean;
begin
		result:= (touching and Direction) > NONE;
end;
function TSMEEntity.justTouched( Direction:integer):Boolean;
begin
		result:= ((touching and Direction) > NONE) and ((wasTouching and Direction) <= NONE);
end;

procedure TSMEEntity.Motion(dt:single);
var
delta,velocityDelta:single;
begin

       onFloor:=false;
       wasTouching := touching;
	 		touching := NONE;


		
		    last.x := x;
		   	last.y := y;
       pvelocity.x:=velocity.x;
        pvelocity.y:=velocity.y;

       {
      velocity.x := calculateVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x,dt);
			velocity.y := calculateVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y,dt);
			angularVelocity := calculateVelocity(angularVelocity, angularAcceleration, angularDrag, maxAngular,dt);

			x :=x+ (velocity.x * dt) + ((pvelocity.x - velocity.x) * dt / 2);
			y :=y+ (velocity.y * dt) + ((pvelocity.y - velocity.y) * dt / 2);
			angle :=angle +angularVelocity * dt;
         }


			velocityDelta := (computeVelocity(dt,angularVelocity,angularAcceleration,angularDrag,maxAngular) - angularVelocity)/2;
			angularVelocity :=angularVelocity+ velocityDelta;
			angle :=angle+ angularVelocity*dt;
			angularVelocity :=angularVelocity+ velocityDelta;

			velocityDelta := (computeVelocity(dt,velocity.x,acceleration.x,drag.x,maxVelocity.x) - velocity.x)/2;
			velocity.x :=velocity.x+ velocityDelta;
			delta := velocity.x*dt;
			velocity.x :=velocity.x+ velocityDelta;
			x :=x+ delta;

			velocityDelta := (computeVelocity(dt,velocity.y,acceleration.y,drag.y,maxVelocity.y) - velocity.y)/2;
			velocity.y :=velocity.y+ velocityDelta;
			delta := velocity.y*dt;
			velocity.y :=velocity.y+ velocityDelta;
			y :=y+ delta;
      
       //Center.x:=(sx - cx )+ (originWidth/2);
       //Center.y:=(sy - cy )+ (originHeight/2);

       Center.x:=x+ (originWidth/2);
       Center.y:=y+ (originHeight/2);

     

      


end ;

procedure TSMEEntity.hitTop(v:single);
begin
if(not fixed) then		velocity.y := V;

end;
procedure TSMEEntity.hitBottom(v:single);
begin
onFloor := true;
if(not fixed) then		velocity.y := V;
end;
procedure TSMEEntity.hitLeft(v:single);
begin
if(not fixed) then		velocity.x := V;
end;
procedure TSMEEntity.hitRight(v:single);
begin
if(not fixed) then		velocity.x := V;
end;

procedure TSMEEntity.OnColide(other:TSMEEntity);
begin
end;

 function TSMEEntity.Colide(newx,newy:single;e:TSMEEntity):boolean;
 begin
 if not assigned(e) then
 begin
 result:=false;
 exit;
 end;

   result:=  ( newx - originX + originwidth >  e.x - e.originX)
					and( newy - originY + originheight > e.y - e.originY)
					and( newx - originX < e.x - e.originX + e.originwidth)
					and( newy - originY < e.y - e.originY + e.originheight)



 end;

procedure TSMEEntity.Reset();
begin


  	 touching := NONE;
		 wasTouching := NONE;

			previous.x:=x;
      previous.y:=y;

      last.x:=x;
      last.y:=y;

			mass := 1.0;
			elasticity := 0.0;
      fixed:=true;
     // immovable:=true;

			velocity.x:=0;
      velocity.y:=0;
      pvelocity.x:=0;
      pvelocity.y:=0;

			acceleration.x:=0;
      acceleration.y:=0;



      moves:=true;

			drag.x:=0;
      drag.y:=0;
			maxVelocity.x:=1000;
      maxVelocity.y:=1000;

			angle := 0;
			angularVelocity := 0;
			angularAcceleration := 0;
			angularDrag := 0;
			maxAngular := 10000;

end;
procedure TSMEEntity.Update(dt:single);
begin
      inherited Update(dt);
      if(moves) then Motion(dt);


end;

procedure TSMEEntity.SetMirror(MirrorX, MirrorY: Boolean);
var
  TX, TY: Single;
begin
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
end;

procedure TSMEEntity.Animate(const MoveCount: Single);
begin

    if not FDoAnimate then Exit;

     case FAnimPlayMode of
          pmForward:
          begin
               FAnimPos := FAnimPos + FAnimSpeed * MoveCount;
               if (FAnimPos >= FAnimStart + FAnimCount ) then
               begin
                    if (Trunc(FAnimPos))= FAnimStart then OnAnimStart;
                    if (Trunc(FAnimPos)) = FAnimStart + FAnimCount then
                    begin
                         FAnimEnded := True;
                         OnAnimEnd;
                    end;

                    if FAnimLooped then
                       FAnimPos := FAnimStart
                    else
                    begin
                         FAnimPos := FAnimStart + FAnimCount-1 ;
                         FDoAnimate := False;
                    end;
               end;
               FPatternIndex := Trunc(FAnimPos);
    

          end;
          pmBackward:
          begin
               FAnimPos := FAnimPos - FAnimSpeed * MoveCount;
               if (FAnimPos < FAnimStart) then
               begin
                   if FAnimLooped then
                        FAnimPos := FAnimStart + FAnimCount
               else
               begin
                   // FAnimPos := FAnimStart;
                     FAnimPos := FAnimStart + FAnimCount;
                    FDoAnimate := False;
               end;
               end;
               FPatternIndex := Trunc(FAnimPos);
          end;
          pmPingPong:
          begin
               FAnimPos := FAnimPos + FAnimSpeed * MoveCount;
               if FAnimLooped then
               begin
                    if (FAnimPos > FAnimStart + FAnimCount - 1) or (FAnimPos < FAnimStart) then
                        FAnimSpeed := -FAnimSpeed;
               end
               else
               begin
                    if (FAnimPos > FAnimStart + FAnimCount) or (FAnimPos < FAnimStart) then
                         FAnimSpeed := -FAnimSpeed;
                    if (Trunc(FAnimPos)) = (FAnimStart + FAnimCount) then
                              FDoFlag1 := True;
                    if (Trunc(FAnimPos) = FAnimStart) and (FDoFlag1) then
                              FDoFlag2 := True;
                    if (FDoFlag1) and (FDoFlag2) then
                    begin
                         FDoAnimate := False;
                         FDoFlag1 := False;
                         FDoFlag2 := False;
                    end;
               end;
                   FPatternIndex := Round(FAnimPos);
          end;
     end;

 // SetPattern(FPatternIndex);

end;

procedure TSMEEntity.OnAnimStart;
begin
end;
procedure TSMEEntity.OnAnimEnd;
begin
end;

procedure TSMEEntity.SetAnim( AniStart, AniCount: Integer; AniSpeed: Single; AniLooped: Boolean;  PlayMode: TAnimPlayMode=pmForward);
begin
     FDoAnimate:=true;
     FAnimStart := AniStart;
     FAnimCount := AniCount;
     FAnimSpeed := AniSpeed;
     FAnimLooped:= AniLooped;
     FAnimPlayMode := PlayMode;
     if (FPatternIndex < FAnimStart) or (FPatternIndex >= FAnimCount + FAnimStart) then
     begin
          FPatternIndex := FAnimStart mod fanimcount;
          FAnimPos := FAnimStart;
     end;
     
end;

procedure TSMEEntity.Draw();
var

  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;

  i:integer;

 vect:hvector;
l,t,r,b,   texw,texh:single;

begin

 



if colider then
begin
//if (id=12) then
//Gfx_RenderRect(center.x,center.y,5,5,1,1,0,0);

//Gfx_RenderRect((sx - cx ),(sy - cy ) ,self.originWidth,self.originHeight,1,1,0,0);

//Gfx_RenderRect((sx - cx ) - originX,(sy - cy ) - originY,self.originWidth,self.originHeight,1,1,0,0);
//Gfx_RenderRect(x ,y ,Width,Height,1,1,1,0);

//sx - cx * scrollx, sy - cy * scrolly


exit;
end;


    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


		l := clipping.x / texture.widthtex;//l:=l*texw;
		t := clipping.y / texture.heighttex;//t:=t*texh;
		r := (clipping.x + clipping.w) / texture.widthtex;//t:=t*texw;
		b := (clipping.y + clipping.h) / texture.heighttex;//b:=b*texh;


    TempX1 := 0;
    TempY1 := 0;
    TempX2 := clipping.w ;
    TempY2 := clipping.H ;
    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;



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

  FQuad.Blend:=blend;
  FQuad.Tex:=texture;
  FQuad.V[0].X := TempX1; FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2; FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2; FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1; FQuad.V[3].Y := TempY2;

  SetMirror(flipx,flipy);

  Bound.Clear;

  for i:=0 to 3 do
  begin
   vect.x:=FQuad.V[i].X;
   vect.y:=FQuad.V[i].y;
   vect:=AbsoluteTransformation.transformPoint(vect);
   FQuad.V[i].X:=vect.x;
   FQuad.V[i].Y:=vect.y;
  end;

  smeRenderQuad(@fquad);


  inherited draw;


//Gfx_RenderRect((sx - cx ),(sy - cy ) ,self.originWidth,self.originHeight,1,0,1,0);

//Gfx_RenderRect(center.x,center.y,5,5,1,1,0,0);


// if(onFloor) then   Bound.draw($FFFF0000) else Bound.draw($FFFFFFFF);
// Bound.draw($FFFF00FF);
// Gfx_RenderRect((sx - cx ) - originX,(sy - cy ) - originY,self.originWidth,self.originHeight,1,1,0,0);


end;


{  TTileMapSprite  }
function ExtractNumberInString( sChaine: String ): String ;
var
i: Integer ;
begin
Result := '' ;
for i := 0 to length( sChaine ) do
begin
if sChaine[ i ] in ['0'..'9'] then
Result := Result + sChaine[ i ] ;
end ;
end;

function TSMETileMap.getClip(frame:integer):TSDL_Rect;
 var
 Left, Right, Top, Bottom: Integer;

begin
  Left := (frame mod ColCount) * 24;
  Right :=  24;
  Top := (frame div ColCount) * 24;
  Bottom := 24;
  result:=sdl_rect(left,top,right,bottom);
end;
constructor TSMETileMap.Create(  fname:string);
var
   MapWidth,mapheight:integer;

   countx,county: Integer;

datanode,layernode, objnode,objgroup, nodeimg, tilesnode, child,node,doc:pointer;
value:integer;
s:string;
cx, cy, c,gid: Integer  ;
ox,oy,ow,oh:integer;
begin





     inherited Create();
     X := 0;
     Y := 0;
    if assigned(GameCamera) then   camera:=GameCamera;

      if (not assigned(images)) then
      begin
      smeTerminate('image list not created');
      exit;
      end;
     

MapObject:=Tlist.Create;

  doc:=smeLoadDocFromFile(pchar(fname));
  if assigned(doc) then
  begin
  node:=smeFirstNodeChildByName(doc,'map');

  smeGetIntAttribute(node,'width',MapWidth);
  smeGetIntAttribute(node,'height',mapheight);
  smeGetIntAttribute(node,'tilewidth',frameWidth);
  smeGetIntAttribute(node,'tileheight',FrameHeight);
  SetMapSize(MapWidth,mapheight);

   tilesnode:=smeFirstNodeChildByName(node,'tileset');
   nodeimg:=smeFirstNodeChildByName(tilesnode,'image');
   s:=smeGetAttribute(nodeimg,'source');
   s:=file_GetDirectory(fname)+s;



   Ftexture :=images.LoadTexture(S);

   layernode:=smeFirstNodeChildByName(node,'layer');
   s:=smeGetAttribute(layernode,'name');



  datanode:=smeFirstNodeChildByName(layernode,'data');
  child:=smeFirstNodeChildByName(datanode,'tile');
  value:=0;
  while (child<>nil) do
  begin
   smeGetIntAttribute(child,'gid',gid);
   FMap[value]:=gid;
   inc(value);
   child:=smeGetNextNodeSibling(child);
  end;

  objgroup:=smeFirstNodeChildByName(node,'objectgroup');
  child:=smeFirstNodeChildByName(objgroup,'object');
  while (child<>nil) do
  begin
   smeGetIntAttribute(child,'x',ox);
   smeGetIntAttribute(child,'y',oy);
   smeGetIntAttribute(child,'width',ow);
   smeGetIntAttribute(child,'height',oh);
   s:=smeGetAttribute(child,'name');
   addOBJ(s,ox,oy,ow,oh);
   child:=smeGetNextNodeSibling(child);
  end;
  smeFreeDoc(doc);
 end;

 datanode:=nil;
 layernode:=nil;
 objnode:=nil;
 objgroup:=nil;
 nodeimg:=nil;
 tilesnode:=nil;
 child:=nil;
 node:=nil;
 doc:=nil;



     width:=frameWidth;
     height:=FrameHeight;
     countx:=ftexture.width  div frameWidth;
     county:=ftexture.height div FrameHeight;
     FDoTile:=false;
     FCountTiles:=countx*county;
     ColCount := fTexture.width div frameWidth;

invTexWidth :=1.0/ftexture.widthTex;
invTexHeight:=1.0/ftexture.heightTex;
FillChar(Vertices,SizeOf(Vertices),0);



  for cy := 0 to FMapHeight - 1 do
   begin
       for cx := 0 to FMapWidth - 1 do
          begin
        c := GetCell(cx , cy );
        SetCollisionMapItem(cx,cy,false);
        if (c<>0) then
        begin
        SetCollisionMapItem(cx,cy,true);
        end;
       end;
    end;



end;


constructor TSMETileMap.Create(texture:PSDL_Texture;frameWidth,FrameHeight,MapWidth,mapheight:integer);
var
move,ti,lx,ly,countx,county:integer;
begin
     inherited Create();
     X := 0;
     Y := 0;
     if not assigned(texture) then exit;
     width:=frameWidth;
     height:=FrameHeight;
     Ftexture:=texture;

     countx:=texture.width  div frameWidth;
     county:=texture.height div FrameHeight;

invTexWidth :=1.0/ftexture.widthTex;
invTexHeight:=1.0/ftexture.heightTex;
FillChar(Vertices,SizeOf(Vertices),0);


     FDoTile:=false;

     SetMapSize(MapWidth,mapheight);
     FCountTiles:=countx*county;

      MapObject:=Tlist.Create;
             if assigned(GameCamera) then   camera:=GameCamera;

    ColCount := Texture.width div frameWidth;
end;

destructor TSMETileMap.Destroy;
var
i:integer;
begin
      SetMapSize(0, 0);
      FillChar(Vertices,0,0);
      MapObject.Destroy;
     inherited Destroy;
end;

procedure TSMETileMap.Bounce(entity:TSMEEntity);
begin

end;
procedure TSMETileMap.addOBJ(name:string;ox,oy,ow,oh:integer);
var
obj:TMapObject;
begin
obj:=TMapObject.Create;
obj.name:=name;
obj.x:=ox;
obj.y:=oy;
obj.w:=ow;
obj.h:=oh;
MapObject.Add(obj);
//writeln('new OBJ:',ox,'<>',oy,'<>',ow,'<>',oh);

end;
function TSMETileMap.numObjs:integer;
begin
result:= MapObject.Count
end;
function TSMETileMap.getOBJ(index:integer):TMapObject;
begin
if MapObject.Count<0 then exit;
result:=MapObject.Items[index];
end;








function IsRectEmpty(const Rect: TSDL_Rect): Boolean;
begin
  Result := (Rect.w <= Rect.x) or (Rect.h <= Rect.y);
end;

function UnionRect(out Rect: TSDL_Rect; const R1, R2: TSDL_Rect): Boolean;
begin
  Rect := R1;
  if not IsRectEmpty(R2) then
  begin
    if R2.x < R1.x then Rect.x := R2.x;
    if R2.y < R1.y then Rect.y := R2.y;
    if R2.w > R1.w then Rect.w := R2.w;
    if R2.h > R1.h then Rect.h := R2.h;
  end;
  Result := not IsRectEmpty(Rect);
  if not Result then FillChar(Rect, SizeOf(Rect), 0);
end;


function OffsetRect(var Rect: TSDL_Rect; DX: Integer; DY: Integer): Boolean;
begin
  if @Rect <> nil then // Test to increase compatiblity with Windows
  begin
    Inc(Rect.x, DX);
    Inc(Rect.w, DX);
    Inc(Rect.y, DY);
    Inc(Rect.h, DY);
    Result := True;
  end
  else
    Result := False;
end;
function IntersectRect(out Rect: TSDL_Rect; const R1, R2: TSDL_Rect): Boolean;
begin
  Rect := R1;
  if R2.x > R1.x then Rect.x := R2.x;
  if R2.y > R1.y then Rect.y := R2.y;
  if R2.w < R1.w then Rect.w := R2.w;
  if R2.h < R1.h then Rect.h := R2.h;
  Result := not IsRectEmpty(Rect);
  if not Result then FillChar(Rect, SizeOf(Rect), 0);
end;
function Mod2(i, i2: Integer): Integer;
begin
     Result := i mod i2;
     if Result < 0 then
        Result := i2 + Result;
end;
//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TSDL_Rect): Boolean;
begin
 Result:= (Rect1.x < Rect2.w)and(Rect1.w > Rect2.x)and
  (Rect1.y < Rect2.h)and(Rect1.h > Rect2.y);
end;
function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TSDL_Rect;
begin
  with Result do
  begin
    x := ALeft;
    y := ATop;
    w := ALeft + AWidth;
    h :=  ATop + AHeight;
  end;
end;
function TSMETileMap.GetBoundsRect: TSDL_Rect;
begin
     if FDoTile then
          Result := sdl_Rect(0, 0,camera.FScreenWidth, camera.FScreenHeight)
     else
     begin
       Result := Bounds(Trunc(-camera.x - X), Trunc(-camera.y - Y),trunc(Width) * FMapWidth, trunc(Height) * FMapHeight)
     end;
end;

function TSMETileMap.Collision(Sprite: TSMEEntity;out bound:TSDL_Rect): Boolean;
var
 b, b1, b2: TSDL_Rect;
  cx, cy, ChipWidth, ChipHeight: Integer;
begin
     Result := True;
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;
     ChipWidth := trunc(Self.Width);
     ChipHeight := trunc(Self.Height);
     b1 := sdl_Rect(Trunc(Sprite.Bound.X1), Trunc(Sprite.Bound.Y1), Trunc(Sprite.Bound.X2),Trunc(Sprite.Bound.Y2));
     b2 := GetBoundsRect;

    IntersectRect(b, b1, b2);

//       Gfx_RenderSDLRect(b1,1,1,1);


     OffsetRect(b, -Trunc(camera.x), - Trunc(camera.Y));
     OffsetRect(b1, -Trunc(camera.x), - Trunc(camera.Y));

     bound:=sdl_rect(b.x,b.y,b.w,b.h);

     for cy := (b.y - ChipHeight + 1) div ChipHeight to b.h div ChipHeight do
     begin
          for cx := (b.x - ChipWidth+1) div ChipWidth to b.w div ChipWidth do
          begin
              if CollisionMap[Mod2(cx, MapWidth), Mod2(cy, MapHeight)] then
              begin
                   if OverlapRect(Bounds(cx * ChipWidth, cy * ChipHeight, ChipWidth, ChipHeight), b1) then Exit;
              end;
          end;
     end;

     Result := False;
end;

function TSMETileMap.TestCollision(Sprite: TSMEEntity): Boolean;
var
  b, b1, b2: TSDL_Rect;
  cx, cy, ChipWidth, ChipHeight: Integer;
begin
     Result := True;
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;
     ChipWidth := trunc(Self.Width);
     ChipHeight := trunc(Self.Height);
     b1 := sdl_Rect(Trunc(Sprite.X), Trunc(Sprite.Y), Trunc(Sprite.X) + trunc(Width),Trunc(Sprite.Y) + trunc(Height));
     b2 := GetBoundsRect;
  //   SDL_IntersectRect(@b1,@b2,@b);

    IntersectRect(b, b1, b2);

     OffsetRect(b, -Trunc(camera.x), - Trunc(camera.Y));
     OffsetRect(b1, -Trunc(camera.x), - Trunc(camera.Y));

     for cy := (b.y - ChipHeight + 1) div ChipHeight to b.h div ChipHeight do
     begin
          for cx := (b.x - ChipWidth+1) div ChipWidth to b.w div ChipWidth do
          begin
              if CollisionMap[Mod2(cx, MapWidth), Mod2(cy, MapHeight)] then
              begin
                   if OverlapRect(Bounds(cx * ChipWidth, cy * ChipHeight, ChipWidth, ChipHeight), b1) then Exit;
              end;
          end;
     end;

     Result := False;
end;

function TSMETileMap.place_meeting(posx,posy:single;Sprite: TSMEEntity): Boolean;
var
  _rect,b, b1, b2: TSDL_Rect;
  cx, cy, ChipWidth, ChipHeight: Integer;
  pointw,pointh,recty,pointx,pointy:integer;

begin

   ChipWidth := trunc(Self.Width);
   ChipHeight := trunc(Self.Height);

pointX:=trunc(posx+sprite.originX);
pointY:=trunc(posy+sprite.originY);
pointw:=trunc(sprite.originWidth);
pointh:=trunc(sprite.originHeight);

if (pointx<=0) then pointx:=0;
if (pointy<=0) then pointy:=0;


result:=
(
GetCollisionMapItem(pointx div ChipWidth,pointy div ChipHeight) or
GetCollisionMapItem((pointx+pointw) div ChipWidth,pointy div ChipHeight) or
GetCollisionMapItem(pointx div ChipWidth,(pointy+pointh) div ChipHeight) or
GetCollisionMapItem((pointx+pointw ) div ChipWidth,(pointy+pointh) div ChipHeight)
);


Gfx_RenderRect(pointx ,pointy ,5,5,0,1,1,0);
Gfx_RenderRect(pointx+pointw ,pointy ,5,5,0,0,1,0);
Gfx_RenderRect(pointx ,pointy+pointh ,5,5,0,0,1,0);
Gfx_RenderRect(pointx+pointw ,pointy+pointh ,5,5,0,0,1,0);

Gfx_RenderRect(pointx  div ChipWidth,pointy div ChipHeight ,5,5,0,1,1,0);
Gfx_RenderRect(pointx+pointw div ChipWidth ,pointy div ChipHeight,5,5,0,0,1,0);
Gfx_RenderRect(pointx div ChipWidth ,pointy+pointh div ChipHeight,5,5,0,0,1,0);
Gfx_RenderRect(pointx+pointw div ChipWidth ,pointy+pointh div ChipHeight ,5,5,0,0,1,0);

	 //	_rect.x := trunc(posx - sprite.x + sprite.originX);
	 //	_rect.y := trunc(posy - sprite.y + sprite.originY);



//    Gfx_RenderRect(pointX,pointy,rectX,rectY,1,0,1,0);



  {


     Result := True;
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;
     ChipWidth := trunc(Self.Width);
     ChipHeight := trunc(Self.Height);
 //  b1 := sdl_Rect(Trunc(posx+Sprite.Bound.X1), Trunc(posy+Sprite.Bound.Y1), Trunc(Sprite.Bound.X2),Trunc(Sprite.Bound.Y2));
   b1 := sdl_Rect(
   Trunc(posx),
   Trunc(posy),
   Trunc(posx+19),
   Trunc(posy+5));
//  b1 := sdl_Rect(Trunc(Sprite.X), Trunc(Sprite.Y), Trunc(Sprite.X) + trunc(Width),Trunc(Sprite.Y) + trunc(Height));

 //    result:=  ( newx - originX + originwidth >  e.x - e.originX)
	 //				and( newy - originY + originheight > e.y - e.originY)
		 //			and( newx - originX < e.x - e.originX + e.originwidth)
			 //		and( newy - originY < e.y - e.originY + e.originheight)


       b2 := GetBoundsRect;

    IntersectRect(b, b1, b2);

    // Gfx_RenderSDLRect(b1,1,1,1);
     Gfx_RenderSDLRect(b1,1,1,1);

 //    OffsetRect(b, -Trunc(camera.x), - Trunc(camera.Y));
 //    OffsetRect(b1, -Trunc(camera.x), - Trunc(camera.Y));

     for cy := (b.y - ChipHeight + 1) div ChipHeight to b.h div ChipHeight do
     begin
          for cx := (b.x - ChipWidth+1) div ChipWidth to b.w div ChipWidth do
          begin
               if CollisionMap[Mod2(cx, MapWidth), Mod2(cy, MapHeight)] then
              begin
                   if OverlapRect(Bounds(cx * ChipWidth, cy * ChipHeight, ChipWidth, ChipHeight), b1) then Exit;
              end;
          end;
     end;
      }
    // Result := False;
end;


function TSMETileMap.colide(Sprite: TSMEEntity): Boolean;
var
  _rect,b, b1, b2: TSDL_Rect;
  cx, cy, ChipWidth, ChipHeight: Integer;
  pointw,pointh,recty,pointx,pointy:integer;

begin

   ChipWidth := trunc(Self.Width);
   ChipHeight := trunc(Self.Height);


pointX:=trunc(sprite.x);
pointY:=trunc(sprite.y);
pointw:=trunc(sprite.originWidth);
pointh:=trunc(sprite.originHeight);


if (pointx<=0) then pointx:=0;
if (pointy<=0) then pointy:=0;


result:=
(
GetCollisionMapItem(pointx div ChipWidth,pointy div ChipHeight) or
GetCollisionMapItem((pointx+pointw) div ChipWidth,pointy div ChipHeight) or
GetCollisionMapItem(pointx div ChipWidth,(pointy+pointh) div ChipHeight) or
GetCollisionMapItem((pointx+pointw ) div ChipWidth,(pointy+pointh) div ChipHeight)
);


 

Gfx_RenderRect(pointx ,pointy ,5,5,0,1,1,0);
Gfx_RenderRect(pointx+pointw ,pointy ,5,5,0,0,1,0);
Gfx_RenderRect(pointx ,pointy+pointh ,5,5,0,0,1,0);
Gfx_RenderRect(pointx+pointw ,pointy+pointh ,5,5,0,0,1,0);

  {
Gfx_RenderRect(pointx  div ChipWidth,pointy div ChipHeight ,5,5,0,1,1,0);
Gfx_RenderRect(pointx+pointw div ChipWidth ,pointy div ChipHeight,5,5,0,0,1,0);
Gfx_RenderRect(pointx div ChipWidth ,pointy+pointh div ChipHeight,5,5,0,0,1,0);
Gfx_RenderRect(pointx+pointw div ChipWidth ,pointy+pointh div ChipHeight ,5,5,0,0,1,0);
}


end;


procedure TSMETileMap.RenderCloud;
var
   _x, _y, cx, cy, cx2, cy2, c, ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_,  dWidth, dHeight: Integer;
   r:TSDL_rect;
     buffer: PHGEVertexArray;

begin

     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;
        x:=0;
        y:=0;



     ChipWidth := trunc(Self.Width);
     ChipHeight :=trunc(Self.Height);

     dWidth  := (camera.FScreenWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (camera.FScreenHeight + ChipHeight) div ChipHeight + 1;

     _x := round(-camera.x - X);
     _y := round(-camera.y - Y);

     OfsX := _x mod ChipWidth;
     OfsY := _y mod ChipHeight;

     StartX := _x div ChipWidth;
     StartX_ := 0;

     if StartX < 0 then
     begin
          StartX_ := -StartX;
          StartX := 0;
     end;

     StartY := _y div ChipHeight;
     StartY_ := 0;

     if StartY < 0 then
     begin
          StartY_ := -StartY;
          StartY := 0;
     end;

     EndX := Mini(StartX + FMapWidth - StartX_, dWidth);
     EndY := Mini(StartY + FMapHeight - StartY_, dHeight);


numPrims:=0;
buffer:=smeBeginCloud(SMEPRIM_QUADS,Ftexture,BLEND_DEFAULT);



     if FDoTile then
     begin
          for cy := -1 to dHeight do
          begin
               cy2 := Mod2((cy - StartY + StartY_), FMapHeight);
               for cx := -1 to dWidth do
               begin
                    cx2 := Mod2((cx - StartX + StartX_), FMapWidth);
                    c := Cells[cx2, cy2];

if c >= 1 then
begin
r:=getClip(c-1);
//drawTile(cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,r,$FFFFFFFF);
 end;
               end;
          end;
     end
     else
     begin
          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin
                    c := GetCell(cx - StartX + StartX_, cy - StartY + StartY_);
                    if (c=0) then Continue;


r:=getClip(c-1);
drawTile(Round(cx * ChipWidth + OfsX),Round(cy * ChipHeight + OfsY),r,$FFFFFFFF);

               end;
          end;
     end;


Move(Vertices,buffer^,numPrims * 4 * SizeOf(HGEVertex));
smeEndCloud(numPrims  );
buffer:=nil;








        last.x:=x;
        last.y:=y;



 end;

procedure TSMETileMap.RenderBatch;
var
   _x, _y, cx, cy, cx2, cy2, c, ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_,  dWidth, dHeight: Integer;
   r:TSDL_rect;
begin
exit;
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;
        x:=0;
        y:=0;



     ChipWidth := trunc(Self.Width);
     ChipHeight :=trunc(Self.Height);

     dWidth  := (camera.FScreenWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (camera.FScreenHeight + ChipHeight) div ChipHeight + 1;

     _x := Trunc(-camera.x - X);
     _y := Trunc(-camera.y - Y);

     OfsX := _x mod ChipWidth;
     OfsY := _y mod ChipHeight;

     StartX := _x div ChipWidth;
     StartX_ := 0;

     if StartX < 0 then
     begin
          StartX_ := -StartX;
          StartX := 0;
     end;

     StartY := _y div ChipHeight;
     StartY_ := 0;

     if StartY < 0 then
     begin
          StartY_ := -StartY;
          StartY := 0;
     end;

     EndX := Mini(StartX + FMapWidth - StartX_, dWidth);
     EndY := Mini(StartY + FMapHeight - StartY_, dHeight);





     if FDoTile then
     begin
          for cy := -1 to dHeight do
          begin
               cy2 := Mod2((cy - StartY + StartY_), FMapHeight);
               for cx := -1 to dWidth do
               begin
                    cx2 := Mod2((cx - StartX + StartX_), FMapWidth);
                    c := Cells[cx2, cy2];

if c >= 1 then
begin
r:=getClip(c-1);
DrawImage(Ftexture,cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,@r,$FFFFFFFF,BLEND_DEFAULT);
 end;
               end;
          end;
     end
     else
     begin
          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin
                    c := GetCell(cx - StartX + StartX_, cy - StartY + StartY_);
                      if c >=1 then
                    begin
r:=getClip(c-1);
DrawImage(Ftexture,cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,@r,$FFFFFFFF,BLEND_DEFAULT);
                    end;
               end;
          end;
     end;

        last.x:=x;
        last.y:=y;
 end;


procedure TSMETileMap.drawTile(  px,  py:single;clip:TSDL_Rect;color:Uint32) ;
var
l,t,r,b,u,v,u2,v2,fx2,fy2,tmp:single;
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;


begin



    l := clip.x / ftexture.widthtex;
		t := clip.y / ftexture.heighttex;
		r := (clip.x + clip.w) / ftexture.widthtex;
		b := (clip.y + clip.h) / ftexture.heighttex;

    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;


    TempX1 := px;
    TempY1 := py;
    TempX2 := px+clip.w ;
    TempY2 := py+clip.H ;




		vertices[numPrims*4+0].x := TempX1;
		vertices[numPrims*4+0].y := TempY1;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := TexX1;
		vertices[numPrims*4+0].ty := TexY1;

		vertices[numPrims*4+1].x := TempX2;
		vertices[numPrims*4+1].y := TempY1;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := TexX2;
		vertices[numPrims*4+1].ty := TexY1;

		vertices[numPrims*4+2].x := TempX2;
		vertices[numPrims*4+2].y := TempY2;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := TexX2;
		vertices[numPrims*4+2].ty := TexY2;

		vertices[numPrims*4+3].x := TempX1;
		vertices[numPrims*4+3].y := TempY2;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := TexX1;
		vertices[numPrims*4+3].ty := TexY2;






    inc(numPrims);
	end;


function TSMETileMap.GetCell(X, Y: Integer): Integer;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
       result:= FMap[Y * FMapWidth + X ]

end;

type
  PBoolean = ^Boolean;

function TSMETileMap.GetCollisionMapItem(X, Y: Integer): Boolean;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         Result := FCollisionMap[Y * FMapWidth+X]
     else
         Result := False;
end;


procedure TSMETileMap.SetCell(X, Y: Integer; Value: Integer);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         FMap[Y * FMapWidth + X]:= Value;
end;

procedure TSMETileMap.SetCollisionMapItem(X, Y: Integer; Value: Boolean);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         FCollisionMap[Y * FMapWidth + X] := Value;
end;



procedure TSMETileMap.SetMapHeight(Value: Integer);
begin
     SetMapSize(FMapWidth, Value);
end;

procedure TSMETileMap.SetMapWidth(Value: Integer);
begin
     SetMapSize(Value, FMapHeight);
end;

procedure TSMETileMap.SetMapSize(AMapWidth, AMapHeight: Integer);
begin
     FMapW := trunc(Width * AMapWidth);
     FMapH := trunc(Height * AMapHeight);
     if (FMapWidth <> AMapWidth) or (FMapHeight <> AMapHeight) then
     begin
          if (AMapWidth <= 0) or (AMapHeight <= 0) then
          begin
               AMapWidth := 0;
               AMapHeight := 0;
          end;

          FMapWidth := AMapWidth;
          FMapHeight := AMapHeight;

          //ReAllocMem(FMap, FMapWidth * FMapHeight * SizeOf(Integer));
          //FillChar(FMap^, FMapWidth * FMapHeight * SizeOf(Integer), 0);
          setlength(FMap,FMapWidth * FMapHeight);

         // ReAllocMem(FCollisionMap, FMapWidth * FMapHeight * SizeOf(Boolean));
         // FillChar(FCollisionMap^, FMapWidth * FMapHeight * SizeOf(Boolean), 1);
          setlength(FCollisionMap,FMapWidth * FMapHeight);
//          setlength(FClips,FMapWidth * FMapHeight);
//          setlength(FColide,FMapWidth * FMapHeight);

         // writeln('mapa size',FMapWidth * FMapHeight);
     end;
end;

   constructor PDParticle.Create();
   begin
    x :=0;
    y :=0;
     rotation:=0;
     currentTime := 0.0;
            totalTime:=1;
            alpha:=1;
            scale := 1.0;
            color := $ffffffff;
            colorArgb:=TColorArgb.Create;
            colorArgbDelta:=TColorArgb.Create;

   end;
procedure PDParticle.draw(texture:PSDL_Texture);
var

  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;



  xOffset,yOffset:integer;
  w,h:integer;
  acos,asin,cosx,sinx,cosy,siny:single;

begin


  w:=trunc(texture.width  * scale);
  h:=trunc(texture.height * scale);



    xOffset :=w shr 1;
    yOffset :=h shr 1;


if (rotation<>0) then
begin
                     acos:= cos(rotation);
                     asin:= sin(rotation);
                     cosX:= acos * xOffset;
                     cosY:= acos * yOffset;
                     sinX:= asin * xOffset;
                     sinY:= asin * yOffset;



FQuad.V[0].x:=  x - cosX + sinY;FQuad.V[0].y:= y - sinX - cosY;
FQuad.V[1].X:=  x + cosX + sinY;FQuad.V[1].Y :=y - sinX - cosY;
FQuad.V[2].X:=  x + cosX - sinY;FQuad.V[2].Y :=y + sinX + cosY;
FQuad.V[3].X := x - cosX - sinY;FQuad.V[3].Y :=y + sinX + cosY;

end else
begin

FQuad.V[0].x:=  x - xOffset;FQuad.V[0].y:= y - yOffset;
FQuad.V[1].X:=  x + xOffset;FQuad.V[1].Y:= y - yOffset;
FQuad.V[2].X:=  x + xOffset;FQuad.V[2].Y:= y + yOffset;
FQuad.V[3].X := x - xOffset;FQuad.V[3].Y:= y + yOffset;


end;



  TexX1 := 0;
  TexY1 := 0;
  TexX2 := 1;
  TexY2 := 1;

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



  FQuad.Blend:=BLEND_ADD;
  FQuad.Tex:=texture;


  smeRenderQuad(@FQuad);
 {
   DrawImage(texture,
             x,y,
             texture.width/2,texture.height/2,
             scale,
             scale,
             rotation,
             0,0,
             color,BLEND_SUB); }
   end;

procedure  TSMEEmitter.initParticle(Particle:PDParticle);
var
lifespan,angle,speed,startSize,endSize:single;
startColor,colorDelta:TColorArgb;
startRotation,endRotation:single;
endColorRed,endColorGreen,endColorBlue,endColorAlpha:single;
begin

            // for performance reasons, the random variances are calculated inline instead
            // of calling a function

             lifespan:= mLifespan + mLifespanVariance * randoms(-1.0 , 1.0);
            
            particle.currentTime := 0.0;
            if (lifespan > 0.0) then particle.totalTime :=lifespan else particle.totalTime:=0;
//            particle.totalTime = lifespan > 0.0 ? lifespan : 0.0;

            if (lifespan <= 0.0) then exit;

            particle.x := mEmitterX + mEmitterXVariance * randoms(-1.0 , 1.0);
            particle.y := mEmitterY + mEmitterYVariance * randoms(-1.0 , 1.0);
            particle.startX := mEmitterX;
            particle.startY := mEmitterY;

            angle:= mEmitAngle + mEmitAngleVariance * (randoms(-1.0 , 1.0));
            speed:= mSpeed + mSpeedVariance * (randoms(-1.0 , 1.0));
            particle.velocityX := speed * cos(angle);
            particle.velocityY := speed * sin(angle);

            particle.emitRadius := mMaxRadius + mMaxRadiusVariance * (randoms(-1.0 , 1.0));
            particle.emitRadiusDelta := mMaxRadius / lifespan;
            particle.emitRotation := mEmitAngle + mEmitAngleVariance * (randoms(-1.0 , 1.0));
            particle.emitRotationDelta := mRotatePerSecond + mRotatePerSecondVariance * (randoms(-1.0 , 1.0));
            particle.radialAcceleration := mRadialAcceleration + mRadialAccelerationVariance * (randoms(-1.0 , 1.0));
            particle.tangentialAcceleration := mTangentialAcceleration + mTangentialAccelerationVariance * (randoms(-1.0 , 1.0));

            startSize:= mStartSize + mStartSizeVariance * (randoms(-1.0 , 1.0));
            endSize:= mEndSize + mEndSizeVariance * (randoms(-1.0 , 1.0));
            if (startSize < 0.1) then startSize := 0.1;
            if (endSize < 0.1)   then endSize := 0.1;
            particle.scale := startSize / texture.width;
            particle.scaleDelta := ((endSize - startSize) / lifespan) / texture.width;

            // colors

             startColor:= particle.colorArgb;
             colorDelta:= particle.colorArgbDelta;
            
            startColor.r   := mStartColor.r;
            startColor.g   := mStartColor.g;
            startColor.b   := mStartColor.b;
            startColor.a   := mStartColor.a;

            if (mStartColorVariance.r <> 0)  then  startColor.r   :=startColor.r+ mStartColorVariance.r   * (randoms(-1.0 , 1.0));
            if (mStartColorVariance.g <> 0)  then  startColor.g   :=startColor.g+ mStartColorVariance.g   * (randoms(-1.0 , 1.0));
            if (mStartColorVariance.b <> 0)  then  startColor.b   :=startColor.b+ mStartColorVariance.b   * (randoms(-1.0 , 1.0));
            if (mStartColorVariance.a <> 0)  then  startColor.a   :=startColor.a+ mStartColorVariance.a   * (randoms(-1.0 , 1.0));


            endColorRed:= mEndColor.r;
            endColorGreen:= mEndColor.g;
            endColorBlue:= mEndColor.b;
            endColorAlpha:= mEndColor.a;

            if (mEndColorVariance.r <> 0)  then  endColorRed     :=endColorRed+ mEndColorVariance.r   * (randoms(-1.0 , 1.0));
            if (mEndColorVariance.g <> 0)  then  endColorGreen   :=endColorGreen+ mEndColorVariance.g   * (randoms(-1.0 , 1.0));
            if (mEndColorVariance.b <> 0)  then  endColorBlue    :=endColorBlue+ mEndColorVariance.b   * (randoms(-1.0 , 1.0));
            if (mEndColorVariance.a <> 0)  then  endColorAlpha   :=endColorAlpha+ mEndColorVariance.a   * (randoms(-1.0 , 1.0));



            colorDelta.r   := (endColorRed   - startColor.r)  / lifespan;
            colorDelta.g   := (endColorGreen - startColor.g)  / lifespan;
            colorDelta.b   := (endColorBlue  - startColor.b)  / lifespan;
            colorDelta.a   := (endColorAlpha - startColor.a)  / lifespan;

            // rotation

                     
             startRotation:= mStartRotation + mStartRotationVariance * (randoms(-1.0 , 1.0));
             endRotation:= mEndRotation   + mEndRotationVariance   * (randoms(-1.0 , 1.0));

            particle.rotation := startRotation;
            particle.rotationDelta := (endRotation - startRotation) / lifespan;
end;
function GetColorARGB(col:TColorArgb):dword;
var
  R, G, B, XH, P1, P2, P3: Single;
  I: Integer;
begin
  Result :=
    Trunc(col.A * 255) shl 24 +
    Trunc(col.R * 255) shl 16 +
    Trunc(col.G * 255) shl 8 +
    Trunc(col.B * 255);
end;


procedure TSMEEmitter.advanceParticle(Particle:PDParticle; passedTime:Single);
var
restTime:single;
r:tsdl_rect;
newY,distanceX,distanceY,distanceScalar,radialX,radialY,tangentialX,tangentialY:single;
begin


            restTime:= particle.totalTime - particle.currentTime;
            if (restTime > passedTime) then  passedTime:=passedTime else passedTime:=restTime;
            particle.currentTime :=particle.currentTime+ passedTime;



            if (mEmitterType =EMITTER_TYPE_RADIAL) then
            begin
                particle.emitRotation :=particle.emitRotation+ particle.emitRotationDelta * passedTime;
                particle.emitRadius   :=particle.emitRadius- particle.emitRadiusDelta   * passedTime;
                particle.x := mEmitterX - cos(particle.emitRotation) * particle.emitRadius;
                particle.y := mEmitterY - sin(particle.emitRotation) * particle.emitRadius;
                
                if (particle.emitRadius < mMinRadius)then   particle.currentTime := particle.totalTime;
            end
            else
            begin

                 distanceX:= particle.x - particle.startX;
                 distanceY:= particle.y - particle.startY;
                 distanceScalar:= sqrt(distanceX*distanceX + distanceY*distanceY);
                if (distanceScalar < 0.01) then distanceScalar := 0.01;

                radialX:= distanceX / distanceScalar;
                radialY:= distanceY / distanceScalar;
                tangentialX:= radialX;
                tangentialY:= radialY;

                radialX :=radialX* particle.radialAcceleration;
                radialY :=radialY* particle.radialAcceleration;

                newY:= tangentialX;
                tangentialX := -tangentialY * particle.tangentialAcceleration;
                tangentialY := newY * particle.tangentialAcceleration;

                particle.velocityX :=particle.velocityX + passedTime * (mGravityX + radialX + tangentialX);
                particle.velocityY :=particle.velocityY + passedTime * (mGravityY + radialY + tangentialY);
                particle.x :=particle.x+ particle.velocityX * passedTime;
                particle.y :=particle.y+ particle.velocityY * passedTime;
            end;

            particle.scale :=particle.scale+ particle.scaleDelta * passedTime;
            particle.rotation :=particle.rotation+ particle.rotationDelta * passedTime;

            particle.colorArgb.r   :=particle.colorArgb.r+ particle.colorArgbDelta.r   * passedTime;
            particle.colorArgb.g   :=particle.colorArgb.g+ particle.colorArgbDelta.g   * passedTime;
            particle.colorArgb.b   :=particle.colorArgb.b+ particle.colorArgbDelta.b   * passedTime;
            particle.colorArgb.a   :=particle.colorArgb.a+ particle.colorArgbDelta.a   * passedTime;

            particle.color:=GetColorARGB( particle.colorArgb);
            
        //    particle.alpha:= particle.colorArgb.a;

          //    r:=sdl_rect(0,0,32,32);
           //  DrawImage(texture,particle.x,particle.y,@r,$FFFFFFFF,BLEND_DEFAULT);
//

        end;

 function deg2rad(deg:single):single;
begin
        result:= deg / 180.0 * pi;
end;
destructor TSMEEmitter.Destory();
var
i:integer;
P:PDParticle;
begin
for i:=0 to mParticles.Count-1 do
begin
P:=mParticles[I];
mParticles.Remove(P);
P.colorArgb.Destroy;
P.colorArgbDelta.Destroy;
P.Destroy;
P:=NIL;
end;
mParticles.Clear;
mParticles.Destroy;
mStartColor:=NIL;
mStartColorVariance:=NIL;
mEndColor:=NIL;
MEndColorVariance:=NIl;

end;

constructor TSMEEmitter.Create (fname:string);
var
i:integer;
par:PDParticle;
s,TagName: string;
node,doc,nodes,child:pointer;
value:double;
begin
inherited create;
      if (not assigned(images)) then
      begin
      smeTerminate('image list not created');
      exit;
      end;

numPrims :=0;
FillChar(Vertices,SizeOf(Vertices),0);



            mParticles:=TList.Create;
            mEmissionTime := 0.0;
            mFrameTime := 0.0;
            mEmitterX :=200;
            mEmitterY :=200;


         mStartColor:=TColorArgb.Create;
         mStartColorVariance:=TColorArgb.Create;
         mEndColor:=TColorArgb.Create;
         mEndColorVariance:=TColorArgb.Create;



  doc:=smeLoadDocFromFile(pchar(fname));
  if assigned(doc) then
  begin

  node:=smeFirstNodeChildByName(doc,'particleEmitterConfig');
  if assigned(node) then
  begin
    //texture
    child:=smeFirstNodeChildByName(node,'texture');
    s:=smeGetAttribute(child,'name');
    s:=file_GetDirectory(fname)+s;
    texture := images.LoadTexture(S);



    child:=smeFirstNodeChildByName(node,'sourcePosition');
    mEmitterX:= strtofloat( smeGetAttribute(child,'x'));
    mEmitterY:= strtofloat( smeGetAttribute(child,'y'));


    child:=smeFirstNodeChildByName(node,'sourcePositionVariance');
    mEmitterXVariance:= strtofloat( smeGetAttribute(child,'x'));
    mEmitterYVariance:= strtofloat( smeGetAttribute(child,'y'));

    child:=smeFirstNodeChildByName(node,'gravity');
    mGravityX:= strtofloat( smeGetAttribute(child,'x'));
    mGravityY:= strtofloat( smeGetAttribute(child,'y'));

   child:=smeFirstNodeChildByName(node,'emitterType');
   smeGetIntAttribute(child,'value',mEmitterType);


   child:=smeFirstNodeChildByName(node,'maxParticles');
   smeGetIntAttribute(child,'value',mMaxNumParticles);
   if (mMaxNumParticles>PATICLESPRIMITIVES) then
   mMaxNumParticles:=PATICLESPRIMITIVES;

   child:=smeFirstNodeChildByName(node,'particleLifeSpan');
   mLifespan := Math.max(0.01, strtofloat( smeGetAttribute(child,'value')));

   child:=smeFirstNodeChildByName(node,'particleLifespanVariance');
   mLifespanVariance :=strtofloat( smeGetAttribute(child,'value'));

     child:=smeFirstNodeChildByName(node,'startParticleSize');
     mStartSize :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'startParticleSizeVariance');
     mStartSizeVariance :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'finishParticleSize');
     mEndSize :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'FinishParticleSizeVariance');
     mEndSizeVariance :=strtofloat( smeGetAttribute(child,'value'));
  //----
     child:=smeFirstNodeChildByName(node,'angle');
     mEmitAngle :=deg2rad(strtofloat( smeGetAttribute(child,'value')));

     child:=smeFirstNodeChildByName(node,'angleVariance');
     mEmitAngleVariance :=deg2rad(strtofloat( smeGetAttribute(child,'value')));

     child:=smeFirstNodeChildByName(node,'rotationStart');
     mStartRotation :=deg2rad(strtofloat( smeGetAttribute(child,'value')));

     child:=smeFirstNodeChildByName(node,'rotationStartVariance');
     mStartRotationVariance :=deg2rad(strtofloat( smeGetAttribute(child,'value')));

     child:=smeFirstNodeChildByName(node,'rotationEnd');
     mEndRotation :=deg2rad(strtofloat( smeGetAttribute(child,'value')));

     child:=smeFirstNodeChildByName(node,'rotationEndVariance');
     mEndRotationVariance :=deg2rad(strtofloat( smeGetAttribute(child,'value')));
   //----

     child:=smeFirstNodeChildByName(node,'speed');
     mSpeed :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'speedVariance');
     mSpeedVariance :=strtofloat( smeGetAttribute(child,'value'));

     child:=smeFirstNodeChildByName(node,'radialAcceleration');
     mRadialAcceleration :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'radialAccelVariance');
     mRadialAccelerationVariance :=strtofloat( smeGetAttribute(child,'value'));

     child:=smeFirstNodeChildByName(node,'tangentialAcceleration');
     mTangentialAcceleration :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'tangentialAccelVariance');
     mTangentialAccelerationVariance :=strtofloat( smeGetAttribute(child,'value'));


     child:=smeFirstNodeChildByName(node,'maxRadius');
     mMaxRadius :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'maxRadiusVariance');
     mMaxRadiusVariance :=strtofloat( smeGetAttribute(child,'value'));
     child:=smeFirstNodeChildByName(node,'minRadius');
     mMinRadius :=strtofloat( smeGetAttribute(child,'value'));


     child:=smeFirstNodeChildByName(node,'rotatePerSecond');
     mRotatePerSecond :=deg2rad(strtofloat( smeGetAttribute(child,'value')));
     child:=smeFirstNodeChildByName(node,'rotatePerSecondVariance');
     mRotatePerSecondVariance :=deg2rad(strtofloat( smeGetAttribute(child,'value')));


     child:=smeFirstNodeChildByName(node,'startColor');
     mStartColor.r :=strtofloat( smeGetAttribute(child,'red'));
     mStartColor.g :=strtofloat( smeGetAttribute(child,'green'));
     mStartColor.b :=strtofloat( smeGetAttribute(child,'blue'));
     mStartColor.a :=strtofloat( smeGetAttribute(child,'alpha'));


     child:=smeFirstNodeChildByName(node,'startColorVariance');
     mStartColorVariance.r :=strtofloat( smeGetAttribute(child,'red'));
     mStartColorVariance.g :=strtofloat( smeGetAttribute(child,'green'));
     mStartColorVariance.b :=strtofloat( smeGetAttribute(child,'blue'));
     mStartColorVariance.a :=strtofloat( smeGetAttribute(child,'alpha'));


     child:=smeFirstNodeChildByName(node,'finishColor');
     mEndColor.r :=strtofloat( smeGetAttribute(child,'red'));
     mEndColor.g :=strtofloat( smeGetAttribute(child,'green'));
     mEndColor.b :=strtofloat( smeGetAttribute(child,'blue'));
     mEndColor.a :=strtofloat( smeGetAttribute(child,'alpha'));

     child:=smeFirstNodeChildByName(node,'finishColorVariance');
     mEndColorVariance.r :=strtofloat( smeGetAttribute(child,'red'));
     mEndColorVariance.g :=strtofloat( smeGetAttribute(child,'green'));
     mEndColorVariance.b :=strtofloat( smeGetAttribute(child,'blue'));
     mEndColorVariance.a :=strtofloat( smeGetAttribute(child,'alpha'));






  end;





  smeFreeDoc(doc);
 end;

     child:=nil;
     doc:=nil;


     invTexWidth :=1.0/texture.widthTex;
     invTexHeight:=1.0/texture.heightTex;



            mMaxCapacity:=mMaxNumParticles;
            mEmissionTime:= maxsingle;
            mEmissionRate := mMaxNumParticles / mLifespan;


            for i:=0 to mMaxCapacity-1 do
            begin
            par:=PDParticle.Create;
            //initParticle(par);
            //advanceParticle(par, random * par.totalTime);
            mParticles.Add(par);
            end;




end;
procedure TSMEEmitter.updateEmissionRate();
begin
            mEmissionRate := mMaxNumParticles / mLifespan;
end;
procedure TSMEEmitter.setmaxNumParticles(value:integer);
begin
            mMaxCapacity := value;
            mMaxNumParticles := mMaxCapacity;
            updateEmissionRate();
end;

procedure  TSMEEmitter.raiseCapacity(byAmount:integer);
var
oldCapacity,newCapacity:integer;
begin

         //   oldCapacity:= capacity;
           //  newCapacity:= mini(mMaxCapacity, capacity + byAmount);
end;
procedure TSMEEmitter.moveTo(x,y:single);
begin
mEmitterX:=x;
mEmitterY:=y;
end;

procedure TSMEEmitter.stop(clearParticles:Boolean);
begin
            mEmissionTime := 0.0;
            if (clearParticles) then mNumParticles := 0;
end;
procedure  TSMEEmitter.start(duration:single);
begin
     //       if (mEmissionRate != 0)
                mEmissionTime := duration;
 end;


procedure TSMEEmitter.draw(particle:PDParticle);
var

  TexX1, TexY1, TexX2, TexY2: Single;
  i:integer;

   vTras:hvector;

  xOffset,yOffset:integer;
  w,h:integer;
  acos,asin,cosx,sinx,cosy,siny:single;

begin


  w:=trunc(texture.width  * particle.scale);
  h:=trunc(texture.height * particle.scale);



    xOffset :=w shr 1;
    yOffset :=h shr 1;


if (particle.rotation<>0) then
begin
                     acos:= cos(particle.rotation);
                     asin:= sin(particle.rotation);
                     cosX:= acos * xOffset;
                     cosY:= acos * yOffset;
                     sinX:= asin * xOffset;
                     sinY:= asin * yOffset;



vertices[numPrims*4+0].x:=  particle.x - cosX + sinY;vertices[numPrims*4+0].y:=particle. y - sinX - cosY;
vertices[numPrims*4+1].X:=  particle.x + cosX + sinY;vertices[numPrims*4+1].Y :=particle.y - sinX - cosY;
vertices[numPrims*4+2].X:=  particle.x + cosX - sinY;vertices[numPrims*4+2].Y :=particle.y + sinX + cosY;
vertices[numPrims*4+3].X := particle.x - cosX - sinY;vertices[numPrims*4+3].Y :=particle.y + sinX + cosY;

end else
begin

vertices[numPrims*4+0].x:=  particle.x - xOffset;vertices[numPrims*4+0].y:= particle.y - yOffset;
vertices[numPrims*4+1].X:=  particle.x + xOffset;vertices[numPrims*4+1].Y:= particle.y - yOffset;
vertices[numPrims*4+2].X:=  particle.x + xOffset;vertices[numPrims*4+2].Y:= particle.y + yOffset;
vertices[numPrims*4+3].X:= particle.x - xOffset;vertices[numPrims*4+3].Y:= particle.y + yOffset;


end;


for i:=0 to 4-1 do
begin
    vTras.x:=vertices[numPrims*4+i].x;
    vTras.y:=vertices[numPrims*4+i].Y;
    vTras:=AbsoluteTransformation.transformPoint(vTras);
    vertices[numPrims*4+i].x:=vTras.x;
    vertices[numPrims*4+i].Y:=vTras.y;
end;






  TexX1 := 0;
  TexY1 := 0;
  TexX2 := 1;
  TexY2 := 1;

vertices[numPrims*4+0].TX := TexX1; vertices[numPrims*4+0].TY := TexY1;
vertices[numPrims*4+1].TX := TexX2; vertices[numPrims*4+1].TY := TexY1;
vertices[numPrims*4+2].TX := TexX2; vertices[numPrims*4+2].TY := TexY2;
vertices[numPrims*4+3].TX := TexX1; vertices[numPrims*4+3].TY := TexY2;

vertices[numPrims*4+0].Z := 0.0;
vertices[numPrims*4+1].Z := 0.0;
vertices[numPrims*4+2].Z := 0.0;
vertices[numPrims*4+3].Z := 0.0;




vertices[numPrims*4+0].Col := particle.Color;
vertices[numPrims*4+1].Col := particle.Color;
vertices[numPrims*4+2].Col := particle.Color;
vertices[numPrims*4+3].Col := particle.Color;
inc(numPrims);



   end;


procedure  TSMEEmitter.drawParticle (  x,  y,  originX,  originY,  width,  height,  scaleX,scaleY,  rotation:single;  srcX,  srcY,  srcWidth,  srcHeight:integer; flipX,flipY:boolean;color:Uint32);
var
u,v,u2,v2,fx2,fy2,tmp:single;
worldOriginX,worldOriginY,fx,fy:single;
    p1x,p1y,p2x,p2y,
    p3x,p3y,p4x,p4y:single;
    x1,y1,x2,y2,x3,y3,x4,y4:single;
   acos,asin:single;
   vTras:hvector;
begin
		 u := srcX * invTexWidth;
		 v := (srcY + srcHeight) * invTexHeight;
		 u2 := (srcX + srcWidth) * invTexWidth;
		 v2 := srcY * invTexHeight;

		// bottom left and top right corner points relative to origin
	 worldOriginX := x + originX;
	 worldOriginY := y + originY;
	 fx := -originX;
	 fy := -originY;
	 fx2 := width - originX;
	 fy2 := height - originY;

		// scale
		if (scaleX <> 1) or (scaleY <> 1) then
    begin
			fx :=fx* scaleX;
			fy :=fy* scaleY;
			fx2 :=fx2* scaleX;
			fy2 :=fy* scaleY;
		end;


		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


		// rotate
		if (rotation <>0) then
    begin
			 acos := cos(rotation);
			 asin := sin(rotation);

			x1 := acos * p1x - asin * p1y;
			y1 := asin * p1x + acos * p1y;

			x2 := acos * p2x - asin * p2y;
			y2 := asin * p2x + acos * p2y;

			x3 := acos * p3x - asin * p3y;
			y3 := asin * p3x + acos * p3y;

			x4 := x1 + (x3 - x2);
			y4 := y3 - (y2 - y1);
		end else
    begin
			x1 := p1x;
			y1 := p1y;

			x2 := p2x;
			y2 := p2y;

			x3 := p3x;
			y3 := p3y;

			x4 := p4x;
			y4 := p4y;
		end;

		x1 :=x1+ worldOriginX;
		y1 :=y1+ worldOriginY;
		x2 :=x2+ worldOriginX;
		y2 :=y2+ worldOriginY;
		x3 :=x3+ worldOriginX;
		y3 :=y3+ worldOriginY;
		x4 :=x4+ worldOriginX;
		y4 :=y4+ worldOriginY;

		if (flipX) then
    begin
			 tmp := u;
			u := u2;
			u2 := tmp;
		end;

		if (flipY) then
    begin
			 tmp := v;
			v := v2;
			v2 := tmp;
		end;


    vTras.x:=x1;
    vTras.y:=y1;
    vTras:=AbsoluteTransformation.transformPoint(vTras);
    x1:=vTras.x;
    y1:=vTras.y;

    vTras.x:=x2;
    vTras.y:=y2;
    vTras:=AbsoluteTransformation.transformPoint(vTras);
    x2:=vTras.x;
    y2:=vTras.y;

    vTras.x:=x3;
    vTras.y:=y3;
    vTras:=AbsoluteTransformation.transformPoint(vTras);
    x3:=vTras.x;
    y3:=vTras.y;

    vTras.x:=x4;
    vTras.y:=y4;
    vTras:=AbsoluteTransformation.transformPoint(vTras);
    x4:=vTras.x;
    y4:=vTras.y;

		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
    vertices[numPrims*4+0].z := 0.0;
		vertices[numPrims*4+0].col := color;
		vertices[numPrims*4+0].tx := u;
		vertices[numPrims*4+0].ty := v;

		vertices[numPrims*4+1].x := x2;
		vertices[numPrims*4+1].y := y2;
    vertices[numPrims*4+1].z := 0.0;
		vertices[numPrims*4+1].col := color;
		vertices[numPrims*4+1].tx := u;
		vertices[numPrims*4+1].ty := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
    vertices[numPrims*4+2].z := 0.0;
		vertices[numPrims*4+2].col := color;
		vertices[numPrims*4+2].tx := u2;
		vertices[numPrims*4+2].ty := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
    vertices[numPrims*4+3].z := 0.0;
		vertices[numPrims*4+3].col := color;
		vertices[numPrims*4+3].tx := u2;
		vertices[numPrims*4+3].ty := v;
    inc(numPrims);
	end;

procedure  TSMEEmitter.RenderCloud(passedTime:Single);
var
particleIndex:integer;
nextParticle,particle:PDParticle;
timeBetweenParticles:single;
i:integer;
r:TSDL_rect;
buffer: PHGEVertexArray;
begin
updateAbsolutePosition;

            particleIndex:=0;

            while (particleIndex < mNumParticles)  do
            begin

                particle := PDParticle(mParticles[particleIndex]);

                if (particle.currentTime < particle.totalTime) then
                begin
                    advanceParticle(particle, passedTime);
                    inc(particleIndex);
                end
                else
                begin
                    if (particleIndex <> mNumParticles - 1)  then
                    begin
                        nextParticle:= PDParticle(mParticles[mNumParticles-1]);
                        mParticles[mNumParticles-1] := particle;
                        mParticles[particleIndex] := nextParticle;
                    end;

                    dec(mNumParticles);

                    if (mNumParticles = 0 )and ( mEmissionTime = 0) then
                    begin
                    writeln('complete');
                    end;
                end;
            end;
            
            // create and advance new particles
            
            if (mEmissionTime > 0) then
            begin
                 timeBetweenParticles:= 1.0 / mEmissionRate;
                 mFrameTime :=mFrameTime+ passedTime;

                while (mFrameTime > 0) do
                begin
                    if (mNumParticles < mMaxCapacity) then
                    begin

                        particle := PDParticle(mParticles[mNumParticles]);
                        initParticle(particle);
                        
                        // particle might be dead at birth
                        if (particle.totalTime > 0.0) then
                        begin
                            advanceParticle(particle, mFrameTime);
                            inc(mNumParticles);
                        end;
                    end;
                    
                    mFrameTime :=mFrameTime- timeBetweenParticles;
                end;

                if (mEmissionTime <> maxsingle) then
                    mEmissionTime := maxs(0.0, mEmissionTime - passedTime);
            end;

        //    writeln(mNumParticles);
   numPrims:=0;
   buffer:=smeBeginCloud(SMEPRIM_QUADS,texture,BLEND_ADD);



            for i:=0 to mNumParticles-1 do
            begin
              particle := PDParticle(mParticles[i]);
              draw(particle);
            end;

Move(Vertices,buffer^,numPrims * 4 * SizeOf(HGEVertex));
smeEndCloud(numPrims  );
buffer:=nil;
end;

procedure  TSMEEmitter.RenderBatch(passedTime:Single);
var
particleIndex:integer;
nextParticle,particle:PDParticle;
timeBetweenParticles:single;
i:integer;

begin
updateAbsolutePosition;

            particleIndex:=0;

            while (particleIndex < mNumParticles)  do
            begin

                particle := PDParticle(mParticles[particleIndex]);

                if (particle.currentTime < particle.totalTime) then
                begin
                    advanceParticle(particle, passedTime);
                    inc(particleIndex);
                end
                else
                begin
                    if (particleIndex <> mNumParticles - 1)  then
                    begin
                        nextParticle:= PDParticle(mParticles[mNumParticles-1]);
                        mParticles[mNumParticles-1] := particle;
                        mParticles[particleIndex] := nextParticle;
                    end;

                    dec(mNumParticles);

                    if (mNumParticles = 0 )and ( mEmissionTime = 0) then
                    begin
                    writeln('complete');
                    end;
                end;
            end;
            
            // create and advance new particles
            
            if (mEmissionTime > 0) then
            begin
                 timeBetweenParticles:= 1.0 / mEmissionRate;
                 mFrameTime :=mFrameTime+ passedTime;

                while (mFrameTime > 0) do
                begin
                    if (mNumParticles < mMaxCapacity) then
                    begin

                        particle := PDParticle(mParticles[mNumParticles]);
                        initParticle(particle);
                        
                        // particle might be dead at birth
                        if (particle.totalTime > 0.0) then
                        begin
                            advanceParticle(particle, mFrameTime);
                            inc(mNumParticles);
                        end;
                    end;
                    
                    mFrameTime :=mFrameTime- timeBetweenParticles;
                end;

                if (mEmissionTime <> maxsingle) then
                    mEmissionTime := maxs(0.0, mEmissionTime - passedTime);
            end;



            for i:=0 to mNumParticles-1 do
            begin
              particle := PDParticle(mParticles[i]);
              particle.draw(texture);
            end;
end;


//------------------------------------------------------------------------------
// Helper routins
//------------------------------------------------------------------------------
function RandomSingle(const Min, Max: Single): Single;
var
  Mi, Ma: Single;
begin
  Mi := Min;
  Ma := Max;

  if (Min > Max) then
  begin
    Mi := Max;
    Ma := Min;
  end;

  RRSeed := 214013 * RRSeed + 2531011;
  Result := Mi + (RRSeed shr 16) * (1.0 / 65535.0) * (Ma - Mi);
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  TXParticleSystem CLASS
//------------------------------------------------------------------------------
constructor TXParticleSystem.Create(Tex: PSDL_Texture;Capacity_: Integer = MAX_PARTICLES_DEF);
var
p:Tpoint;
begin


  SetCapacity(Capacity_);
  FEmissionResidue := 0.0;
  FParticlesAlive  := 0;
  FAge             := -1.0;
  FUpdSpeed        := 0.0;
  FResidue         := 0.0;
  FAngle           := 0.0;
  FPrevLocation.x    := 0.0;
  FPrevLocation.y    := 0.0;
  FTexture:=tex;

  NullSettings();
  SetLength(FEmitters, 0);
  EmittersAdd([p]);
end;

//------------------------------------------------------------------------------
destructor TXParticleSystem.Destroy();
begin
  Stop(true);
  FTexture := nil;
  RemoveAllEmitters();
  SetCapacity(0);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.SetCapacity(Value: Integer);
begin
  if (Value = FCapacity) then Exit;

  FCapacity := Value;
  Setlength(FParticles, FCapacity);
end;

//------------------------------------------------------------------------------
function TXParticleSystem.Load(const PSS: TXParticleSettings): boolean;
begin
  FSettings := PSS;


  Result    := true;
end;

//------------------------------------------------------------------------------
function TXParticleSystem.LoadFromStream(Stream: TStream): boolean;
var
  PSS: TXParticleSettings;
begin
  if (Stream <> nil) then
  begin
    Stream.Position := 0;
    Result := (Stream.Read(PSS, SizeOf(TXParticleSettings)) > 0);
    Load(PSS);
  end
  else
    Result := false;
end;

//------------------------------------------------------------------------------
function TXParticleSystem.SaveToStream(Stream: TStream): boolean;
begin
  if (Stream <> nil) then
    Result := (Stream.Write(FSettings, SizeOf(TXParticleSettings)) > 0)
  else
    Result := false;
end;

//------------------------------------------------------------------------------
function TXParticleSystem.LoadFromFile(const FileName: string): boolean;
var
  Stream: TFileStream;
begin
  Result := false;
  if (not FileExists(FileName)) then Exit;

  Stream := TFileStream.Create(FileName, fmOpenRead);
  Stream.Position := 0;
  Result := LoadFromStream(Stream);
  Stream.Free();
end;


//------------------------------------------------------------------------------
procedure TXParticleSystem.NullSettings();
begin
  FillChar(FSettings, SizeOf(TXParticleSettings), 0);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.Render( dx: Integer = 0; dy: Integer = 0);
var
  i: integer;
  Par: PXParticle;
begin
  if (FParticlesAlive <= 0) then Exit;

  if (FSettings.InverseRender) then
    for i := FParticlesAlive - 1 downto 0 do
    begin
      Par := @FParticles[i];

      RenderParticle( FTexture, dx + Par.Location.x,
        dy + Par.Location.y, Par.Angle, Par.Scale, Par.Frame,
        Par.Color, FSettings.Sprite.DrawFx);
    end
  else
    for i := 0 to FParticlesAlive - 1 do
    begin
      Par := @FParticles[i];

      RenderParticle( FTexture,
        dx + Par.Location.x,
        dy + Par.Location.y,
        Par.Angle, Par.Scale, Par.Frame,
        Par.Color, FSettings.Sprite.DrawFx);
    end;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.RenderParticle( Tex: PSDL_Texture;
  X, Y, Angle, Scale, Pattern: Single; Color: hcolor; DrawFx: Cardinal);
begin
//Gfx_RenderRect(x,y,1,1,color.r,color.g,color.b,color.a);
DrawImage(FTexture,
        x,y,
        FTexture.Width,FTexture.Height,
        0,
        0,
        scale,
        scale,
        angle,
        0,
        0,
        GetColor(color),
        BLEND_ADD);

   //  writeln(ftos(x),'<>',ftos(y));


end;

function VecAngle4(const v1, v2: hvector): Real;
begin
  Result := ArcTan2(v2.y - v1.y, v2.x - v1.x);
end;

function NormSmoothColor(const Color: HColor): Hcolor;
begin
  Result := Color;

  if (Result.R < 0) then
    Result.R := 0
  else
    if (Result.R > 255) then Result.R := 255;

  if (Result.G < 0) then
    Result.G := 0
  else
    if (Result.G > 255) then Result.G := 255;

  if (Result.B < 0) then
    Result.B := 0
  else
    if (Result.B > 255) then Result.B := 255;

  if (Result.A < 0) then
    Result.A := 0
  else
    if (Result.A > 255) then
      Result.A := 255 - 1; // Perfomance
end;



function SmoothRGBA(R, G, B, A: Single; Norm: boolean):HColor;
begin
  Result.R := R;
  Result.G := G;
  Result.B := B;
  Result.A := A;
  if (Norm) then Result := NormSmoothColor(Result);
end;

function SmoothColorDelta(const SmColor: hcolor; Color: Cardinal; Time: Single): hcolor;
begin
  Result := SmoothRGBA(
    (Color and $FF - SmColor.R) / Time,
    ((Color shr 8) and $FF - SmColor.G) / Time,
    ((Color shr 16) and $FF - SmColor.B) / Time,
    ((Color shr 24) and $FF - SmColor.A) / Time,
    false);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.AddParticle(x, y: integer);
var
  ang, c_rnd, a_rnd: Single;
  Par: PXParticle;
   tmp:hvector;
  r, g, b, a: Single;
  Pnt: TPoint;
  CosPhi, SinPhi: Extended;
  EmitterCount: Integer;
begin
  EmitterCount := Length(FEmitters);
  if (FParticlesAlive >= FCapacity) or (EmitterCount = 0) then Exit;

  Par := @FParticles[FParticlesAlive];

  Par.Age := 0.0;
  Par.TerminalAge := RandomSingle(FSettings.ParticleLifeMin, FSettings.ParticleLifeMax);
  Par.MidAge := Par.TerminalAge * FSettings.Middle;

  // Spawn location
  Par.Location.x := FPrevLocation.x + ((FPosition.x - FPrevLocation.x) * RandomSingle(0.0, 1.0));
  Par.Location.y := FPrevLocation.y + ((FPosition.y - FPrevLocation.y) * RandomSingle(0.0, 1.0));

  // Random select start point
  Pnt := FEmitters[Random(EmitterCount)];
 // Par.Location.x := x + Par.Location.x + Pnt.X + RandomSingle(-1.0, 1.0);
  //Par.Location.y := y + Par.Location.y + Pnt.Y + RandomSingle(-1.0, 1.0);
 // Par.Location.x := x + Par.Location.x + Pnt.X;
 // Par.Location.y := y + Par.Location.y + Pnt.Y;

  Par.Displacement.x := FPosition.x - Par.Location.x;
  Par.Displacement.y := FPosition.y - Par.Location.y;

  //Particles direction and velocity
  ang := FSettings.Direction + FAngle +   RandomSingle(0.0, FSettings.Spread) - FSettings.Spread / 2.0;

  if (FSettings.Relative) then
  begin
    tmp.x:=FPrevLocation.y - FPosition.x;
    tmp.y:=FPrevLocation.y - FPosition.y;

    ang := ang + VecAngle4(VecZero2, tmp);
  end;

  // SinCos is twice as fast as calling Sin and Cos separately for the same angle.
  SinCos(Ang, SinPhi, CosPhi);
  Par.Velocity.x := SinPhi;
  Par.Velocity.y := CosPhi;
  Par.Velocity.x   := RandomSingle(FSettings.VelMin, FSettings.VelMax) * Par.Velocity.x;
  Par.Velocity.y   := RandomSingle(FSettings.VelMin, FSettings.VelMax) * Par.Velocity.y;

  // GRAVITY
  Par.Gravity := RandomSingle(FSettings.GravityMin, FSettings.GravityMax);

  // ACCELeration
  Par.Accel := RandomSingle(FSettings.AccelMin, FSettings.AccelMax);
  Par.TangentialAccel := RandomSingle(FSettings.TangentialAccelMin, FSettings.TangentialAccelMax);

  // SCALE
  Par.Scale := RandomSingle(FSettings.ScaleStart, FSettings.ScaleStart +(FSettings.ScaleMid - FSettings.ScaleStart) * FSettings.ScaleRnd);
  Par.ScaleDelta := (FSettings.ScaleMid - Par.Scale) / Par.MidAge;

  // SPIN
  Par.Angle := RandomSingle(FSettings.SpinStart, FSettings.SpinStart +(FSettings.SpinMid - FSettings.SpinStart) * FSettings.SpinRnd);
  Par.AngleDelta := (FSettings.SpinMid - Par.Angle) / Par.MidAge;

  // ANIM
  Par.Frame := FSettings.Sprite.Pattern;
  if (FSettings.Sprite.FrameEnd >= 0) and
    (FSettings.Sprite.Pattern <> FSettings.Sprite.FrameEnd) then
    Par.FrameDelta := (FSettings.Sprite.FrameEnd - Par.Frame) / Par.TerminalAge
  else
    Par.FrameDelta := 0.0;

  // Define start COLOR
  r := (FSettings.ColorStart and $FF);
  g := (FSettings.ColorStart shr 8) and $FF;
  b := (FSettings.ColorStart shr 16) and $FF;
  a := (FSettings.ColorStart shr 24) and $FF;
  c_rnd := RandomSingle(0.0, FSettings.ColorRnd);
  a_rnd := RandomSingle(0.0, FSettings.AlphaRnd);

  Par.Color := SmoothRGBA(
    (r + ((FSettings.ColorMid and $FF - r) * c_rnd)),
    (g + (((FSettings.ColorMid shr 8) and $FF - g) * c_rnd)),
    (b + (((FSettings.ColorMid shr 16) and $FF - b) * c_rnd)),
    (a + (((FSettings.ColorMid shr 24) and $FF - a) * a_rnd)),
    true);

  Par.ColorDelta := SmoothColorDelta(Par.Color, FSettings.ColorMid, Par.MidAge);

  Inc(FParticlesAlive);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.Update(const DeltaTime: Single);
begin
  UpdateSys(DeltaTime);
end;

function VecAbs2(const v: hvector): single;
begin
 //Result:= Sqrt(Sqr(v.x) + Sqr(v.y));
 Result := Hypot(v.x, v.y);
end;

function VecNorm2(const v: hvector): hvector;
var
 Amp: Single;
begin
 Amp:= VecAbs2(v);

 if (Amp <> 0.0) then
  begin
   Result.x:= v.x / Amp;
   Result.y:= v.y / Amp;
  end else Result:= VecZero2;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.UpdateSys(DeltaTime: Single);
var
  i, Index, Shift: integer;
  fAux, TimeLeft: Single;
  Par: PXParticle;
  AccelVec, AccelVec2: hvector;

  ParticlesNeeded: Single;
  ParticlesCreated: integer;

  Middle: boolean;


begin
 if (FAge >= 0) then
  begin
    FAge := FAge + DeltaTime;
    if (FAge >= FSettings.LifeTime) then FAge := -1.0;
  end;

  // Update all ALIVE particles and remove dead

  Index := 0;
  Shift := 0;
  while (Index < FParticlesAlive) do
  begin
    if (Index > FCapacity - 1) then Break;

    if (Shift > 0) then
      FParticles[Index] := FParticles[Index + Shift];

    Par := @FParticles[Index];

    // If particle LifeTime is over remove it
    Par.Age := Par.Age + DeltaTime;
    if (Par.Age >= Par.TerminalAge) then
    begin
      Dec(FParticlesAlive);
      Inc(Shift);
      Continue;
    end;

    Middle := ((Par.Age - DeltaTime < Par.MidAge) and (Par.Age >= Par.MidAge));

    AccelVec.x  := Par.Location.x - (FPosition.x + Par.Displacement.x);
    AccelVec.y  := Par.Location.y - (FPosition.y + Par.Displacement.y);

    //AccelVec := Par.Location - FPosition;
    AccelVec  := VecNorm2(AccelVec);
    AccelVec2 := AccelVec;
    AccelVec.x  := AccelVec.x * Par.Accel;
    AccelVec.y  := AccelVec.y * Par.Accel;

    // Rotate
    fAux := AccelVec2.x;
    AccelVec2.x := -AccelVec2.y;
   AccelVec2.y := fAux;

    AccelVec2.x := AccelVec2.x * Par.TangentialAccel;
    AccelVec2.y := AccelVec2.y * Par.TangentialAccel;

    Par.Velocity.x := Par.Velocity.x + ((AccelVec.x + AccelVec2.x) * FORCE_KOEF * DeltaTime);
    Par.Velocity.y := Par.Velocity.y + ((AccelVec.y + AccelVec2.y) * FORCE_KOEF * DeltaTime);

    Par.Velocity.y := Par.Velocity.y + (Par.Gravity * FORCE_KOEF * DeltaTime);

    Par.Location.x := Par.Location.x + Par.Velocity.x * DeltaTime;
    Par.Location.y := Par.Location.y + Par.Velocity.y * DeltaTime;

    Par.Angle := Par.Angle + Par.AngleDelta * DeltaTime;
    Par.Scale := Par.Scale + Par.ScaleDelta * DeltaTime;    
    Par.Frame := Par.Frame + Par.FrameDelta * DeltaTime;

    // MIDDLE.
    if (Middle) then
    begin
      TimeLeft := Par.TerminalAge - Par.MidAge;
      // SPIN
      Par.AngleDelta := (FSettings.SpinEnd - Par.Angle) / TimeLeft;
      // SCALE
      Par.ScaleDelta := (FSettings.ScaleEnd - Par.Scale) / TimeLeft;
      // COLOR
      Par.ColorDelta := SmoothColorDelta(Par.Color, FSettings.ColorEnd, TimeLeft);
    end;

//    Par.Color := NormSmoothColor(Par.Color + Par.ColorDelta * DeltaTime);
    Par.Color.r := Par.Color.r + Par.ColorDelta.r * DeltaTime;
    Par.Color.g := Par.Color.g + Par.ColorDelta.g * DeltaTime;
    Par.Color.b := Par.Color.b + Par.ColorDelta.b * DeltaTime;
    Par.Color.a := Par.Color.a + Par.ColorDelta.a * DeltaTime;

    Inc(Index);
  end;

  // Generate NEW particles
  if (FAge >= 0.0) then
  begin
    ParticlesNeeded  := FSettings.EmissionRate * DeltaTime + FEmissionResidue;
    ParticlesCreated := Round(ParticlesNeeded);
    FEmissionResidue := ParticlesNeeded - ParticlesCreated;

    for i := 0 to ParticlesCreated - 1 do
    begin
      if (FParticlesAlive >= FCapacity) then Break;
      AddParticle(0, 0);
    end;
  end;

  FPrevLocation := FPosition;

end;

//------------------------------------------------------------------------------
function TXParticleSystem.EmitterAdd(const NewEmitter: TPoint): integer;
var
  Count: integer;
begin
  Count := Length(FEmitters);
  SetLength(FEmitters, Count + 1);
  FEmitters[Count] := NewEmitter;
  Result := Count;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.EmittersAdd(const NewEmitters: array of TPoint);
var
  i: integer;
begin
  for i := 0 to Length(NewEmitters) - 1 do
    EmitterAdd(NewEmitters[i]);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.EmittersAddFromImage(Image: PSDL_Surface; Color: Cardinal);
var
  x, y: integer;
begin
  if (not Assigned(Image)) then Exit;

  SetLength(FEmitters, 0);

//  for x := 0 to Image.PatternSize.X - 1 do
  //  for y := 0 to Image.PatternSize.Y - 1 do
    //  if (Image.Pixels[x, y, 0] = Color) then
      //  EmittersAdd([Point(x, y)]);
end;


//------------------------------------------------------------------------------
procedure TXParticleSystem.EmittersSaveToFile(const FileName: string);
var
  EmtHdr: TEmittersFileHeader;
  Stream: TFileStream;
begin
  EmtHdr.Count := Length(FEmitters);

  Stream := TFileStream.Create(FileName, fmCreate);
  Stream.Position := 0;
  try
    Stream.WriteBuffer(EmtHdr, SizeOf(EmtHdr));
    Stream.WriteBuffer(FEmitters[0], SizeOf(FEmitters[0]) * EmtHdr.Count);
  finally
    Stream.Free();
  end;
end;

//------------------------------------------------------------------------------
function TXParticleSystem.EmittersLoadFromFile(const FileName: string): boolean;
var
  EmtHdr: TEmittersFileHeader;
  Stream: TFileStream;
begin
  Result := true;

  if (not FileExists(FileName)) then Exit;

  Stream := TFileStream.Create(FileName, fmOpenRead);
  Stream.Position := 0;
  try
    try
      Stream.ReadBuffer(EmtHdr, SizeOf(EmtHdr));
      SetLength(FEmitters, EmtHdr.Count);
      Stream.ReadBuffer(FEmitters[0], SizeOf(FEmitters[0]) * EmtHdr.Count);
    except
      Result := false;
    end;
  finally
    Stream.Free();
  end;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.ScaleEmitters(Scale: Single);
var
  i: integer;
begin
  for i := 0 to Length(FEmitters) - 1 do
  begin
    FEmitters[i].X := Round(FEmitters[i].X * Scale);
    FEmitters[i].Y := Round(FEmitters[i].Y * Scale);
  end;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.RemoveEmitter(Index: Integer);
var
  LastId: integer;
begin
  LastId := Length(FEmitters) - 1;
  if (Index < 0)or(Index > LastId - 1) then Exit;

  FEmitters[Index] := FEmitters[LastId];
  SetLength(FEmitters, LastId);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.RemoveAllEmitters();
begin
  SetLength(FEmitters, 0);
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.StartAt(x,y:single);
begin
  Stop();
  MoveTo(x,y);
  Start();
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.Start();
begin
  if (Length(FEmitters) = 0) then Exit;

  if (FSettings.Lifetime <= 0.0) then
    FAge := -1.0
  else
    FAge := 0.0;

  FResidue := 0.0;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.Stop(KillParticles: boolean = false);
begin
  FAge := -1.0;
  if (KillParticles) then FParticlesAlive := 0;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.Move(x,y:single; MoveParticles: boolean = false);
var
  i: Integer;
  DeltaPos: hvector;

begin
DeltaPos.x:=x;
DeltaPos.y:=y;
  if (MoveParticles) then
  begin
    for i := 0 to FParticlesAlive - 1 do
    begin
      FParticles[i].Location.x := FParticles[i].Location.x + DeltaPos.x;
      FParticles[i].Location.y := FParticles[i].Location.y + DeltaPos.y;
    end;

    FPrevLocation.x := FPrevLocation.x + DeltaPos.x;
    FPrevLocation.y := FPrevLocation.y + DeltaPos.y;
  end
  else
  begin
    if (Age < 0.0) then
    begin
      FPrevLocation.x := FPosition.x + DeltaPos.x;
      FPrevLocation.y := FPosition.y + DeltaPos.y;
    end else
      FPrevLocation := FPosition;
  end;

  FPosition.x := FPosition.x + DeltaPos.x;
  FPosition.y := FPosition.y + DeltaPos.y;
end;

//------------------------------------------------------------------------------
procedure TXParticleSystem.MoveTo(x,y:single; MoveParticles: boolean = false);
var
p:hvector;
begin
p.x:=x-FPosition.x;
p.y:=y-FPosition.y;

  Move(p.x,p.y, MoveParticles);
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// TXParticleManager.
//------------------------------------------------------------------------------
constructor TXParticleManager.Create();
begin
  FSysCount := 0;
end;

//------------------------------------------------------------------------------
destructor TXParticleManager.Destroy();
begin
  KillAll();

  inherited;
end;
//------------------------------------------------------------------------------
procedure TXParticleManager.Update(const DeltaTime: Single);
var
  i: integer;
begin
  i := 0;
  while (i <= FSysCount - 1) do
  begin
    FSystems[i].Update(DeltaTime);

    if (FSystems[i] <> nil) and (FSystems[i].Age < 0.0) and
      (FSystems[i].ParticlesAlive = 0) then
    begin
      FSystems[i].Free();
      FSystems[i] := FSystems[FSysCount - 1];
      Dec(FSysCount);
    end
    else Inc(i);
  end;
end;

//------------------------------------------------------------------------------
procedure TXParticleManager.Render(dx: integer = 0; dy: integer = 0);
var
  i: integer;
begin
  for i := 0 to FSysCount - 1 do
    FSystems[i].Render( dx, dy)
end;

//------------------------------------------------------------------------------
// Return ID of added Settings 
function TXParticleManager.Add(const PSS: TXParticleSettings; const Name: string): integer;
var
  cnt: integer;
begin
  cnt := Length(FSettings);
  Inc(cnt);
  SetLength(FSettings, cnt);
  SetLength(FNameList, cnt);
  Result := cnt - 1;
  FSettings[Result] := PSS;
  FNameList[Result] := LowerCase(Name);
end;



//------------------------------------------------------------------------------
// Launch particles by ID
function TXParticleManager.Launch(Index: Integer; x,y:single): TXParticleSystem;
begin
  Result := nil;
  if (Index >= 0)and(Index < Length(FSettings)) then
    Result := LaunchEx(FSettings[Index], FTexture, x,y);
end;

//------------------------------------------------------------------------------
// Launch particles by Name
function TXParticleManager.Launch(const Name: string; x,y:single): TXParticleSystem;
var
  Index: integer;
begin
  Result := nil;
  Index := IndexOf(Name);
  if (Index >= 0) then
    Result := Launch(Index, x,y);
end;

//------------------------------------------------------------------------------
function TXParticleManager.LaunchEx(const PSS: TXParticleSettings;  pTexture: PSDL_Texture; x,y:single): TXParticleSystem;
var
  NewSys: TXParticleSystem;
begin
  if (FSysCount >= MAX_PSYSTEMS) then
  begin
    Result := nil;
    Exit;
  end;

  NewSys := TXParticleSystem.Create(pTexture);
  with NewSys do
  begin
    Load(PSS);
    Texture := pTexture;
    MoveTo(x,y);
    Start();
  end;
  
  FSystems[FSysCount] := NewSys;
  Result := NewSys;

  Inc(FSysCount);
end;

//------------------------------------------------------------------------------
procedure TXParticleManager.StopAll();
var
  i: integer;
begin
  for i := 0 to FSysCount - 1 do
    FSystems[i].Stop();
end;

//------------------------------------------------------------------------------
function TXParticleManager.IsPSAlive(PS: TXParticleSystem): boolean;
var
  i: integer;
begin
  Result := false;

  for i := 0 to FSysCount - 1 do
    if (FSystems[i] = PS) then
    begin
      Result := true;
      Break;
    end;
end;

//------------------------------------------------------------------------------
procedure TXParticleManager.KillPS(PS: TXParticleSystem);
var
  i: integer;
begin
  for i := 0 to FSysCount - 1 do
  begin
    if (FSystems[i] = PS) then
    begin
      FSystems[i].Free();
      FSystems[i] := FSystems[FSysCount - 1];
      FNameList[i] := FNameList[FSysCount - 1];
      Dec(FSysCount);
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TXParticleManager.KillAll();
var
  i: integer;
begin
  for i := 0 to FSysCount - 1 do FSystems[i].Free();
  FSysCount := 0;
  SetLength(FNameList, 0);
end;

//------------------------------------------------------------------------------
function TXParticleManager.GetSystem(Index: Integer): TXParticleSystem;
begin
  Result := nil;
  if (Index >= 0)and(Index < SystemCount) then
    Result := FSystems[Index];
end;

//------------------------------------------------------------------------------
function TXParticleManager.GetSettings(Index: Integer): PXParticleSettings;
begin
  Result := nil;
  if (Index > 0)and(Index < SettingsCount) then
    Result := @FSettings[Index];
end;

//------------------------------------------------------------------------------
// Return settings ID by Name
function TXParticleManager.IndexOf(Name: string): integer;
var
  i: integer;
begin
  Result := -1;
  Name := LowerCase(Name);
  for i := 0 to Length(FNameList) - 1 do
    if (Name = FNameList[i]) then
    begin
      Result := i;
      break;
    end;
end;

//------------------------------------------------------------------------------
function TXParticleManager.GetSettingsCount(): integer;
begin
  Result := Length(FSettings);
end;

//------------------------------------------------------------------------------
function TXParticleManager.GetParticlesAlive(): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to FSysCount - 1 do
    Result := Result + FSystems[i].ParticlesAlive;
end;

//------------------------------------------------------------------------------


//*************************************

function TSMETextureList.Get(Index: Integer): TTexture;
begin
 Result:=inherited get(Index);
// Result := TTexture(Items[Index]);

end;

procedure TSMETextureList.Put(Index: Integer; Item: TTexture);
begin
 inherited put(Index, Item);
// TTexture(Items[Index]) := Item;
//  TTexture(FItems[Index]) := Item;

end;
function TSMETextureList.Add(Obj: TTexture): TTexture;
begin
  Result := TTexture(inherited Add(Pointer(Obj)));
end;

//------------------------------------------------------------------------------
function TSMETextureList.IndexOf(Item: TTexture): Integer;
begin
  Result:=inherited IndexOf(Item);
end;

//------------------------------------------------------------------------------
function TSMETextureList.IndexOf(const Name: String): Integer;
var x: Integer;
begin
  Result:=-1;
  For x:=0 to Count - 1 do
  IF Items[x].Name = Name then
   begin
    Result:=x;
    Exit;
  end;
end;

//------------------------------------------------------------------------------
function TSMETextureList.Find(const Name: string): PSDL_texture;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
    result:=Items[Index].texture
  end ;
end;
procedure TSMETextureList.Del(Idx: Integer);
begin
  TTexture(Items[Idx]).Destroy;
  inherited;
end;

procedure TSMETextureList.Clear;
var
  i : Integer;
  tex:TTexture;
begin
   for i := 0 to Count - 1 do
   begin
     tex:=Items[i];
     smeFreeTexture(tex.texture);
     tex.Destroy;
    tex:=nil;
   end;
   inherited;
end;



function CreateTexture(Width, Height, Format : Word; pData : Pointer) : Integer;
var
  Texture : integer;
begin
  glGenTextures(1, @Texture);
  glBindTexture(GL_TEXTURE_2D, Texture);
//  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);  {Texture blends with object background}
//  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);  {Texture does NOT blend with object background}

 //  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP);
 //  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

   
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST); { only first two can be used }
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); { all of the above can be used }
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); { only first two can be used }
//   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); { all of the above can be used }


  if Format = GL_RGBA then
//    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, pData)
    GLtexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData)
  else
//    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, Width, Height, GL_RGB, GL_UNSIGNED_BYTE, pData);
     GLtexImage2D(GL_TEXTURE_2D, 0, GL_RGB, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData);
 // glTexImage2D(GL_TEXTURE_2D, 0, 3, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pData);  // Use when not wanting mipmaps to be built by openGL

  result :=Texture;
end;



function IsPowerOfTwo(Value: Integer): Boolean;
begin
 Result:= (Value >= 1)and((Value and (Value - 1)) = 0);
end;
function IsPow2(Num: LongInt): Boolean;
begin
  Result := (Num and -Num) = Num;
end;

function NextPow2(Num: LongInt): LongInt;
begin
  Result := Num and -Num;
  while (Result < Num) do
    Result := Result shl 1;
end;

function SDL_GetPixel( SrcSurface : PSDL_Surface; x : integer; y : integer ) : Uint32;
var
  bpp          : UInt32;
  p            : PInteger;
begin
  bpp := SrcSurface.format.BytesPerPixel;
  // Here p is the address to the pixel we want to retrieve
  p := Pointer( Uint32( SrcSurface.pixels ) + UInt32( y ) * SrcSurface.pitch + UInt32( x ) *
    bpp );
  case bpp of
    1 : result := PUint8( p )^;
    2 : result := PUint16( p )^;
    3 :
      if ( SDL_BYTEORDER = SDL_BIG_ENDIAN ) then
        result := PUInt8Array( p )[ 0 ] shl 16 or PUInt8Array( p )[ 1 ] shl 8 or
          PUInt8Array( p )[ 2 ]
      else
        result := PUInt8Array( p )[ 0 ] or PUInt8Array( p )[ 1 ] shl 8 or
          PUInt8Array( p )[ 2 ] shl 16;
    4 : result := PUint32( p )^;
  else
    result := 0; // shouldn't happen, but avoids warnings
  end;
end;

procedure SDL_PutPixel( DstSurface : PSDL_Surface; x : integer; y : integer; pixel :
  Uint32 );
var
  bpp          : UInt32;
  p            : PInteger;
begin
  bpp := DstSurface.format.BytesPerPixel;
  p := Pointer( Uint32( DstSurface.pixels ) + UInt32( y ) * DstSurface.pitch + UInt32( x )
    * bpp );
  case bpp of
    1 : PUint8( p )^ := pixel;
    2 : PUint16( p )^ := pixel;
    3 :
      if ( SDL_BYTEORDER = SDL_BIG_ENDIAN ) then
      begin
        PUInt8Array( p )[ 0 ] := ( pixel shr 16 ) and $FF;
        PUInt8Array( p )[ 1 ] := ( pixel shr 8 ) and $FF;
        PUInt8Array( p )[ 2 ] := pixel and $FF;
      end
      else
      begin
        PUInt8Array( p )[ 0 ] := pixel and $FF;
        PUInt8Array( p )[ 1 ] := ( pixel shr 8 ) and $FF;
        PUInt8Array( p )[ 2 ] := ( pixel shr 16 ) and $FF;
      end;
    4 :
      PUint32( p )^ := pixel;
  end;
end;



procedure SDL_ZoomSurface( SrcSurface : PSDL_Surface; SrcRect : PSDL_Rect; DstSurface : PSDL_Surface; DstRect : PSDL_Rect );
var
  xc, yc       : cardinal;
  rx, wx, ry, wy, ry16 : cardinal;
  color        : cardinal;
  modx, mody   : cardinal;
begin
  // Warning! No checks for surface pointers!!!
  if srcrect = nil then srcrect := @SrcSurface.clip_rect;
  if dstrect = nil then dstrect := @DstSurface.clip_rect;

    SDL_LockSurface( SrcSurface );
    SDL_LockSurface( DstSurface );
  modx := trunc( ( srcrect.w / dstrect.w ) * 65536 );
  mody := trunc( ( srcrect.h / dstrect.h ) * 65536 );
  //rx := srcrect.x * 65536;
  ry := srcrect.y * 65536;
  wy := dstrect.y;
  for yc := 0 to dstrect.h - 1 do
  begin
    rx := srcrect.x * 65536;
    wx := dstrect.x;
    ry16 := ry shr 16;
    for xc := 0 to dstrect.w - 1 do
    begin
      color := SDL_GetPixel( SrcSurface, rx shr 16, ry16 );
      SDL_PutPixel( DstSurface, wx, wy, color );
      rx := rx + modx;
      inc( wx );
    end;
    ry := ry + mody;
    inc( wy );
  end;
    SDL_UnlockSurface( SrcSurface );
    SDL_UnlockSurface( DstSurface );
end;

function rescaleSurface(SrcSurface : PSDL_Surface; w,h:integer):PSDL_Surface;
var
clip:Tsdl_rect;
begin
 clip:=sdl_rect(0,0,SrcSurface.w,SrcSurface.h);
 result := SDL_CreateRGBSurface(0,W,H,32,
 SrcSurface.format.Rmask,
 SrcSurface.format.Gmask,
 SrcSurface.format.Bmask,
 SrcSurface.format.Amask);
 SDL_ZoomSurface(SrcSurface,nil,result,@clip);
end;


function loadSurface(fname:string):PSDL_Texture;
var
ressurface,surface:PSDL_Surface;
mode:integer;
begin

new (result);

    surface := IMG_Load(pchar(fname));
    result.width:=surface.w;
    result.height:=surface.h;
    result.widthTex:=NextPow2(result.width);
    result.heightTex:=NextPow2(result.height);

 //   writeln(result.w,'<>',result.h);
 //   writeln(result.texw,'<>',result.texh);

          

   case (Surface.format.BytesPerPixel) of
     1:Mode := GL_ALPHA;
     3:Mode := GL_RGB;
     4:Mode := GL_RGBA;
     end;
       writeln('mode:',Surface.format.BytesPerPixel);

     if (not IsPow2(result.width) or (not IsPow2(result.height))) then
     begin
     ressurface:= rescaleSurface( surface,result.widthTex,result.heightTex);
     result.Glid:=CreateTexture(ressurface.w,ressurface.h,mode,ressurface.pixels);
   //  IMG_SavePNG(surface,'data\savenormal.png');
   //  IMG_SavePNG(ressurface,'data\saveres.png');
     SDL_FreeSurface(surface);
     SDL_FreeSurface(ressurface);
    end else
    begin
     result.Glid:=CreateTexture(surface.w,surface.h,mode,surface.pixels);
     //  IMG_SavePNG(surface,'data\savenormal.png');

     SDL_FreeSurface(surface);
    end;

end;



function TSMETextureList.LoadTexture(fname:string):PSDL_texture;
var
tex:TTexture;
lookname:string;
begin
lookname:=file_GetName(fname);
if (Exists(lookname)) then
begin
result:=Find(lookname);
end else
begin
tex:=TTexture.Create();
tex.texture:=loadSurface(fname);//smeLoadTextureFromFile(pchar(fname));
if not assigned(tex) then tex.texture:=smeCreateRectangleTexture(32,32,$FFFFFF,true);
//tex.texture:=smeCreateRectangleTexture(tex.texture.width,tex.texture.height,$FFFFFF,true);

tex.name:=file_GetName(fname);
result:=tex.texture;

Add(tex);
end;

end;
function TSMETextureList.Exists(name:string):boolean;
var Index: Integer;
begin
  Index:=IndexOf(Name);
  IF Index <> -1 then
  begin
  result:=true;
  end else
  begin
  result:=false;
  end;
end;
function TSMETextureList.GetContains(Name: String): Boolean;
begin
  Result:=IndexOf(Name) <> -1 ;
end;
destructor TSMETextureList.Destroy;
begin
clear;
inherited ;
end;
constructor TSMETextureList.Create;
begin
inherited;

end;
procedure TSMETextureList.BindTexture(Name : String);
begin

end;


//------------------------------------------------------------------------------
procedure TSMETextureList.BindTexture(Index: Integer);
begin
end;
procedure TSMETextureList.EnableTexturing;
begin
//  glEnable(GL_TEXTURE_2D);
end;

//------------------------------------------------------------------------------
procedure TSMETextureList.DisableTexturing;
begin
 // glDisable(GL_TEXTURE_2D);
end;


end.

