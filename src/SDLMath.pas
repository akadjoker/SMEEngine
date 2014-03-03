unit SDLMath;

interface
uses sysutils,math,classes;



  type
 //---------------------------------------------------------------------------
 PPoint2 = ^TPoint2;

 TPoint2 = record
  x, y: Single;
 end;
 TPoints2=array of TPoint2;

 //---------------------------------------------------------------------------
  TPoint3 = record
  x, y, z: Single;
 end;

 PPoint4 = ^TPoint4;
 TPoint4 = array[0..3] of TPoint2;




 //---------------------------------------------------------------------------
const
 VecUp2   : TPoint2 = (x: 0.0; y: -1.0);
 VecDown2 : TPoint2 = (x: 0.0; y: 1.0);
 VecLeft2 : TPoint2 = (x: -1.0; y: 0.0);
 VecRight2: TPoint2 = (x: 1.0; y: 0.0);
 VecZero2 : TPoint2 = (x: 0.0; y: 0.0);


const PI2       =  6.283185307179586476925286766559000;
const PIDiv180  =  0.017453292519943295769236907684886;
const _180DivPI = 57.295779513082320876798154814105000;


type


//---------------------------------------------------------------------------
 PColor4 = ^TColor4;
 TColor4 = array[0..3] of Cardinal;



//---------------------------------------------------------------------------
const


 clWhite4  : TColor4 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
 clBlack4  : TColor4 = ($FF000000, $FF000000, $FF000000, $FF000000);
 clMaroon4 : TColor4 = ($FF000080, $FF000080, $FF000080, $FF000080);
 clGreen4  : TColor4 = ($FF008000, $FF008000, $FF008000, $FF008000);
 clOlive4  : TColor4 = ($FF008080, $FF008080, $FF008080, $FF008080);
 clNavy4   : TColor4 = ($FF800000, $FF800000, $FF800000, $FF800000);
 clPurple4 : TColor4 = ($FF800080, $FF800080, $FF800080, $FF800080);
 clTeal4   : TColor4 = ($FF808000, $FF808000, $FF808000, $FF808000);
 clGray4   : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clSilver4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clRed4    : TColor4 = ($FF0000FF, $FF0000FF, $FF0000FF, $FF0000FF);
 clLime4   : TColor4 = ($FF00FF00, $FF00FF00, $FF00FF00, $FF00FF00);
 clYellow4 : TColor4 = ($FF00FFFF, $FF00FFFF, $FF00FFFF, $FF00FFFF);
 clBlue4   : TColor4 = ($FFFF0000, $FFFF0000, $FFFF0000, $FFFF0000);
 clFuchsia4: TColor4 = ($FFFF00FF, $FFFF00FF, $FFFF00FF, $FFFF00FF);

 clAqua4   : TColor4 = ($FFFFFF00, $FFFFFF00, $FFFFFF00, $FFFFFF00);
 clLtGray4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clDkGray4 : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clOpaque4 : TColor4 = ($00FFFFFF, $00FFFFFF, $00FFFFFF, $00FFFFFF);



 ZeroCoord4: TPoint4 = ((x: 0.0; y: 0.0), (x: 0.0; y: 0.0), (x: 0.0; y: 0.0),
  (x: 0.0; y: 0.0));



 const
 clWhite1  : Cardinal = $FFFFFFFF;
 clBlack1  : Cardinal = $FF000000;
 clMaroon1 : Cardinal = $FF800000;
 clGreen1  : Cardinal = $FF008000;
 clOlive1  : Cardinal = $FF808000;
 clNavy1   : Cardinal = $FF000080;
 clPurple1 : Cardinal = $FF800080;
 clTeal1   : Cardinal = $FF008080;
 clGray1   : Cardinal = $FF808080;
 clSilver1 : Cardinal = $FFC0C0C0;
 clRed1    : Cardinal = $FFFF0000;
 clLime1   : Cardinal = $FF00FF00;
 clYellow1 : Cardinal = $FFFFFF00;
 clBlue1   : Cardinal = $FF0000FF;
 clFuchsia1: Cardinal = $FFFF00FF;
 clAqua1   : Cardinal = $FF00FFFF;
 clLtGray1 : Cardinal = $FFC0C0C0;
 clDkGray1 : Cardinal = $FF808080;
 clOpaque1 : Cardinal = $00FFFFFF;
 clUnknown : Cardinal = $00000000;






//---------------------------------------------------------------------------
type
 PPolygon = ^TPolygon;
 TPolygon = array of TPoint2;

  TTriangle=record
  a,b,c:TPoint2;
  end;

  Triangles=array of TTriangle;


//---------------------------------------------------------------------------
TPoint=record
x,y:integer;
end;
TRect=record
left,top,right,bottom:integer;
end;
 TBezierPoints  = array[0..3] of TPoint;
 TBezierPoints2 = TPoint4;


function Point2(x, y: Real): TPoint2;
function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4;
function pRect4(const Rect: TRect): TPoint4;
//---------------------------------------------------------------------------
// Extended Point4 helper routines.
//---------------------------------------------------------------------------

function pBounds4s(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
function pBounds4s2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
function pBounds4sc2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
// rotated rectangle (Origin + Size) around (Middle) with Angle and Scale
function pRotate42(const Origin, Size, Middle: TPoint2; Angle: Real;
 ScaleX, ScaleY: Real): TPoint4;
function pRotate4c2(const Origin, Size: TPoint2; Angle,
 ScaleX, ScaleY: Real): TPoint4;
function pRotateTransForm(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4,
 CenterX, CenterY, Angle: Real; Scale: Real = 1.0): TPoint4;
function pRotateTransForm2(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4,
 CenterX, CenterY, Angle, ScaleX, ScaleY: Real): TPoint4;
 function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real;
 Scale: Real): TPoint4;
 function pBounds4sc(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;

//---------------------------------------------------------------------------
// Color helper routines
//---------------------------------------------------------------------------
function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4; overload;
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4; overload;
function cColor4(Color: Cardinal): TColor4; overload;
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4; overload;
function cGray4(Gray: Cardinal): TColor4; overload;
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4; overload;
function cAlpha4(Alpha: Cardinal): TColor4; overload;
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4; overload;
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;

 function pRotate4c(const Origin, Size: TPoint2; Angle: Real;Scale: Real): TPoint4;
function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
function cGray1(Gray: Cardinal): Cardinal;
function cAlpha1(Alpha: Cardinal): Cardinal;


//---------------------------------------------------------------------------
function BezierPoints(const OriginPoint, DestPoint, C1Point, C2Point: TPoint): TBezierPoints; overload;
function BezierPoints(const OriginPoint, DestPoint, C1Point, C2Point: TPoint2): TBezierPoints2;overload;

//---------------------------------------------------------------------------
// returns True if the point4  Quadrangle overlap
//---------------------------------------------------------------------------
function OverlapQuadrangle(const Q1, Q2: TPoint4): Boolean;
function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
function RectInRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------



//---------------------------------------------------------------------------
// returns True if polygons overlap
// last points of polygons must be the first one ( P1[0] = P1[N]  ; P2[0] = P2[N] )
//---------------------------------------------------------------------------


{Returns whether a point lies inside a triangle. ap1 specifies the point,
 tp1, tp2 and tp3 the triangle points.}
function PointInTriangle(const ap1, tp1, tp2, tp3 : TPoint2): boolean;
{Triangulates the given polygon. The polygon must not contain any intersections or holes/islands.}
function Triangulate(const APolygon: TPolygon; var ATriangles: Triangles):boolean;
{Returns true if the polygon is in clockwise orientation, false if it is counter-clockwise}
//function PolygonIsClockwise(const APolygon : TAdPolygon):boolean;


function OverlapPolygon(const P1, P2: TPolygon): Boolean;
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

function PtInPolygon(const Pt: TPoint2; const Pg: TPolygon):Boolean;

function cColor4car(Color: Cardinal): TColor4;
function cAlpha4x4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4;
//---------------------------------------------------------------------------
// Precalculated Sin/Cos tables
//---------------------------------------------------------------------------
function Cos8(i: Integer): Real;
function Sin8(i: Integer): Real;
function Cos16(i: Integer): Real;
function Sin16(i: Integer): Real;
function Cos32(i: Integer): Real;
function Sin32(i: Integer): Real;
function Cos64(i: Integer): Real;
function Sin64(i: Integer): Real;
function Cos128(i: Integer): Real;
function Sin128(i: Integer): Real;
function Cos256(i: Integer): Real;
function Sin256(i: Integer): Real;
function Cos512(i: Integer): Real;
function Sin512(i: Integer): Real;
//---------------------------------------------------------------------------
function Angle360(X, Y: Integer): Real;
function Angle256(X, Y: Integer): Real;
function AngleDiff(SrcAngle, DestAngle: Single): Single;


const
 ZeroVec2 : TPoint2 = (x: 0.0; y: 0.0);
 UnityVec2: TPoint2 = (x: 1.0; y: 1.0);

//---------------------------------------------------------------------------

function Length2(const v: TPoint2): Single;
function Norm2(const v: TPoint2): TPoint2;
function Angle2(const v: TPoint2): Single;
function Lerp2(const v0, v1: TPoint2; Alpha: Single): TPoint2;
function Dot2(const a, b: TPoint2): Single;

function VecAbs2(const v: TPoint2): Real;
function VecScale2(const v: TPoint2; Theta: Real): TPoint2;
function VecNorm2(const v: TPoint2): TPoint2;
function VecAdd2(const a, b: TPoint2): TPoint2;
function VecSub2(const a, b: TPoint2): TPoint2;
function VecMul2(const a, b: TPoint2): TPoint2;
function VecNeg2(const v: TPoint2): TPoint2;
function VecAngle2(const v: TPoint2; Alpha: Real; Theta: Real = 1.0): TPoint2;
function VecAvg2(const a, b: TPoint2; Theta: Real = 0.5): TPoint2;



procedure Rotate(RotAng:single; const x,y:single; out Nx,Ny:single);overload;
procedure Rotate(const RotAng:single; const x,y,ox,oy:single; out Nx,Ny:single);overload;
implementation


//---------------------------------------------------------------------------
function VecAbs2(const v: TPoint2): Real;
begin
 Result:= Sqrt(Sqr(v.x) + Sqr(v.y));
end;

//---------------------------------------------------------------------------
function VecScale2(const v: TPoint2; Theta: Real): TPoint2;
begin
 Result.x:= v.x * Theta;
 Result.y:= v.y * Theta;
end;

//---------------------------------------------------------------------------
function VecNorm2(const v: TPoint2): TPoint2;
begin
 Result:= VecScale2(v, 1.0 / VecAbs2(v));
end;

//---------------------------------------------------------------------------
function VecAdd2(const a, b: TPoint2): TPoint2;
begin
 Result.x:= a.x + b.x;
 Result.y:= a.y + b.y;
end;

//---------------------------------------------------------------------------
function VecAvg2(const a, b: TPoint2; Theta: Real): TPoint2;
begin
 Result.x:= b.x + ((a.x - b.x) * Theta);
 Result.y:= b.y + ((a.y - b.y) * Theta);
end;

//---------------------------------------------------------------------------
function VecSub2(const a, b: TPoint2): TPoint2;
begin
 Result.x:= a.x - b.x;
 Result.y:= a.y - b.y;
end;

//---------------------------------------------------------------------------
function VecNeg2(const v: TPoint2): TPoint2;
begin
 Result.x:= -v.x;
 Result.y:= -v.y;
end;

//---------------------------------------------------------------------------
function VecAngle2(const v: TPoint2; Alpha: Real; Theta: Real): TPoint2;
var
 Delta: Real;
begin
 Delta:= VecAbs2(v) * Theta;

 Result.x:= Cos(Alpha) * Delta;
 Result.y:= -Sin(Alpha) * Delta;
end;

//---------------------------------------------------------------------------
function VecMul2(const a, b: TPoint2): TPoint2;
begin
 Result.x:= a.x * b.x;
 Result.y:= a.y * b.y;
end;


function pBounds4s2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
begin
 Result:= pBounds4(_Left, _Top, Round(_Width * ScaleX), Round(_Height * ScaleY));
end;

function pBounds4sc2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
var
 Left, Top: Real;
 Width, Height: Real;
begin
 if (ScaleX = 1.0) and (ScaleY=1.0) then
  Result:= pBounds4(_Left, _Top, _Width, _Height)
 else
  begin
   Width := _Width * ScaleX;
   Height:= _Height * ScaleY;
   Left  := _Left + Round((_Width - Width) * 0.5);
   Top   := _Top + Round((_Height - Height) * 0.5);
   Result:= pBounds4(Left, Top, Round(Width), Round(Height));
  end;
end;

//---------------------------------------------------------------------------


function pRotate42(const Origin, Size, Middle: TPoint2; Angle: Real;
 ScaleX, ScaleY: Real ): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.X, -Middle.Y, Size.X, Size.Y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * ScaleX;
   Points[Index].y:= Points[Index].y * ScaleY;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x;
   Points[Index].y:= Point.y + Origin.y;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------

function pRotate4c2(const Origin, Size: TPoint2; Angle,
 ScaleX, ScaleY: Real): TPoint4;
begin
 Result:= pRotate42(Origin, Size, Point2(Size.x * 0.5, Size.y * 0.5), Angle, ScaleX, ScaleY);
end;

function pRotateTransForm(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle: Real; Scale: Real = 1.0): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= Point4(X1-CenterX, Y1-CenterY, X2-CenterX, Y2-CenterY,
                  X3-CenterX, Y3-CenterY, X4-CenterX, Y4-CenterY);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].X:= Points[Index].X * Scale;
   Points[Index].Y:= Points[Index].Y * Scale;

   // rotate the point around Phi
   Point.x:= (Points[Index].X * CosPhi) - (Points[Index].Y * SinPhi);
   Point.y:= (Points[Index].Y * CosPhi) + (Points[Index].X * SinPhi);

   // translate the point to (Origin)
   Points[Index].X:= Point.X + X ;
   Points[Index].Y:= Point.Y + Y ;
  end;

 Result:= Points;
end;

function pRotateTransForm2(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle, ScaleX, ScaleY: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= Point4(X1-CenterX, Y1-CenterY, X2-CenterX, Y2-CenterY,
                  X3-CenterX, Y3-CenterY, X4-CenterX, Y4-CenterY);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].X:= Points[Index].X * ScaleX;
   Points[Index].Y:= Points[Index].Y * ScaleY;

   // rotate the point around Phi
   Point.x:= (Points[Index].X * CosPhi) - (Points[Index].Y * SinPhi);
   Point.y:= (Points[Index].Y * CosPhi) + (Points[Index].X * SinPhi);

   // translate the point to (Origin)
   Points[Index].X:= Point.X + X ;
   Points[Index].Y:= Point.Y + Y ;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------
function BezierPoints(const OriginPoint, DestPoint, C1Point, C2Point: TPoint): TBezierPoints;
begin
  Result[0] := OriginPoint;
  Result[1] := C1Point;
  Result[2] := C2Point;
  Result[3] := DestPoint;
end;

function BezierPoints(const OriginPoint, DestPoint, C1Point, C2Point: TPoint2): TBezierPoints2;
begin
  Result[0] := OriginPoint;
  Result[1] := C1Point;
  Result[2] := C2Point;
  Result[3] := DestPoint;
end;

//---------------------------------------------------------------------------
function OverlapQuadrangle(const Q1, Q2: TPoint4): Boolean;
var
 d1, d2, d3, d4: Single;
begin
 d1:= (Q1[2].X - Q1[1].X) * (Q2[0].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) *
  (Q2[0].Y - Q1[0].Y);
 d2:= (Q1[3].X - Q1[2].X) * (Q2[0].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) *
  (Q2[0].Y - Q1[1].Y);
 d3 := (Q1[0].X - Q1[3].X) * (Q2[0].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) *
  (Q2[0].Y - Q1[2].Y);
 d4:= (Q1[1].X - Q1[0].X) * (Q2[0].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) *
  (Q2[0].Y - Q1[3].Y);

 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result:= True;
  Exit;
 end;

 d1:= (Q1[2].X - Q1[1].X) * (Q2[1].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) *
  (Q2[1].Y - Q1[0].Y);
 d2:= (Q1[3].X - Q1[2].X) * (Q2[1].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) *
  (Q2[1].Y - Q1[1].Y);
 d3:= (Q1[0].X - Q1[3].X) * (Q2[1].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) *
  (Q2[1].Y - Q1[2].Y);
 d4:= (Q1[1].X - Q1[0].X) * (Q2[1].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) *
  (Q2[1].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result:= True;
  Exit;
 end;

 d1:= (Q1[2].X - Q1[1].X) * (Q2[2].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) *
  (Q2[2].Y - Q1[0].Y);
 d2:= (Q1[3].X - Q1[2].X) * (Q2[2].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) *
  (Q2[2].Y - Q1[1].Y);
 d3:= (Q1[0].X - Q1[3].X) * (Q2[2].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) *
  (Q2[2].Y - Q1[2].Y);
 d4:= (Q1[1].X - Q1[0].X) * (Q2[2].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) *
  (Q2[2].Y - Q1[3].Y);
 if(d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result := True;
  Exit;
 end;

 d1:= (Q1[2].X - Q1[1].X) * (Q2[3].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) *
  (Q2[3].Y - Q1[0].Y);
 d2:= (Q1[3].X - Q1[2].X) * (Q2[3].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) *
  (Q2[3].Y - Q1[1].Y);
 d3:= (Q1[0].X - Q1[3].X) * (Q2[3].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) *
  (Q2[3].Y - Q1[2].Y);
 d4:= (Q1[1].X - Q1[0].X) * (Q2[3].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) *
  (Q2[3].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result:= True;
  Exit;
 end;

 Result:= False;
end;

//---------------------------------------------------------------------------
{ algorithm by Paul Bourke }
function PtInPolygon(const Pt: TPoint2; const Pg: TPolygon): Boolean;
var
  N, Counter , I : Integer;
  XInters : Real;
  P1, P2 : TPoint2;
begin
  N := High(Pg);
  Counter := 0;
  P1 := Pg[0];
  for I := 1 to N do
  begin
    P2 := Pg[I mod N];
    if Pt.y > Min(P1.y, P2.y) then
      if Pt.y <= Max(P1.y, P2.y) then
        if Pt.x <= Max(P1.x, P2.x) then
          if P1.y <> P2.y then
          begin
            XInters := (Pt.y - P1.y) * (P2.x - P1.x) / (P2.y - P1.y) + P1.x;
            if (P1.x = P2.x) or (Pt.x <= XInters) then Inc(Counter);
          end;
    P1 := P2;
  end;
  Result := (Counter mod 2 <> 0);
end;

//---------------------------------------------------------------------------
{ NOTE: last points of polygons must be the first one ( P1[0] = P1[N]  ; P2[0] = P2[N] ) }
function OverlapPolygon(const P1, P2: TPolygon): Boolean;
var
  Poly1, Poly2 : TPolygon;
  I, J : Integer;
  xx , yy : Single;
  StartP, EndP : Integer;
  Found : Boolean;
begin
  Found := False;
  { Find polygon with fewer points }
  if High(P1) < High(P2) then
  begin
    Poly1 := P1;
    Poly2 := P2;
  end
  else
  begin
    Poly1 := P2;
    Poly2 := P1;
  end;

  for I := 0 to High(Poly1) - 1 do
  begin
    { Trace new line }
    StartP := Round(Min(Poly1[I].x, Poly1[I+1].x));
    EndP   := Round(Max(Poly1[I].x, Poly1[I+1].x));


    if StartP = EndP then
    { A vertical line (ramp = inf) }
    begin
      xx := StartP;
      StartP := Round(Min(Poly1[I].y, Poly1[I+1].y));
      EndP   := Round(Max(Poly1[I].y, Poly1[I+1].y));
      { Follow a vertical line }
      for J := StartP to EndP do
      begin
        { line equation }
        if PtInPolygon(Point2(xx,J), Poly2) then
        begin
          Found := True;
          Break;
        end;
      end;
    end
    else
    { Follow a usual line (ramp <> inf) }
    begin
      { A Line which X is its variable i.e. Y = f(X) }
      if Abs(Poly1[I].x -  Poly1[I+1].x) >= Abs(Poly1[I].y -  Poly1[I+1].y) then
      begin
        StartP := Round(Min(Poly1[I].x, Poly1[I+1].x));
        EndP   := Round(Max(Poly1[I].x, Poly1[I+1].x));
        for J := StartP to EndP do
        begin
          xx := J;
          { line equation }
          yy := (Poly1[I+1].y - Poly1[I].y) / (Poly1[I+1].x - Poly1[I].x) * (xx - Poly1[I].x) + Poly1[I].y;
          if PtInPolygon(Point2(xx,yy), Poly2) then
          begin
            Found := True;
            Break;
          end;
        end;
      end
      { A Line which Y is its variable i.e. X = f(Y) }
      else
      begin
        StartP := Round(Min(Poly1[I].y, Poly1[I+1].y));
        EndP   := Round(Max(Poly1[I].y, Poly1[I+1].y));
        for J := StartP to EndP do
        begin
          yy := J;
          { line equation }
          xx := (Poly1[I+1].x - Poly1[I].x) / (Poly1[I+1].y - Poly1[I].y) * (yy - Poly1[I].y) + Poly1[I].x;
          if PtInPolygon(Point2(xx,yy), Poly2) then
          begin
            Found := True;
            Break;
          end;
        end;
      end;
    end;
    if Found then Break;
  end;

  { Maybe one polygon is completely inside another }
  if not Found then
    Found := PtInPolygon(Poly1[0], Poly2) or PtInPolygon(Poly2[0], Poly1);

  Result := Found;
end;



//---------------------------------------------------------------------------
//precalculated fixed  point  cosines for a full circle
var
  CosTable8  : array[0..7]   of Double;
  CosTable16 : array[0..15]  of Double;
  CosTable32 : array[0..31]  of Double;
  CosTable64 : array[0..63]  of Double;
  CosTable128: array[0..127] of Double;
  CosTable256: array[0..255] of Double;
  CosTable512: array[0..511] of Double;

procedure InitCosTable;
var
  i: Integer;
begin
   for i:=0 to 7 do
    CosTable8[i] := Cos((i/8)*2*PI);

   for i:=0 to 15 do
    CosTable16[i] := Cos((i/16)*2*PI);

   for i:=0 to 31 do
    CosTable32[i] := Cos((i/32)*2*PI);

   for i:=0 to 63 do
    CosTable64[i] := Cos((i/64)*2*PI);

   for i:=0 to 127 do
    CosTable128[i] := Cos((i/128)*2*PI);

   for i:=0 to 255 do
    CosTable256[i] := Cos((i/256)*2*PI);

   for i:=0 to 511 do
    CosTable512[i] := Cos((i/512)*2*PI);
end;

function Cos8(i: Integer): Real;
begin
  Result := CosTable8[i and 7];
end;

function Sin8(i: Integer): Real;
begin
  Result := CosTable8[(i+6) and 7];
end;

function Cos16(i: Integer): Real;
begin
  Result := CosTable16[i and 15];
end;

function Sin16(i: Integer): Real;
begin
  Result := CosTable16[(i+12) and 15];
end;

function Cos32(i: Integer): Real;
begin
  Result := CosTable32[i and 31];
end;

function Sin32(i: Integer): Real;
begin
  Result := CosTable32[(i+24) and 31];
end;

function Cos64(i: Integer): Real;
begin
  Result := CosTable64[i and 63];
end;

function Sin64(i: Integer): Real;
begin
  Result := CosTable64[(i+48) and 63];
end;

function Cos128(i: Integer): Real;
begin
  Result := CosTable128[i and 127];
end;

function Sin128(i: Integer): Real;
begin
  Result := CosTable128[(i+96) and 127];
end;

function Cos256(i: Integer): Real;
begin
  Result := CosTable256[i and 255];
end;

function Sin256(i: Integer): Real;
begin
  Result := CosTable256[(i+192) and 255];
end;

function Cos512(i: Integer): Real;
begin
  Result := CosTable512[i and 511];
end;

function Sin512(i: Integer): Real;
begin
  Result := CosTable512[(i+384) and 511];
end;

//---------------------------------------------------------------------------
function Angle360(X, Y: Integer): Real;
begin
     if Result < 0 then Result := ((Arctan2(X, Y) * -57.4));
     if Result > 0 then Result := (180+(Arctan2(X, Y) * -57.4));
end;

function Angle256(X, Y: Integer): Real;
begin
     if Result < 0 then Result := ((Arctan2(X, Y) * -40.5));
     if Result > 0 then Result := (128 + (Arctan2(X, Y) * -40.5));
end;

function AngleDiff(SrcAngle, DestAngle: Single): Single;
var                       
    Diff: Single;
begin
     Diff := DestAngle - SrcAngle;
     if (SrcAngle > DestAngle) then
     begin
          if (SrcAngle > 128) and (DestAngle < 128) then
              if (Diff < 128.0) then Diff := Diff + 256.0 ;
          if (Diff > 128.0) then  Diff := Diff - 256.0;
     end
     else
     begin
          if (Diff > 128.0) then  Diff := Diff - 256.0;
     end;
     Result:= Diff;
end;




//---------------------------------------------------------------------------
function IsPowerOfTwo(Value: Integer): Boolean;
begin
 Result:= (Value >= 1)and((Value and (Value - 1)) = 0);
end;



//---------------------------------------------------------------------------
function Point2(x, y: Real): TPoint2;
begin
 Result.x:= x;
 Result.y:= y;
end;

function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4;
begin
 Result[0].x:= x1;
 Result[0].y:= y1;
 Result[1].x:= x2;
 Result[1].y:= y2;
 Result[2].x:= x3;
 Result[2].y:= y3;
 Result[3].x:= x4;
 Result[3].y:= y4;
end;

function pRect4(const Rect: TRect): TPoint4;
begin
 Result[0].x:= Rect.Left;
 Result[0].y:= Rect.Top;
 Result[1].x:= Rect.Right;
 Result[1].y:= Rect.Top;
 Result[2].x:= Rect.Right;
 Result[2].y:= Rect.Bottom;
 Result[3].x:= Rect.Left;
 Result[3].y:= Rect.Bottom;
end;
function cColor4car(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4;
begin
 Result[0]:= Color1;
 Result[1]:= Color2;
 Result[2]:= Color3;
 Result[3]:= Color4;
end;
//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left < Rect2.Right)and(Rect1.Right > Rect2.Left)and
  (Rect1.Top < Rect2.Bottom)and(Rect1.Bottom > Rect2.Top);
end;
//---------------------------------------------------------------------------
function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
 Result:= (Point.X >= Rect.Left)and(Point.X <= Rect.Right)and
  (Point.Y >= Rect.Top)and(Point.Y <= Rect.Bottom);
end;

//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left >= Rect2.Left)and(Rect1.Right <= Rect2.Right)and
  (Rect1.Top >= Rect2.Top)and(Rect1.Bottom <= Rect2.Bottom);
end;

function cAlpha4(Alpha: Cardinal): TColor4;
begin
 Result:= cColor4car($FFFFFF or ((Alpha and $FF) shl 24));
end;

function cAlpha4x4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4;
begin
 Result[0]:= $FFFFFF or ((Alpha1 and $FF) shl 24);
 Result[1]:= $FFFFFF or ((Alpha2 and $FF) shl 24);
 Result[2]:= $FFFFFF or ((Alpha3 and $FF) shl 24);
 Result[3]:= $FFFFFF or ((Alpha4 and $FF) shl 24);
end;



function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
begin
 Result[0].X:= _Left;
 Result[0].Y:= _Top;
 Result[1].X:= _Left + _Width;
 Result[1].Y:= _Top;
 Result[2].X:= _Left + _Width;
 Result[2].Y:= _Top + _Height;
 Result[3].X:= _Left;
 Result[3].Y:= _Top + _Height;
end;

function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
begin
 Result:= r or (g shl 8) or (b shl 16) or (a shl 24);
end;

function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4;
begin
 Result:= cColor4car(cRGB1(r, g, b, a));
end;


function cRGB4ex(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4;
begin
 Result[0]:= cRGB1(r1, g1, b1, a1);
 Result[1]:= Result[0];
 Result[2]:= cRGB1(r2, g2, b2, a2);
 Result[3]:= Result[2];
end;



//---------------------------------------------------------------------------
function pBounds4s(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
begin
 Result:= pBounds4(_Left, _Top, Round(_Width * Scale), Round(_Height * Scale));
end;

//---------------------------------------------------------------------------

function pBounds4sc(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
var
 Left, Top: Real;
 Width, Height: Real;
begin
 if (Scale = 1.0) then
  Result:= pBounds4(_Left, _Top, _Width, _Height)
 else
  begin
   Width := _Width * Scale;
   Height:= _Height * Scale;
   Left  := _Left + ((_Width - Width) * 0.5);
   Top   := _Top + ((_Height - Height) * 0.5);
   Result:= pBounds4(Left, Top, Round(Width), Round(Height));
  end;
end;


//---------------------------------------------------------------------------
function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real; Scale: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.x, -Middle.y, Size.x, Size.y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * Scale;
   Points[Index].y:= Points[Index].y * Scale;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x;
   Points[Index].y:= Point.y + Origin.y;
  end;

 Result:= Points;
end;

function pRotate4c(const Origin, Size: TPoint2; Angle: Real;Scale: Real): TPoint4;
begin
 Result:= pRotate4(Origin, Size, Point2(Size.x * 0.5, Size.y * 0.5), Angle,
  Scale);
end;




//---------------------------------------------------------------------------
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4;
begin
 Result[0]:= cRGB1(r1, g1, b1, a1);
 Result[1]:= Result[0];
 Result[2]:= cRGB1(r2, g2, b2, a2);
 Result[3]:= Result[2];
end;

//---------------------------------------------------------------------------
function cColor4(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

//---------------------------------------------------------------------------
function cGray4(Gray: Cardinal): TColor4;
begin
 Result:= cColor4(((Gray and $FF) or ((Gray and $FF) shl 8) or
  ((Gray and $FF) shl 16)) or $FF000000);
end;

//---------------------------------------------------------------------------
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4;
begin
 Result[0]:= ((Gray1 and $FF) or ((Gray1 and $FF) shl 8) or ((Gray1 and $FF) shl 16)) or $FF000000;
 Result[1]:= ((Gray2 and $FF) or ((Gray2 and $FF) shl 8) or ((Gray2 and $FF) shl 16)) or $FF000000;
 Result[2]:= ((Gray3 and $FF) or ((Gray3 and $FF) shl 8) or ((Gray3 and $FF) shl 16)) or $FF000000;
 Result[3]:= ((Gray4 and $FF) or ((Gray4 and $FF) shl 8) or ((Gray4 and $FF) shl 16)) or $FF000000;
end;


//---------------------------------------------------------------------------
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4;
begin
 Result[0]:= $FFFFFF or ((Alpha1 and $FF) shl 24);
 Result[1]:= $FFFFFF or ((Alpha2 and $FF) shl 24);
 Result[2]:= $FFFFFF or ((Alpha3 and $FF) shl 24);
 Result[3]:= $FFFFFF or ((Alpha4 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
begin
 Result:= cColor4((Color and $FFFFFF) or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4;
begin
 Result[0]:= (Color1 and $FFFFFF) or ((Alpha1 and $FF) shl 24);
 Result[1]:= (Color2 and $FFFFFF) or ((Alpha2 and $FF) shl 24);
 Result[2]:= (Color3 and $FFFFFF) or ((Alpha3 and $FF) shl 24);
 Result[3]:= (Color4 and $FFFFFF) or ((Alpha4 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColor1(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

//---------------------------------------------------------------------------
function cGray1(Gray: Cardinal): Cardinal;
begin
 Result:= ((Gray and $FF) or ((Gray and $FF) shl 8) or ((Gray and $FF) shl 16))
  or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha1(Alpha: Cardinal): Cardinal;
begin
 Result:= $FFFFFF or ((Alpha and $FF) shl 24);
end;


//---------------------------------------------------------------------------
function Length2(const v: TPoint2): Single;
begin
 Result:= Hypot(v.x, v.y);
end;

//---------------------------------------------------------------------------
function Norm2(const v: TPoint2): TPoint2;
var
 Amp: Single;
begin
 Amp:= Length2(v);

 if (Amp <> 0.0) then
  begin
   Result.x:= v.x / Amp;
   Result.y:= v.y / Amp;
  end else Result:= ZeroVec2;
end;


//---------------------------------------------------------------------------
function Angle2(const v: TPoint2): Single;
begin
 Result:= ArcTan2(v.y, v.x);
end;

//---------------------------------------------------------------------------
function Lerp2(const v0, v1: TPoint2; Alpha: Single): TPoint2;
begin
 Result.x:= v0.x + (v1.x - v0.x) * Alpha;
 Result.y:= v0.y + (v1.y - v0.y) * Alpha;
end;

//---------------------------------------------------------------------------
function Dot2(const a, b: TPoint2): Single;
begin
 Result:= (a.x * b.x) + (a.y * b.y);
end;



procedure Rotate(RotAng:single; const x,y:single; out Nx,Ny:single);
var
  SinVal : single;
  CosVal : single;
begin
  RotAng := RotAng * PIDiv180;
  SinVal := Sin(RotAng);
  CosVal := Cos(RotAng);
  Nx     := (x * CosVal) - (y * SinVal);
  Ny     := (y * CosVal) + (x * SinVal);
end;
(* End of Rotate Cartesian Point *)


procedure Rotate(const RotAng:single; const x,y,ox,oy:single; out Nx,Ny:single);
begin
  Rotate(RotAng,x - ox,y - oy,Nx,Ny);
  Nx := Nx + ox;
  Ny := Ny + oy;
end;


function CircleToPolygon(const Cx,Cy,Radius:single; const PointCount:Integer):TPolygon;
var
  i     : Integer;
  Angle : single;
begin
  SetLength(Result,PointCount);
  Angle := 360.0 / (1.0 * PointCount);
  for i := 0 to PointCount - 1 do
  begin
    Rotate(Angle * i,Cx + Radius, Cy,Cx,Cy,Result[i].x,Result[i].y);
  end
end;

//�berpr�ft ob ein Punkt in einem Dreieck liegt
function PointInTriangle(const ap1, tp1, tp2, tp3 : Tpoint2): boolean;
var
  b0, b1, b2, b3: Double;
begin
  b0 := ((tp2.x - tp1.x) * (tp3.y - tp1.y) - (tp3.x - tp1.x) * (tp2.y - tp1.y));
  if b0 <> 0 then
  begin
    b1 := (((tp2.x - ap1.x) * (tp3.y - ap1.y) - (tp3.x - ap1.x) * (tp2.y - ap1.y)) / b0);
    b2 := (((tp3.x - ap1.x) * (tp1.y - ap1.y) - (tp1.x - ap1.x) * (tp3.y - ap1.y)) / b0);
    b3 := 1 - b1 - b2;

    result := (b1 > 0) and (b2 > 0) and (b3 > 0);
  end else
    result := false;
end;

function Triangulate(const APolygon: TPolygon; var ATriangles: Triangles):boolean;
var
  lst:TList;
  i, j:integer;
  p, p1, p2, pt:PPoint2;
  l:double;
  intriangle : boolean;
  lastear :  integer;

  //Berechnet aus einem Index, der auch die Listen-Grenzen �ber- oder unterschreiten
  //kann einen validen Listenindex.
  function GetItem(const ai, amax:integer):integer;
  begin
    result := ai mod amax;
    if result < 0 then
      result := amax + result;
  end;

begin
  lst := TList.Create;

  //Kopiere die Punkte des Polygons in eine TList (also eine Vektordatenstruktur)
  for i := 0 to High(APolygon) do
  begin
    New(p);
    p^.X := APolygon[i].X;
    p^.Y := APolygon[i].Y;
    lst.Add(p);
  end;

  i := 0;
  lastear := -1;
  repeat
    lastear := lastear + 1;

    //Suche drei benachbarte Punkte aus der Liste
    p1 := lst.Items[GetItem(i - 1, lst.Count)];
    p  := lst.Items[GetItem(i, lst.Count)];
    p2 := lst.Items[GetItem(i + 1, lst.Count)];


    //Berechne, ob die Ecke konvex oder konkav ist
    l := ((p1.X - p.X) * (p2.Y - p.Y) - (p1.Y - p.Y) * (p2.X - p.X));

    //Nur weitermachen, wenn die Ecke konkav ist
    if l < 0 then
    begin
      //�berpr�fe ob irgendein anderer Punkt aus dem Polygon
      //das ausgew�hlte Dreieck schneidet
      intriangle := false;
      for j := 2 to lst.Count - 2 do
      begin
        pt := lst.Items[GetItem(i + j, lst.Count)];
        if PointInTriangle(pt^, p1^, p^, p2^) then
        begin
          intriangle := true;
          break;
        end;
      end;
     
      //Ist dies nicht der Fall, so entferne die ausgwew�hlte Ecke und bilde
      //ein neues Dreieck
      if not intriangle then
      begin
        SetLength(ATriangles, Length(ATriangles) + 1);
        ATriangles[High(ATriangles)].a := Point2(p1^.X, p1^.Y);
        ATriangles[High(ATriangles)].b := Point2(p^.X, p^.Y);
        ATriangles[High(ATriangles)].c := Point2(p2^.X, p2^.Y);

        lst.Delete(GetItem(i, lst.Count));
        Dispose(p);

        lastear := 0;

        i := i-1;
      end;
    end;

    i := i + 1;
    if i > lst.Count - 1 then
      i := 0;


  until (lastear > lst.Count*2) or (lst.Count = 3);

  if lst.Count = 3 then
  begin
    p1 := lst.Items[GetItem(0, lst.Count)];
    p  := lst.Items[GetItem(1, lst.Count)];
    p2 := lst.Items[GetItem(2, lst.Count)];
    SetLength(ATriangles, Length(ATriangles) + 1);
    ATriangles[High(ATriangles)].a := Point2(p1^.X, p1^.Y);
    ATriangles[High(ATriangles)].b := Point2(p^.X, p^.Y);
    ATriangles[High(ATriangles)].c := Point2(p2^.X, p2^.Y);
  end;

  result := lst.Count = 3;

  for i := 0 to lst.Count - 1 do
  begin
    Dispose(PPoint2(lst.Items[i]));
  end;
  lst.Clear;
  lst.Free;
end;



initialization
 InitCosTable();
end.

