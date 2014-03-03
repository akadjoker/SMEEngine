unit SMEGL;

interface
uses
Classes,  math, SysUtils,sdl2,sdl_simple,sdl2_image, glmath, GLES1;


 const
texture_frag_shader='#ifdef GL_ES'+#10+
'precision mediump float;'+#10+
'#endif'+#10+
'varying vec2 v_texCoord;'+#10+
'varying vec4 vColor;'+#10+
'uniform sampler2D u_texture;'+#10+
'void main()'+#10+
'{'+#10+
'   vec4 texColor = texture2D(u_texture, v_texCoord);'+#10+
'   gl_FragColor = vColor * texColor;'+#10+
'}';

texture_pixel_shader='uniform mat4 u_projection;'+#10+
    'attribute vec2 a_position;'+#10+
    'attribute vec2 a_texCoord;'+#10+
	'attribute vec4 a_color;'+#10+
	'varying vec2 v_texCoord;'+#10+
	'varying vec4 vColor;'+#10+
    'void main()'+#10+
    '{'+#10+
	    'vColor = a_color;'+#10+
        'v_texCoord = a_texCoord;'+#10+
        'gl_Position = u_projection * vec4(a_position, 0.0, 1.0);'+#10+
        'gl_PointSize = 1.0;'+#10+
    '}';

color_pixel_shader='uniform mat4 u_projection;'+#10+
    'attribute vec2 a_position;'+#10+
  	'attribute vec4 a_color;'+#10+
   	'varying vec4 vColor;'+#10+
    'void main()'+#10+
    '{'+#10+
	    'vColor = a_color;'+#10+
        'gl_Position = u_projection * vec4(a_position, 0.0, 1.0);'+#10+
        'gl_PointSize = 1.0;'+#10+
    '}';
color_frag_shader='#ifdef GL_ES'+#10+
'precision mediump float;'+#10+
'#endif'+#10+
'varying vec4 vColor;'+#10+
'void main()'+#10+
'{'+#10+
'gl_FragColor = vColor ;'+#10+
'}';

const
  M_PI   = 3.14159265358979323846;
  M_PI_2 = 1.57079632679489661923;
  M_PI_4 = 0.785398163397448309616;
  M_1_PI = 0.318309886183790671538;
  M_2_PI = 0.636619772367581343076;
  EPSILON = 0.00000001;
  IRad = 1 / 360;
  TwoPI = 2 * 3.14159265358;



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
    Colorvertex=record
    x,y:Single;
    color:hcolor;		// color
    end;

   hgeVertex=record
				x, y:single;		// screen position
				tx, ty:single;		// texture coordinates
  			col:hcolor;		// color
   end;

PHGEVertex = ^HGEVertex;
hgeVertexArray = array [0..MaxInt div 32 - 1] of hgeVertex;
PhgeVertexArray = ^HGEVertexArray;




  Vector2f= record
  x,y:single
  end;
  Vector3f= record
  x,y,z:single
  end;



  TVertex = record
    U, V    : Single;
    Color   : HColor;
    X, Y, Z : Single;
  end;
  


Type

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

TSMEModel=class;

TSMECamera=class
protected
 projMatrix,
 viewMatrix,
 transpositionPool,
 projViewMatrix:Matrix;
 ftarget:TSMEModel;
 fposition,
 fscale:Vector2D;
 fzoom,fangle:single;
public
ScreenWidth,ScreenHeight:Integer;
x,y:single;
bound:TSMERect;


constructor Create(width,height:Integer);
procedure setFollow(target:TSMEModel);

procedure setWorldBound(minx,miny,maxx,maxy:single);

procedure Update();

procedure rotate(value:single);
procedure addRotate(value:single);

procedure zoom(value:single);

procedure moveX(value:single);
procedure moveY(value:single);
procedure Move(x,y:single);
procedure Translate(x,y:single);

procedure scale(x,y:single);



end;

TSMECameraOrtho=class(TSMECamera)
private

public
constructor Create(width,height:Integer);
procedure  resize(width,height:Integer);
function   getCombinedMatrix:Matrix;
function   getCombinedTransposeMatrix:Matrix;

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

  
  TSMERegion=class
  public
   name:string;
   x,y,width,height,frameX,frameY,frameWidth,Frameheight:single;
   clip:TSDL_Rect;
   texture:PSDL_Texture;
   procedure Load(fname:string);
   procedure setFromTexture(tex:PSDL_Texture);
  end;

  
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



   function count:integer;

  end;



TSMESpriteCloud = Class
  private
   { Private declarations }


   numPrims,idx,index:integer;
   invTexWidth,invTexHeight:single;
   numSprites:Integer;

    MAX_VERTICES:Integer;
   Texture :PSDL_Texture;
   Fcolor:HColor;

    procedure SetMaxVertices(count:integer);


  public
    Vertices  : array of Vector2f;
    TexCoords : array of Vector2f;
    Colors    : array of HColor;
    Indices   : array of Word;

    countvertex:integer;

      constructor Create(maxSprites:integer;RenderTexture:PSDL_Texture);

    Destructor Destroy;


   
  procedure beginBatch(blend:integer);
  procedure endBatch();





    procedure DrawQuad(dstrect,srcrect:TSDL_rect;color:Uint32) ;
    procedure drawTile(px,  py:single;clip:TSDL_Rect;color:Uint32) ;

   procedure setColor(color:Uint32) ;



  procedure drawSprite( x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single) ;overload ;
  procedure drawSprite( x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;overload ;
  procedure drawSprite( x,  y,  width,  height:single;flipx,flipy:boolean) ;overload ;
  procedure drawSprite( x,  y:single) ;overload ;
  procedure drawSprite( x,  y,width,  height:single) ;overload;
  procedure drawSprite( x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;overload ;





  end;

  

TSMESpriteBatch = Class
  private


   FPrim:integer;
   invTexWidth,invTexHeight:single;
   MAX_VERTICES:Integer;
 FCurTexture:PSDL_Texture;


 FVertArray: PHGEVertexArray;
 FCurPrimType: Integer;
 Indices   : array of Word;


 Fcolor:hcolor;

  procedure flush(endscene:Boolean=false);

  public





    constructor Create(maxSprites:Integer);
    Destructor Destroy;


   
  procedure beginBatch();
  procedure endBatch();


  procedure DrawImage(
  Texture :PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword);


           procedure DrawArray(Texture :PSDL_Texture;vertices: array of HGEVertex;count:Integer;  blend:integer=0) ;

    procedure DrawQuad(Texture :PSDL_Texture;dstrect,srcrect:TSDL_rect;color:Longword=$FFFFFFFF;blend:integer=0) ;
    procedure drawTile(Texture :PSDL_Texture;px,  py:single;clip:TSDL_Rect;color:Longword=$FFFFFFFF;blend:integer=0) ;

   procedure setColor(color:Uint32) ;



  procedure drawSprite(Texture :PSDL_Texture; x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;color:Longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;color:Longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y,  width,  height:single;flipx,flipy:boolean;color:Longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y:single;color:Longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y,width,  height:single;color:longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;color:Longword=$FFFFFFFF;blend:integer=0) ;overload;
  procedure drawSprite(Texture :PSDL_Texture; x,  y,originx,originy,scale,rotation:single;flipx,flipy:boolean;r,g,b,a:single;blend:integer) ;overload;





  end;



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
  
TSMEModel=class
protected
  AbsoluteTransformation, Fmatrix:TSMEMatrix;
  FParent:TSMEModel;
  sx,sy,cx,cy:single;
  camera:TSMECamera;
 procedure updateAbsolutePosition();

 function getX:single;
 function getY:single;


public
  Visible:boolean;
  Alive:boolean;
  Active:boolean;
  Remove:Boolean;
  Layer:integer;


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


 procedure setCamera(cam:TSMECamera);

 function getRelativeTransformation:TSMEMatrix;
 function getAbsoluteTransformation:TSMEMatrix;


procedure Draw;virtual;
procedure Update(dt:single);virtual;

procedure addChild(child:TSMEModel;parentToState:boolean=true);
procedure removeChild(Entity:TSMEModel);
procedure setParent(parent:TSMEModel);

end;

TSMEGroup=class(TSMEModel)
protected

 NeedSort:boolean;
 procedure Sort;
public



procedure Update(dt:single);
procedure Draw;

procedure add(md:TSMEModel);
procedure remove(md:TSMEModel);


end;

TSMEGame=class;
TSMEState=class(TSMEGroup)
protected
game:TSMEGame;
public
procedure Render();virtual;
procedure startState;virtual;
procedure endState();virtual;
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

procedure Update(dt:single);virtual;
procedure Render();


procedure LoadGame();virtual;
procedure EndGame();virtual;
end;



 type
     TColorArgb=class
  public
  r,g,b,a:single;
  end;


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
        color:hcolor;
        alpha:Single;
        currentTime:Single;
        totalTime:Single;
        constructor Create();

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
         mBlend:Integer;
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
        procedure  Update(passedTime:Single);
        procedure  Render(batch:TSMESpriteBatch);overload;
        procedure  stop(clearParticles:Boolean);
        procedure  start(duration:single);
        procedure  moveTo(x,y:single);

  end;



  
TMapObject=class
public
x,y,w,h:integer;
name:string;
end;


type

 TSMETileMap = class
 private
      FCollisionMap: array of boolean;
      FMap: array of integer;
      MapObject:Tlist;
      FMapW:Integer;
      FMapH: Integer;
      Width,Height,FMapWidth: Integer;
      FMapHeight: Integer;

      Ftexture:PSDL_Texture;
      ColCount,FCountTiles:integer;
      OfsX, OfsY:integer;
      fcamera:TSMECamera;
       invTexWidth,invTexHeight:single;
      numPrims :integer;
      x,y:Single;



      procedure SetMapHeight(Value: Integer);
      procedure SetMapWidth(Value: Integer);
      procedure drawTile(  px,  py:single;clip:TSDL_Rect;color:Uint32) ;

 protected

 public
      constructor Create(camera:TSMECamera;  texture:PSDL_Texture;frameWidth,FrameHeight,MapWidth,MapHeight:integer);overload;
      constructor Create(camera:TSMECamera;  fname:string);overload;

      destructor Destroy;
      procedure RenderBatch(batch:TSMESpriteBatch);


      function numObjs:integer;
      function getOBJ(index:integer):TMapObject;

      procedure addOBJ(name:string;ox,oy,ow,oh:integer);

      function GetCollisionMapItem(X, Y: Integer): Boolean;
      function GetCell(X, Y: Integer): Integer;
      procedure SetCell(X, Y: Integer; Value: Integer);
      procedure SetCollisionMapItem(X, Y: Integer; Value: Boolean);

      function getClip(frame:integer):TSDL_Rect;
//      function GetBoundsRect: TSDL_Rect;

//

      procedure SetMapSize(AMapWidth, AMapHeight: Integer);
      property Cells[X, Y: Integer]: Integer read GetCell write SetCell;
      property CollisionMap[X, Y: Integer]: Boolean read GetCollisionMapItem write SetCollisionMapItem;
      property MapHeight: Integer read FMapHeight write SetMapHeight;
      property MapWidth: Integer read FMapWidth write SetMapWidth;

 end;

 TSMEMapLayer=object
 private
  Ftexture:PSDL_Texture;
  color:HColor;
  ColCount,width,height:Integer;
  twidth,theight:Integer;
  name:string;

  function getClip(frame:integer):TSDL_Rect;
  function GetCell(X, Y: Integer): Integer;
  public
  CollisionMap: array  of boolean;
  Map: array    of integer;
  procedure init(layername:string; texture:PSDL_Texture;tileWidth,tileHeight,mWidth,mHeight:integer) ;
  procedure free;
 end;


 TSMETilesMap = class
 private
      MapObject:Tlist;
      FMapW:Integer;
      FMapH: Integer;
      Width,Height,FMapWidth: Integer;
      FMapHeight: Integer;
      tiles:array of TSMEMapLayer;
      Ftexture:PSDL_Texture;
      x,y:single;
    layers:Integer;
     OfsX, OfsY:integer;


 protected
   procedure SetMapSize(AMapWidth, AMapHeight: Integer);
   procedure addOBJ(name:string;ox,oy,ow,oh:integer);

 public
      constructor Create( fname:string);

      destructor Destroy;

      function numObjs:integer;
      function getOBJ(index:integer):TMapObject;



      function GetCollisionMapItem(layer,X, Y: Integer): Boolean;
      function GetCell(layer,X, Y: Integer): Integer;
      procedure SetCell(layer,X, Y: Integer; Value: Integer);
      procedure SetCollisionMapItem(layer,X, Y: Integer; Value: Boolean);



      procedure Render(camera:TSMECamera;batch:TSMESpriteBatch);overload;


      procedure RenderLayer(index:Integer;camera:TSMECamera;batch:TSMESpriteBatch);overload;


      function numLayer:Integer;

 end;


   TSMECanvas=class
    private
      Vertices:array[0..500] of Colorvertex;
      Fcolor:hcolor;

   public
   constructor Create;
   destructor Destroy;
   procedure setColor(color:Uint32) ;
   procedure Circle(X, Y, Radius: Single; Color: Cardinal=$FFFFFFFF; Filled: Boolean=true );
   procedure Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean);
   procedure Rect(rect:TSDL_rect; Color: Cardinal; Filled: Boolean);
   procedure Rectangle(x,y,width,height:single; Color: Cardinal; Filled: Boolean);
   procedure Quadrangle(x1,y1,x2,y2:single; Color: Cardinal; Filled: Boolean);
   procedure Polygon(Points: array of Vector2D; Color: Cardinal; Filled: Boolean);overload;
   procedure Polygon(Points: array of Vector2D; NumPoints: Integer;Color: Cardinal; Filled: Boolean);overload;
   procedure Line(x1,y1,x2,y2:single; Color: Cardinal);



   procedure Bind(mat:Matrix);
   procedure Ubind;

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
    FClips  : array [0..255] of TSDL_Rect;
    FPre, FPost: array [0..255] of Single;
    FHeight, FScale, FProportion, FRot, FTracking, FSpacing, FZ: Single;
    FCol: Longword;
    FBlend: Integer;
    SkewX,SkewY:single;
    function GetLine(const FromFile, Line: PChar): PChar;
  public

    constructor Create(const Filename: String);overload;
    constructor Create(data:pointer;size:longword);overload;

    destructor Destroy;


    procedure Render(Batch:TSMESpriteBatch; X, Y: Single; const Algn: Integer; const S: String);
    procedure PrintF(Batch:TSMESpriteBatch; X, Y: Single; const Align: Integer;const Format: String; const Args: array of const);
    procedure PrintFB(Batch:TSMESpriteBatch; X, Y, W, H: Single; const Align: Integer;const Format: String; const Args: array of const);

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




function vx2(u,v:single):Vector2f;
function vx3(x,y:single):Vector3f;
procedure COLOR_UnRGBA(color : LongWord; var R, G, B,A : Byte);


var









   realw,realh:integer;
   winw,winh:integer;
   window:PSDL_Window;
   glcontext:TSDL_GLContext;
    FCurBlendMode:Integer=-1;
    setblends:Integer=0;
implementation
uses
SDLUtils;

procedure SetBlendMode(blendMode:integer);
begin

    if (blendMode <> FCurBlendMode)  then
    begin
        case blendMode of


        SDL_BLENDMODE_NONE:
            glDisable(GL_BLEND);

         SDL_BLENDMODE_BLEND:
         begin
           glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
          end;
         SDL_BLENDMODE_ADD:
         begin
            glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE);
         end;
         SDL_BLENDMODE_MOD:
         begin
            glEnable(GL_BLEND);
           glBlendFunc(GL_ZERO, GL_SRC_COLOR);
          end;
          end;
        FCurBlendMode := blendMode;
        Inc(setblends);
    end;

end;

procedure smeTerminate(msg:string);
begin
SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,'SME Fail!',pchar(msg),window);
Halt;
end;

function ResourceLoad(const Filename: String;out data:pointer; var Size: integer):boolean;

var
  Done, I: Integer;
  F: THandle;
  BytesRead: Cardinal;
  uncompressed_size : integer;
  RWops:PSDL_RWops;
begin
Result := false;
Data := nil;

RWops:= SDL_RWFromFile(pchar(filename),'r');
if assigned(RWops) then
 begin
 uncompressed_size := smeRWsize(RWops);
 GetMem(Data,uncompressed_size);
 BytesRead:= smeRWread(RWops,Data,1,uncompressed_size);
 Size := BytesRead;
 SDL_FreeRW(RWops);
 SDL_Log(PChar('load resource:'+Filename));
end;
  result:=true;
end;

function vx2(u,v:single):Vector2f;
begin
result.x:=u;
result.y:=v;
end;
function vx3(x,y:single):Vector3f;
begin
result.x:=x;
result.y:=y;
result.z:=0.0;
end;

function RGBA(r,g,b,a: single): integer;
begin
Result :=
    (round(a * 255) shl 24) or
    (round(r * 255) shl 16) or
    (round(g * 255) shl 8) or
    (round(b * 255));


end;

function Color_RGB(R, G, B : Byte):integer;
begin
Result :=
    (r shl 16) or
    (g shl 8) or
    (b);

end;
procedure COLOR_UnRGBA(color : LongWord; var R, G, B,A : Byte);
begin
           A:= color shr 24;
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;

procedure COLOR_UnRGB(color : LongWord; var R, G, B : Byte);
begin
           R:= color shr 16;
           G:= color shr 8;
           B:= color;
end;

procedure COLOR_UnRGBAF(color : LongWord; var cR, cG, cB,cA : single);
var
r,g,b,a:byte;

begin
           A:= color shr 24;
           R:= color shr 16;
           G:= color shr 8;
           B:= color;

           cr:=r/255.0;
           cg:=g/255.0;
           cb:=b/255.0;
           ca:=a/255.0;

end;

function COLOR_ARGB(a,r,g,b: single): DWORD;
begin
Result :=
    (round(a * 255) shl 24) or
    (round(r * 255) shl 16) or
    (round(g * 255) shl 8) or
    (round(b * 255));
end;




//==============================================================================


constructor TSMESpriteCloud.Create(maxSprites:integer;RenderTexture:PSDL_Texture);
var
  i,  N,X:INTEGER;
begin
MAX_VERTICES:=maxSprites* 4;
Texture:=RenderTexture;


SetMaxVertices(MAX_VERTICES);

		invTexWidth := 1.0 / texture.widthTex;
		invTexHeight := 1.0 / texture.heightTex;
     



 n:=0;
 x:=0;



for I := 0 to (MAX_VERTICES div 4) - 1 do
begin
Indices[x]:=n;  inc(x);
Indices[x]:=n+1;inc(x);
Indices[x]:=n+2;inc(x);
Indices[x]:=n+2;inc(x);
Indices[x]:=n+3;inc(x);
Indices[x]:=n;  inc(x);
 Inc(N,4);
end;




end;

//------------------------------------------------------------------------------
destructor TSMESpriteCloud.Destroy;
begin
     
     setlength(Vertices ,0);
     setlength(TexCoords,0);
     setlength(Colors,0);
     setlength(Indices,0);
end;

FUNCTION FSIN(S:SINGLE):SINGLE;
begin
result:=sin(s);
end;
FUNCTION FCOS(S:SINGLE):SINGLE;
begin
result:=cos(s);
end;



procedure TSMESpriteCloud.DrawQuad(dstrect,srcrect:TSDL_rect;color:Uint32) ;
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;

begin


setColor(color);


    TexX1 := srcrect.x / texture.widthTex;
    TexY1 := srcrect.y / texture.heightTex;
    TexX2 := (srcrect.x + srcrect.w) / texture.widthTex;
    TexY2 := (srcrect.y + srcrect.h) / texture.heightTex;


    TempX1 := dstrect.x;
    TempY1 := dstrect.y;
    TempX2 := (dstrect.x + dstrect.w);
    TempY2 := (dstrect.y + dstrect.h);




		vertices[numPrims*4+0].x := TempX1;
		vertices[numPrims*4+0].y := TempY1;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := TexX1;
		texCoords[numPrims*4+0].y := TexY1;

		vertices[numPrims*4+1].x := TempX2;
		vertices[numPrims*4+1].y := TempY1;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := TexX2;
		texCoords[numPrims*4+1].y := TexY1;

		vertices[numPrims*4+2].x := TempX2;
		vertices[numPrims*4+2].y := TempY2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := TexX2;
		texCoords[numPrims*4+2].y := TexY2;

		vertices[numPrims*4+3].x := TempX1;
		vertices[numPrims*4+3].y := TempY2;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := TexX1;
		texCoords[numPrims*4+3].y := TexY2;
    inc(numPrims);
  end;

procedure TSMESpriteCloud.setColor(color:Uint32) ;
var
    cr,cg,cb,ca:Single;
begin
      COLOR_UnRGBAF(color,cr,cg,cb,ca);
      Fcolor.r:=cr;       Fcolor.g:=cg;       Fcolor.b:=cb;       Fcolor.a:=ca;
end;

procedure TSMESpriteCloud.drawTile( px,  py:single;clip:TSDL_Rect;color:Uint32) ;

var
  l,t,r,b:single;
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;

begin



    setColor(color);

    l := clip.x / texture.widthtex;
		t := clip.y / texture.heighttex;
		r := (clip.x + clip.w) / texture.widthtex;
		b := (clip.y + clip.h) / texture.heighttex;

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
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := TexX1;
		texCoords[numPrims*4+0].y := TexY1;

		vertices[numPrims*4+1].x := TempX2;
		vertices[numPrims*4+1].y := TempY1;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := TexX2;
		texCoords[numPrims*4+1].y := TexY1;

		vertices[numPrims*4+2].x := TempX2;
		vertices[numPrims*4+2].y := TempY2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := TexX2;
		texCoords[numPrims*4+2].y := TexY2;

		vertices[numPrims*4+3].x := TempX1;
		vertices[numPrims*4+3].y := TempY2;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := TexX1;
		texCoords[numPrims*4+3].y := TexY2;



    inc(numPrims);
	end;


  procedure TSMESpriteCloud.beginBatch(blend:integer);
  begin
  numPrims:=0;
  setColor($FFFFFFFF);
  SetBlendMode(blend);

    if Assigned(Texture) then
    begin
     glBindTexture(GL_TEXTURE_2D, Texture.Glid);
    end;


  end;

  procedure TSMESpriteCloud.endBatch();
  begin
 // glVertexAttribPointer(ATTRIBUTE_POSITION, 2, GL_FLOAT, GL_FALSE, 0, @vertices[0]);
 // glVertexAttribPointer(ATTRIBUTE_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 0, @texCoords[0]);
//  glVertexAttribPointer(ATTRIBUTE_COLOR, 4, GL_FLOAT, GL_FALSE, 0, @colors[0]);
  glDrawElements(GL_TRIANGLES, numPrims *6  ,GL_UNSIGNED_SHORT, @Indices[0]);
  end;




procedure TSMESpriteCloud.drawSprite( x,  y:single) ;
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
begin


	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + texture.Width;
		   fy2 := Y + texture.Height;





		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X;
		vertices[numPrims*4+1].y := fy2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);
end;


procedure TSMESpriteCloud.drawSprite(x,  y,width,  height:single) ;
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
begin


	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + Width;
		   fy2 := Y + Height;





		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X;
		vertices[numPrims*4+1].y := fy2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);
end;


procedure TSMESpriteCloud.drawSprite( x,  y,  width,  height,angle:single; srcX,srcY,srcWidth,srcHeight:single) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
begin



         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X2;
		vertices[numPrims*4+1].y := Y2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);

end;


procedure TSMESpriteCloud.drawSprite( x,  y,
originx,originy,
width,  height,
scale,
rotation:single;
srcX,srcY,srcWidth,srcHeight:single;
flipx,flipy:boolean) ;
var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
begin


		// top left and bottom right corner points relative to origin
		worldOriginX := x + originX;
		worldOriginY := y + originY;
		fx := - originX;
		fy := - originY;
		fx2 :=  width - originX;
		fy2 :=  height - originY;

		// scale
    IF (scale<>1.0) THEN
    BEGIN
 		fx :=fx* scale;
		fy :=fy* scale;
		fx2 :=fx2* scale;
		fy2 :=fy2* scale;
    END;

		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


     IF (rotation<>0) then
     begin
         rad := rotation* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

		 x1 := cos * p1x - sin * p1y;
		 y1 := sin * p1x + cos * p1y;

		 x2 := cos * p2x - sin * p2y;
		 y2 := sin * p2x + cos * p2y;

		 x3 := cos * p3x - sin * p3y;
		 y3 := sin * p3x + cos * p3y;

		 x4 := cos * p4x - sin * p4y;
		 y4 := sin * p4x + cos * p4y;
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








	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;






		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X2;
		vertices[numPrims*4+1].y := Y2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);

end;



procedure TSMESpriteCloud.drawSprite(x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
BEGIN





         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;







    

		vertices[numPrims*4+0].x := x1;
		vertices[numPrims*4+0].y := y1;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X2;
		vertices[numPrims*4+1].y := Y2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := x3;
		vertices[numPrims*4+2].y := y3;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := x4;
		vertices[numPrims*4+3].y := y4;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);

end;

procedure TSMESpriteCloud.drawSprite(x,  y,  width,  height:single;flipx,flipy:boolean) ;
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
begin




	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + Width;
		   fy2 := Y + Height;



   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;



		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X;
		vertices[numPrims*4+1].y := fy2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);



end;


//------------------------------------------------------------------------------
procedure TSMESpriteCloud.SetMaxVertices(count:integer);
begin
     countvertex :=count;
     setlength(Vertices ,countvertex*sizeof(Vector2f));
     setlength(TexCoords,countvertex*sizeof(Vector2f));
     setlength(Colors   ,countvertex*sizeof(HColor));
     setlength(Indices,(countvertex * 6));

end;



//------------------------------------------------------------------------------

//==============================================================================


constructor TSMESpriteBatch.Create(maxSprites:Integer);
var
  i,  N,X:INTEGER;
begin

  MAX_VERTICES:=maxSprites*4;
  



 FVertArray := nil;
 setlength( Indices,MAX_VERTICES * 6 div 4 * SizeOf(INTEGER));


 FPrim := 0;
 FCurPrimType := SMEPRIM_QUADS;
 FCurTexture:=nil;
 FCurBlendMode:=0;

 n:=0;
 x:=0;



for I := 0 to (MAX_VERTICES div 4) - 1 do
begin
Indices[x]:=n;  inc(x);
Indices[x]:=n+1;inc(x);
Indices[x]:=n+2;inc(x);
Indices[x]:=n+2;inc(x);
Indices[x]:=n+3;inc(x);
Indices[x]:=n;  inc(x);
 Inc(N,4);
end;


  invTexWidth :=1.0;
  invTexHeight:=1.0;

end;

//------------------------------------------------------------------------------
destructor TSMESpriteBatch.Destroy;
begin
     setlength(Indices,0);
end;





procedure TSMESpriteBatch.DrawImage(Texture :PSDL_Texture;
        x,y:single;
        clipping:PSDL_Rect;
        PivotX,
        PivotY,
        ScaleX,
        ScaleY,
        Rotation,
        SkewX,
        SkewY:single;Color:dword);


var
  TempX1, TempY1, TempX2, TempY2: Single;
  TexX1, TexY1, TexX2, TexY2: Single;
  FQuad: hgeQuad;
  i:integer;

vect:hvector;

l,t,r,b,   texw,texh:single;

begin
    {
if (texture <> lastTexture) then	switchTexture(texture) else flush;




    texw := texture.width / texture.widthTex;
    texh := texture.height / texture.heightTex;


    if (assigned(clipping)) then
    begin
		l := clipping.x / texture.widthtex;
		t := clipping.y / texture.heighttex;
		r := (clipping.x + clipping.w) / texture.widthtex;
		b := (clipping.y + clipping.h) / texture.heighttex;


    TempX1 := 0;
    TempY1 := 0;
    TempX2 := clipping.w ;
    TempY2 := clipping.H ;
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

     }
end;

procedure TSMESpriteBatch.DrawArray(Texture :PSDL_Texture;vertices: array of HGEVertex;count:Integer;  blend:integer=0) ;
begin

  if Assigned(FVertArray) then
  begin

    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin


      flush();
      FCurPrimType := SMEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;


    Move(vertices,FVertArray[FPrim],SizeOf(HGEVertex) * count *4 );
    Inc(FPrim,count div 4);

  end;
//  Writeln(count);
end;


procedure TSMESpriteBatch.DrawQuad(Texture :PSDL_Texture;dstrect,srcrect:TSDL_rect;color:Longword;blend:integer) ;
var
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
     vertices: array [0..4] of HGEVertex;
begin

  


  if Assigned(FVertArray) then
  begin


    TexX1 := srcrect.x / texture.widthTex;
    TexY1 := srcrect.y / texture.heightTex;
    TexX2 := (srcrect.x + srcrect.w) / texture.widthTex;
    TexY2 := (srcrect.y + srcrect.h) / texture.heightTex;


    TempX1 := dstrect.x;
    TempY1 := dstrect.y;
    TempX2 := (dstrect.x + dstrect.w);
    TempY2 := (dstrect.y + dstrect.h);


    setColor(color);


		vertices[0].x := TempX1;
		vertices[0].y := TempY1;
		vertices[0].col :=fcolor;
		vertices[0].tx := TexX1;
		vertices[0].ty := TexY1;

		vertices[1].x := TempX2;
		vertices[1].y := TempY1;
		vertices[1].col :=fcolor;
		vertices[1].tx := TexX2;
		vertices[1].ty := TexY1;

		vertices[2].x := TempX2;
		vertices[2].y := TempY2;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := TexX2;
		vertices[2].ty := TexY2;

		vertices[3].x := TempX1;
		vertices[3].y := TempY2;
		vertices[3].col :=fcolor;
		vertices[3].tx := TexX1;
		vertices[3].ty := TexY2;


    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin


      flush();
      FCurPrimType := SMEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);

  end;

  end;

procedure TSMESpriteBatch.setColor(color:Uint32) ;
var
    cr,cg,cb,ca:Single;
begin
      COLOR_UnRGBAF(color,cr,cg,cb,ca);
      Fcolor.r:=cr;       Fcolor.g:=cg;       Fcolor.b:=cb;       Fcolor.a:=ca;
//fcolor:=color;
end;

procedure TSMESpriteBatch.drawTile(Texture :PSDL_Texture; px,  py:single;clip:TSDL_Rect;color:Longword;blend:integer) ;

var
  l,t,r,b:single;
  TexX1, TexY1, TexX2, TexY2: Single;
  TempX1, TempY1, TempX2, TempY2: Single;
  vertices: array [0..4] of HGEVertex;


begin







    l := clip.x / texture.widthtex;
		t := clip.y / texture.heighttex;
		r := (clip.x + clip.w) / texture.widthtex;
		b := (clip.y + clip.h) / texture.heighttex;

    TexX1 := l;
    TexY1 := t;
    TexX2 := r;
    TexY2 := b;


    TempX1 := px;
    TempY1 := py;
    TempX2 := px+clip.w ;
    TempY2 := py+clip.H ;

 


    setColor(color);


		vertices[0].x := TempX1;
		vertices[0].y := TempY1;
//    vertices[0].z := 0.0;
		vertices[0].col :=fcolor;
		vertices[0].tx := TexX1;
		vertices[0].ty := TexY1;

		vertices[1].x := TempX2;
		vertices[1].y := TempY1;
  //  vertices[1].z := 0.0;
		vertices[1].col :=fcolor;
		vertices[1].tx := TexX2;
		vertices[1].ty := TexY1;

		vertices[2].x := TempX2;
		vertices[2].y := TempY2;
  //  vertices[2].z := 0.0;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := TexX2;
		vertices[2].ty := TexY2;

		vertices[3].x := TempX1;
		vertices[3].y := TempY2;
 //   vertices[3].z := 0.0;
		vertices[3].col :=fcolor;
		vertices[3].tx := TexX1;
		vertices[3].ty := TexY2;


    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin
       

      flush();
      FCurPrimType := SMEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);


	end;



  procedure TSMESpriteBatch.beginBatch();
  begin
   setColor($FFFFFFFF);
   if Assigned(FVertArray) then
    begin
      FreeMem(FVertArray);
      FVertArray := nil;
    end;
    FCurTexture:=NIL;
    GetMem( pointer(FVertArray),MAX_VERTICES * SizeOf(HGEVertex));

  FCurBlendMode:=-1;


                  



    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer    (2, GL_FLOAT, sizeof(hgeVertex),  @FVertArray[0].x);
    glEnableClientState(GL_COLOR_ARRAY);
    glColorPointer     (4, GL_FLOAT, sizeof(hgeVertex),  @FVertArray[0].col);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTexCoordPointer  (2, GL_FLOAT, sizeof(hgeVertex),  @FVertArray[0].tx);






  end;

  procedure TSMESpriteBatch.endBatch();
  begin
  Flush(True);
     //     glDisableClientState(GL_VERTEX_ARRAY);
     //     glDisableClientState(GL_TEXTURE_COORD_ARRAY);
     //     glDisableClientState(GL_COLOR_ARRAY);

  end;



procedure TSMESpriteBatch.flush(endscene:Boolean=false);

var
i:integer;
vertex:HGEVertex;
r,g,b,a:byte;
color:longword;
begin
  if Assigned(FVertArray) then
  begin
   if (FPrim <> 0) then
   begin

   


       glDrawElements(GL_TRIANGLES, FPrim *6  ,GL_UNSIGNED_SHORT, @Indices[0]);
//         glDrawArrays(GL_TRIANGLES,0, FPrim);


      end;

      FPrim := 0;
    end;

    if (EndScene) then
    begin
      FreeMem(FVertArray);
      FVertArray := nil;
    end ;


end;



procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture; x,  y:single;color:Longword;blend:integer);
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
 vertices: array [0..4] of HGEVertex;
begin



	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + texture.Width;
		   fy2 := Y + texture.Height;




           {
		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X;
		vertices[numPrims*4+1].y := fy2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);
    }
end;


procedure TSMESpriteBatch.drawSprite( Texture :PSDL_Texture;x,  y,width,  height:single;color:Longword;blend:integer);
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
 vertices: array [0..4] of HGEVertex;
begin



	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + Width;
		   fy2 := Y + Height;


      {


		vertices[numPrims*4+0].x := x;
		vertices[numPrims*4+0].y := y;
		colors[numPrims*4+0] :=Fcolor;
		texCoords[numPrims*4+0].x := u;
		texCoords[numPrims*4+0].y := v;

		vertices[numPrims*4+1].x := X;
		vertices[numPrims*4+1].y := fy2;
		colors[numPrims*4+1]:=Fcolor;
		texCoords[numPrims*4+1].x := u;
		texCoords[numPrims*4+1].y := v2;

		vertices[numPrims*4+2].x := fx2;
		vertices[numPrims*4+2].y := fy2;
	 	colors[numPrims*4+2]:=Fcolor;
		texCoords[numPrims*4+2].x := u2;
		texCoords[numPrims*4+2].y := v2;

		vertices[numPrims*4+3].x := fx2;
		vertices[numPrims*4+3].y := y;
		colors[numPrims*4+3]:=Fcolor;
		texCoords[numPrims*4+3].x := u2;
		texCoords[numPrims*4+3].y := v;
    inc(numPrims);
    }
end;


procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture; x,  y,  width,  height,angle:single; srcX,srcY,srcWidth,srcHeight:single;color:Longword;blend:integer);
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
 vertices: array [0..4] of HGEVertex;
begin


         		invTexWidth := 1.0 / texture.widthTex;
	        	invTexHeight := 1.0 / texture.heightTex;



         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;




     setColor(color);


		vertices[0].x := x1;
		vertices[0].y := y1;
		vertices[0].col :=fcolor;
		vertices[0].tx := u;
		vertices[0].ty := v;

		vertices[1].x := x2;
		vertices[1].y := y2;
		vertices[1].col :=fcolor;
		vertices[1].tx := u;
		vertices[1].ty := v2;

		vertices[2].x := x3;
		vertices[2].y := y3;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := u2;
		vertices[2].ty := v2;

		vertices[3].x := x4;
		vertices[3].y := y4;
		vertices[3].col :=fcolor;
		vertices[3].tx := u2;
		vertices[3].ty := v;


     

    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin
       

      flush();
      FCurPrimType := SMEPRIM_QUADS;
          if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);





end;

procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture; x,  y,originx,originy,scale,rotation:single;flipx,flipy:boolean;r,g,b,a:single;blend:integer) ;

var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
width,height,worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
 vertices: array [0..4] of HGEVertex;
begin
      width:=texture.width;
      height:=texture.height;

   		invTexWidth := 1.0 / texture.widthTex;
  		invTexHeight := 1.0 / texture.heightTex;


		// top left and bottom right corner points relative to origin
		worldOriginX := x + originX;
		worldOriginY := y + originY;
		fx := - originX;
		fy := - originY;
		fx2 :=  width - originX;
		fy2 :=  height - originY;

		// scale
    IF (scale<>1.0) THEN
    BEGIN
 		fx :=fx* scale;
		fy :=fy* scale;
		fx2 :=fx2* scale;
		fy2 :=fy2* scale;
    END;

		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


     IF (rotation<>0) then
     begin
         rad := rotation* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

		 x1 := cos * p1x - sin * p1y;
		 y1 := sin * p1x + cos * p1y;

		 x2 := cos * p2x - sin * p2y;
		 y2 := sin * p2x + cos * p2y;

		 x3 := cos * p3x - sin * p3y;
		 y3 := sin * p3x + cos * p3y;

		 x4 := cos * p4x - sin * p4y;
		 y4 := sin * p4x + cos * p4y;
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








	     u := 0;
		   v := 0;
		   u2 := 1;
		   v2 := 1;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;



        
fcolor.r:=r;
fcolor.g:=g;
fcolor.b:=b;
fcolor.a:=a;

       

		vertices[0].x := x1;
		vertices[0].y := y1;
		vertices[0].col :=fcolor;
		vertices[0].tx := u;
		vertices[0].ty := v;

		vertices[1].x := x2;
		vertices[1].y := y2;
		vertices[1].col :=fcolor;
		vertices[1].tx := u;
		vertices[1].ty := v2;

		vertices[2].x := x3;
		vertices[2].y := y3;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := u2;
		vertices[2].ty := v2;

		vertices[3].x := x4;
		vertices[3].y := y4;
		vertices[3].col :=fcolor;
		vertices[3].tx := u2;
		vertices[3].ty := v;





    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin


      flush();
      FCurPrimType := SMEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);







end;


procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture; x,  y,
originx,originy,
width,  height,
scale,
rotation:single;
srcX,srcY,srcWidth,srcHeight:single;
flipx,flipy:boolean;color:Longword;blend:integer);

var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
 vertices: array [0..4] of HGEVertex;
begin


   		invTexWidth := 1.0 / texture.widthTex;
  		invTexHeight := 1.0 / texture.heightTex;


		// top left and bottom right corner points relative to origin
		worldOriginX := x + originX;
		worldOriginY := y + originY;
		fx := - originX;
		fy := - originY;
		fx2 :=  width - originX;
		fy2 :=  height - originY;

		// scale
    IF (scale<>1.0) THEN
    BEGIN
 		fx :=fx* scale;
		fy :=fy* scale;
		fx2 :=fx2* scale;
		fy2 :=fy2* scale;
    END;

		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


     IF (rotation<>0) then
     begin
         rad := rotation* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

		 x1 := cos * p1x - sin * p1y;
		 y1 := sin * p1x + cos * p1y;

		 x2 := cos * p2x - sin * p2y;
		 y2 := sin * p2x + cos * p2y;

		 x3 := cos * p3x - sin * p3y;
		 y3 := sin * p3x + cos * p3y;

		 x4 := cos * p4x - sin * p4y;
		 y4 := sin * p4x + cos * p4y;
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








	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;




     setColor(color);



		vertices[0].x := x1;
		vertices[0].y := y1;
		vertices[0].col :=fcolor;
		vertices[0].tx := u;
		vertices[0].ty := v;

		vertices[1].x := x2;
		vertices[1].y := y2;
		vertices[1].col :=fcolor;
		vertices[1].tx := u;
		vertices[1].ty := v2;

		vertices[2].x := x3;
		vertices[2].y := y3;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := u2;
		vertices[2].ty := v2;

		vertices[3].x := x4;
		vertices[3].y := y4;
		vertices[3].col :=fcolor;
		vertices[3].tx := u2;
		vertices[3].ty := v;





    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin


      flush();
      FCurPrimType := SMEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);







end;



procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture; x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;color:Longword;blend:integer);
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
 vertices: array [0..4] of HGEVertex;
BEGIN




       		invTexWidth := 1.0 / texture.widthTex;
		      invTexHeight := 1.0 / texture.heightTex;



         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;








     setColor(color);


		vertices[0].x := x1;
		vertices[0].y := y1;
		vertices[0].col :=fcolor;
		vertices[0].tx := u;
		vertices[0].ty := v;

		vertices[1].x := x2;
		vertices[1].y := y2;
		vertices[1].col :=fcolor;
		vertices[1].tx := u;
		vertices[1].ty := v2;

		vertices[2].x := x3;
		vertices[2].y := y3;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := u2;
		vertices[2].ty := v2;

		vertices[3].x := x4;
		vertices[3].y := y4;
		vertices[3].col :=fcolor;
		vertices[3].tx := u2;
		vertices[3].ty := v;




    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin
       

      flush();
      FCurPrimType := SMEPRIM_QUADS;
           if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);


	end;




procedure TSMESpriteBatch.drawSprite(Texture :PSDL_Texture;x,  y,  width,  height:single;flipx,flipy:boolean;color:Longword;blend:integer);
var
tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
 vertices: array [0..4] of HGEVertex;
begin





	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := X + Width;
		   fy2 := Y + Height;



   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;

    

     setColor(color);


		vertices[0].x := x;
		vertices[0].y := y;
		vertices[0].col :=fcolor;
		vertices[0].tx := u;
		vertices[0].ty := v;

		vertices[1].x := x;
		vertices[1].y := fy2;
		vertices[1].col :=fcolor;
		vertices[1].tx := u;
		vertices[1].ty := v2;

		vertices[2].x := fx2;
		vertices[2].y := fy2;
	 	vertices[2].col :=fcolor;
		vertices[2].tx := u2;
		vertices[2].ty := v2;

		vertices[3].x := fx2;
		vertices[3].y := y;
		vertices[3].col :=fcolor;
		vertices[3].tx := u2;
		vertices[3].ty := v;




    if (FPrim >= MAX_VERTICES div SMEPRIM_QUADS)
      or (FCurTexture <> Texture)
      or (FCurBlendMode <> Blend)
      then
    begin
       

      flush();
      FCurPrimType := SMEPRIM_QUADS;
           if (FCurBlendMode <> Blend) then    SetBlendMode(Blend);
      if (Texture <> FCurTexture) then
      begin
        glBindTexture(GL_TEXTURE_2D, Texture.Glid);
        FCurTexture := Texture;
      end;

    end;

    Move(vertices,FVertArray[FPrim * SMEPRIM_QUADS],SizeOf(HGEVertex) * SMEPRIM_QUADS);
    Inc(FPrim);


	end;












(****************************************************************************
 * HGEFont.h, HGEFont.cpp
 ****************************************************************************)

const
  FNTHEADERTAG = '[HGEFONT]';
  FNTBITMAPTAG = 'Bitmap';
  FNTCHARTAG = 'Char';

{ TSMEFont }



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
  FBlend := SDL_BLENDMODE_BLEND;
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



     FTexture := smeLoadTextureFromFile(pchar(s));
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
  FBlend := SDL_BLENDMODE_BLEND;
  FCol := $FFFFFFFF;





 ResourceLoad(Filename,data,Size);



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


     FTexture := smeLoadTextureFromFile(pchar(s));
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


procedure TSMEFont.PrintF(Batch:TSMESpriteBatch; X, Y: Single; const Align: Integer;
  const Format: String; const Args: array of const);
begin
  Render(Batch,X,Y,Align,SysUtils.Format(Format,Args));
end;

procedure TSMEFont.PrintFB(Batch:TSMESpriteBatch; X, Y, W, H: Single; const Align: Integer;
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

  Render(Batch,TX,TY,Align,Buf);
end;

procedure TSMEFont.Render(Batch:TSMESpriteBatch; X, Y: Single; const Algn: Integer;const S: String);
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
        Batch.drawTile(FTexture,fx,fy,FClips[i],FCol,FBlend);

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
         

//*************************************

function TSMETextureList.Get(Index: Integer): TTexture;
begin
 Result:=inherited get(Index);
end;

procedure TSMETextureList.Put(Index: Integer; Item: TTexture);
begin
 inherited put(Index, Item);
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
tex.texture:=smeLoadTextureFromFile(pchar(fname));
if not assigned(tex) then tex.texture:=smeCreateRectangleTexture(32,32,$FFFFFF,true);
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
  glEnable(GL_TEXTURE_2D);
end;

//------------------------------------------------------------------------------
procedure TSMETextureList.DisableTexturing;
begin
 glDisable(GL_TEXTURE_2D);
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

end;
destructor TSMESpriteSheet.Destory();
begin
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



procedure TSMESpriteSheet.load(fname:string);
var
 region:TSMERegion;
child,node,doc:pointer;
value:integer;
s:string;
begin


  doc:=smeLoadDocFromFile(pchar(fname));
  if assigned(doc) then
  begin
  node:=smeFirstNodeChildByName(doc,'TextureAtlas');
  s:=smeGetAttribute(node,'imagePath');
  s:=file_GetDirectory(fname)+s;
  texture :=smeLoadTextureFromFile(pchar(s));


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

name:=fname;
 x:=0;
 y:=0;
 texture:=smeLoadTextureFromFile(pchar(fname));
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






//***************************
constructor TSMECamera.Create(width,height:Integer);
begin
bound.SetRect(0,0,Width,Height);
ScreenWidth:=width;
ScreenHeight:=height;
x:=0;
y:=0;
fzoom:=1;
ftarget:=nil;
 fposition.x:=0;
 fposition.y:=0;
 fscale.x:=1;
 fscale.y:=1;
 fangle:=0;



end;


procedure TSMECamera.moveX(value:single);
begin
fposition.X:=fposition.X+value;
end;
procedure TSMECamera.moveY(value:single);
begin
fposition.y:=fposition.y+value;
end;
procedure TSMECamera.Move(x,y:single);
begin
fposition.X:=fposition.X+x;
fposition.y:=fposition.y+y;
end;
procedure TSMECamera.Translate(x,y:single);
begin
fposition.X:=x;
fposition.X:=y;

end;

procedure TSMECamera.rotate(value:single);
begin
fangle:=value;
end;
procedure TSMECamera.addRotate(value:single);
begin
fangle:=fangle+value;
end;
procedure TSMECamera.scale(x,y:single);
begin
fscale.x:=x;
fscale.y:=y;
end;

procedure TSMECamera.zoom(value:single);
begin
fscale.x:=fscale.x+value;
fscale.y:=fscale.y+value;
end;

procedure TSMECamera.Update();
var
mat1,mat2,mat3,mat4,matRotate,matScale,matTraslate:Matrix;

begin
matTraslate:=MatrixIdentity;
matScale:=MatrixIdentity;
matRotate:=MatrixIdentity;





mat1:=MatrixTranslation(-ScreenWidth/2,-ScreenHeight/2,0);
mat2:=MatrixRotation(0,0,fangle/rad2deg);
mat3:=MatrixTranslation(ScreenWidth/2,ScreenHeight/2,0);
mat4:=MatrixMultiply4x4(mat1,mat2);

matRotate:=MatrixMultiply4x4(mat1,matRotate);
matRotate:=MatrixMultiply4x4(mat2,matRotate);
matRotate:=MatrixMultiply4x4(mat3,matRotate);


matTraslate:=MatrixTranslation((-ScreenWidth/2)+fposition.x,(-ScreenHeight/2)+fposition.y,0);
matScale:=MatrixScale(fscale.x,fscale.y,1);



viewMatrix:=MatrixMultiply4x4(matScale,matRotate);
viewMatrix:=MatrixMultiply4x4(matTraslate,viewMatrix);
        

//viewMatrix:=MatrixRotation(0,0,sin(smeGetTicks/100));


    if assigned(ftarget) then
    begin

			 	x := (ftarget.x + ftarget.width / 2 - ScreenWidth / (2 * fzoom));
			 	y := (ftarget.y + ftarget.height /2 - ScreenHeight / (2 * fzoom));

		 		x := clamp(x, bound.X1, bound.x2 - ScreenWidth / fzoom);
		 		y := clamp(y, bound.y1, bound.y2 - ScreenHeight / fzoom);


    end else
    begin
     	 		x := clamp(x, bound.X1, bound.x2 - ScreenWidth / fzoom);
		 	  	y := clamp(y, bound.y1, bound.y2 - ScreenHeight / fzoom);

    end;


   // Gfx_RenderRect(bound.x1,bound.y1,bound.x2,bound.y2,1,0,1,0);

end;
procedure TSMECamera.setFollow(target:TSMEModel);
begin
ftarget:=target;
end;

procedure TSMECamera.setWorldBound(minx,miny,maxx,maxy:single);
begin
self.bound.SetRect(minx,miny,maxx,maxy);
end;

constructor TSMECameraOrtho.Create(width,height:integer);
begin
  inherited create(width,height);
 ScreenWidth:=width;
 ScreenHeight:=height;
 projMatrix:=MatrixIdentity;
 viewMatrix:=MatrixIdentity;
 transpositionPool:=MatrixIdentity;
 projViewMatrix:=MatrixIdentity;
// projMatrix:=MatrixOrtho(0,width,height, 0, -1, 1);
projMatrix:=MatrixOrtho(-width/2,width/2,height/2, -height/2, -1, 1);

end;
procedure TSMECameraOrtho.resize(width,height:Integer);
begin
ScreenWidth:=width;
ScreenHeight:=height;
//projMatrix:=MatrixOrtho(0,width,height, 0, -1, 1);

projMatrix:=MatrixOrtho(-width/2,width/2,height/2, -height/2, -1, 1);


end;

function   TSMECameraOrtho.getCombinedTransposeMatrix:Matrix;
var
  transpose:Matrix;
begin
transpositionPool:=MatrixTranspose(projMatrix);
projViewMatrix:=MatrixMultiply4x4(transpositionPool,viewMatrix);
Result:=projViewMatrix;
end;

function   TSMECameraOrtho.getCombinedMatrix:Matrix;
var
  transpose:Matrix;
begin
//transpositionPool:=MatrixTranspose(projMatrix);
projViewMatrix:=MatrixMultiply4x4(projMatrix,viewMatrix);
Result:=projViewMatrix;
end;

//****************************************
constructor TSMECanvas.Create;
begin


end;
destructor TSMECanvas.Destroy;
begin

end;
procedure TSMECanvas.Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean );
var
  Max, I: Integer;
  Ic, IInc: Single;
begin


  setColor(color);
  if Radius > 1000 then Radius := 1000;
  Max := Round(Radius);
  IInc := 1 / Max;
  Ic := 0;
  Vertices[0].X := x;
  Vertices[0].Y := y;
  Vertices[0].color := fColor;
  for I := 1 to Max + 1 do
  begin
    Vertices[I].X := X + Radius * Cos(Ic * TwoPI);
    Vertices[I].Y := Y + Radius * Sin(Ic * TwoPI);
    Vertices[I].color := fColor;
    Ic := Ic + IInc;
  end;

  if not Filled then
  begin
    Vertices[0].X := Vertices[Max + 1].X;
    Vertices[0].Y := Vertices[Max + 1].Y;
glVertexPointer(2, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);
glDrawArrays(GL_LINE_STRIP, 0, max+2);
  end
  else
  begin
glVertexPointer(2, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);
glDrawArrays(GL_TRIANGLE_FAN, 0, max+2);
  end;

end;

procedure TSMECanvas.Quadrangle(x1,y1,x2,y2:single; Color: Cardinal; Filled: Boolean);
var
xmin,xmax,ymin,ymax:single;
i:Integer;
begin
 setColor(color);


         xMin := x1;
         xMax := x2;
         yMin := y1;
         yMax := y2;

          if Filled then
          begin

        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x:= xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;

glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);
glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
end else
begin
        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x := xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;

        vertices[4].x := xMin;
        vertices[4].y := yMin;
        vertices[4].color:=fcolor;

        vertices[5].x := xMin;
        vertices[5].y := yMax;
        vertices[5].color:=fcolor;


        vertices[6].x := xMax;
        vertices[6].y := yMin;
        vertices[6].color:=fcolor;

        vertices[7].x := xMax;
        vertices[7].y := yMax;
        vertices[7].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

 glDrawArrays(GL_LINES, 0, 8) ;
end;

end;

procedure TSMECanvas.Line(x1,y1,x2,y2:single; Color: Cardinal);
var
xmin,xmax,ymin,ymax:single;
i:Integer;
begin
 setColor(color);


         xMin := x1;
         xMax := x2;
         yMin := y1;
         yMax := y2;

         vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x:= xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

glDrawArrays(GL_LINES, 0, 4)



end;


procedure TSMECanvas.Polygon(Points: array of Vector2D; NumPoints: Integer;Color: Cardinal; Filled: Boolean);
var
  I: Integer;
begin
   setColor(color);

  for I := 0 to NumPoints - 1 do
  begin
    Vertices[I].X := Points[I].X;
    Vertices[I].Y := PointS[I].Y;
    Vertices[I].Color := fColor;
  end;


  if Filled then
  begin
  glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

glDrawArrays(GL_TRIANGLE_FAN, 0, NumPoints - 2)

//    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, NumPoints - 2);
  end
  else
  begin
    Vertices[NumPoints].X := Points[0].X;
    Vertices[NumPoints].y := Points[0].Y;
    Vertices[NumPoints].Color := fColor;
    glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

glDrawArrays(GL_LINE_STRIP, 0, NumPoints )

//    FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, NumPoints);
 end;
end;

procedure TSMECanvas.Polygon(Points: array of Vector2D; Color: Cardinal; Filled: Boolean);
begin
  Polygon(Points, High(Points) + 1, Color, Filled);
end;


procedure TSMECanvas.Rectangle(x,y,width,height:single; Color: Cardinal; Filled: Boolean);
var
xmin,xmax,ymin,ymax:single;
i:Integer;
begin
 setColor(color);


         xMin := x;
         xMax := (x+width);
         yMin := y;
         yMax := (y+height);

          if Filled then
          begin

        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x:= xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
end else
begin
        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x := xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;

        vertices[4].x := xMin;
        vertices[4].y := yMin;
        vertices[4].color:=fcolor;

        vertices[5].x := xMin;
        vertices[5].y := yMax;
        vertices[5].color:=fcolor;


        vertices[6].x := xMax;
        vertices[6].y := yMin;
        vertices[6].color:=fcolor;

        vertices[7].x := xMax;
        vertices[7].y := yMax;
        vertices[7].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

  glDrawArrays(GL_LINES, 0, 8) ;
end;

end;


procedure TSMECanvas.Rect(rect:TSDL_rect; Color: Cardinal; Filled: Boolean);
var
xmin,xmax,ymin,ymax:single;
i:Integer;
begin
 setColor(color);

         xMin := rect.x;
         xMax := (rect.x + rect.w);
         yMin := rect.y;
         yMax := (rect.y + rect.h);

          if Filled then
          begin

        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x:= xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
end else
begin
        vertices[0].x := xMin;
        vertices[0].y := yMin;
        vertices[0].color:=fcolor;

        vertices[1].x := xMax;
        vertices[1].y := yMin;
        vertices[1].color:=fcolor;

        vertices[2].x := xMin;
        vertices[2].y := yMax;
        vertices[2].color:=fcolor;

        vertices[3].x := xMax;
        vertices[3].y := yMax;
        vertices[3].color:=fcolor;

        vertices[4].x := xMin;
        vertices[4].y := yMin;
        vertices[4].color:=fcolor;

        vertices[5].x := xMin;
        vertices[5].y := yMax;
        vertices[5].color:=fcolor;


        vertices[6].x := xMax;
        vertices[6].y := yMin;
        vertices[6].color:=fcolor;

        vertices[7].x := xMax;
        vertices[7].y := yMax;
        vertices[7].color:=fcolor;
glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

  glDrawArrays(GL_LINES, 0, 8) ;
end;

end;

procedure TSMECanvas.Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
   setColor(color);
  if R1 > 1000 then R1 := 1000;
  Max := Round(R1);
  IInc := 1 / Max;
  Ic := 0;
  Vertices[0].X := X;
  Vertices[0].Y := Y;
  Vertices[0].Color := fColor;
  for i := 1 to max + 1 do
  begin
    Vertices[I].X := X + R1 * Cos(Ic * TwoPI);
    Vertices[I].Y := y + R2 * Sin(Ic * TwoPI);
    Vertices[I].Color := fColor;
    Ic := Ic + IInc;
  end;

  if not Filled then
  begin
    Vertices[0].X := Vertices[Max + 1].X;
    Vertices[0].Y := Vertices[Max + 1].Y;
    glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

    glDrawArrays(GL_LINE_STRIP, 0, max+2);

  end
  else
  begin
  glVertexPointer(3, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].x);
glColorPointer(4, GL_FLOAT, sizeof(Colorvertex), @Vertices[0].color);

    glDrawArrays(GL_TRIANGLE_FAN, 0, max+2);
 end;

end;

procedure TSMECanvas.setColor(color:Uint32) ;
var
    cr,cg,cb,ca:Single;
begin
      COLOR_UnRGBAF(color,cr,cg,cb,ca);
      Fcolor.r:=cr;       Fcolor.g:=cg;       Fcolor.b:=cb;       Fcolor.a:=ca;
   // fcolor:=color;
end;
procedure TSMECanvas.Bind(mat:Matrix);
begin
  SetBlendMode(SDL_BLENDMODE_NONE);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);




end;
procedure TSMECanvas.Ubind;
begin

end;


//***********************************************************************

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
constructor TSMETileMap.Create(camera:TSMECamera;  fname:string);
var
   MapWidth,mapheight,  frameWidth,FrameHeight:integer;

   countx,county: Integer;

datanode,layernode, objnode,objgroup, nodeimg, tilesnode, child,node,doc:pointer;
value:integer;
s:string;
cx, cy, c,gid: Integer  ;
ox,oy,ow,oh:integer;
begin
  fcamera:=camera;
   x:=0;
   y:=0;
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



   Ftexture :=smeLoadTextureFromFile(pchar(s));

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

     FCountTiles:=countx*county;
     ColCount := fTexture.width div frameWidth;

invTexWidth :=1.0/ftexture.widthTex;
invTexHeight:=1.0/ftexture.heightTex;
//FillChar(Vertices,SizeOf(Vertices),0);



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


constructor TSMETileMap.Create(camera:TSMECamera;texture:PSDL_Texture;frameWidth,FrameHeight,MapWidth,mapheight:integer);
var
move,ti,lx,ly,countx,county:integer;
begin
fcamera:=camera;
x:=0;
y:=0;


     if not assigned(texture) then exit;
     width:=frameWidth;
     height:=FrameHeight;
     Ftexture:=texture;

     countx:=texture.width  div frameWidth;
     county:=texture.height div FrameHeight;

invTexWidth :=1.0/ftexture.widthTex;
invTexHeight:=1.0/ftexture.heightTex;




     SetMapSize(MapWidth,mapheight);
     FCountTiles:=countx*county;

      MapObject:=Tlist.Create;


    ColCount := Texture.width div frameWidth;
end;

destructor TSMETileMap.Destroy;
var
i:integer;
begin
      SetMapSize(0, 0);
      MapObject.Destroy;
      inherited Destroy;
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
{
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




end;
     }

procedure TSMETileMap.RenderBatch(batch:TSMESpriteBatch);
var
   _x, _y, cx, cy, cx2, cy2, c, ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_,  dWidth, dHeight: Integer;
   r:TSDL_rect;
begin
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;



     ChipWidth := Width;
     ChipHeight :=Height;

     dWidth  := (fcamera.ScreenWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (fcamera.ScreenHeight + ChipHeight) div ChipHeight + 1;

     _x := Trunc(-fcamera.x - X);
     _y := Trunc(-fcamera.y - Y);

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





          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin
                    c := GetCell(cx - StartX + StartX_, cy - StartY + StartY_);
                      if c >=1 then
                    begin
                     r:=getClip(c-1);
                     batch.drawTile(Ftexture,cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,r,$FFFFFFFF);
                    end;
               end;
          end;



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



        {
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

      }




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
//************************************************************

constructor TSMETilesMap.Create(  fname:string);
var
   MapWidth,mapheight,  frameWidth,FrameHeight:integer;

   i,countx,county: Integer;

datanode,layernode, objnode,objgroup, nodeimg, tilesnode, child,node,doc:pointer;
value:integer;
s:string;
cx, cy, c,gid: Integer  ;
ox,oy,ow,oh:integer;
begin
x:=0;
y:=0;

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



   Ftexture :=smeLoadTextureFromFile(pchar(s));

   layers:=0;

   layernode:=smeFirstNodeChildByName(node,'layer');
  while (layernode<>nil) do
  begin


   s:=smeGetAttribute(layernode,'name');
 //   Writeln('layer ',s);

  SetLength(tiles,Length(tiles)+1);
  tiles[layers].init(s,ftexture,frameWidth,FrameHeight,MapWidth,mapheight);

  datanode:=smeFirstNodeChildByName(layernode,'data');
  child:=smeFirstNodeChildByName(datanode,'tile');
  value:=0;
  while (child<>nil) do
  begin
   smeGetIntAttribute(child,'gid',gid);
   tiles[layers].Map[value]:=gid;
   inc(value);
   child:=smeGetNextNodeSibling(child);
  end;
    Inc(layers);
    layernode:=smeGetNextNodeSibling(layernode);
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



  for i:=0 to layers-1 do
  begin

  for cy := 0 to FMapHeight - 1 do
   begin
       for cx := 0 to FMapWidth - 1 do
          begin
        c := GetCell(i,cx , cy );
        SetCollisionMapItem(i,cx,cy,false);
        if (c<>0) then
        begin
        SetCollisionMapItem(i,cx,cy,true);
        end;
       end;
    end;
  end;


end;



destructor TSMETilesMap.Destroy;
var
i:integer;
begin

for i:=0 to layers-1 do
tiles[i].free;

      MapObject.Destroy;

end;


procedure TSMETilesMap.addOBJ(name:string;ox,oy,ow,oh:integer);
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
function TSMETilesMap.numObjs:integer;
begin
result:= MapObject.Count
end;
function TSMETilesMap.getOBJ(index:integer):TMapObject;
begin
if MapObject.Count<0 then exit;
result:=MapObject.Items[index];
end;

procedure TSMETilesMap.Render(camera:TSMECamera;batch:TSMESpriteBatch);
var
   l,_x, _y, cx, cy, cx2, cy2, c, ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_,  dWidth, dHeight: Integer;
   r:TSDL_rect;
begin
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;



     ChipWidth := Width;
     ChipHeight :=Height;

     dWidth  := (camera.ScreenWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (camera.ScreenHeight + ChipHeight) div ChipHeight + 1;

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


                   for l:=0 to layers-1 do
                   begin

          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin

                    c := GetCell(l,cx - StartX + StartX_, cy - StartY + StartY_);
                      if c >=1 then
                    begin
                      r:=tiles[l].getClip(c-1);

                     batch.drawTile(Ftexture,cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,r,$FFFFFFFF,SDL_BLENDMODE_BLEND);
                    end;

               end;
          end;
                   end; 


 end;
procedure TSMETilesMap.RenderLayer(index:Integer;camera:TSMECamera;batch:TSMESpriteBatch);
var
   l,_x, _y, cx, cy, cx2, cy2, c, ChipWidth, ChipHeight: Integer;
   StartX, StartY, EndX, EndY, StartX_, StartY_,  dWidth, dHeight: Integer;
   r:TSDL_rect;
begin
     if (FMapWidth <= 0) or (FMapHeight <= 0) then Exit;



     ChipWidth := Width;
     ChipHeight :=Height;

     dWidth  := (camera.ScreenWidth + ChipWidth) div ChipWidth + 1;
     dHeight := (camera.ScreenHeight + ChipHeight) div ChipHeight + 1;

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




          for cy := StartY to EndY - 1 do
          begin
               for cx := StartX to EndX - 1 do
               begin
                    c := GetCell(index,cx - StartX + StartX_, cy - StartY + StartY_);
                      if c >=1 then
                    begin
                      r:=tiles[index].getClip(c-1);

                     batch.drawTile(Ftexture,cx * ChipWidth + OfsX,cy * ChipHeight + OfsY,r,$FFFFFFFF,SDL_BLENDMODE_BLEND);
                    end;
               end;
          end;



 end;

function TSMETilesMap.numLayer:Integer;
begin
  Result:=layers;

end;














function TSMETilesMap.GetCell(layer,X, Y: Integer): Integer;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
       result:= tiles[layer].Map[Y * FMapWidth + X ]

end;


function TSMETilesMap.GetCollisionMapItem(layer,X, Y: Integer): Boolean;
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
         Result :=  tiles[layer].CollisionMap[Y * FMapWidth+X]
     else
         Result := False;
end;


procedure TSMETilesMap.SetCell(layer,X, Y: Integer; Value: Integer);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
          tiles[layer].Map[Y * FMapWidth + X]:= Value;
end;

procedure TSMETilesMap.SetCollisionMapItem(layer,X, Y: Integer; Value: Boolean);
begin
     if (X >= 0) and (X < FMapWidth) and (Y >= 0) and (Y < FMapHeight) then
          tiles[layer].CollisionMap[Y * FMapWidth + X] := Value;
end;





procedure TSMETilesMap.SetMapSize(AMapWidth, AMapHeight: Integer);
begin
          FMapW := Width * AMapWidth;
          FMapH := Height * AMapHeight;
          FMapWidth := AMapWidth;
          FMapHeight := AMapHeight;

        //  setlength(FMap,FMapWidth * FMapHeight);
         // setlength(FCollisionMap,FMapWidth * FMapHeight);

end;


//*************************************************************
function TSMEMapLayer.GetCell(X, Y: Integer): Integer;
begin
     if (X >= 0) and (X < Width) and (Y >= 0) and (Y < height) then
       result:= Map[Y * Width + X ]

end;


procedure TSMEMapLayer.init(layername:string; texture:PSDL_Texture;tileWidth,tileHeight,mWidth,mHeight:integer) ;
begin
  setlength(Map,mWidth * mHeight);
  setlength(CollisionMap,mWidth * mHeight);
  name:=layername;
   Ftexture:=texture;


    width :=mWidth;
    height:=mHeight;
    twidth:=tileWidth;
    theight:=tileHeight;

    ColCount := fTexture.width div twidth;


end;

function TSMEMapLayer.getClip(frame:integer):TSDL_Rect;
 var
 Left, Right, Top, Bottom: Integer;

begin
  Left := (frame mod ColCount) * twidth;
  Right :=  twidth;
  Top := (frame div ColCount) * theight;
  Bottom := theight;
  result:=sdl_rect(left,top,right,bottom);


end;

procedure TSMEMapLayer.free;
begin
 setlength(Map,0);
  setlength(CollisionMap,0);


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
//**********************
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
      

name:='Object';

end;
destructor TSMEModel.Destroy();
begin
fchilds.Clear;
fchilds.Destroy;
Fmatrix.Free;

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

procedure TSMEModel.setCamera(cam:TSMECamera);
begin
if assigned(cam) then camera:=cam;
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
       cx:=camera.x;
       cy:=camera.y;
      end else
      begin
			 cx := 0;
			 cy := 0;
      end; 

			if ((scaleX <> 1) or (scaleY <> 1))  then
      begin
      //  fmatrix.translate(-PivotX,-PivotY);
        fmatrix.translate(-pivotx + sx - cx * scrollx, -pivoty + sy - cy * scrolly);
        fmatrix.scale(scaleX,scaleY);
        fmatrix.translate(pivotx + sx - cx * scrollx, pivoty + sy - cy * scrolly);
			end else
      fmatrix.translate(sx - cx * scrollx, sy - cy * scrolly);

  if ((PivotX <> 0.0) or (PivotY <> 0.0)) then
  begin
     fMatrix.tx := sx - cx * scrollx - fMatrix.a * PivotX  - fMatrix.c * PivotY;
     fMatrix.ty := sy - cy * scrolly - fMatrix.b * PivotX  - fMatrix.d * PivotY;
  end;



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
procedure TSMEModel.setParent(parent:TSMEModel);
begin
fparent:=parent;
end;
///***************************************************

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

            particle.color.r:=particle.colorArgb.r;
            particle.color.g:=particle.colorArgb.g;
            particle.color.b:=particle.colorArgb.b;
            particle.color.a:=particle.colorArgb.a;

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
   constructor PDParticle.Create();
   begin
    x :=0;
    y :=0;
     rotation:=0;
     currentTime := 0.0;
            totalTime:=1;
            alpha:=1;
            scale := 1.0;
            color.r := 1;
            color.g := 1;
            color.b := 1;
            color.a := 1;
            colorArgb:=TColorArgb.Create;
            colorArgbDelta:=TColorArgb.Create;

   end;

constructor TSMEEmitter.Create (fname:string);
var
n,x,i:integer;
par:PDParticle;
s,TagName: string;
node,doc,nodes,child:pointer;
value:double;
begin
inherited create;

mBlend:=SDL_BLENDMODE_ADD;
numPrims :=0;


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
    texture :=  smeLoadTextureFromFile(pchar(s));



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
     {

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






vertices[numPrims*4+0].Col := particle.Color;
vertices[numPrims*4+1].Col := particle.Color;
vertices[numPrims*4+2].Col := particle.Color;
vertices[numPrims*4+3].Col := particle.Color;
inc(numPrims);

   inc(rendervertices);
      }
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
	 {	 u := srcX * invTexWidth;
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
    }
	end;

procedure  TSMEEmitter.Update(passedTime:Single);
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






end;

procedure  TSMEEmitter.Render(batch:TSMESpriteBatch);
var

particle:PDParticle;

i:integer;
w,h:Single;

begin




  w:=texture.width;
  h:=texture.height;






            for i:=0 to mNumParticles-1 do
            begin
              particle := PDParticle(mParticles[i]);


             batch.drawSprite(texture,
             particle.x,
             particle.y,
             w/2,h/2 ,

             particle.scale,
             particle.rotation,
              False,False,
              particle.Color.r,
              particle.Color.g,
              particle.Color.b,
              particle.Color.a,
              mBlend);


            end;

end;                  


//*********************************

procedure TSMEGroup.add(md:TSMEModel);
begin
 addChild(md);
 NeedSort := true;
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
   fchilds.Remove( md );
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




constructor TSMEGame.Create(width,heigth:integer;world_width,worldheigth:single;gameState:TSMEState);
begin
requestedReset := false;
requestNewState(gameState);
LoadGame();
end;
procedure TSMEGame.Destroy();
begin
EndGame();
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
   if assigned(fstate) then
   begin
    	fstate.update(dt);
 		end;
end;


procedure TSMEGame.LoadGame();
begin
end;
procedure TSMEGame.EndGame();
begin
end;






end.
