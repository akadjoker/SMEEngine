
Unit GLMath;

Interface
uses sysutils,math,classes;

Const
  Epsilon = 0.00001;

  Rad   = 0.017453292519;   // Pi/180
  Deg   = 57.29577951308;   // 180/Pi

  RAND_MAX = Pred(MAXINT);
  INV_RAND_MAX = 1.0 / (RAND_MAX + 1);


Type
  PVector3D = ^Vector3D;

  Vector3D=Packed Object
    X:Single;
    Y:Single;
    Z:Single;

    Function Equals(Const B:Vector3D):Boolean;
    Function Dot(Const B:Vector3D):Single;

    Procedure Add(Const B:Vector3D);
    Procedure Subtract(Const B:Vector3D);

    Procedure Scale(Const S:Single);
    Procedure Multiply(Const B:Vector3D);

    Function Get(Index:Integer):Single;
    Procedure SetValue(Index:Integer; Value:Single);

    // Normalizes the vector
    Procedure Normalize;
    Function Length:Single;
    Function LengthSquared:Single;
    Function Distance(Const B:Vector3D):Single;
    Function Distance2D(Const B:Vector3D):Single;




    Procedure Rotate(Const Axis:Vector3D; Const Angle:Single);
  End;
  
Type
  PVector2D=^Vector2D;
  Vector2D=Packed Object
    X,Y:Single;

    Function Equals(Const B:Vector2D):Boolean;

    Procedure Rotate(Const Angle:Single); Overload;
    Procedure Rotate(Const Angle:Single; Const Center:Vector2D); Overload;

    Procedure Add(Const B:Vector2D);
    Procedure Subtract(Const B:Vector2D);

    Procedure Scale(Const S:Single);Overload;
    Procedure Scale(Const B:Vector2D);Overload;

    Procedure Project(Const V:Vector2D);

    Procedure Normalize;

    Function Length:Single;
    Function Distance(Const B:Vector2D):Single;

    Function Dot(B:Vector2D):Single;


  End;

  Function VectorCreate2D(Const X,Y:Single):Vector2D; 
Function VectorCross2D(Const A,B:Vector2D):Single;

Function VectorAdd2D(Const A,B:Vector2D):Vector2D;
Function VectorSubtract2D(Const A,B:Vector2D):Vector2D;



Const
// Vector constants
  VectorZero: Vector3D = (X:0.0; Y:0.0; Z:0.0);
  VectorOne:  Vector3D = (X:1.0; Y:1.0; Z:1.0);
  VectorUp:   Vector3D = (X:0.0; Y:1.0; Z:0.0);

// Vector functions
Function VectorCreate(Const X,Y,Z:Single):Vector3D; 

Function VectorUniform(Const N:Single):Vector3D; 

Function VectorMax(Const A,B:Vector3D):Vector3D; 
Function VectorMin(Const A,B:Vector3D):Vector3D; 

Function VectorAdd(Const A,B:Vector3D):Vector3D; 
Function VectorSubtract(Const A,B:Vector3D):Vector3D; 
Function VectorMultiply(Const A,B:Vector3D):Vector3D; 
Function VectorCross(Const A,B:Vector3D):Vector3D; 

// Returns the dot product between two vectors
Function VectorDot(Const A,B:Vector3D):Single; 

// Scales a vector by S
Function VectorScale(Const A:Vector3D; S:Single):Vector3D; 

// Reflect two vectors
Function VectorReflect(Const Source,Normal:Vector3D):Vector3D; 

Function VectorInterpolate(Const A,B:Vector3D; Const S:Single):Vector3D; 

// Halve arc between unit vectors v0 and v1.
Function VectorBisect(Const A,B:Vector3D):Vector3D; 

// Returns a triangle normal
Function TriangleNormal(Const V0,V1,V2:Vector3D):Vector3D; 

//  Quad functions
Function GetTriangleHeight(H0,H1,H2:Single; X,Y:Single; Normal:PVector3D=Nil):Single;


type
  MatrixColumns = Array[0..2] Of Vector3D;

  PMatrix = ^Matrix;
  Matrix=Packed Object
    V:Array [0..15] Of Single;



    Function Transform(P:Vector3D):Vector3D;
    Function TransformNormal(P:Vector3D):Vector3D;

    Procedure Orthonormalize;

    Function Get(I,J:Integer):Single;
    Function GetTranslation:Vector3D;

    Function GetColumns:MatrixColumns;
  End;


  PMatrixArray=^MatrixArray;
  MatrixArray=Array[0..255] Of Matrix;

Const
 MatrixIdentity:Matrix= (V:(1.0, 0.0, 0.0, 0.0,
                            0.0, 1.0, 0.0, 0.0,
                            0.0, 0.0, 1.0, 0.0,
                            0.0, 0.0, 0.0, 1.0));

// Returns a rotation matrix
Function MatrixRotation(Const Rotation:Vector3D):Matrix; Overload; 
Function MatrixRotation(Const X,Y,Z:Single):Matrix; Overload; 

Function MatrixRotation(Const Axis:Vector3D; Const Angle:Single):Matrix; Overload;

// Returns a translation matrix
Function MatrixTranslation(Const Translation:Vector3D):Matrix;Overload;
Function MatrixTranslation(Const X,Y,Z:Single):Matrix;Overload; 
Function MatrixTranslate(Const X,Y,Z:Single):Matrix;

Function MatrixTransform(Const Position,Rotation,Scale:Vector3D):Matrix;

Function MatrixOrientation(Const Position,Direction,Up,Scale:Vector3D):Matrix;

Function MatrixLerp(Const A,B:Matrix; Const S:Single):Matrix;

// Inverts a matrix
Function MatrixInverse(A:Matrix):Matrix;

Function MatrixScale(Const Scale:Vector3D):Matrix;Overload; 
Function MatrixScale(Const X,Y,Z:Single):Matrix;Overload;   

// Returns a reflection matrix
Function MatrixMirror(Const Source,Normal:Vector3D):Matrix;

Function MatrixTranspose(Const Source:Matrix):Matrix;

// Multiplys two matrices
Function MatrixMultiply4x3(Const A,B:Matrix):Matrix;
Function MatrixMultiply4x4(Const A,B:Matrix):Matrix;

Function MatrixPerspective(FOV, AspectRatio, zNear, zFar:Single):Matrix;
Function MatrixLookAt(Eye, LookAt, Roll:Vector3D):Matrix;
Function MatrixOrtho(left, right,  bottom,  top,  nearVal,  farVal:Single):Matrix;



Type
  PPlane =^ Plane;
  Plane = Packed Object
    A,B,C,D:Single;

    Function Distance(X,Y,Z:Single):Single; Overload;
    Function Distance(V:Vector3D):Single; Overload;

    Function Normal:Vector3D;
  End;

Function PlaneCreate(PA,PB,PC,PD:Single):Plane;Overload;
Function PlaneCreate(V1,V2,V3:Vector3D):Plane;Overload;
Function PlaneCreate(Source, Normal: Vector3D):Plane;Overload;

Function GetQuadHeight(A,B,C,D, Position:Vector3D; Normal:PVector3D=Nil):Single;


Type
  PMatrix2D = ^Matrix2D;
  Matrix2D=Packed Object
    V:Array [0..8] Of Single;

    Function Transform(Const P:Vector2D):Vector2D; Overload;
    Function Transform(Const P:Vector3D):Vector3D; Overload;

    Procedure Init(M:Matrix);
  End;

Const
 MatrixIdentity2D:Matrix2D= (V:(1.0, 0.0, 0.0,
                              0.0, 1.0, 0.0,
                              0.0, 0.0, 1.0));

// Returns a rotation matrix
Function MatrixRotation2D(Const Angle:Single):Matrix2D; 

// Returns a translation matrix
Function MatrixTranslation2D(Const Translation:Vector2D):Matrix2D;Overload; 
Function MatrixTranslation2D(Const X,Y:Single):Matrix2D;Overload; 

Function MatrixScale2D(Const Scale:Vector2D):Matrix2D;Overload; 
Function MatrixScale2D(Const X,Y:Single):Matrix2D;Overload;   

// Multiplys two matrices
Function MatrixMultiply3x3(Const A,B:Matrix2D):Matrix2D;

Type
  PTQuaternion = ^TQuaternion;
  TQuaternion=Packed Object
    X:Single;
    Y:Single;
    Z:Single;
    W:Single;

    Function Equals(Const B:TQuaternion):Boolean;

    Procedure Transform(Const M:Matrix);
    // Returns a normalized quaternion
    Procedure Normalize;


    Procedure Add(Const B:TQuaternion);
    Procedure Subtract(Const B:TQuaternion);

    Function Length:Single;
  End;

  Vector4D = TQuaternion;
//  Color4F = Vector4D;

Const
  TQuaternionOne:Vector4D=(X:1.0; Y:1.0; Z:1.0; W:1.0);
  TQuaternionZero:Vector4D=(X:0.0; Y:0.0; Z:0.0; W:1.0);

Function TQuaternionCreate(Const X,Y,Z,W:Single):TQuaternion;Overload;
Function TQuaternionCreate(Const V:Vector3D):TQuaternion;Overload;

// Creates a quaterion with specified rotation
Function TQuaternionRotation(Const Rotation:Vector3D):TQuaternion;

// Returns a matrix representing the quaternion
Function TQuaternionMatrix(Const Quaternion:TQuaternion):Matrix;

// Slerps two quaternions
Function TQuaternionSlerp(A,B:TQuaternion; Const T:Single):TQuaternion;


// Returns the conjugate of a quaternion
Function TQuaternionConjugate(Const Q:TQuaternion):TQuaternion;

// Multiplies two quaternions
Function TQuaternionMultiply(Const Ql,Qr:TQuaternion):TQuaternion;

Function TQuaternionAdd(Const A,B:TQuaternion):TQuaternion;

Function TQuaternionScale(Const Q:TQuaternion; Const Scale:Single):TQuaternion;

Function TQuaternionFromBallPoints(Const arcFrom,arcTo:Vector3D):TQuaternion;
Procedure TQuaternionToBallPoints(Var Q:TQuaternion; arcFrom,arcTo:Vector3D);

Function TQuaternionFromAxisAngle(Const Axis:Vector3D; Const Angle:Single):TQuaternion;

Function TQuaternionToEuler(Const Q:TQuaternion):Vector3D;

type
Circle = Object
    Center:Vector2D;
    Radius:Single;

    // test if point P is inside this circle
    Function PointInside(P:Vector2D):Boolean;

    Function Intersect(C:Circle):Boolean;
  End;

  Polygon2D = Object
      Vertices:Array Of Vector2D;
      VertexCount:Integer;

      Procedure AddVertex(X, Y:Single); Overload;
      Procedure AddVertex(P:Vector2D); Overload;

      // test if point P is inside this poly
      Function PointInside(P:Vector2D):Boolean;
      // test if poly P is inside this poly
      Function PolygonInside(P:Polygon2D):Boolean;

      Function Intersect(C:Circle; Hit:PVector2D = Nil):Boolean;
  End;

  Line2D = Object
    P1:Vector2D;
    P2:Vector2D;

    Function Intersect(C:Circle; Hit:PVector2D = Nil; Distance:PSingle = Nil):Boolean; Overload;
    Function Intersect(B:Line2D; Hit:PVector2D = Nil):Boolean; Overload;
    Function Intersect(P:Polygon2D; Hit:PVector2D = Nil):Boolean; Overload;

    Function PointInside(P:Vector2D):Boolean;
  End;

  PointCloud2D = Object
    Points:Array Of Vector2D;
    PointCount:Integer;

    Procedure AddPoint(P:Vector2D);
    Function GetConvexHull:Polygon2D;
    Function GetRect:Line2D;
  End;

  Function CircleCreate(Origin:Vector2D; Radius:Single):Circle; Overload;
  Function CircleCreate(X,Y:Single; Radius:Single):Circle; Overload;

  Function LineCreate2D(X1,Y1,X2,Y2:Single):Line2D; Overload;
  Function LineCreate2D(P1,P2:Vector2D):Line2D; Overload;

  Function TriangleArea2D(A,B,C:Vector2D):Single;





Function FloatMax(Const A,B:Single):Single; 
Function FloatMin(Const A,B:Single):Single;

Function RandomFloat:Single; Overload;
Function RandomFloat(Const min,max:Single):Single; Overload;

Function RealMod(Const n,d: Single): Single;

Function Atan2(Y,X : extended): Extended;

Function SmoothStep(A,B,X:Single):Single;

Function NearestPowerOfTwo(P:Cardinal):Cardinal;

Function LinearInterpolate(a,b, mu:Single):Single;
Function CubicInterpolate(y0, y1, y2, y3, mu:Single):Single;
Function CatmullRomInterpolate(y0, y1, y2, y3, mu:Single):Single;

Function QuadraticBezierCurve(y0, y1, y2, mu:Single):Single;
Function CubicBezierCurve(y0, y1, y2, y3, mu:Single):Single;

Function InvSqrt(X:Single):Single;


Function Pow(X, Y:Single):Single;
function tan( x : Single ) : Single;

Implementation

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




Function sgn (a : real) : real;
Begin
  if (a < 0) then
    sgn := -1
  else
    sgn :=  1;
End;
function ArcTan2( dx, dy : Single ) : Single;
begin
  Result := abs( ArcTan( dy / dx ) * ( 180 / pi ) );
end;

Function atan2 (y, x : Extended) : Extended;
Begin
  if x > 0       then  result := arctan (y/x)
  else if x < 0  then  result := arctan (y/x) + pi
  else                 result := pi/2 * sgn (y);
End;


Function RealMod(Const n,d: Single): Single;
Var
  i: integer;
Begin
  i := trunc(n / d);
  result := n - d * i;
End;

Function IntPower(X:Single; I: Integer): Single;
var
  Y: Integer;
begin
  Y := Abs(I);
  Result := 1.0;
  While Y > 0 do
  Begin
    While Not Odd(Y) do
    Begin
      Y := Y Shr 1;
      X := X * X;
    End;
    Dec(Y);
    Result := Result * X;
  End;
  if I < 0.0 Then
    Result := 1.0 / Result;
End;

Function Pow(X, Y:Single):Single;
Begin
  If Y = 0.0 Then
    Result := 1.0
  Else if (X = 0.0) and (Y > 0.0) Then
    Result := 0.0
  Else if (Frac(Y) = 0.0) and (Abs(Y) <= MaxInt) then
    Result := IntPower(X, Integer(Trunc(Y)))
  Else
    Result := Exp(Y * Ln(X))
End;

Function NearestPowerOfTwo(P:Cardinal):Cardinal;
Var
  I,N:Cardinal;
Begin
  Result := 0;
  For I:=14 DownTo 2 Do
  Begin
    N:=(1 Shl I);
    If N<P Then
     Break
    Else
      Result:=N;
  End;
End;

Function LinearInterpolate(a,b, mu:Single):Single; 
Begin
  Result := (B * Mu) + A * (1.0 - Mu);
End;

Function CubicInterpolate(y0, y1, y2, y3, mu:Single):Single; 
Var
   a0,a1,a2,a3,mu2:Single;
Begin
   mu2 := Sqr(mu);
   a0 := y3 - y2 - y0 + y1;
   a1 := y0 - y1 - a0;
   a2 := y2 - y0;
   a3 := y1;
   Result := (a0 * mu * mu2) + (a1 * mu2) + (a2 * mu) + a3;
End;

Function CatmullRomInterpolate(y0, y1, y2, y3, mu:Single):Single; 
Var
   a0,a1,a2,a3,mu2:Single;
Begin
   mu2 := Sqr(mu);
   a0 := (-0.5 * y0) + (1.5 * y1) - (1.5 * y2) + (0.5 * y3);
   a1 := y0 - (2.5 * y1) + (2.0 * y2) - (0.5 * y3);
   a2 := (-0.5 * y0) + (0.5 * y2);
   a3 := y1;
   Result := (a0 * mu * mu2) + (a1 * mu2) + (a2 * mu) + a3;
End;

Function QuadraticBezierCurve(y0, y1, y2,  mu:Single):Single; 
Begin
  Result := Sqr(1-mu) * y0 + 2 * (1-mu) * y1  + Sqr(mu) * y2;
End;

Function CubicBezierCurve(y0, y1, y2, y3, mu:Single):Single; 
Begin
  Result := (1-mu) * Sqr(1-mu) * y0 + 3 * Sqr(1-mu) * y1  + 3 * (1-mu) * Sqr(mu) * y2 + Sqr(mu) * mu * y3;
End;

Function FloatMax(Const A,B:Single):Single; 
Begin
  If A>B Then Result:=A Else Result:=B;
End;

Function FloatMin(Const A,B:Single):Single; 
Begin
  If A<B Then Result:=A Else Result:=B;
End;

Function RandomFloat:Single; Overload;
Begin
  Result := System.Random(RAND_MAX) * INV_RAND_MAX;
End;

Function RandomFloat(Const min,max:Single):Single; Overload;
Begin
	Result := Min + ((max - min) * (System.Random(RAND_MAX) * INV_RAND_MAX));
End;

Function SmoothStep(A, B, X:Single):Single; 
Begin
  If (x < a) Then
    Result := 0.0
  Else
  If (x >= b) Then
    Result := 1.0
  Else
  Begin
    x := (x-a) / (b-a);
    Result := (x*x) * (3-2*x);
  End;
End;



Function InvSqrt(X:Single):Single;
Var
  I:Cardinal;
  xhalf:Single;
Begin
  xhalf := 0.5*x;
  i := PCardinal(@x)^;         // get bits for floating value
  i := $5f3759df - (i Shr 1);   // give initial guess y0
  x := PSingle(@i)^;           // convert bits back to float
  x := X * (1.5 - xhalf*x*x);     // newton step, repeating this step
  x := X * (1.5 - xhalf*x*x); // increases accuracy
  Result := X;
End;

Function VectorCreate2D(Const X,Y:Single):Vector2D;
Begin
  Result.X := X;
  Result.Y := Y;
End;

Function VectorCross2D(Const A,B:Vector2D):Single;
Begin
  Result := (A.X * B.Y) - (A.Y * B.X);
End;

Function Vector2D.Equals(Const B:Vector2D):Boolean;
Begin
  Result := (Self.X = B.X) And (Self.Y = B.Y);
End;

Function VectorAdd2D(Const A,B:Vector2D):Vector2D;
Begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
End;

Function VectorSubtract2D(Const A,B:Vector2D):Vector2D;
Begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
End;

Procedure Vector2D.Project(Const V:Vector2D);
Var
  thisDotV:Single;
Begin
  thisDotV := Self.Dot(V);
  Self.X := V.X * thisDotV;
  Self.Y := V.Y * thisDotV;
End;

Procedure Vector2D.Rotate(Const Angle:Single; Const Center:Vector2D);
Begin
  Self.Subtract(Center);
  Self.Rotate(Angle);
  Self.Add(Center);
End;

Procedure Vector2D.Rotate(Const Angle:Single); 
Var
  SX,SY:Single;
  Sine,Cosine:Single;
Begin
  SX := Self.X;
  SY := Self.Y;
  Sine := Sin(Angle);
  Cosine := Cos(Angle);
  X := (Sx * Cosine) - (Sy * Sine);
  Y := (Sx * Sine) + (Sy * Cosine);
End;

Procedure Vector2D.Add(Const B:Vector2D); 
Begin
  X := X + B.X;
  Y := Y + B.Y;
End;



Procedure Vector2D.Subtract(Const B:Vector2D); 
Begin
  X := X - B.X;
  Y := Y - B.Y;
End;

Procedure Vector2D.Scale(Const S:Single);
Begin
  X := X * S;
  Y := Y * S;
End;

Procedure Vector2D.Scale(Const B:Vector2D);
Begin
  X := X * B.X;
  Y := Y * B.Y;
End;





Function Vector2D.Length:Single;
Begin
  Result := Sqrt(Sqr(X)+Sqr(Y));
End;

Function Vector2D.Distance(Const B:Vector2D):Single;
Begin
  Result := Sqrt(Sqr(Self.X-B.X)+Sqr(Self.Y-B.Y));
End;


Procedure Vector2D.Normalize;
Var
  K:Single;
Begin
  K := Length;
  If (K<=1.0) Then
    Exit;
    
  X := X / K;
  Y := Y / K;
End;

Function Vector2D.Dot(B:Vector2D):Single;
Begin
  Result := (Self.X * B.X) + (Self.Y * B.Y);
End;



Function Vector3D.Get(Index:Integer):Single;
Begin
  Case Index Of
  0:  Result := X;
  1:  Result := Y;
  2:  Result := Z;
  End;
End;

Procedure Vector3D.SetValue(Index:Integer; Value:Single);
Begin
  Case Index Of
  0:  X := Value;
  1:  Y := Value;
  2:  Z := Value;
  End;
End;

Function VectorCreate(Const X,Y,Z:Single):Vector3D;
Begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
End;

Function VectorUniform(Const N:Single):Vector3D;
Begin
  Result.X := N;
  Result.Y := N;
  Result.Z := N;
End;

Function Vector3D.Equals(Const B:Vector3D):Boolean;
Begin
  Result := (Self.X=B.X) And (Self.Y=B.Y) And(Self.Z=B.Z);
End;

Function VectorMax(Const A,B:Vector3D):Vector3D;
Begin
  If A.X>B.X Then Result.X:=A.X Else Result.X:=B.X;
  If A.Y>B.Y Then Result.Y:=A.Y Else Result.Y:=B.Y;
  If A.Z>B.Z Then Result.Z:=A.Z Else Result.Z:=B.Z;
End;

Function VectorMin(Const A,B:Vector3D):Vector3D;
Begin
  If A.X<B.X Then Result.X:=A.X Else Result.X:=B.X;
  If A.Y<B.Y Then Result.Y:=A.Y Else Result.Y:=B.Y;
  If A.Z<B.Z Then Result.Z:=A.Z Else Result.Z:=B.Z;
End;

Procedure Vector3D.Rotate(Const Axis:Vector3D; Const Angle:Single);
Var
  SX,SY,SZ:Single;
  C,S:Single;
Begin
	C := Cos(angle);
	S := Sin(angle);

  SX := X;
  SY := Y;
  SZ := Z;

	X  := (Axis.x*Axis.x*(1-c) + c)	* Sx + (Axis.x*Axis.y*(1-c) - Axis.z*s)	* Sy + (Axis.x*Axis.z*(1-c) + Axis.y*s)	* Sz;
  Y  := (Axis.y*Axis.x*(1-c) + Axis.z*s)	* Sx + (Axis.y*Axis.y*(1-c) + c)	* Sy + (Axis.y*Axis.z*(1-c) - Axis.x*s)	* Sz;
	Z  := (Axis.x*Axis.z*(1-c) - Axis.y*s)	* Sx + (Axis.y*Axis.z*(1-c) + Axis.x*s)	* Sy + (Axis.z*Axis.z*(1-c) + c)	* Sz;
End;

{Function VectorDotRotate(Const Source:Vector3D; Const Matrix:LMatrix):Vector3D;
Begin
  Result.x:=VectorDot(Source,MatrixGetRow(Matrix,0));
  Result.y:=VectorDot(Source,MatrixGetRow(Matrix,1));
  Result.z:=VectorDot(Source,MatrixGetRow(Matrix,2));
End;
}

Procedure Vector3D.Add(Const B:Vector3D); 
Begin
  X := X + B.X;
  Y := Y + B.Y;
  Z := Z + B.Z;
End;

Procedure Vector3D.Subtract(Const B:Vector3D); 
Begin
  X := X - B.X;
  Y := Y - B.Y;
  Z := Z - B.Z;
End;

Procedure Vector3D.Scale(Const S:Single); 
Begin
  X := X * S;
  Y := Y * S;
  Z := Z * S;
End;

Procedure Vector3D.Multiply(Const B:Vector3D); 
Begin
  X := X * B.X;
  Y := Y * B.Y;
  Z := Z * B.Z;
End;

Function Vector3D.Dot(Const B:Vector3D):Single; 
Begin
  Result := (X*B.X)+(Y*B.Y)+(Z*B.Z);
End;

Function VectorDot(Const A,B:Vector3D):Single; 
Begin
  Result := (A.X*B.X)+(A.Y*B.Y)+(A.Z*B.Z);
End;

// R = 2 * ( N dot V ) * V - V
// R =	V - 2 * ( N dot V ) * V
Function VectorReflect(Const Source,Normal:Vector3D):Vector3D; 
Var
  N:Single;
Begin
  N := VectorDot(Normal,Source) * 2;
  Result := VectorScale(Source, N);
  Result := VectorSubtract(Source,Result);
End;

Function VectorCross(Const A,B:Vector3D):Vector3D; 
Begin
  With Result Do
  Begin
    X := A.Y*B.Z - A.Z*B.Y;
    Y := A.Z*B.X - A.X*B.Z;
    Z := A.X*B.Y - A.Y*B.X;
  End;
End;

Function VectorSubtract(Const A,B:Vector3D):Vector3D; 
Begin
  With Result Do
  Begin
    X:=A.X-B.X;
    Y:=A.Y-B.Y;
    Z:=A.Z-B.Z;
  End;
End;

Function VectorScale(Const A:Vector3D; S:Single):Vector3D;
Begin
  With Result Do
  Begin
    X := A.X* S;
    Y := A.Y* S;
    Z := A.Z* S;
  End;
End;

Function VectorAdd(Const A,B:Vector3D):Vector3D;
Begin
  With Result Do
  Begin
    X:=(A.X+B.X);
    Y:=(A.Y+B.Y);
    Z:=(A.Z+B.Z);
  End;
End;

Function VectorMultiply(Const A,B:Vector3D):Vector3D;
Begin
  With Result Do
  Begin
    X:=(A.X*B.X);
    Y:=(A.Y*B.Y);
    Z:=(A.Z*B.Z);
  End;
End;

Function VectorInterpolate(Const A,B:Vector3D; Const S:Single):Vector3D;
Begin
  With Result Do
  Begin
    X := (A.X*S)+(B.X*(1-S));
    Y := (A.Y*S)+(B.Y*(1-S));
    Z := (A.Z*S)+(B.Z*(1-S));
  End;
End;

Function VectorBisect(Const A,B:Vector3D):Vector3D; 
Var
  Len:Single;
Begin
  Result := VectorAdd(A,B);

  Len := Result.Length;
  If (Len<Epsilon) Then
    Result := VectorZero
  Else
    Result := VectorScale(Result, 1.0 / Len);
End;

Function VectorNullify(Const A:Vector3D):Vector3D;
Begin
  If Abs(A.X)<Epsilon Then Result.X:=0 Else Result.X:=A.X;
  If Abs(A.Y)<Epsilon Then Result.Y:=0 Else Result.Y:=A.Y;
  If Abs(A.Z)<Epsilon Then Result.Z:=0 Else Result.Z:=A.Z;
End;


Procedure Vector3D.Normalize;
Var
  K:Single;
Begin
  K := Sqr(X) + Sqr(Y) + Sqr(Z);
  {If (K<=SingleOne) Then
    Exit;}

  K := InvSqrt(K);
  X := X * K;
  Y := Y * K;
  Z := Z * K;
End;

Function Vector3D.Length:Single; 
Begin
  Result := Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z));
End;

Function Vector3D.LengthSquared:Single; 
Begin
  Result := Sqr(X) + Sqr(Y) + Sqr(Z);
End;

Function Vector3D.Distance(Const B:Vector3D):Single; 
Begin
  Result := Sqrt(Sqr(Self.X-B.X) + Sqr(Self.Y-B.Y) + Sqr(Self.Z-B.Z));
End;


Function Vector3D.Distance2D(Const B:Vector3D):Single; 
Begin
  Result := Sqrt(Sqr(Self.X-B.X)+Sqr(Self.Z-B.Z));
End;

Function TriangleNormal(Const V0,V1,V2:Vector3D):Vector3D;
Var
 A,B:Vector3D;
Begin
  A := VectorSubtract(V1,V0);
  B := VectorSubtract(V2,V0);
  Result := VectorCross(A,B);
  Result.Normalize;
End;

Function TriangleHeightNormal(Const V0,V1,V2:Single):Vector3D;
Begin
  Result:=TriangleNormal(VectorCreate(0.0, V0, 0.0),
                         VectorCreate(1.0, V1, 0.0),
                         VectorCreate(0.0, V2, 1.0));
End;

Function GetTriangleHeight(H0,H1,H2:Single; X,Y:Single; Normal:PVector3D=Nil):Single;
Var
  D:Single;
  FloorNormal:Vector3D;
Begin
  FloorNormal := TriangleHeightNormal(H0, H1, H2);

  D := - (FloorNormal.Y * H0);
  Result := - ((FloorNormal.X * X) + (FloorNormal.Z * Y) + D) / FloorNormal.Y;

  If Assigned(Normal) Then
    Normal^ := FloorNormal;
End;


Function MatrixTranspose(Const Source:Matrix):Matrix;
Begin
  Result.V[0] := Source.V[0];
  Result.V[1] := Source.V[4];
  Result.V[2] := Source.V[8];
  Result.V[3] := Source.V[12];

  Result.V[4] := Source.V[1];
  Result.V[5] := Source.V[5];
  Result.V[6] := Source.V[9];
  Result.V[7] := Source.V[13];

  Result.V[8] := Source.V[2];
  Result.V[9] := Source.V[6];
  Result.V[10] := Source.V[10];
  Result.V[11] := Source.V[14];

  Result.V[12] := Source.V[3];
  Result.V[13] := Source.V[7];
  Result.V[14] := Source.V[11];
  Result.V[15] := Source.V[15];
End;

Function MatrixOrtho(left, right,  bottom,  top,  nearVal,  farVal:Single):Matrix;
Var
  Tx, Ty, Tz:Single;
Begin
  TX := -(Right + Left)/(Right - Left);
  TY := -(Top + Bottom)/(Top - Bottom);
  TZ := -(farVal + nearVal)/(farVal - nearVal);

  Result.V[0] := 2 / (Right - Left);
  Result.V[1] := 0;
  Result.V[2] := 0;
  Result.V[3] := 0;

  Result.V[4] := 0;
  Result.V[5] := 2 / (Top - Bottom);
  Result.V[6] := 0;
  Result.V[7] := 0;

  Result.V[8] := 0;
  Result.V[9] := 0;
  Result.V[10] := -2 / (farVal - nearVal);
  Result.V[11] := 0;

  Result.V[12] := tx;
  Result.V[13] := ty;
  Result.V[14] := tz;
  Result.V[15] := 1.0;
  // + 0.375
End;

//TESTME
Function Matrix.Get(I, J: Integer): Single;
Begin
  Result := V[J*4+I];
End;

Function Matrix.GetColumns: MatrixColumns;
Begin
	Result[0] := VectorCreate(V[0], V[4], V[8]);
	Result[1] := VectorCreate(V[1], V[5], V[9]);
	Result[2] := VectorCreate(V[2], V[6], V[10]);
End;

Function Matrix.GetTranslation:Vector3D;
Begin
  Result.X := V[12];
  Result.Y := V[13];
  Result.Z := V[14];
End;

Procedure Matrix.Orthonormalize;
Var
  x,y,z:Vector3D;
Begin
  // It probably should be going 11, 12, 13 for x
  x := VectorCreate(V[0], V[1], V[2]);
  // And 21, 22, 23 for y.
  x := VectorCreate(V[4], V[5], V[6]);

  x.Normalize();
  z := VectorCross(x, y);
  z.Normalize;
  y := VectorCross(z, x);
  y.Normalize;
  V[0] := x.X;
  V[1] := y.X;
  V[2] := z.X;
  V[4] := x.Y;
  V[5] := y.Y;
  V[6] := z.Y;
  V[8] := x.Z;
  V[9] := y.Z;
  V[10] := z.Z;
End;

Function Matrix.Transform(P:Vector3D):Vector3D; 
Begin
  Result.X := P.X*V[0] + P.Y*V[4] + P.Z*V[8]  + V[12];
  Result.Y := P.X*V[1] + P.Y*V[5] + P.Z*V[9]  + V[13];
  Result.Z := P.X*V[2] + P.Y*V[6] + P.Z*V[10] + V[14];
End;

Function Matrix.TransformNormal(P:Vector3D):Vector3D; 
Begin
  Result.X := P.X*V[0] + P.Y*V[4] + P.Z*V[8];
  Result.Y := P.X*V[1] + P.Y*V[5] + P.Z*V[9];
  Result.Z := P.X*V[2] + P.Y*V[6] + P.Z*V[10];
End;

Function MatrixTransform(Const Position,Rotation,Scale:Vector3D):Matrix;
Var
  CosRx,CosRy,CosRz:Single;
  SinRx,SinRy,SinRz:Single;
Begin
  CosRx := Cos(Rotation.x); //Used 6x
  CosRy := Cos(Rotation.y); //Used 4x
  CosRz := Cos(Rotation.z); //Used 4x
  SinRx := Sin(Rotation.x); //Used 5x
  SinRy := Sin(Rotation.y); //Used 5x
  SinRz := Sin(Rotation.z); //Used 5x

  Result.V[0] := CosRy*CosRz*Scale.x;
  Result.V[1] := CosRy*SinRz*Scale.x;
  Result.V[2] := -SinRy*Scale.x;
  Result.V[3] := 0.0;

  Result.V[4] := (CosRz*SinRx*SinRy*Scale.y) - (CosRx*SinRz*Scale.y);
  Result.V[5] := (CosRx*CosRz*Scale.y) + (SinRx*SinRy*SinRz*Scale.y);
  Result.V[6] := CosRy*SinRx*Scale.y;
  Result.V[7] := 0.0;

  Result.V[8] := (CosRx*CosRz*SinRy*Scale.z) + (SinRx*SinRz*Scale.z);
  Result.V[9] := (-CosRz*SinRx*Scale.z) + (CosRx*SinRy*SinRz*Scale.z);
  Result.V[10] := CosRx*CosRy*Scale.z;
  Result.V[11] := 0.0;

  Result.V[12] := Position.x;
  Result.V[13] := Position.y;
  Result.V[14] := Position.z;
  Result.V[15] := 1.0;
End;

Function MatrixOrientation(Const Position,Direction,Up,Scale:Vector3D):Matrix;
Var
  TX,TZ:Vector3D;
Begin
  TZ := VectorCross(Direction, Up);
  TZ.Normalize;
  TX := VectorCross(Up, TZ);
  TX.Normalize;

  Result.V[0] := TX.X * Scale.X;
  Result.V[1] := TX.Y * Scale.X;
  Result.V[2] := TX.Z * Scale.X;
  Result.V[3] := 0.0;

  Result.V[4] := Up.X * Scale.y;
  Result.V[5] := Up.Y * Scale.y;
  Result.V[6] := Up.Z * Scale.Y;
  Result.V[7] := 0.0;

  Result.V[8] := TZ.X * Scale.Z;
  Result.V[9] := TZ.Y * Scale.Z;
  Result.V[10] := TZ.Z * Scale.Z;
  Result.V[11] := 0.0;

  Result.V[12] := Position.x;
  Result.V[13] := Position.y;
  Result.V[14] := Position.z;
  Result.V[15] := 1.0;
End;

Function MatrixRotation(Const Axis:Vector3D; Const Angle:Single):Matrix;
Var
  C,S,T:Single;
  X,Y,Z:Single;
Begin
  C := Cos(Angle);
  S := Sin(Angle);
  T := 1-C;

  X := Axis.X;
  Y := Axis.Y;
  Z := Axis.Z;

	Result.V[0] := T * Sqr(X) + C;
	Result.V[1] := (T * X * Y) - (s *Z);
	Result.V[2] := (T * X * Z) + (s * Y);
  Result.V[3] := 0.0;

	Result.V[4] := (t * X * Y) + (s * Z);
	Result.V[5] := (t * Y * Y)+ C;
	Result.V[6] := (T * Y * Z) - (S * X);
  Result.V[7] := 0.0;

	Result.V[8] := (T * X * Z) - (S * Y);
	Result.V[9] := (T * Y * Z) + (S * X);
	Result.V[10] := (T * Z * Z) +  C;
  Result.V[11] := 0.0;
  Result.V[12] := 0.0;
  Result.V[13] := 0.0;
  Result.V[14] := 0.0;
  Result.V[15] := 1.0;
End;

Function MatrixRotation(Const Rotation:Vector3D):Matrix;  
Begin
  Result := MatrixRotation(Rotation.X, Rotation.Y, Rotation.Z);
End;

Function MatrixRotation(Const X,Y,Z:Single):Matrix;  
Var
  Cr,Sr,Cp,Sp,Cy,Sy,Srsp,Crsp:Single;
Begin
  cr := Cos(X);
	sr := Sin(X);
	cp := Cos(Y);
	sp := Sin(Y);
	cy := Cos(Z);
	sy := Sin(Z);

	Result.V[0] := cp * cy;
	Result.V[1] := cp * sy;
	Result.V[2] := -sp;

  If Result.V[2] = -0 Then
    Result.V[2] := 0;
  Result.V[3] := 0.0;

	srsp := sr * sp;
	crsp := cr * sp;

	Result.V[4] := (srsp * cy) - (cr * sy);
	Result.V[5] := (srsp * sy) + (cr * cy);
	Result.V[6] := (sr * cp);
  Result.V[7] := 0.0;

	Result.V[8] := (crsp * cy) + (sr * sy);
	Result.V[9] := (crsp * sy) - (sr * cy);
	Result.V[10] := (cr * cp);
  Result.V[11] := 0.0;
  Result.V[12] := 0.0;
  Result.V[13] := 0.0;
  Result.V[14] := 0.0;
  Result.V[15] := 1.0;
End;

Function MatrixTranslation(Const Translation:Vector3D):Matrix;
Begin
  Result := MatrixTranslation(Translation.X,Translation.Y,Translation.Z);
End;

Function MatrixTranslation(Const X,Y,Z:Single):Matrix;
Begin
  Result.V[0] := 1.0;
  Result.V[1] := 0.0;
  Result.V[2] := 0.0;
  Result.V[3] := 0.0;
  Result.V[4] := 0.0;
  Result.V[5] := 1.0;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := 0.0;
  Result.V[9] := 0.0;
  Result.V[10] := 1.0;
  Result.V[11] := 0.0;
  Result.V[12] := X;
  Result.V[13] := Y;
  Result.V[14] := Z;
  Result.V[15] := 1.0;
End;

Function MatrixTranslate(Const X,Y,Z:Single):Matrix;
Begin
  Result.V[12] :=Result.V[12]+ X;
  Result.V[13] :=Result.V[13]+ Y;
  Result.V[14] :=Result.V[14]+ Z;

End;

Function MatrixScale(Const Scale:Vector3D):Matrix;  
Begin
  Result := MatrixScale(Scale.X,Scale.Y,Scale.Z);
End;

Function MatrixScale(Const X,Y,Z:Single):Matrix;  
Begin
  Result.V[0] := X;
  Result.V[1] := 0.0;
  Result.V[2] := 0.0;
  Result.V[3] := 0.0;
  Result.V[4] := 0.0;
  Result.V[5] := Y;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := 0.0;
  Result.V[9] := 0.0;
  Result.V[10] := Z;
  Result.V[11] := 0.0;
  Result.V[12] := 0.0;
  Result.V[13] := 0.0;
  Result.V[14] := 0.0;
  Result.V[15] := 1.0;
End;

Function MatrixPerspective(FOV, aspectRatio, znear, zfar:Single):Matrix;
Var
  left, right, bottom, top:Single;
  ymax, xmax:Single;
  temp, temp2, temp3, temp4:Single;
Begin
  ymax := znear * Tan(FOV * 0.5 * Rad);
  xmax := ymax * aspectRatio;

  left := -xmax;
  right := xmax;
  bottom := -ymax;
  top := ymax;

  temp := znear * 2.0;
  temp2 := (xmax * 2.0);
  temp3 :=  (top - bottom);
  temp4 := 1.0 / (zfar - znear);
  Result.V[0] := temp / temp2;
  Result.V[1] := 0.0;
  Result.V[2] := 0.0;
  Result.V[3] := 0.0;
  Result.V[4] := 0.0;
  Result.V[5] := temp / temp3;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := (right + left) / temp2;
  Result.V[9] := (top + bottom) / temp3;
  Result.V[10] := (-zfar - znear) * temp4;
  Result.V[11] := -1.0;
  Result.V[12] := 0.0;
  Result.V[13] := 0.0;
  Result.V[14] := (-temp * zfar) * temp4;
  Result.V[15] := 0.0;
End;

Function MatrixLookAt(Eye, LookAt, Roll:Vector3D):Matrix;
Var
  xaxis, yaxis, zaxis:Vector3D;
Begin
  zaxis := VectorSubtract(Eye, lookAt);
  zaxis.Normalize();
  xaxis := VectorCross(Roll, zaxis);
  xaxis.Normalize();
  yaxis := VectorCross(zaxis, xaxis);

  Result.V[0] := xaxis.x;
  Result.V[1] := yaxis.x;
  Result.V[2] := zaxis.x;
  Result.V[3] := 0.0;
  Result.V[4] := xaxis.y;
  Result.V[5] := yaxis.y;
  Result.V[6] := zaxis.y;
  Result.V[7] := 0.0;
  Result.V[8] := xaxis.z;
  Result.V[9] := yaxis.z;
  Result.V[10] := zaxis.z;
  Result.V[11] := 0.0;
  Result.V[12] := -xaxis.dot(eye);
  Result.V[13] := -yaxis.dot(eye);
  Result.V[14] := -zaxis.dot(eye);
  Result.V[15] := 1.0;
End;

Function MatrixMirror(Const Source,Normal:Vector3D):Matrix;
Var
  Dot:Single;
Begin
  Dot := VectorDot(Source,Normal);

  Result.V[0] := 1.0 - (2.0 *Normal.X * Normal.X);
  Result.V[1] := - (2.0 * Normal.Y * Normal.X);
  Result.V[2] := - (2.0 * Normal.Z * Normal.X);
  Result.V[3] := 0.0;

  Result.V[4] := - (2.0 * Normal.X * Normal.Y);
  Result.V[5] := 1.0 - (2.0 * Normal.Y * Normal.Y);
  Result.V[6] := - (2.0 * Normal.Z * Normal.Y);
  Result.V[7] := 0.0;

  Result.V[8] := - (2.0 * Normal.X * Normal.Z);
  Result.V[9] := - (2.0 * Normal.Y * Normal.Z);
  Result.V[10] := 1.0 - (2.0 * Normal.Z * Normal.Z);
  Result.V[11] := 0.0;

  Result.V[12]:= 2.0 * Dot * Normal.X;
  Result.V[13]:= 2.0 * Dot * Normal.Y;
  Result.V[14]:= 2.0 * Dot * Normal.Z;
  Result.V[15]:= 1.0;
End;

Function MatrixGetTranslation(Const A:Matrix):Vector3D;
Begin
  Result.X := A.V[12];
  Result.Y := A.V[13];
  Result.Z := A.V[14];
End;

Function MatrixGetScale(Const A:Matrix):Vector3D;
Begin
  Result.X := A.V[0];
  Result.Y := A.V[5];
  Result.Z := A.V[10];
End;

// 4x4 matrix inverse using Gauss-Jordan algorithm with row pivoting
// originally written by Nathan Reed, now released into the public domain.
Function MatrixInverse(A:Matrix):Matrix;
Var
  I:Integer;
  a0, a1, a2, a3, a4, a5: Single;
  b0, b1, b2, b3, b4, b5: Single;
  Det, invDet:Single;
Begin
  a0 := A.V[ 0] * A.V[ 5] - A.V[ 1] *A.V[ 4];
  a1 := A.V[ 0] * A.V[ 6] - A.V[ 2] *A.V[ 4];
  a2 := A.V[ 0] * A.V[ 7] - A.V[ 3] *A.V[ 4];
  a3 := A.V[ 1] * A.V[ 6] - A.V[ 2] *A.V[ 5];
  a4 := A.V[ 1] * A.V[ 7] - A.V[ 3] *A.V[ 5];
  a5 := A.V[ 2] * A.V[ 7] - A.V[ 3] *A.V[ 6];
  b0 := A.V[ 8] * A.V[13] - A.V[ 9] *A.V[12];
  b1 := A.V[ 8] * A.V[14] - A.V[10] *A.V[12];
  b2 := A.V[ 8] * A.V[15] - A.V[11] *A.V[12];
  b3 := A.V[ 9] * A.V[14] - A.V[10] *A.V[13];
  b4 := A.V[ 9] * A.V[15] - A.V[11] *A.V[13];
  b5 := A.V[10] * A.V[15] - A.V[11] *A.V[14];

  Det := a0*b5 - a1*b4 + a2*b3 + a3*b2 - a4*b1 + a5*b0;
  If (Abs(Det) > Epsilon) Then
  Begin
    Result.V[ 0] := + A.V[ 5]*b5 - A.V[ 6]*b4 + A.V[ 7]*b3;
    Result.V[ 4] := - A.V[ 4]*b5 + A.V[ 6]*b2 - A.V[ 7]*b1;
    Result.V[ 8] := + A.V[ 4]*b4 - A.V[ 5]*b2 + A.V[ 7]*b0;
    Result.V[12] := - A.V[ 4]*b3 + A.V[ 5]*b1 - A.V[ 6]*b0;
    Result.V[ 1] := - A.V[ 1]*b5 + A.V[ 2]*b4 - A.V[ 3]*b3;
    Result.V[ 5] := + A.V[ 0]*b5 - A.V[ 2]*b2 + A.V[ 3]*b1;
    Result.V[ 9] := - A.V[ 0]*b4 + A.V[ 1]*b2 - A.V[ 3]*b0;
    Result.V[13] := + A.V[ 0]*b3 - A.V[ 1]*b1 + A.V[ 2]*b0;
    Result.V[ 2] := + A.V[13]*a5 - A.V[14]*a4 + A.V[15]*a3;
    Result.V[ 6] := - A.V[12]*a5 + A.V[14]*a2 - A.V[15]*a1;
    Result.V[10] := + A.V[12]*a4 - A.V[13]*a2 + A.V[15]*a0;
    Result.V[14] := - A.V[12]*a3 + A.V[13]*a1 - A.V[14]*a0;
    Result.V[ 3] := - A.V[ 9]*a5 + A.V[10]*a4 - A.V[11]*a3;
    Result.V[ 7] := + A.V[ 8]*a5 - A.V[10]*a2 + A.V[11]*a1;
    Result.V[11] := - A.V[ 8]*a4 + A.V[ 9]*a2 - A.V[11]*a0;
    Result.V[15] := + A.V[ 8]*a3 - A.V[ 9]*a1 + A.V[10]*a0;

    invDet := 1.0 / Det;
    For I:=0 To 15 Do
      Result.V[ I] := Result.V[ I] * invDet;
  End Else
    FillChar(Result, SizeOf(Result), 0);
End;

Function MatrixLerp(Const A,B:Matrix; Const S:Single):Matrix;
Var
  I:Integer;
Begin
  For I:=0 To 15 Do
   Result.V[I] := A.V[I] * S + B.V[I] * (1.0 - S);
End;


Function MatrixMultiply4x4(Const A,B:Matrix):Matrix;
Begin
	Result.V[0] := A.V[0]*B.V[0] + A.V[4]*B.V[1] + A.V[8]*B.V[2] + A.V[12]*B.V[3];
	Result.V[1] := A.V[1]*B.V[0] + A.V[5]*B.V[1] + A.V[9]*B.V[2] + A.V[13]*B.V[3];
	Result.V[2] := A.V[2]*B.V[0] + A.V[6]*B.V[1] + A.V[10]*B.V[2] + A.V[14]*B.V[3];
	Result.V[3] := A.V[3]*B.V[0] + A.V[7]*B.V[1] + A.V[11]*B.V[2] + A.V[15]*B.V[3];

	Result.V[4] := A.V[0]*B.V[4] + A.V[4]*B.V[5] + A.V[8]*B.V[6] + A.V[12]*B.V[7];
	Result.V[5] := A.V[1]*B.V[4] + A.V[5]*B.V[5] + A.V[9]*B.V[6] + A.V[13]*B.V[7];
	Result.V[6] := A.V[2]*B.V[4] + A.V[6]*B.V[5] + A.V[10]*B.V[6] + A.V[14]*B.V[7];
	Result.V[7] := A.V[3]*B.V[4] + A.V[7]*B.V[5] + A.V[11]*B.V[6] + A.V[15]*B.V[7];

	Result.V[8] := A.V[0]*B.V[8] + A.V[4]*B.V[9] + A.V[8]*B.V[10] + A.V[12]*B.V[11];
	Result.V[9] := A.V[1]*B.V[8] + A.V[5]*B.V[9] + A.V[9]*B.V[10] + A.V[13]*B.V[11];
	Result.V[10] := A.V[2]*B.V[8] + A.V[6]*B.V[9] + A.V[10]*B.V[10] + A.V[14]*B.V[11];
	Result.V[11] := A.V[3]*B.V[8] + A.V[7]*B.V[9] + A.V[11]*B.V[10] + A.V[15]*B.V[11];

	Result.V[12] := A.V[0]*B.V[12] + A.V[4]*B.V[13] + A.V[8]*B.V[14] + A.V[12]*B.V[15];
	Result.V[13] := A.V[1]*B.V[12] + A.V[5]*B.V[13] + A.V[9]*B.V[14] + A.V[13]*B.V[15];
	Result.V[14] := A.V[2]*B.V[12] + A.V[6]*B.V[13] + A.V[10]*B.V[14] + A.V[14]*B.V[15];
	Result.V[15] := A.V[3]*B.V[12] + A.V[7]*B.V[13] + A.V[11]*B.V[14] + A.V[15]*B.V[15];
End;

Function MatrixMultiply4x3(Const A,B:Matrix):Matrix;
Begin
	Result.V[0] := A.V[0]*B.V[0] + A.V[4]*B.V[1] + A.V[8]*B.V[2];
	Result.V[1] := A.V[1]*B.V[0] + A.V[5]*B.V[1] + A.V[9]*B.V[2];
	Result.V[2] := A.V[2]*B.V[0] + A.V[6]*B.V[1] + A.V[10]*B.V[2];
	Result.V[3] := 0.0;

	Result.V[4] := A.V[0]*B.V[4] + A.V[4]*B.V[5] + A.V[8]*B.V[6];
	Result.V[5] := A.V[1]*B.V[4] + A.V[5]*B.V[5] + A.V[9]*B.V[6];
	Result.V[6] := A.V[2]*B.V[4] + A.V[6]*B.V[5] + A.V[10]*B.V[6];
	Result.V[7] := 0.0;

	Result.V[8] := A.V[0]*B.V[8] + A.V[4]*B.V[9] + A.V[8]*B.V[10];
	Result.V[9] := A.V[1]*B.V[8] + A.V[5]*B.V[9] + A.V[9]*B.V[10];
	Result.V[10] := A.V[2]*B.V[8] + A.V[6]*B.V[9] + A.V[10]*B.V[10];
	Result.V[11] := 0.0;

	Result.V[12] := A.V[0]*B.V[12] + A.V[4]*B.V[13] + A.V[8]*B.V[14] + A.V[12];
	Result.V[13] := A.V[1]*B.V[12] + A.V[5]*B.V[13] + A.V[9]*B.V[14] + A.V[13];
	Result.V[14] := A.V[2]*B.V[12] + A.V[6]*B.V[13] + A.V[10]*B.V[14] + A.V[14];
	Result.V[15] := 1.0;
End;


Function TQuaternionCreate(Const X,Y,Z,W:Single):TQuaternion;
Begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
  Result.W := W;
End;

Function TQuaternionCreate(Const V:Vector3D):TQuaternion;
Begin
  Result.X := V.X;
  Result.Y := V.Y;
  Result.Z := V.Z;
  Result.W := 1.0;
End;

Function TQuaternion.Length:Single;
Begin
  Result := Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z) + Sqr(W));
End;

Function TQuaternion.Equals(Const B:TQuaternion):Boolean;
Begin
  Result := (Self.X=B.X) And (Self.Y=B.Y) And(Self.Z=B.Z) And(Self.W=B.W);
End;

Function TQuaternionRotation(Const Rotation:Vector3D):TQuaternion;
Var
  cos_z_2, cos_y_2, cos_x_2:Single;
  sin_z_2, sin_y_2, sin_x_2:Single;
Begin
  cos_z_2 := Cos(0.5 * Rotation.Z);
  cos_y_2 := Cos(0.5 * Rotation.y);
  cos_x_2 := Cos(0.5 * Rotation.x);

  sin_z_2 := Sin(0.5 * Rotation.z);
  sin_y_2 := Sin(0.5 * Rotation.y);
  sin_x_2 := Sin(0.5 * Rotation.x);

	// and now compute quaternion
	Result.W := cos_z_2*cos_y_2*cos_x_2 + sin_z_2*sin_y_2*sin_x_2;
  Result.X := cos_z_2*cos_y_2*sin_x_2 - sin_z_2*sin_y_2*cos_x_2;
	Result.Y := cos_z_2*sin_y_2*cos_x_2 + sin_z_2*cos_y_2*sin_x_2;
  Result.Z := sin_z_2*cos_y_2*cos_x_2 - cos_z_2*sin_y_2*sin_x_2;

  Result.Normalize;
End;

Function TQuaternionMatrix(Const Quaternion:TQuaternion):Matrix;
Var
  Q:TQuaternion;
Begin
  Q := Quaternion;
  Q.Normalize;

  Result.V[0]:= 1.0 - 2.0*Q.Y*Q.Y -2.0 *Q.Z*Q.Z;
  Result.V[1]:= 2.0 * Q.X*Q.Y + 2.0 * Q.W*Q.Z;
  Result.V[2]:= 2.0 * Q.X*Q.Z - 2.0 * Q.W*Q.Y;
  Result.V[3] := 0;

  Result.V[4]:= 2.0 * Q.X*Q.Y - 2.0 * Q.W*Q.Z;
  Result.V[5]:= 1.0 - 2.0 * Q.X*Q.X - 2.0 * Q.Z*Q.Z;
  Result.V[6]:= 2.0 * Q.Y*Q.Z + 2.0 * Q.W*Q.X;
  Result.V[7] := 0;

  Result.V[8] := 2.0 * Q.X*Q.Z + 2.0 * Q.W*Q.Y;
  Result.V[9] := 2.0 * Q.Y*Q.Z - 2.0 * Q.W*Q.X;
  Result.V[10] := 1.0 - 2.0 * Q.X*Q.X - 2.0 * Q.Y*Q.Y;
  Result.V[11] := 0;

  Result.V[12] := 0.0;
  Result.V[13] := 0.0;
  Result.V[14] := 0.0;
  Result.V[15] := 1.0;
End;

Function TQuaternionMultiply(Const Ql,Qr:TQuaternion):TQuaternion;
Begin
  Result.W := qL.W * qR.W - qL.X * qR.X - qL.Y * qR.Y - qL.Z * qR.Z;
  Result.X := qL.W * qR.X + qL.X * qR.W + qL.Y * qR.Z - qL.Z * qR.Y;
  Result.Y := qL.W * qR.Y + qL.Y * qR.W + qL.Z * qR.X - qL.X * qR.Z;
  Result.Z := qL.W * qR.Z + qL.Z * qR.W + qL.X * qR.Y - qL.Y * qR.X;
End;




Procedure TQuaternion.Normalize;
Var
  Len:Single;
Begin

  Len := Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z) + Sqr(W));
  If (Len<=0) Then
    Exit;

  Len := 1.0 / Len;
  X := X * Len;
  Y := Y * Len;
  Z := Z * Len;
  W := W * Len;

End;


Function TQuaternionSlerp(A,B:TQuaternion; Const T:Single):TQuaternion;
Var
  Theta, Sine, Beta, Alpha:Single;
  Cosine:Single;
Begin
  Cosine := a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w;
  Cosine := Abs(Cosine);

  If ((1-cosine)>Epsilon) Then
  Begin
    Theta := ArcCos(cosine);
  	Sine := Sin(theta);

  	Beta := Sin((1-t)*theta) / sine;
  	Alpha := Sin(t*theta) / sine;
  End Else
  Begin
    Beta := (1.0 - T);
    Alpha := T;
  End;

  Result.X := A.X * Beta + B.X * Alpha;
  Result.Y := A.Y * Beta + B.Y * Alpha;
  Result.Z := A.Z * Beta + B.Z * Alpha;
  Result.W := A.W * Beta + B.W * Alpha;
End;

Procedure TQuaternion.Add(Const B:TQuaternion);
Begin
  X := X + B.X;
  Y := Y + B.Y;
  Z := Z + B.Z;
//  W := W + B.W;
End;

Procedure TQuaternion.Subtract(Const B:TQuaternion);
Begin
  X := X - B.X;
  Y := Y - B.Y;
  Z := Z - B.Z;
//  W := W - B.W;
End;

Function TQuaternionAdd(Const A,B:TQuaternion):TQuaternion;
Begin
  With Result Do
  Begin
    X := A.X + B.X;
    Y := A.Y + B.Y;
    Z := A.Z + B.Z;
    W := A.W + B.W;
  End;
End;

Function TQuaternionScale(Const Q:TQuaternion; Const Scale:Single):TQuaternion;
Begin
  With Result Do
  Begin
    X := Q.X * Scale;
    Y := Q.Y * Scale;
    Z := Q.Z * Scale;
    W := Q.W * Scale;
  End;
End;

Function TQuaternionFromBallPoints(Const arcFrom,arcTo:Vector3D):TQuaternion;
Begin
  Result.X := arcFrom.Y * arcTo.Z - arcFrom.Z * arcTo.Y;
  Result.Y := arcFrom.Z * arcTo.X - arcFrom.X * arcTo.Z;
  Result.Z := arcFrom.X * arcTo.Y - arcFrom.Y * arcTo.X;
  Result.W := arcFrom.X * arcTo.X + arcFrom.Y * arcTo.Y + arcFrom.Z * arcTo.Z;
End;

Procedure TQuaternionToBallPoints(Var Q:TQuaternion; arcFrom,arcTo:Vector3D);
Var
  S:Single;
Begin
  S := Sqrt(Sqr(Q.X) + Sqr(Q.Y));

  If s=0 Then
    arcFrom:=VectorCreate(0.0, 1.0, 0.0)
  Else
    arcFrom:=VectorCreate(-Q.Y/S, Q.X/S, 0.0);

  arcTo.X := (Q.W * arcFrom.X) - (Q.Z * arcFrom.Y);
  arcTo.Y := (Q.W * arcFrom.Y) + (Q.Z * arcFrom.X);
  arcTo.Z := (Q.X * arcFrom.Y) - (Q.Y * arcFrom.X);

  If Q.W<0.0 Then
    arcFrom := VectorCreate(-arcFrom.X, -arcFrom.Y, 0.0);
End;

Function TQuaternionConjugate(Const Q:TQuaternion):TQuaternion;
Begin
  Result.X :=  -Q.X;
  Result.Y := -Q.Y;
  Result.Z := -Q.Z;
  Result.W := Q.W;
End;

Function VectorCreate4D(Const X,Y,Z,W:Single):TQuaternion;
Begin
 Result.X := X;
 Result.Y := Y;
 Result.Z := Z;
 Result.W := W;
End;

Procedure TQuaternion.Transform(Const M:Matrix);
Var
  QX,QY,QZ,QW:Single;
Begin
  QX := X;
  QY := Y;
  QZ := Z;
  QW := W;

  X := QX*M.V[0] + QY*M.V[4] + QZ*M.V[8]  + QW*M.V[12];
  Y := QX*M.V[1] + QY*M.V[5] + QZ*M.V[9]  + QW*M.V[13];
  Z := QX*M.V[2] + QY*M.V[6] + QZ*M.V[10] + QW*M.V[14];
  W := QX*M.V[3] + QY*M.V[7] + QZ*M.V[11] + QW*M.V[15];
End;


//! converts from a normalized axis - angle pair rotation to a quaternion
Function TQuaternionFromAxisAngle(Const Axis:Vector3D; Const Angle:Single):TQuaternion;
Var
  S:Single;
Begin
  S := Sin(Angle/2);
  Result.X := Axis.X * S;
  Result.Y := Axis.Y * S;
  Result.Z := Axis.Z * S;
  Result.W := Cos(angle/2);
End;

Function TQuaternionToEuler(Const Q:TQuaternion):Vector3D;
Var
  sqw, sqx, sqy, sqz:Single;
Begin
{  Result.X := Atan2(2 * q.Y * q.W - 2 * q.X * q.Z,
 	                1 - 2* Pow(q.Y, 2) - 2*Pow(q.Z, 2)   );

  Result.Y := Arcsin(2*q.X*q.Y + 2*q.Z*q.W);

  Result.Z := Atan2(2*q.X*q.W-2*q.Y*q.Z,
 	                1 - 2*Pow(q.X, 2) - 2*Pow(q.Z, 2)     );

  If (q.X*q.Y + q.Z*q.W = 0.5) Then
  Begin
    Result.X := (2 * Atan2(q.X,q.W));
 	  Result.Z := 0;
  End Else
  If (q.X*q.Y + q.Z*q.W = -0.5) Then
  Begin
    Result.X := (-2 * Atan2(q.X, q.W));
    Result.Z := 0;
  End;}

	sqx := Sqr(Q.X);
	sqy := Sqr(Q.Y);
	sqz := Sqr(Q.Z);

		{if (homogenous) Then
			euler.x = atan2f(2.f * (v.x*v.y + v.z*s), sqx - sqy - sqz + sqw);
			euler.y = asinf(-2.f * (v.x*v.z - v.y*s));
			euler.z = atan2f(2.f * (v.y*v.z + v.x*s), -sqx - sqy + sqz + sqw);
		End Else
    }

  Result.x := atan2(2 * (Q.z*Q.y + Q.x*Q.W), 1 - 2*(sqx + sqy));
  Result.y := arcsin(-2 * (Q.x*Q.z - Q.y*Q.W));
  Result.z := atan2(2 * (Q.x*Q.y + Q.z*Q.W), 1 - 2*(sqy + sqz));
End;

{
  0 1 2
  3 4 5
  6 7 8
}

Function Matrix2D.Transform(Const P:Vector2D):Vector2D;
Begin
  Result.X := P.X * V[0] + P.Y * V[1] + V[2];
  Result.Y := P.X * V[3] + P.Y * V[4] + V[5];
End;

Procedure Matrix2D.Init(M: Matrix);
Begin
  V[0] := M.V[0];
  V[1] := M.V[1];
  V[2] := M.V[2];

  V[3] := M.V[4];
  V[4] := M.V[5];
  V[5] := M.V[6];

  V[6] := M.V[8];
  V[7] := M.V[9];
  V[8] := M.V[10];
End;

Function Matrix2D.Transform(Const P:Vector3D):Vector3D;
Begin
  Result.X := P.X * V[0] + P.Y * V[1] + V[2];
  Result.Y := P.X * V[3] + P.Y * V[4] + V[5];
  Result.Z := P.Z;
End;

Function MatrixRotation2D(Const Angle:Single):Matrix2D;  
Var
  S,C:Single;
Begin
  C := Cos(Angle);
	S := Sin(Angle);
  Result.V[0] := C;
  Result.V[1] := S;
  Result.V[2] := 0.0;
  Result.V[3] := -S;
  Result.V[4] := C;
  Result.V[5] := 0.0;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := 1.0;
End;

Function MatrixTranslation2D(Const Translation:Vector2D):Matrix2D;  
Begin
  Result := MatrixTranslation2D(Translation.X,Translation.Y);
End;

Function MatrixTranslation2D(Const X,Y:Single):Matrix2D;  
Begin
  Result.V[0] := 1.0;
  Result.V[1] := 0.0;
  Result.V[2] := X;
  Result.V[3] := 0.0;
  Result.V[4] := 1.0;
  Result.V[5] := Y;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := 1.0;
End;

Function MatrixScale2D(Const Scale:Vector2D):Matrix2D;  
Begin
  Result := MatrixScale2D(Scale.X, Scale.Y);
End;

Function MatrixScale2D(Const X,Y:Single):Matrix2D;  
Begin
  Result.V[0] := X;
  Result.V[1] := 0.0;
  Result.V[2] := 0.0;
  Result.V[3] := 0.0;
  Result.V[4] := Y;
  Result.V[5] := 0.0;
  Result.V[6] := 0.0;
  Result.V[7] := 0.0;
  Result.V[8] := 1.0;
End;



{
  0 1 2
  3 4 5
  6 7 8
}

Function MatrixMultiply3x3(Const A,B:Matrix2D):Matrix2D;
Begin
	Result.V[0] := A.V[0]*B.V[0] + A.V[3]*B.V[1] + A.V[6]*B.V[2];
	Result.V[1] := A.V[1]*B.V[0] + A.V[4]*B.V[1] + A.V[7]*B.V[2];
	Result.V[2] := A.V[2]*B.V[0] + A.V[5]*B.V[1] + A.V[8]*B.V[2];

	Result.V[3] := A.V[0]*B.V[3] + A.V[3]*B.V[4] + A.V[6]*B.V[5];
	Result.V[4] := A.V[1]*B.V[3] + A.V[4]*B.V[4] + A.V[7]*B.V[5];
	Result.V[5] := A.V[2]*B.V[3] + A.V[5]*B.V[4] + A.V[8]*B.V[5];

	Result.V[6] := A.V[0]*B.V[6] + A.V[3]*B.V[7] + A.V[6]*B.V[8];
	Result.V[7] := A.V[1]*B.V[6] + A.V[4]*B.V[7] + A.V[7]*B.V[8];
	Result.V[8] := A.V[2]*B.V[6] + A.V[5]*B.V[7] + A.V[8]*B.V[8];
End;

Function TriangleArea2D(A,B,C:Vector2D):Single;
Begin
  Result := (A.X*B.Y + B.X * C.Y + C.X * A.Y - A.X*C.Y - B.X * A.Y - C.x* B.Y) * 0.5;
End;


Function CircleCreate(Origin:Vector2D; Radius:Single):Circle;
Begin
  Result.Center := Origin;
  Result.Radius := Radius;
End;

Function CircleCreate(X,Y:Single; Radius:Single):Circle;
Begin
  Result := CircleCreate(VectorCreate2D(X,Y), Radius);
End;

Function LineCreate2D(P1,P2:Vector2D):Line2D;
Begin
  Result.P1 := P1;
  Result.P2 := P2;
End;

Function LineCreate2D(X1,Y1,X2,Y2:Single):Line2D;
Begin
  Result.P1 := VectorCreate2D(X1,Y1);
  Result.P2 := VectorCreate2D(X2,Y2);
End;


Function Line2D.PointInside(P: Vector2D): Boolean;
Var
  MinX, MinY, MaxX, MaxY:Single;
Begin
  MinX := FloatMin(P1.X, P2.X);
  MinY := FloatMin(P1.Y, P2.Y);
  MaxX := FloatMax(P1.X, P2.X);
  MaxY := FloatMax(P1.Y, P2.Y);
  Result := (P.X>=MinX) And (P.X<=MaxX) And (P.Y>=MinY) And (P.Y<=MaxY);
End;

Function Line2D.Intersect(C:Circle; Hit:PVector2D; Distance:PSingle):Boolean;
{    const Vector2& c,        // center
    float r,                            // radius
    const Vector2& p1,     // segment start
    const Vector2& p2)     // segment end}
Var
  Dir, Diff:Vector2D;
  T, Distsqr:Single;
  Closest, D:Vector2D;
Begin
  Dir := P2;
  Dir.Subtract(P1);
  Diff := C.Center;
  Diff.Subtract(P1);

  T := Diff.Dot(Dir) / Dir.Dot(Dir);

  If (T < 0.0) Then
    T := 0.0;

  If (T > 1.0) Then
    T := 1.0;

  Closest := Dir;
  Closest.Scale(T);
  Closest.Add(P1);

  D := C.Center;
  D.Subtract(Closest);

  Distsqr := D.Dot(D);
  If Assigned(Distance) Then
    Distance^ := Sqrt(Distsqr);

  Result := (distsqr <= Sqr(C.Radius));
  If Assigned(Hit) Then
    Hit^ := Closest;
End;


Function Line2D.Intersect(B:Line2D; Hit:PVector2D = Nil):Boolean;
Var
  Denom, nume_a, nume_b:Single;
  Ua,Ub:Single;
Begin
  denom := (B.P2.y - B.P1.y) * (P2.x - P1.x) - (B.P2.x - B.P1.x) * (P2.y - P1.y);
  nume_a := (B.P2.x - B.P1.x) * (P1.y - B.P1.y) - (B.P2.y - B.P1.y) * (P1.x - B.P1.x);
  nume_b := (P2.x - P1.x) * (P1.y - B.P1.y) - (P2.y - P1.y) * (P1.x - B.P1.x);

  If (denom = 0.0) Then
  Begin
    If(nume_a = 0.0) And (nume_b = 0.0) Then
      Result := True // COINCIDENT
    Else
      Result := False; //PARALLEL;
    Exit;
  End;

  ua := nume_a / denom;
  ub := nume_b / denom;

  If (ua >= 0.0) And (ua <= 1.0) And (ub >= 0.0) And (ub <= 1.0) Then
  Begin
    // Get the intersection point.
    If (Assigned(Hit)) Then
    Begin
      Hit.X := P1.x + ua*(P2.x - P1.x);
      Hit.Y := P1.y + ua*(P2.y - P1.y);
    End;

    Result := True;
  End Else
    Result := False;
End;

Function Line2D.Intersect(P:Polygon2D; Hit:PVector2D):Boolean;
Var
  I,J:Integer;
Begin
  J := Pred(P.VertexCount);
  For I:=0 To Pred(P.VertexCount) Do
  Begin
    If (Self.Intersect(LineCreate2D(P.Vertices[I], P.Vertices[J]), Hit)) Then
    Begin
      Result := True;
      Exit;
    End;
    J := I;
  End;

  Result := False;
End;

{ Polygon2D }
Procedure Polygon2D.AddVertex(X, Y:Single);
Begin
  Self.AddVertex(VectorCreate2D(X,Y));
End;

Procedure Polygon2D.AddVertex(P:Vector2D);
Begin
  Inc(VertexCount);
  SetLength(Vertices, VertexCount);
  Vertices[Pred(VertexCount)] := P;
End;

Function Polygon2D.Intersect(C:Circle; Hit:PVector2D = Nil):Boolean;
Var
  I,J:Integer;
Begin
  J := Pred(VertexCount);
  For I:=0 To Pred(VertexCount) Do
  Begin
    If (LineCreate2D(Vertices[I], Vertices[J]).Intersect(C, Hit)) Then
    Begin
      Result := True;
      Exit;
    End;
    J := I;
  End;

  Result := PointInside(C.Center);
End;

Function Polygon2D.PolygonInside(P:Polygon2D):Boolean;
Var
  I:Integer;
Begin
  For I:=0 To Pred(P.VertexCount) Do
  If (Not PointInside(P.Vertices[I])) Then
  Begin
    Result := False;
    Exit;
  End;

  Result := True;
End;

Function Polygon2D.PointInside(P: Vector2D):Boolean;
Var
  I,Counter:Integer;
  P1,P2:Vector2D;
  xinters:Single;
Begin
  Counter := 0;
  If (VertexCount<=0) Then
  Begin
    Result := False;
    Exit;
  End;

  P1 := Vertices[0];
  For I:=1 To VertexCount Do
  Begin
    P2 := Vertices[I Mod VertexCount];
    If (P.y > FloatMin(p1.y,p2.y)) Then
      If (p.y <= FloatMax(p1.y,p2.y)) Then
        if (p.x <= FloatMax(p1.x,p2.x)) Then
          if (p1.y <>  p2.y) Then
          Begin
            xinters := ((p.y - p1.y) * (p2.x-p1.x)) / (p2.y-p1.y) + p1.x;
            if (p1.x = p2.x) Or (p.x <= xinters) Then
              Inc(counter);
          End;
    p1 := p2;
  End;

  Result := Odd(Counter);
End;

{ ConvexHull2D }

Procedure PointCloud2D.AddPoint(P: Vector2D);
Begin
  Inc(PointCount);
  SetLength(Points, PointCount);
  Points[Pred(PointCount)] := P;
End;

Function PointCloud2D.GetRect:Line2D;
Var
  I:Integer;
Begin
  Result.P1 := Points[0];
  Result.P2 := Points[0];
  For I:=1 To Pred(PointCount) Do
  Begin
    Result.P1.X := FloatMin(Result.P1.X, Points[I].X);
    Result.P1.Y := FloatMin(Result.P1.Y, Points[I].Y);
    Result.P2.X := FloatMax(Result.P2.X, Points[I].X);
    Result.P2.Y := FloatMax(Result.P2.Y, Points[I].Y);
  End;
End;

Function PointCloud2D.GetConvexHull: Polygon2D;
Var
  I,J, pointOnHull, firstPoint:Integer;
  AllOnLeft, Found:Boolean;
  Min:Single;
Begin
  Result.VertexCount := 0;

  // remove duplicate vertices
  I := 0;
  While (I<PointCount) Do
  Begin
    Found := False;
    For J:=0 To Pred(PointCount) Do
    If (I<>J) And (Points[J].Distance(Points[I])<=0.1) Then
    Begin
      Found := True;
      Break;
    End;

    If (Found) Then
    Begin
      Points[I] := Points[Pred(PointCount)];
      Dec(PointCount);
    End Else
      Inc(I);
  End;

  If (PointCount<3) Then
    Exit;

  If (PointCount=3) Then
  Begin
    For I:=0 To 2 Do
      Result.AddVertex(Points[I]);
    Exit;
  End;

  //    pointOnHull = leftmost point in S
  pointOnHull := 0;
  Min := Points[0].X;
  For I:=1 To Pred(PointCount) Do
  If (Points[I].X<Min) Then
  Begin
    Min := Points[I].X;
    pointOnHull := I;
  End;

  firstPoint := pointOnHull;
  Repeat
    Result.AddVertex(Points[pointOnHull]); //   P[i] = pointOnHull
    Found := False;
    For I:=0 To Pred(PointCount) Do
    If (I<>PointOnHull) Then
    Begin
      AllOnLeft := True;
      For J:=0 To Pred(PointCount) Do
      If (J<>I) And (J<>pointOnHull) Then
      Begin
        If (TriangleArea2D(Points[pointOnHull], Points[I], Points[J])<0) Then
        Begin
          AllOnLeft := False;
          Break;
        End;
      End;

      If (AllOnLeft) Then
      Begin
        pointOnHull := I;
        Found := True;
        Break;
      End;
    End;

    If Not Found Then
    Begin
    End;

  Until (pointOnHull = firstPoint) {Or (Not Found)};

{  If Not Found Then
  Begin
    Save('hullpoints.dat');
    Halt;
  End;}
End;

{Procedure PointCloud2D.Load(FileName: String);
Var
  Source:FileStream;
Begin
  Source := FileStream.Open(FileName);
  Source.Read(PointCount, 4);
  SetLength(Points, PointCount);
  Source.Read(Points[0], SizeOf(Vector2D) * PointCount);
  Source.Destroy;
End;

Procedure PointCloud2D.Save(FileName: String);
Var
  Dest:FileStream;
Begin
  Dest := FileStream.Create(FileName);
  Dest.Write(PointCount, 4);
  Dest.Write(Points[0], SizeOf(Vector2D) * PointCount);
  Dest.Destroy;
End;}

Function Circle.Intersect(C: Circle): Boolean;
Var
  Dx,Dy,R:Single;
Begin
  //compare the distance to combined radii
  Dx := C.Center.X - Self.Center.X;
  Dy := C.Center.Y - Self.Center.Y;
  R := C.Radius + Self.Radius;
  Result := (Sqr(Dx) + Sqr(Dy) < Sqr(R));
End;

{Procedure Polygon2D.Load(FileName: String);
Var
  Source:FileStream;
Begin
  Source := FileStream.Open(FileName);
  Source.Read(VertexCount, 4);
  SetLength(Vertices, VertexCount);
  If (VertexCount>0) Then
    Source.Read(Vertices[0], SizeOf(Vector2D) * VertexCount);
  Source.Destroy;
End;

Procedure Polygon2D.Save(FileName: String);
Var
  Dest:FileStream;
Begin
  Dest := FileStream.Create(FileName);
  Dest.Write(VertexCount, 4);
  If (VertexCount>0) Then
    Dest.Write(Vertices[0], SizeOf(Vector2D) * VertexCount);
  Dest.Destroy;
End;}

Function Circle.PointInside(P: Vector2D): Boolean;
Begin
  Result := (P.Distance(Center)<=Radius);
End;


Function Plane.Distance(X,Y,Z:Single):Single; 
Begin
  // This function will simply perform a dot product of the point and this plane.
  Result := A*X + B*Y + C*Z + D;
End;

Function Plane.Distance(V:Vector3D):Single;  
Begin
  Result := A*V.X + B*V.Y + C*V.Z + D;
End;

Function PlaneCreate(PA,PB,PC,PD:Single):Plane;
Begin
  Result.A := PA;
  Result.B := PB;
  Result.C := PC;
  Result.D := PD;
End;

Function PlaneCreate(V1,V2,V3:Vector3D):Plane;
Var
  N:Vector3D;
Begin
  N := TriangleNormal(V1,V2,V3);
  Result := PlaneCreate(V1,N);
End;

Function PlaneCreate(Source, Normal: Vector3D):Plane;
Begin
  Result.A := Normal.X;
  Result.B := Normal.Y;
  Result.C := Normal.Z;
  Result.D := -VectorDot(Source, Normal);
End;

{
Function PlaneDotCoord(P:Plane; Vector:Vector3D):Single;
Begin
  With P, Vector Do
    Result := A*X + B*Y + C*Z + D*1;
End;

Function PlaneDotNormal(P:Plane; Normal:Vector3D):Single;
Begin
  With P, Normal Do
    Result := A*X + B*Y + C*Z + D*0;
End;


Function GetMirrorPlane(Const StartVertex,EndVertex,Normal:Vector3D):Plane;
Var
  Vertex:Array[0..2]Of Vector3D;
Begin
  Vertex[0]:=StartVertex;
  Vertex[1]:=StartVertex;
  Vertex[1].Y:=EndVertex.Y;
  Vertex[2]:=EndVertex;

   //determining the coefficients in plane's equation
  Result.A:= ( (vertex[1].y - vertex[0].y)*(vertex[2].z - vertex[0].z) ) - ( (vertex[1].z - vertex[0].z)*(vertex[2].y - vertex[0].y) );
  Result.B:= ( (vertex[1].z - vertex[0].z)*(vertex[2].x - vertex[0].x) ) - ( (vertex[2].z - vertex[0].z)*(vertex[1].x - vertex[0].x) );
  Result.C:= ( (vertex[1].x - vertex[0].x)*(vertex[2].y - vertex[0].y) ) - ( (vertex[1].y - vertex[0].y)*(vertex[2].x - vertex[0].x) );
  Result.D:= - ( vertex[0].x* Result.A + vertex[0].y*Result.B + vertex[0].z*Result.C );
End;
 }

{
A----B
|    |
|    |
C----D
}
Function GetQuadHeight(A,B,C,D, Position:Vector3D; Normal:PVector3D=Nil):Single;
Var
  P:Plane;
  coefX, coefZ:Single;
Begin
  coefX := B.x - position.x;
  coefZ := B.z - position.z;

//1. Decide which triangle it's in:
  if (coefX >= coefZ) Then // you are in ABD
    P := PlaneCreate(A,B,D)
  Else //we're in ACD
    P := PlaneCreate(A,C,D);

  Result := (-position.x * P.a - position.z * P.c - P.d) / P.b;

  If Assigned(Normal) Then
  Begin
    Normal^ := VectorCreate(-P.A, -P.B, -P.C);
    Normal^.Normalize;
  End;
End;

Function Plane.Normal: Vector3D;
Begin
  Result.X := A;
  Result.Y := B;
  Result.Z := C;
  Result.Normalize;
End;
End.

