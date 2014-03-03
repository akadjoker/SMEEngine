{**********************************************************************
 Package pl_OpenGL.pkg
 This unit is part of CodeTyphon Studio (http://www.pilotlogic.com/)
***********************************************************************}

unit GLES2;

interface

uses
{$IFDEF  MSWINDOWS}
windows,
{$ELSE}
log,
{$ENDIF}
sdl2,
math, sysutils;


function  InitGLES20 : Boolean;
procedure FreeGLES20;

const

  {$IFDEF MSWINDOWS}
    libEGL     = 'libEGL.dll';
    libGLESv2  = 'libGLESv2.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    libEGL     = 'libEGL.so';
    libGLESv2  = 'libGLESv2.so';
  {$ENDIF}

Type



  GLdouble   = Double;
  PGLdouble   = ^GLdouble;
  T3dArray = array [0..2] of GLdouble;

type
  PEGLConfig  = ^EGLConfig;
  PEGLint  = ^EGLint;
  EGLint = longint; // Why int64 only on win64 and not even on 64-bit linux???

  EGLConfig = pointer;

  PGLubyte = ^GLubyte;
  PGLboolean  = ^GLboolean;
  PGLenum  = ^GLenum;
  PGLfloat  = ^GLfloat;
  PGLint  = ^GLint;
  PGLsizei  = ^GLsizei;
  PGLuint  = ^GLuint;


     GLvoid = pointer;
     TGLvoid = GLvoid;

     GLenum = dword;
     TGLenum = GLenum;

     GLboolean = byte;
     TGLboolean = GLboolean;

     GLbitfield = dword;
     TGLbitfield = GLbitfield;

     GLbyte = shortint;
     TGLbyte = GLbyte;

     GLshort = smallint;
     TGLshort = GLshort;

     GLint = longint;
     TGLint = GLint;

     GLsizei = longint;
     TGLsizei = GLsizei;

     GLubyte = byte;
     TGLubyte = GLubyte;

     GLushort = word;
     TGLushort = GLushort;

     GLuint = longword;
     TGLuint = GLuint;

     GLfloat = single;
     TGLfloat = GLfloat;

     GLclampf = single;
     TGLclampf = GLclampf;

     GLfixed = longint;
     TGLfixed = GLfixed;
  { GL types for handling large vertex buffer objects  }

     GLintptr = Longint;

     GLsizeiptr = Longint;
  { OpenGL ES core versions  }


  { EGL Types  }
  { EGLint is defined in eglplatform.h  }

  type

{$IFDEF  MSWINDOWS}

     EGLNativeDisplayType = HDC;
     EGLNativeWindowType = HWND;
     EGLNativePixmapType = HBITMAP;

{$ELSE}

     EGLNativeDisplayType = ptrint;
     EGLNativeWindowType = pointer;
     EGLNativePixmapType = pointer;

{$ENDIF}

     EGLBoolean = dword;
     EGLenum = dword;
     EGLContext = pointer;
     EGLDisplay = pointer;
     EGLSurface = pointer;
     EGLClientBuffer = pointer;
  { EGL Versioning  }

  const
     EGL_VERSION_1_0 = 1;
     EGL_VERSION_1_1 = 1;
     EGL_VERSION_1_2 = 1;
     EGL_VERSION_1_3 = 1;
     EGL_VERSION_1_4 = 1;
  { EGL Enumerants. Bitmasks and other exceptional cases aside, most
   * enums are assigned unique values starting at 0x3000.
    }
  { EGL aliases  }
     EGL_FALSE = 0;
     EGL_TRUE = 1;
  { Out-of-band handle values  }
  { was #define dname def_expr }
  function EGL_DEFAULT_DISPLAY : EGLNativeDisplayType;
  { was #define dname def_expr }
  function EGL_NO_CONTEXT : EGLContext;
  { was #define dname def_expr }
  function EGL_NO_DISPLAY : EGLDisplay;
  { was #define dname def_expr }
  function EGL_NO_SURFACE : EGLSurface;
  { Out-of-band attribute value  }
  { was #define dname def_expr }
  function EGL_DONT_CARE : EGLint;
  { Errors / GetError return values  }

  const
     EGL_SUCCESS = $3000;
     EGL_NOT_INITIALIZED = $3001;
     EGL_BAD_ACCESS = $3002;
     EGL_BAD_ALLOC = $3003;
     EGL_BAD_ATTRIBUTE = $3004;
     EGL_BAD_CONFIG = $3005;
     EGL_BAD_CONTEXT = $3006;
     EGL_BAD_CURRENT_SURFACE = $3007;
     EGL_BAD_DISPLAY = $3008;
     EGL_BAD_MATCH = $3009;
     EGL_BAD_NATIVE_PIXMAP = $300A;
     EGL_BAD_NATIVE_WINDOW = $300B;
     EGL_BAD_PARAMETER = $300C;
     EGL_BAD_SURFACE = $300D;
  { EGL 1.1 - IMG_power_management  }
     EGL_CONTEXT_LOST = $300E;
  { Reserved 0x300F-0x301F for additional errors  }
  { Config attributes  }
     EGL_BUFFER_SIZE = $3020;
     EGL_ALPHA_SIZE = $3021;
     EGL_BLUE_SIZE = $3022;
     EGL_GREEN_SIZE = $3023;
     EGL_RED_SIZE = $3024;
     EGL_DEPTH_SIZE = $3025;
     EGL_STENCIL_SIZE = $3026;
     EGL_CONFIG_CAVEAT = $3027;
     EGL_CONFIG_ID = $3028;
     EGL_LEVEL = $3029;
     EGL_MAX_PBUFFER_HEIGHT = $302A;
     EGL_MAX_PBUFFER_PIXELS = $302B;
     EGL_MAX_PBUFFER_WIDTH = $302C;
     EGL_NATIVE_RENDERABLE = $302D;
     EGL_NATIVE_VISUAL_ID = $302E;
     EGL_NATIVE_VISUAL_TYPE = $302F;
     EGL_PRESERVED_RESOURCES = $3030;
     EGL_SAMPLES = $3031;
     EGL_SAMPLE_BUFFERS = $3032;
     EGL_SURFACE_TYPE = $3033;
     EGL_TRANSPARENT_TYPE = $3034;
     EGL_TRANSPARENT_BLUE_VALUE = $3035;
     EGL_TRANSPARENT_GREEN_VALUE = $3036;
     EGL_TRANSPARENT_RED_VALUE = $3037;
  { Attrib list terminator  }
     EGL_NONE = $3038;
     EGL_BIND_TO_TEXTURE_RGB = $3039;
     EGL_BIND_TO_TEXTURE_RGBA = $303A;
     EGL_MIN_SWAP_INTERVAL = $303B;
     EGL_MAX_SWAP_INTERVAL = $303C;
     EGL_LUMINANCE_SIZE = $303D;
     EGL_ALPHA_MASK_SIZE = $303E;
     EGL_COLOR_BUFFER_TYPE = $303F;
     EGL_RENDERABLE_TYPE = $3040;
  { Pseudo-attribute (not queryable)  }
     EGL_MATCH_NATIVE_PIXMAP = $3041;
     EGL_CONFORMANT = $3042;
  { Reserved 0x3041-0x304F for additional config attributes  }
  { Config attribute values  }
  { EGL_CONFIG_CAVEAT value  }
     EGL_SLOW_CONFIG = $3050;
  { EGL_CONFIG_CAVEAT value  }
     EGL_NON_CONFORMANT_CONFIG = $3051;
  { EGL_TRANSPARENT_TYPE value  }
     EGL_TRANSPARENT_RGB = $3052;
  { EGL_COLOR_BUFFER_TYPE value  }
     EGL_RGB_BUFFER = $308E;
  { EGL_COLOR_BUFFER_TYPE value  }
     EGL_LUMINANCE_BUFFER = $308F;
  { More config attribute values, for EGL_TEXTURE_FORMAT  }
     EGL_NO_TEXTURE = $305C;
     EGL_TEXTURE_RGB = $305D;
     EGL_TEXTURE_RGBA = $305E;
     EGL_TEXTURE_2D = $305F;
  { Config attribute mask bits  }
  { EGL_SURFACE_TYPE mask bits  }
     EGL_PBUFFER_BIT = $0001;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_PIXMAP_BIT = $0002;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_WINDOW_BIT = $0004;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_VG_COLORSPACE_LINEAR_BIT = $0020;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_VG_ALPHA_FORMAT_PRE_BIT = $0040;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_MULTISAMPLE_RESOLVE_BOX_BIT = $0200;
  { EGL_SURFACE_TYPE mask bits  }
     EGL_SWAP_BEHAVIOR_PRESERVED_BIT = $0400;
  { EGL_RENDERABLE_TYPE mask bits  }
     EGL_OPENGL_ES_BIT = $0001;
  { EGL_RENDERABLE_TYPE mask bits  }
     EGL_OPENVG_BIT = $0002;
  { EGL_RENDERABLE_TYPE mask bits  }
     EGL_OPENGL_ES2_BIT = $0004;
  { EGL_RENDERABLE_TYPE mask bits  }
     EGL_OPENGL_BIT = $0008;
  { QueryString targets  }
     EGL_VENDOR = $3053;
     EGL_VERSION = $3054;
     EGL_EXTENSIONS = $3055;
     EGL_CLIENT_APIS = $308D;
  { QuerySurface / SurfaceAttrib / CreatePbufferSurface targets  }
     EGL_HEIGHT = $3056;
     EGL_WIDTH = $3057;
     EGL_LARGEST_PBUFFER = $3058;
     EGL_TEXTURE_FORMAT = $3080;
     EGL_TEXTURE_TARGET = $3081;
     EGL_MIPMAP_TEXTURE = $3082;
     EGL_MIPMAP_LEVEL = $3083;
     EGL_RENDER_BUFFER = $3086;
     EGL_VG_COLORSPACE = $3087;
     EGL_VG_ALPHA_FORMAT = $3088;
     EGL_HORIZONTAL_RESOLUTION = $3090;
     EGL_VERTICAL_RESOLUTION = $3091;
     EGL_PIXEL_ASPECT_RATIO = $3092;
     EGL_SWAP_BEHAVIOR = $3093;
     EGL_MULTISAMPLE_RESOLVE = $3099;
  { EGL_RENDER_BUFFER values / BindTexImage / ReleaseTexImage buffer targets  }
     EGL_BACK_BUFFER = $3084;
     EGL_SINGLE_BUFFER = $3085;
  { OpenVG color spaces  }
  { EGL_VG_COLORSPACE value  }
     EGL_VG_COLORSPACE_sRGB = $3089;
  { EGL_VG_COLORSPACE value  }
     EGL_VG_COLORSPACE_LINEAR = $308A;
  { OpenVG alpha formats  }
  { EGL_ALPHA_FORMAT value  }
     EGL_VG_ALPHA_FORMAT_NONPRE = $308B;
  { EGL_ALPHA_FORMAT value  }
     EGL_VG_ALPHA_FORMAT_PRE = $308C;
  { Constant scale factor by which fractional display resolutions &
   * aspect ratio are scaled when queried as integer values.
    }
     EGL_DISPLAY_SCALING = 10000;
  { Unknown display resolution/aspect ratio  }
  { was #define dname def_expr }
  function EGL_UNKNOWN : EGLint;

  { Back buffer swap behaviors  }
  { EGL_SWAP_BEHAVIOR value  }

  const
     EGL_BUFFER_PRESERVED = $3094;
  { EGL_SWAP_BEHAVIOR value  }
     EGL_BUFFER_DESTROYED = $3095;
  { CreatePbufferFromClientBuffer buffer types  }
     EGL_OPENVG_IMAGE = $3096;
  { QueryContext targets  }
     EGL_CONTEXT_CLIENT_TYPE = $3097;
  { CreateContext attributes  }
     EGL_CONTEXT_CLIENT_VERSION = $3098;
  { Multisample resolution behaviors  }
  { EGL_MULTISAMPLE_RESOLVE value  }
     EGL_MULTISAMPLE_RESOLVE_DEFAULT = $309A;
  { EGL_MULTISAMPLE_RESOLVE value  }
     EGL_MULTISAMPLE_RESOLVE_BOX = $309B;
  { BindAPI/QueryAPI targets  }
     EGL_OPENGL_ES_API = $30A0;
     EGL_OPENVG_API = $30A1;
     EGL_OPENGL_API = $30A2;
  { GetCurrentSurface targets  }
     EGL_DRAW = $3059;
     EGL_READ = $305A;
  { WaitNative engines  }
     EGL_CORE_NATIVE_ENGINE = $305B;
  { EGL 1.2 tokens renamed for consistency in EGL 1.3  }
     EGL_COLORSPACE = EGL_VG_COLORSPACE;
     EGL_ALPHA_FORMAT = EGL_VG_ALPHA_FORMAT;
     EGL_COLORSPACE_sRGB = EGL_VG_COLORSPACE_sRGB;
     EGL_COLORSPACE_LINEAR = EGL_VG_COLORSPACE_LINEAR;
     EGL_ALPHA_FORMAT_NONPRE = EGL_VG_ALPHA_FORMAT_NONPRE;
     EGL_ALPHA_FORMAT_PRE = EGL_VG_ALPHA_FORMAT_PRE;
  { EGL extensions must request enum blocks from the Khronos
   * API Registrar, who maintains the enumerant registry. Submit
   * a bug in Khronos Bugzilla against task "Registry".
    }
  { EGL Functions  }

  var
    eglGetError : function:EGLint;stdcall;
    eglGetDisplay : function(display_id:EGLNativeDisplayType):EGLDisplay;stdcall;
    eglInitialize : function(dpy:EGLDisplay; major:pEGLint; minor:pEGLint):EGLBoolean;stdcall;
    eglTerminate : function(dpy:EGLDisplay):EGLBoolean;stdcall;
    eglQueryString : function(dpy:EGLDisplay; name:EGLint):pchar;stdcall;
    eglGetConfigs : function(dpy:EGLDisplay; configs:pEGLConfig; config_size:EGLint; num_config:pEGLint):EGLBoolean;stdcall;
    eglChooseConfig : function(dpy:EGLDisplay; attrib_list:pEGLint; configs:pEGLConfig; config_size:EGLint; num_config:pEGLint):EGLBoolean;stdcall;
    eglGetConfigAttrib : function(dpy:EGLDisplay; config:EGLConfig; attribute:EGLint; value:pEGLint):EGLBoolean;stdcall;
    eglCreateWindowSurface : function(dpy:EGLDisplay; config:EGLConfig; win:EGLNativeWindowType; attrib_list:pEGLint):EGLSurface;stdcall;
    eglCreatePbufferSurface : function(dpy:EGLDisplay; config:EGLConfig; attrib_list:pEGLint):EGLSurface;stdcall;
    eglCreatePixmapSurface : function(dpy:EGLDisplay; config:EGLConfig; pixmap:EGLNativePixmapType; attrib_list:pEGLint):EGLSurface;stdcall;
    eglDestroySurface : function(dpy:EGLDisplay; surface:EGLSurface):EGLBoolean;stdcall;
    eglQuerySurface : function(dpy:EGLDisplay; surface:EGLSurface; attribute:EGLint; value:pEGLint):EGLBoolean;stdcall;
    eglBindAPI : function(api:EGLenum):EGLBoolean;stdcall;
    eglQueryAPI : function:EGLenum;stdcall;
    eglWaitClient : function:EGLBoolean;stdcall;
    eglReleaseThread : function:EGLBoolean;stdcall;
    eglCreatePbufferFromClientBuffer : function(dpy:EGLDisplay; buftype:EGLenum; buffer:EGLClientBuffer; config:EGLConfig; attrib_list:pEGLint):EGLSurface;stdcall;
    eglSurfaceAttrib : function(dpy:EGLDisplay; surface:EGLSurface; attribute:EGLint; value:EGLint):EGLBoolean;stdcall;
    eglBindTexImage : function(dpy:EGLDisplay; surface:EGLSurface; buffer:EGLint):EGLBoolean;stdcall;
    eglReleaseTexImage : function(dpy:EGLDisplay; surface:EGLSurface; buffer:EGLint):EGLBoolean;stdcall;
    eglSwapInterval : function(dpy:EGLDisplay; interval:EGLint):EGLBoolean;stdcall;
    eglCreateContext : function(dpy:EGLDisplay; config:EGLConfig; share_context:EGLContext; attrib_list:pEGLint):EGLContext;stdcall;
    eglDestroyContext : function(dpy:EGLDisplay; ctx:EGLContext):EGLBoolean;stdcall;
    eglMakeCurrent : function(dpy:EGLDisplay; draw:EGLSurface; read:EGLSurface; ctx:EGLContext):EGLBoolean;stdcall;
    eglGetCurrentContext : function:EGLContext;stdcall;
    eglGetCurrentSurface : function(readdraw:EGLint):EGLSurface;stdcall;
    eglGetCurrentDisplay : function:EGLDisplay;stdcall;
    eglQueryContext : function(dpy:EGLDisplay; ctx:EGLContext; attribute:EGLint; value:pEGLint):EGLBoolean;stdcall;
    eglWaitGL : function:EGLBoolean;stdcall;
    eglWaitNative : function(engine:EGLint):EGLBoolean;stdcall;
    eglSwapBuffers : function(dpy:EGLDisplay; surface:EGLSurface):EGLBoolean;stdcall;
    eglCopyBuffers : function(dpy:EGLDisplay; surface:EGLSurface; target:EGLNativePixmapType):EGLBoolean;stdcall;
  { This is a generic function pointer type, whose name indicates it must
   * be cast to the proper type *and calling convention* before use.
    }

  type

     __eglMustCastToProperFunctionPointerType = procedure (_para1:pointer);stdcall;
  { Now, define eglGetProcAddress using the generic function ptr. type  }
(* Const before type ignored *)

  var
    eglGetProcAddress : function(procname:{$IFDEF LINUX}PWideChar{$ELSE}PChar{$ENDIF}):__eglMustCastToProperFunctionPointerType;stdcall;
  { Header file version number  }
  { Current version at http://www.khronos.org/registry/egl/  }

  const
     EGL_EGLEXT_VERSION = 3;
     EGL_KHR_config_attribs = 1;
  { EGLConfig attribute  }
     EGL_CONFORMANT_KHR = $3042;
  { EGL_SURFACE_TYPE bitfield  }
     EGL_VG_COLORSPACE_LINEAR_BIT_KHR = $0020;
  { EGL_SURFACE_TYPE bitfield  }
     EGL_VG_ALPHA_FORMAT_PRE_BIT_KHR = $0040;
     EGL_KHR_lock_surface = 1;
  { EGL_LOCK_USAGE_HINT_KHR bitfield  }
     EGL_READ_SURFACE_BIT_KHR = $0001;
  { EGL_LOCK_USAGE_HINT_KHR bitfield  }
     EGL_WRITE_SURFACE_BIT_KHR = $0002;
  { EGL_SURFACE_TYPE bitfield  }
     EGL_LOCK_SURFACE_BIT_KHR = $0080;
  { EGL_SURFACE_TYPE bitfield  }
     EGL_OPTIMAL_FORMAT_BIT_KHR = $0100;
  { EGLConfig attribute  }
     EGL_MATCH_FORMAT_KHR = $3043;
  { EGL_MATCH_FORMAT_KHR value  }
     EGL_FORMAT_RGB_565_EXACT_KHR = $30C0;
  { EGL_MATCH_FORMAT_KHR value  }
     EGL_FORMAT_RGB_565_KHR = $30C1;
  { EGL_MATCH_FORMAT_KHR value  }
     EGL_FORMAT_RGBA_8888_EXACT_KHR = $30C2;
  { EGL_MATCH_FORMAT_KHR value  }
     EGL_FORMAT_RGBA_8888_KHR = $30C3;
  { eglLockSurfaceKHR attribute  }
     EGL_MAP_PRESERVE_PIXELS_KHR = $30C4;
  { eglLockSurfaceKHR attribute  }
     EGL_LOCK_USAGE_HINT_KHR = $30C5;
  { eglQuerySurface attribute  }
     EGL_BITMAP_POINTER_KHR = $30C6;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PITCH_KHR = $30C7;
  { eglQuerySurface attribute  }
     EGL_BITMAP_ORIGIN_KHR = $30C8;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PIXEL_RED_OFFSET_KHR = $30C9;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PIXEL_GREEN_OFFSET_KHR = $30CA;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PIXEL_BLUE_OFFSET_KHR = $30CB;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PIXEL_ALPHA_OFFSET_KHR = $30CC;
  { eglQuerySurface attribute  }
     EGL_BITMAP_PIXEL_LUMINANCE_OFFSET_KHR = $30CD;
  { EGL_BITMAP_ORIGIN_KHR value  }
     EGL_LOWER_LEFT_KHR = $30CE;
  { EGL_BITMAP_ORIGIN_KHR value  }
     EGL_UPPER_LEFT_KHR = $30CF;
(* Const before type ignored *)

  const
     EGL_KHR_image = 1;
  { eglCreateImageKHR target  }
     EGL_NATIVE_PIXMAP_KHR = $30B0;

type
     EGLImageKHR = pointer;
  { was #define dname def_expr }
  function EGL_NO_IMAGE_KHR : EGLImageKHR;

(* Const before type ignored *)

  const
     EGL_KHR_vg_parent_image = 1;
  { eglCreateImageKHR target  }
     EGL_VG_PARENT_IMAGE_KHR = $30BA;
     EGL_KHR_gl_texture_2D_image = 1;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_2D_KHR = $30B1;
  { eglCreateImageKHR attribute  }
     EGL_GL_TEXTURE_LEVEL_KHR = $30BC;
     EGL_KHR_gl_texture_cubemap_image = 1;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X_KHR = $30B3;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X_KHR = $30B4;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y_KHR = $30B5;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_KHR = $30B6;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z_KHR = $30B7;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_KHR = $30B8;
     EGL_KHR_gl_texture_3D_image = 1;
  { eglCreateImageKHR target  }
     EGL_GL_TEXTURE_3D_KHR = $30B2;
  { eglCreateImageKHR attribute  }
     EGL_GL_TEXTURE_ZOFFSET_KHR = $30BD;
     EGL_KHR_gl_renderbuffer_image = 1;
  { eglCreateImageKHR target  }
     EGL_GL_RENDERBUFFER_KHR = $30B9;
     EGL_KHR_image_base = 1;
  { Most interfaces defined by EGL_KHR_image_pixmap above  }
  { eglCreateImageKHR attribute  }
     EGL_IMAGE_PRESERVED_KHR = $30D2;
     EGL_KHR_image_pixmap = 1;
  { Interfaces defined by EGL_KHR_image above  }



  const
     GL_ES_VERSION_2_0 = 1;
  { ClearBufferMask  }
     GL_DEPTH_BUFFER_BIT = $00000100;
     GL_STENCIL_BUFFER_BIT = $00000400;
     GL_COLOR_BUFFER_BIT = $00004000;
  { Boolean  }
     GL_FALSE = 0;
     GL_TRUE = 1;
  { BeginMode  }
     GL_POINTS = $0000;
     GL_LINES = $0001;
     GL_LINE_LOOP = $0002;
     GL_LINE_STRIP = $0003;
     GL_TRIANGLES = $0004;
     GL_TRIANGLE_STRIP = $0005;
     GL_TRIANGLE_FAN = $0006;
  { AlphaFunction (not supported in ES20)  }
  {      GL_NEVER  }
  {      GL_LESS  }
  {      GL_EQUAL  }
  {      GL_LEQUAL  }
  {      GL_GREATER  }
  {      GL_NOTEQUAL  }
  {      GL_GEQUAL  }
  {      GL_ALWAYS  }
  { BlendingFactorDest  }
     GL_ZERO = 0;
     GL_ONE = 1;
     GL_SRC_COLOR = $0300;
     GL_ONE_MINUS_SRC_COLOR = $0301;
     GL_SRC_ALPHA = $0302;
     GL_ONE_MINUS_SRC_ALPHA = $0303;
     GL_DST_ALPHA = $0304;
     GL_ONE_MINUS_DST_ALPHA = $0305;
  { BlendingFactorSrc  }
  {      GL_ZERO  }
  {      GL_ONE  }
     GL_DST_COLOR = $0306;
     GL_ONE_MINUS_DST_COLOR = $0307;
     GL_SRC_ALPHA_SATURATE = $0308;
  {      GL_SRC_ALPHA  }
  {      GL_ONE_MINUS_SRC_ALPHA  }
  {      GL_DST_ALPHA  }
  {      GL_ONE_MINUS_DST_ALPHA  }
  { BlendEquationSeparate  }
     GL_FUNC_ADD = $8006;
     GL_BLEND_EQUATION = $8009;
  { same as BLEND_EQUATION  }
     GL_BLEND_EQUATION_RGB = $8009;
     GL_BLEND_EQUATION_ALPHA = $883D;
  { BlendSubtract  }
     GL_FUNC_SUBTRACT = $800A;
     GL_FUNC_REVERSE_SUBTRACT = $800B;
  { Separate Blend Functions  }
     GL_BLEND_DST_RGB = $80C8;
     GL_BLEND_SRC_RGB = $80C9;
     GL_BLEND_DST_ALPHA = $80CA;
     GL_BLEND_SRC_ALPHA = $80CB;
     GL_CONSTANT_COLOR = $8001;
     GL_ONE_MINUS_CONSTANT_COLOR = $8002;
     GL_CONSTANT_ALPHA = $8003;
     GL_ONE_MINUS_CONSTANT_ALPHA = $8004;
     GL_BLEND_COLOR = $8005;
  { Buffer Objects  }
     GL_ARRAY_BUFFER = $8892;
     GL_ELEMENT_ARRAY_BUFFER = $8893;
     GL_ARRAY_BUFFER_BINDING = $8894;
     GL_ELEMENT_ARRAY_BUFFER_BINDING = $8895;
     GL_STREAM_DRAW = $88E0;
     GL_STATIC_DRAW = $88E4;
     GL_DYNAMIC_DRAW = $88E8;
     GL_BUFFER_SIZE = $8764;
     GL_BUFFER_USAGE = $8765;
     GL_CURRENT_VERTEX_ATTRIB = $8626;
  { CullFaceMode  }
     GL_FRONT = $0404;
     GL_BACK = $0405;
     GL_FRONT_AND_BACK = $0408;
  { DepthFunction  }
  {      GL_NEVER  }
  {      GL_LESS  }
  {      GL_EQUAL  }
  {      GL_LEQUAL  }
  {      GL_GREATER  }
  {      GL_NOTEQUAL  }
  {      GL_GEQUAL  }
  {      GL_ALWAYS  }
  { EnableCap  }
     GL_TEXTURE_2D = $0DE1;
     GL_CULL_FACE = $0B44;
     GL_BLEND = $0BE2;
     GL_DITHER = $0BD0;
     GL_STENCIL_TEST = $0B90;
     GL_DEPTH_TEST = $0B71;
     GL_SCISSOR_TEST = $0C11;
     GL_POLYGON_OFFSET_FILL = $8037;
     GL_SAMPLE_ALPHA_TO_COVERAGE = $809E;
     GL_SAMPLE_COVERAGE = $80A0;
  { ErrorCode  }
     GL_NO_ERROR = 0;
     GL_INVALID_ENUM = $0500;
     GL_INVALID_VALUE = $0501;
     GL_INVALID_OPERATION = $0502;
     GL_OUT_OF_MEMORY = $0505;
  { FrontFaceDirection  }
     GL_CW = $0900;
     GL_CCW = $0901;
  { GetPName  }
     GL_LINE_WIDTH = $0B21;
     GL_ALIASED_POINT_SIZE_RANGE = $846D;
     GL_ALIASED_LINE_WIDTH_RANGE = $846E;
     GL_CULL_FACE_MODE = $0B45;
     GL_FRONT_FACE = $0B46;
     GL_DEPTH_RANGE = $0B70;
     GL_DEPTH_WRITEMASK = $0B72;
     GL_DEPTH_CLEAR_VALUE = $0B73;
     GL_DEPTH_FUNC = $0B74;
     GL_STENCIL_CLEAR_VALUE = $0B91;
     GL_STENCIL_FUNC = $0B92;
     GL_STENCIL_FAIL = $0B94;
     GL_STENCIL_PASS_DEPTH_FAIL = $0B95;
     GL_STENCIL_PASS_DEPTH_PASS = $0B96;
     GL_STENCIL_REF = $0B97;
     GL_STENCIL_VALUE_MASK = $0B93;
     GL_STENCIL_WRITEMASK = $0B98;
     GL_STENCIL_BACK_FUNC = $8800;
     GL_STENCIL_BACK_FAIL = $8801;
     GL_STENCIL_BACK_PASS_DEPTH_FAIL = $8802;
     GL_STENCIL_BACK_PASS_DEPTH_PASS = $8803;
     GL_STENCIL_BACK_REF = $8CA3;
     GL_STENCIL_BACK_VALUE_MASK = $8CA4;
     GL_STENCIL_BACK_WRITEMASK = $8CA5;
     GL_VIEWPORT = $0BA2;
     GL_SCISSOR_BOX = $0C10;
  {      GL_SCISSOR_TEST  }
     GL_COLOR_CLEAR_VALUE = $0C22;
     GL_COLOR_WRITEMASK = $0C23;
     GL_UNPACK_ALIGNMENT = $0CF5;
     GL_PACK_ALIGNMENT = $0D05;
     GL_MAX_TEXTURE_SIZE = $0D33;
     GL_MAX_VIEWPORT_DIMS = $0D3A;
     GL_SUBPIXEL_BITS = $0D50;
     GL_RED_BITS = $0D52;
     GL_GREEN_BITS = $0D53;
     GL_BLUE_BITS = $0D54;
     GL_ALPHA_BITS = $0D55;
     GL_DEPTH_BITS = $0D56;
     GL_STENCIL_BITS = $0D57;
     GL_POLYGON_OFFSET_UNITS = $2A00;
  {      GL_POLYGON_OFFSET_FILL  }
     GL_POLYGON_OFFSET_FACTOR = $8038;
     GL_TEXTURE_BINDING_2D = $8069;
     GL_SAMPLE_BUFFERS = $80A8;
     GL_SAMPLES = $80A9;
     GL_SAMPLE_COVERAGE_VALUE = $80AA;
     GL_SAMPLE_COVERAGE_INVERT = $80AB;
  { GetTextureParameter  }
  {      GL_TEXTURE_MAG_FILTER  }
  {      GL_TEXTURE_MIN_FILTER  }
  {      GL_TEXTURE_WRAP_S  }
  {      GL_TEXTURE_WRAP_T  }
     GL_NUM_COMPRESSED_TEXTURE_FORMATS = $86A2;
     GL_COMPRESSED_TEXTURE_FORMATS = $86A3;
  { HintMode  }
     GL_DONT_CARE = $1100;
     GL_FASTEST = $1101;
     GL_NICEST = $1102;
  { HintTarget  }
     GL_GENERATE_MIPMAP_HINT = $8192;
  { DataType  }
     GL_BYTE = $1400;
     GL_UNSIGNED_BYTE = $1401;
     GL_SHORT = $1402;
     GL_UNSIGNED_SHORT = $1403;
     GL_INT = $1404;
     GL_UNSIGNED_INT = $1405;
     GL_FLOAT = $1406;
     GL_FIXED = $140C;
  { PixelFormat  }
     GL_DEPTH_COMPONENT = $1902;
     GL_ALPHA = $1906;
     GL_RGB = $1907;
     GL_RGBA = $1908;
     GL_LUMINANCE = $1909;
     GL_LUMINANCE_ALPHA = $190A;
  { PixelType  }
  {      GL_UNSIGNED_BYTE  }
     GL_UNSIGNED_SHORT_4_4_4_4 = $8033;
     GL_UNSIGNED_SHORT_5_5_5_1 = $8034;
     GL_UNSIGNED_SHORT_5_6_5 = $8363;
  { Shaders  }
     GL_FRAGMENT_SHADER = $8B30;
     GL_VERTEX_SHADER = $8B31;
     GL_MAX_VERTEX_ATTRIBS = $8869;
     GL_MAX_VERTEX_UNIFORM_VECTORS = $8DFB;
     GL_MAX_VARYING_VECTORS = $8DFC;
     GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = $8B4D;
     GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = $8B4C;
     GL_MAX_TEXTURE_IMAGE_UNITS = $8872;
     GL_MAX_FRAGMENT_UNIFORM_VECTORS = $8DFD;
     GL_SHADER_TYPE = $8B4F;
     GL_DELETE_STATUS = $8B80;
     GL_LINK_STATUS = $8B82;
     GL_VALIDATE_STATUS = $8B83;
     GL_ATTACHED_SHADERS = $8B85;
     GL_ACTIVE_UNIFORMS = $8B86;
     GL_ACTIVE_UNIFORM_MAX_LENGTH = $8B87;
     GL_ACTIVE_ATTRIBUTES = $8B89;
     GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = $8B8A;
     GL_SHADING_LANGUAGE_VERSION = $8B8C;
     GL_CURRENT_PROGRAM = $8B8D;
  { StencilFunction  }
     GL_NEVER = $0200;
     GL_LESS = $0201;
     GL_EQUAL = $0202;
     GL_LEQUAL = $0203;
     GL_GREATER = $0204;
     GL_NOTEQUAL = $0205;
     GL_GEQUAL = $0206;
     GL_ALWAYS = $0207;
  { StencilOp  }
  {      GL_ZERO  }
     GL_KEEP = $1E00;
     GL_REPLACE = $1E01;
     GL_INCR = $1E02;
     GL_DECR = $1E03;
     GL_INVERT = $150A;
     GL_INCR_WRAP = $8507;
     GL_DECR_WRAP = $8508;
  { StringName  }
     GL_VENDOR = $1F00;
     GL_RENDERER = $1F01;
     GL_VERSION = $1F02;
     GL_EXTENSIONS = $1F03;
  { TextureMagFilter  }
     GL_NEAREST = $2600;
     GL_LINEAR = $2601;
  { TextureMinFilter  }
  {      GL_NEAREST  }
  {      GL_LINEAR  }
     GL_NEAREST_MIPMAP_NEAREST = $2700;
     GL_LINEAR_MIPMAP_NEAREST = $2701;
     GL_NEAREST_MIPMAP_LINEAR = $2702;
     GL_LINEAR_MIPMAP_LINEAR = $2703;
  { TextureParameterName  }
     GL_TEXTURE_MAG_FILTER = $2800;
     GL_TEXTURE_MIN_FILTER = $2801;
     GL_TEXTURE_WRAP_S = $2802;
     GL_TEXTURE_WRAP_T = $2803;
  { TextureTarget  }
  {      GL_TEXTURE_2D  }
     GL_TEXTURE = $1702;
     GL_TEXTURE_CUBE_MAP = $8513;
     GL_TEXTURE_BINDING_CUBE_MAP = $8514;
     GL_TEXTURE_CUBE_MAP_POSITIVE_X = $8515;
     GL_TEXTURE_CUBE_MAP_NEGATIVE_X = $8516;
     GL_TEXTURE_CUBE_MAP_POSITIVE_Y = $8517;
     GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = $8518;
     GL_TEXTURE_CUBE_MAP_POSITIVE_Z = $8519;
     GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = $851A;
     GL_MAX_CUBE_MAP_TEXTURE_SIZE = $851C;
  { TextureUnit  }
     GL_TEXTURE0 = $84C0;
     GL_TEXTURE1 = $84C1;
     GL_TEXTURE2 = $84C2;
     GL_TEXTURE3 = $84C3;
     GL_TEXTURE4 = $84C4;
     GL_TEXTURE5 = $84C5;
     GL_TEXTURE6 = $84C6;
     GL_TEXTURE7 = $84C7;
     GL_TEXTURE8 = $84C8;
     GL_TEXTURE9 = $84C9;
     GL_TEXTURE10 = $84CA;
     GL_TEXTURE11 = $84CB;
     GL_TEXTURE12 = $84CC;
     GL_TEXTURE13 = $84CD;
     GL_TEXTURE14 = $84CE;
     GL_TEXTURE15 = $84CF;
     GL_TEXTURE16 = $84D0;
     GL_TEXTURE17 = $84D1;
     GL_TEXTURE18 = $84D2;
     GL_TEXTURE19 = $84D3;
     GL_TEXTURE20 = $84D4;
     GL_TEXTURE21 = $84D5;
     GL_TEXTURE22 = $84D6;
     GL_TEXTURE23 = $84D7;
     GL_TEXTURE24 = $84D8;
     GL_TEXTURE25 = $84D9;
     GL_TEXTURE26 = $84DA;
     GL_TEXTURE27 = $84DB;
     GL_TEXTURE28 = $84DC;
     GL_TEXTURE29 = $84DD;
     GL_TEXTURE30 = $84DE;
     GL_TEXTURE31 = $84DF;
     GL_ACTIVE_TEXTURE = $84E0;
  { TextureWrapMode  }
     GL_REPEAT = $2901;
     GL_CLAMP_TO_EDGE = $812F;
     GL_MIRRORED_REPEAT = $8370;
  { Uniform Types  }
     GL_FLOAT_VEC2 = $8B50;
     GL_FLOAT_VEC3 = $8B51;
     GL_FLOAT_VEC4 = $8B52;
     GL_INT_VEC2 = $8B53;
     GL_INT_VEC3 = $8B54;
     GL_INT_VEC4 = $8B55;
     GL_BOOL = $8B56;
     GL_BOOL_VEC2 = $8B57;
     GL_BOOL_VEC3 = $8B58;
     GL_BOOL_VEC4 = $8B59;
     GL_FLOAT_MAT2 = $8B5A;
     GL_FLOAT_MAT3 = $8B5B;
     GL_FLOAT_MAT4 = $8B5C;
     GL_SAMPLER_2D = $8B5E;
     GL_SAMPLER_CUBE = $8B60;
  { Vertex Arrays  }
     GL_VERTEX_ATTRIB_ARRAY_ENABLED = $8622;
     GL_VERTEX_ATTRIB_ARRAY_SIZE = $8623;
     GL_VERTEX_ATTRIB_ARRAY_STRIDE = $8624;
     GL_VERTEX_ATTRIB_ARRAY_TYPE = $8625;
     GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = $886A;
     GL_VERTEX_ATTRIB_ARRAY_POINTER = $8645;
     GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = $889F;
  { Read Format  }
     GL_IMPLEMENTATION_COLOR_READ_TYPE = $8B9A;
     GL_IMPLEMENTATION_COLOR_READ_FORMAT = $8B9B;
  { Shader Source  }
     GL_COMPILE_STATUS = $8B81;
     GL_INFO_LOG_LENGTH = $8B84;
     GL_SHADER_SOURCE_LENGTH = $8B88;
     GL_SHADER_COMPILER = $8DFA;
  { Shader Binary  }
     GL_SHADER_BINARY_FORMATS = $8DF8;
     GL_NUM_SHADER_BINARY_FORMATS = $8DF9;
  { Shader Precision-Specified Types  }
     GL_LOW_FLOAT = $8DF0;
     GL_MEDIUM_FLOAT = $8DF1;
     GL_HIGH_FLOAT = $8DF2;
     GL_LOW_INT = $8DF3;
     GL_MEDIUM_INT = $8DF4;
     GL_HIGH_INT = $8DF5;
  { Framebuffer Object.  }
     GL_FRAMEBUFFER = $8D40;
     GL_RENDERBUFFER = $8D41;
     GL_RGBA4 = $8056;
     GL_RGB5_A1 = $8057;
     GL_RGB565 = $8D62;
     GL_DEPTH_COMPONENT16 = $81A5;
     GL_STENCIL_INDEX = $1901;
     GL_STENCIL_INDEX8 = $8D48;
     GL_RENDERBUFFER_WIDTH = $8D42;
     GL_RENDERBUFFER_HEIGHT = $8D43;
     GL_RENDERBUFFER_INTERNAL_FORMAT = $8D44;
     GL_RENDERBUFFER_RED_SIZE = $8D50;
     GL_RENDERBUFFER_GREEN_SIZE = $8D51;
     GL_RENDERBUFFER_BLUE_SIZE = $8D52;
     GL_RENDERBUFFER_ALPHA_SIZE = $8D53;
     GL_RENDERBUFFER_DEPTH_SIZE = $8D54;
     GL_RENDERBUFFER_STENCIL_SIZE = $8D55;
     GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = $8CD0;
     GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = $8CD1;
     GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = $8CD2;
     GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = $8CD3;
     GL_COLOR_ATTACHMENT0 = $8CE0;
     GL_DEPTH_ATTACHMENT = $8D00;
     GL_STENCIL_ATTACHMENT = $8D20;
     GL_NONE = 0;
     GL_FRAMEBUFFER_COMPLETE = $8CD5;
     GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = $8CD6;
     GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = $8CD7;
     GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS = $8CD9;
     GL_FRAMEBUFFER_UNSUPPORTED = $8CDD;
     GL_FRAMEBUFFER_BINDING = $8CA6;
     GL_RENDERBUFFER_BINDING = $8CA7;
     GL_MAX_RENDERBUFFER_SIZE = $84E8;
     GL_INVALID_FRAMEBUFFER_OPERATION = $0506;
  {-------------------------------------------------------------------------
   * GL core functions.
   *----------------------------------------------------------------------- }

  var
    glActiveTexture : procedure(texture:GLenum);stdcall;
    glAttachShader : procedure(_program:GLuint; shader:GLuint);stdcall;
(* Const before type ignored *)
    glBindAttribLocation : procedure(_program:GLuint; index:GLuint; name:pchar);stdcall;
    glBindBuffer : procedure(target:GLenum; buffer:GLuint);stdcall;
    glBindFramebuffer : procedure(target:GLenum; framebuffer:GLuint);stdcall;
    glBindRenderbuffer : procedure(target:GLenum; renderbuffer:GLuint);stdcall;
    glBindTexture : procedure(target:GLenum; texture:GLuint);stdcall;
    glBlendColor : procedure(red:GLclampf; green:GLclampf; blue:GLclampf; alpha:GLclampf);stdcall;
    glBlendEquation : procedure(mode:GLenum);stdcall;
    glBlendEquationSeparate : procedure(modeRGB:GLenum; modeAlpha:GLenum);stdcall;
    glBlendFunc : procedure(sfactor:GLenum; dfactor:GLenum);stdcall;
    glBlendFuncSeparate : procedure(srcRGB:GLenum; dstRGB:GLenum; srcAlpha:GLenum; dstAlpha:GLenum);stdcall;
(* Const before type ignored *)
    glBufferData : procedure(target:GLenum; size:GLsizeiptr; data:pointer; usage:GLenum);stdcall;
(* Const before type ignored *)
    glBufferSubData : procedure(target:GLenum; offset:GLintptr; size:GLsizeiptr; data:pointer);stdcall;
    glCheckFramebufferStatus : function(target:GLenum):GLenum;stdcall;
    glClear : procedure(mask:GLbitfield);stdcall;
    glClearColor : procedure(red:GLclampf; green:GLclampf; blue:GLclampf; alpha:GLclampf);stdcall;
    glClearDepthf : procedure(depth:GLclampf);stdcall;
    glClearStencil : procedure(s:GLint);stdcall;
    glColorMask : procedure(red:GLboolean; green:GLboolean; blue:GLboolean; alpha:GLboolean);stdcall;
    glCompileShader : procedure(shader:GLuint);stdcall;
(* Const before type ignored *)
    glCompressedTexImage2D : procedure(target:GLenum; level:GLint; internalformat:GLenum; width:GLsizei; height:GLsizei;
      border:GLint; imageSize:GLsizei; data:pointer);stdcall;
(* Const before type ignored *)
    glCompressedTexSubImage2D : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; width:GLsizei;
      height:GLsizei; format:GLenum; imageSize:GLsizei; data:pointer);stdcall;
    glCopyTexImage2D : procedure(target:GLenum; level:GLint; internalformat:GLenum; x:GLint; y:GLint;
      width:GLsizei; height:GLsizei; border:GLint);stdcall;
    glCopyTexSubImage2D : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; x:GLint;
      y:GLint; width:GLsizei; height:GLsizei);stdcall;
    glCreateProgram : function:GLuint;stdcall;
    glCreateShader : function(_type:GLenum):GLuint;stdcall;
    glCullFace : procedure(mode:GLenum);stdcall;
(* Const before type ignored *)
    glDeleteBuffers : procedure(n:GLsizei; buffers:pGLuint);stdcall;
(* Const before type ignored *)
    glDeleteFramebuffers : procedure(n:GLsizei; framebuffers:pGLuint);stdcall;
    glDeleteProgram : procedure(_program:GLuint);stdcall;
(* Const before type ignored *)
    glDeleteRenderbuffers : procedure(n:GLsizei; renderbuffers:pGLuint);stdcall;
    glDeleteShader : procedure(shader:GLuint);stdcall;
(* Const before type ignored *)
    glDeleteTextures : procedure(n:GLsizei; textures:pGLuint);stdcall;
    glDepthFunc : procedure(func:GLenum);stdcall;
    glDepthMask : procedure(flag:GLboolean);stdcall;
    glDepthRangef : procedure(zNear:GLclampf; zFar:GLclampf);stdcall;
    glDetachShader : procedure(_program:GLuint; shader:GLuint);stdcall;
    glDisable : procedure(cap:GLenum);stdcall;
    glDisableVertexAttribArray : procedure(index:GLuint);stdcall;
    glDrawArrays : procedure(mode:GLenum; first:GLint; count:GLsizei);stdcall;
(* Const before type ignored *)
    glDrawElements : procedure(mode:GLenum; count:GLsizei; _type:GLenum; indices:pointer);stdcall;
    glEnable : procedure(cap:GLenum);stdcall;
    glEnableVertexAttribArray : procedure(index:GLuint);stdcall;
    glFinish : procedure;stdcall;
    glFlush : procedure;stdcall;
    glFramebufferRenderbuffer : procedure(target:GLenum; attachment:GLenum; renderbuffertarget:GLenum; renderbuffer:GLuint);stdcall;
    glFramebufferTexture2D : procedure(target:GLenum; attachment:GLenum; textarget:GLenum; texture:GLuint; level:GLint);stdcall;
    glFrontFace : procedure(mode:GLenum);stdcall;
    glGenBuffers : procedure(n:GLsizei; buffers:pGLuint);stdcall;
    glGenerateMipmap : procedure(target:GLenum);stdcall;
    glGenFramebuffers : procedure(n:GLsizei; framebuffers:pGLuint);stdcall;
    glGenRenderbuffers : procedure(n:GLsizei; renderbuffers:pGLuint);stdcall;
    glGenTextures : procedure(n:GLsizei; textures:pGLuint);stdcall;
    glGetActiveAttrib : procedure(_program:GLuint; index:GLuint; bufsize:GLsizei; length:pGLsizei; size:pGLint; _type:pGLenum; name:pchar);stdcall;
    glGetActiveUniform : procedure(_program:GLuint; index:GLuint; bufsize:GLsizei; length:pGLsizei; size:pGLint; _type:pGLenum; name:pchar);stdcall;
    glGetAttachedShaders : procedure(_program:GLuint; maxcount:GLsizei; count:pGLsizei; shaders:pGLuint);stdcall;
(* Const before type ignored *)
    glGetAttribLocation : function(_program:GLuint; name:pchar):longint;stdcall;
    glGetBooleanv : procedure(pname:GLenum; params:pGLboolean);stdcall;
    glGetBufferParameteriv : procedure(target:GLenum; pname:GLenum; params:pGLint);stdcall;
    glGetError : function:GLenum;stdcall;
    glGetFloatv : procedure(pname:GLenum; params:pGLfloat);stdcall;
    glGetFramebufferAttachmentParameteriv : procedure(target:GLenum; attachment:GLenum; pname:GLenum; params:pGLint);stdcall;
    glGetIntegerv : procedure(pname:GLenum; params:pGLint);stdcall;
    glGetProgramiv : procedure(_program:GLuint; pname:GLenum; params:pGLint);stdcall;
    glGetProgramInfoLog : procedure(_program:GLuint; bufsize:GLsizei; length:pGLsizei; infolog:pchar);stdcall;
    glGetRenderbufferParameteriv : procedure(target:GLenum; pname:GLenum; params:pGLint);stdcall;
    glGetShaderiv : procedure(shader:GLuint; pname:GLenum; params:pGLint);stdcall;
    glGetShaderInfoLog : procedure(shader:GLuint; bufsize:GLsizei; length:pGLsizei; infolog:pchar);stdcall;
    glGetShaderPrecisionFormat : procedure(shadertype:GLenum; precisiontype:GLenum; range:pGLint; precision:pGLint);stdcall;
    glGetShaderSource : procedure(shader:GLuint; bufsize:GLsizei; length:pGLsizei; source:pchar);stdcall;
(* Const before type ignored *)
    glGetString : function(name:GLenum):PGLubyte;stdcall;
    glGetTexParameterfv : procedure(target:GLenum; pname:GLenum; params:pGLfloat);stdcall;
    glGetTexParameteriv : procedure(target:GLenum; pname:GLenum; params:pGLint);stdcall;
    glGetUniformfv : procedure(_program:GLuint; location:GLint; params:pGLfloat);stdcall;
    glGetUniformiv : procedure(_program:GLuint; location:GLint; params:pGLint);stdcall;
(* Const before type ignored *)
    glGetUniformLocation : function(_program:GLuint; name:pchar):longint;stdcall;
    glGetVertexAttribfv : procedure(index:GLuint; pname:GLenum; params:pGLfloat);stdcall;
    glGetVertexAttribiv : procedure(index:GLuint; pname:GLenum; params:pGLint);stdcall;
    glGetVertexAttribPointerv : procedure(index:GLuint; pname:GLenum; pointer:Ppointer);stdcall;
    glHint : procedure(target:GLenum; mode:GLenum);stdcall;
    glIsBuffer : function(buffer:GLuint):GLboolean;stdcall;
    glIsEnabled : function(cap:GLenum):GLboolean;stdcall;
    glIsFramebuffer : function(framebuffer:GLuint):GLboolean;stdcall;
    glIsProgram : function(_program:GLuint):GLboolean;stdcall;
    glIsRenderbuffer : function(renderbuffer:GLuint):GLboolean;stdcall;
    glIsShader : function(shader:GLuint):GLboolean;stdcall;
    glIsTexture : function(texture:GLuint):GLboolean;stdcall;
    glLineWidth : procedure(width:GLfloat);stdcall;
    glLinkProgram : procedure(_program:GLuint);stdcall;
    glPixelStorei : procedure(pname:GLenum; param:GLint);stdcall;
    glPolygonOffset : procedure(factor:GLfloat; units:GLfloat);stdcall;
    glReadPixels : procedure(x:GLint; y:GLint; width:GLsizei; height:GLsizei; format:GLenum; _type:GLenum; pixels:pointer);stdcall;
    glReleaseShaderCompiler : procedure;stdcall;
    glRenderbufferStorage : procedure(target:GLenum; internalformat:GLenum; width:GLsizei; height:GLsizei);stdcall;
    glSampleCoverage : procedure(value:GLclampf; invert:GLboolean);stdcall;
    glScissor : procedure(x:GLint; y:GLint; width:GLsizei; height:GLsizei);stdcall;
(* Const before type ignored *)
(* Const before type ignored *)
    glShaderBinary : procedure(n:GLsizei; shaders:pGLuint; binaryformat:GLenum; binary:pointer; length:GLsizei);stdcall;
(* Const before type ignored *)
(* Const before type ignored *)
    glShaderSource : procedure(shader:GLuint; count:GLsizei; _string:Ppchar; length:pGLint);stdcall;
    glStencilFunc : procedure(func:GLenum; ref:GLint; mask:GLuint);stdcall;
    glStencilFuncSeparate : procedure(face:GLenum; func:GLenum; ref:GLint; mask:GLuint);stdcall;
    glStencilMask : procedure(mask:GLuint);stdcall;
    glStencilMaskSeparate : procedure(face:GLenum; mask:GLuint);stdcall;
    glStencilOp : procedure(fail:GLenum; zfail:GLenum; zpass:GLenum);stdcall;
    glStencilOpSeparate : procedure(face:GLenum; fail:GLenum; zfail:GLenum; zpass:GLenum);stdcall;
(* Const before type ignored *)
    glTexImage2D : procedure(target:GLenum; level:GLint; internalformat:GLenum; width:GLsizei; height:GLsizei; border:GLint; format:GLenum; _type:GLenum; pixels:pointer);stdcall;
    glTexParameterf : procedure(target:GLenum; pname:GLenum; param:GLfloat);stdcall;
(* Const before type ignored *)
    glTexParameterfv : procedure(target:GLenum; pname:GLenum; params:pGLfloat);stdcall;
    glTexParameteri : procedure(target:GLenum; pname:GLenum; param:GLint);stdcall;
(* Const before type ignored *)
    glTexParameteriv : procedure(target:GLenum; pname:GLenum; params:pGLint);stdcall;
(* Const before type ignored *)
    glTexSubImage2D : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; width:GLsizei; height:GLsizei; format:GLenum; _type:GLenum; pixels:pointer);stdcall;
    glUniform1f : procedure(location:GLint; x:GLfloat);stdcall;
(* Const before type ignored *)
    glUniform1fv : procedure(location:GLint; count:GLsizei; v:pGLfloat);stdcall;
    glUniform1i : procedure(location:GLint; x:GLint);stdcall;
(* Const before type ignored *)
    glUniform1iv : procedure(location:GLint; count:GLsizei; v:pGLint);stdcall;
    glUniform2f : procedure(location:GLint; x:GLfloat; y:GLfloat);stdcall;
(* Const before type ignored *)
    glUniform2fv : procedure(location:GLint; count:GLsizei; v:pGLfloat);stdcall;
    glUniform2i : procedure(location:GLint; x:GLint; y:GLint);stdcall;
(* Const before type ignored *)
    glUniform2iv : procedure(location:GLint; count:GLsizei; v:pGLint);stdcall;
    glUniform3f : procedure(location:GLint; x:GLfloat; y:GLfloat; z:GLfloat);stdcall;
(* Const before type ignored *)
    glUniform3fv : procedure(location:GLint; count:GLsizei; v:pGLfloat);stdcall;
    glUniform3i : procedure(location:GLint; x:GLint; y:GLint; z:GLint);stdcall;
(* Const before type ignored *)
    glUniform3iv : procedure(location:GLint; count:GLsizei; v:pGLint);stdcall;
    glUniform4f : procedure(location:GLint; x:GLfloat; y:GLfloat; z:GLfloat; w:GLfloat);stdcall;
(* Const before type ignored *)
    glUniform4fv : procedure(location:GLint; count:GLsizei; v:pGLfloat);stdcall;
    glUniform4i : procedure(location:GLint; x:GLint; y:GLint; z:GLint; w:GLint);stdcall;
(* Const before type ignored *)
    glUniform4iv : procedure(location:GLint; count:GLsizei; v:pGLint);stdcall;
(* Const before type ignored *)
    glUniformMatrix2fv : procedure(location:GLint; count:GLsizei; transpose:GLboolean; value:pGLfloat);stdcall;
(* Const before type ignored *)
    glUniformMatrix3fv : procedure(location:GLint; count:GLsizei; transpose:GLboolean; value:pGLfloat);stdcall;
(* Const before type ignored *)
    glUniformMatrix4fv : procedure(location:GLint; count:GLsizei; transpose:GLboolean; value:pGLfloat);stdcall;
    glUseProgram : procedure(_program:GLuint);stdcall;
    glValidateProgram : procedure(_program:GLuint);stdcall;
    glVertexAttrib1f : procedure(indx:GLuint; x:GLfloat);stdcall;
(* Const before type ignored *)
    glVertexAttrib1fv : procedure(indx:GLuint; values:pGLfloat);stdcall;
    glVertexAttrib2f : procedure(indx:GLuint; x:GLfloat; y:GLfloat);stdcall;
(* Const before type ignored *)
    glVertexAttrib2fv : procedure(indx:GLuint; values:pGLfloat);stdcall;
    glVertexAttrib3f : procedure(indx:GLuint; x:GLfloat; y:GLfloat; z:GLfloat);stdcall;
(* Const before type ignored *)
    glVertexAttrib3fv : procedure(indx:GLuint; values:pGLfloat);stdcall;
    glVertexAttrib4f : procedure(indx:GLuint; x:GLfloat; y:GLfloat; z:GLfloat; w:GLfloat);stdcall;
(* Const before type ignored *)
    glVertexAttrib4fv : procedure(indx:GLuint; values:pGLfloat);stdcall;
(* Const before type ignored *)
    glVertexAttribPointer : procedure(indx:GLuint; size:GLint; _type:GLenum; normalized:GLboolean; stride:GLsizei; ptr:pointer);stdcall;
    glViewport : procedure(x:GLint; y:GLint; width:GLsizei; height:GLsizei);stdcall;
  {------------------------------------------------------------------------*
   * IMG extension tokens
   *------------------------------------------------------------------------ }
  { GL_IMG_binary_shader  }

  const
     GL_SGX_BINARY_IMG = $8C0A;
  { GL_IMG_texture_compression_pvrtc  }
     GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG = $8C00;
     GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG = $8C01;
     GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG = $8C02;
     GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG = $8C03;
     GL_BGRA = $80E1;
  {------------------------------------------------------------------------*
   * IMG extension functions
   *------------------------------------------------------------------------ }
  { GL_IMG_binary_shader  }
     GL_IMG_binary_shader = 1;
  { GL_IMG_texture_compression_pvrtc  }
     GL_IMG_texture_compression_pvrtc = 1;
  {
   * This document is licensed under the SGI Free Software B License Version
   * 2.0. For details, see http://oss.sgi.com/projects/FreeB/ .
    }
  {------------------------------------------------------------------------*
   * OES extension tokens
   *------------------------------------------------------------------------ }
  { GL_OES_compressed_ETC1_RGB8_texture  }
     GL_ETC1_RGB8_OES = $8D64;
  { GL_OES_compressed_paletted_texture  }
     GL_PALETTE4_RGB8_OES = $8B90;
     GL_PALETTE4_RGBA8_OES = $8B91;
     GL_PALETTE4_R5_G6_B5_OES = $8B92;
     GL_PALETTE4_RGBA4_OES = $8B93;
     GL_PALETTE4_RGB5_A1_OES = $8B94;
     GL_PALETTE8_RGB8_OES = $8B95;
     GL_PALETTE8_RGBA8_OES = $8B96;
     GL_PALETTE8_R5_G6_B5_OES = $8B97;
     GL_PALETTE8_RGBA4_OES = $8B98;
     GL_PALETTE8_RGB5_A1_OES = $8B99;
  { GL_OES_depth24  }
     GL_DEPTH_COMPONENT24_OES = $81A6;
  { GL_OES_depth32  }
     GL_DEPTH_COMPONENT32_OES = $81A7;
  { GL_OES_depth_texture  }
  { No new tokens introduced by this extension.  }
  { GL_OES_EGL_image  }

  type

     GLeglImageOES = pointer;
  { GL_OES_get_program_binary  }

  const
     GL_PROGRAM_BINARY_LENGTH_OES = $8741;
     GL_NUM_PROGRAM_BINARY_FORMATS_OES = $87FE;
     GL_PROGRAM_BINARY_FORMATS_OES = $87FF;
  { GL_OES_mapbuffer  }
     GL_WRITE_ONLY_OES = $88B9;
     GL_BUFFER_ACCESS_OES = $88BB;
     GL_BUFFER_MAPPED_OES = $88BC;
     GL_BUFFER_MAP_POINTER_OES = $88BD;
  { GL_OES_packed_depth_stencil  }
     GL_DEPTH_STENCIL_OES = $84F9;
     GL_UNSIGNED_INT_24_8_OES = $84FA;
     GL_DEPTH24_STENCIL8_OES = $88F0;
  { GL_OES_rgb8_rgba8  }
     GL_RGB8_OES = $8051;
     GL_RGBA8_OES = $8058;
  { GL_OES_standard_derivatives  }
     GL_FRAGMENT_SHADER_DERIVATIVE_HINT_OES = $8B8B;
  { GL_OES_stencil1  }
     GL_STENCIL_INDEX1_OES = $8D46;
  { GL_OES_stencil4  }
     GL_STENCIL_INDEX4_OES = $8D47;
  { GL_OES_texture3D  }
     GL_TEXTURE_WRAP_R_OES = $8072;
     GL_TEXTURE_3D_OES = $806F;
     GL_TEXTURE_BINDING_3D_OES = $806A;
     GL_MAX_3D_TEXTURE_SIZE_OES = $8073;
     GL_SAMPLER_3D_OES = $8B5F;
     GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_OES = $8CD4;
  { GL_OES_texture_half_float  }
     GL_HALF_FLOAT_OES = $8D61;
  { GL_OES_vertex_half_float  }
  { GL_HALF_FLOAT_OES defined in GL_OES_texture_half_float already.  }
  { GL_OES_vertex_type_10_10_10_2  }
     GL_UNSIGNED_INT_10_10_10_2_OES = $8DF6;
     GL_INT_10_10_10_2_OES = $8DF7;
  {------------------------------------------------------------------------*
   * AMD extension tokens
   *------------------------------------------------------------------------ }
  { GL_AMD_compressed_3DC_texture  }
     GL_3DC_X_AMD = $87F9;
     GL_3DC_XY_AMD = $87FA;
  { GL_AMD_compressed_ATC_texture  }
     GL_ATC_RGB_AMD = $8C92;
     GL_ATC_RGBA_EXPLICIT_ALPHA_AMD = $8C93;
     GL_ATC_RGBA_INTERPOLATED_ALPHA_AMD = $87EE;
  { GL_AMD_program_binary_Z400  }
     GL_Z400_BINARY_AMD = $8740;
  { GL_AMD_performance_monitor  }
{$define GL_AMD_performance_monitor}
     GL_COUNTER_TYPE_AMD = $8BC0;
     GL_COUNTER_RANGE_AMD = $8BC1;
     GL_UNSIGNED_INT64_AMD = $8BC2;
     GL_PERCENTAGE_AMD = $8BC3;
     GL_PERFMON_RESULT_AVAILABLE_AMD = $8BC4;
     GL_PERFMON_RESULT_SIZE_AMD = $8BC5;
     GL_PERFMON_RESULT_AMD = $8BC6;
  {------------------------------------------------------------------------*
   * EXT extension tokens
   *------------------------------------------------------------------------ }
  { GL_EXT_texture_filter_anisotropic  }
     GL_TEXTURE_MAX_ANISOTROPY_EXT = $84FE;
     GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = $84FF;
  { GL_EXT_texture_type_2_10_10_10_REV  }
     GL_UNSIGNED_INT_2_10_10_10_REV_EXT = $8368;
  {------------------------------------------------------------------------*
   * OES extension functions
   *------------------------------------------------------------------------ }
  { GL_OES_compressed_ETC1_RGB8_texture  }
     GL_OES_compressed_ETC1_RGB8_texture = 1;
  { GL_OES_compressed_paletted_texture  }
     GL_OES_compressed_paletted_texture = 1;
  { GL_OES_EGL_image  }

  var
    glEGLImageTargetTexture2DOES : procedure(target:GLenum; image:GLeglImageOES);stdcall;
    glEGLImageTargetRenderbufferStorageOES : procedure(target:GLenum; image:GLeglImageOES);stdcall;

  { GL_OES_depth24  }

  const
     GL_OES_depth24 = 1;
  { GL_OES_depth32  }
     GL_OES_depth32 = 1;
  { GL_OES_depth_texture  }
     GL_OES_depth_texture = 1;
  { GL_OES_element_index_uint  }
     GL_OES_element_index_uint = 1;
  { GL_OES_fbo_render_mipmap  }
     GL_OES_fbo_render_mipmap = 1;
  { GL_OES_fragment_precision_high  }
     GL_OES_fragment_precision_high = 1;
  { GL_OES_get_program_binary  }

  var
    glGetProgramBinaryOES : procedure(_program:GLuint; bufSize:GLsizei; length:pGLsizei; binaryFormat:pGLenum; binary:pointer);stdcall;
(* Const before type ignored *)
    glProgramBinaryOES : procedure(_program:GLuint; binaryFormat:GLenum; binary:pointer; length:GLint);stdcall;

(* Const before type ignored *)
  { GL_OES_mapbuffer  }

  const
     GL_OES_mapbuffer = 1;

  var
    glMapBufferOES : function(target:GLenum; access:GLenum):pointer;stdcall;
    glUnmapBufferOES : function(target:GLenum):GLboolean;stdcall;
    glGetBufferPointervOES : procedure(target:GLenum; pname:GLenum; params:Ppointer);stdcall;

  type

     PFNGLMAPBUFFEROESPROC = pointer;
  { GL_OES_packed_depth_stencil  }

  const
     GL_OES_packed_depth_stencil = 1;
  { GL_OES_rgb8_rgba8  }
     GL_OES_rgb8_rgba8 = 1;
  { GL_OES_standard_derivatives  }
     GL_OES_standard_derivatives = 1;
  { GL_OES_stencil1  }
     GL_OES_stencil1 = 1;
  { GL_OES_stencil4  }
     GL_OES_stencil4 = 1;
  { GL_OES_texture_3D  }
     GL_OES_texture_3D = 1;
(* Const before type ignored *)

  var
    glTexImage3DOES : procedure(target:GLenum; level:GLint; internalformat:GLenum; width:GLsizei; height:GLsizei; depth:GLsizei; border:GLint; format:GLenum; _type:GLenum; pixels:pointer);stdcall;
(* Const before type ignored *)
    glTexSubImage3DOES : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; zoffset:GLint; width:GLsizei; height:GLsizei; depth:GLsizei; format:GLenum; _type:GLenum; pixels:pointer);stdcall;
    glCopyTexSubImage3DOES : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; zoffset:GLint;  x:GLint; y:GLint; width:GLsizei; height:GLsizei);stdcall;
(* Const before type ignored *)
    glCompressedTexImage3DOES : procedure(target:GLenum; level:GLint; internalformat:GLenum; width:GLsizei; height:GLsizei; depth:GLsizei; border:GLint; imageSize:GLsizei; data:pointer);stdcall;
(* Const before type ignored *)
    glCompressedTexSubImage3DOES : procedure(target:GLenum; level:GLint; xoffset:GLint; yoffset:GLint; zoffset:GLint; width:GLsizei; height:GLsizei; depth:GLsizei; format:GLenum; imageSize:GLsizei; data:pointer);stdcall;
    glFramebufferTexture3DOES : procedure(target:GLenum; attachment:GLenum; textarget:GLenum; texture:GLuint; level:GLint;zoffset:GLint);stdcall;
(* Const before type ignored *)

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  { GL_OES_texture_float_linear  }

  const
     GL_OES_texture_float_linear = 1;
  { GL_OES_texture_half_float_linear  }
     GL_OES_texture_half_float_linear = 1;
  { GL_OES_texture_float  }
     GL_OES_texture_float = 1;
  { GL_OES_texture_half_float  }
     GL_OES_texture_half_float = 1;
  { GL_OES_texture_npot  }
     GL_OES_texture_npot = 1;
  { GL_OES_vertex_half_float  }
     GL_OES_vertex_half_float = 1;
  { GL_OES_vertex_type_10_10_10_2  }
     GL_OES_vertex_type_10_10_10_2 = 1;
  {------------------------------------------------------------------------*
   * AMD extension functions
   *------------------------------------------------------------------------ }
  { GL_AMD_compressed_3DC_texture  }
     GL_AMD_compressed_3DC_texture = 1;
  { GL_AMD_compressed_ATC_texture  }
     GL_AMD_compressed_ATC_texture = 1;
  { GL_AMD_program_binary_Z400  }
     GL_AMD_program_binary_Z400 = 1;
  { AMD_performance_monitor  }
     GL_AMD_performance_monitor = 1;

  var
    glGetPerfMonitorGroupsAMD : procedure(numGroups:pGLint; groupsSize:GLsizei; groups:pGLuint);stdcall;
    glGetPerfMonitorCountersAMD : procedure(group:GLuint; numCounters:pGLint; maxActiveCounters:pGLint; counterSize:GLsizei; counters:pGLuint);stdcall;
    glGetPerfMonitorGroupStringAMD : procedure(group:GLuint; bufSize:GLsizei; length:pGLsizei; groupString:pchar);stdcall;
    glGetPerfMonitorCounterStringAMD : procedure(group:GLuint; counter:GLuint; bufSize:GLsizei; length:pGLsizei; counterString:pchar);stdcall;
    glGetPerfMonitorCounterInfoAMD : procedure(group:GLuint; counter:GLuint; pname:GLenum; data:pointer);stdcall;
    glGenPerfMonitorsAMD : procedure(n:GLsizei; monitors:pGLuint);stdcall;
    glDeletePerfMonitorsAMD : procedure(n:GLsizei; monitors:pGLuint);stdcall;
    glSelectPerfMonitorCountersAMD : procedure(monitor:GLuint; enable:GLboolean; group:GLuint; numCounters:GLint; countersList:pGLuint);stdcall;
    glBeginPerfMonitorAMD : procedure(monitor:GLuint);stdcall;
    glEndPerfMonitorAMD : procedure(monitor:GLuint);stdcall;
    glGetPerfMonitorCounterDataAMD : procedure(monitor:GLuint; pname:GLenum; dataSize:GLsizei; data:pGLuint; bytesWritten:pGLint);stdcall;

  {------------------------------------------------------------------------*
   * EXT extension functions
   *------------------------------------------------------------------------ }
  { GL_EXT_texture_filter_anisotropic  }

  const
     GL_EXT_texture_filter_anisotropic = 1;
  { GL_EXT_texture_type_2_10_10_10_REV  }
     GL_EXT_texture_type_2_10_10_10_REV = 1;

     
{$IFDEF UNIX}
function dlopen ( Name : PWideChar; Flags : longint) : Pointer; cdecl; external 'dl';
function dlclose( Lib : Pointer) : boolean; cdecl; external 'dl';
function dlsym  ( Lib : Pointer; pchar : pchar) : Pointer; cdecl; external 'dl';
{$ENDIF}



type
TShader=object
public
 VertexShader,FragmentShader,ShaderProgram:TGLuint;
procedure init(vertexs,fragments:string);
procedure Free();
end;



implementation
uses sdl_simple;

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

procedure PrintShaderInfoLog(Shader:TGLUint;ShaderType:string);
var len,Success:TGLint;
    Buffer:pchar;
begin
 glGetShaderiv(Shader,GL_COMPILE_STATUS,@Success);
 if Success<>GL_TRUE then
 begin
  glGetShaderiv(Shader,GL_INFO_LOG_LENGTH,@len);
  if len>0 then
  begin
   getmem(Buffer,len+1);
   glGetShaderInfoLog(Shader,len,nil,Buffer);
   sdl_log(pchar(ShaderType+': '+Buffer));
   freemem(Buffer);
  end;
 end;
end;

function CreateShader(ShaderType:TGLenum;Source:pchar):TGLuint;
begin
 result:=glCreateShader(ShaderType);
 glShaderSource(result,1,@Source,nil);
 glCompileShader(result);
 if ShaderType=GL_VERTEX_SHADER then
 begin
  PrintShaderInfoLog(result,'Vertex shader');
 end else
 begin
  PrintShaderInfoLog(result,'Fragment shader');
 end;
end;


procedure TShader.Free();
begin
 glDeleteProgram(ShaderProgram);
 glDeleteShader(FragmentShader);
 glDeleteShader(VertexShader);

end;
procedure TShader.init(vertexs,fragments:string);
var
  Data: Pointer;
  Size: integer;


begin


 ShaderProgram:=glCreateProgram();


  ResourceLoad(vertexs,data,Size);
  if (Data = nil) then      Exit;
  VertexShader:=CreateShader(GL_VERTEX_SHADER,data);
  Data := nil;
  FreeMem(Data);


 
  ResourceLoad(fragments,data,Size);
  if (Data = nil) then      Exit;
  FragmentShader:=CreateShader(GL_FRAGMENT_SHADER,data);
  Data := nil;
  FreeMem(Data);



 glAttachShader(ShaderProgram,VertexShader);
 glAttachShader(ShaderProgram,FragmentShader);
 glLinkProgram(ShaderProgram);
end;



type
{$IFDEF UNIX}
 EsHandle=Pointer;
  {$ELSE}
 EsHandle=HMODULE;
{$ENDIF}



var
{$IFDEF UNIX}
 EGLLib:   EsHandle=nil;
 GLESv2Lib:   EsHandle=nil;

  {$ELSE}
 EGLLib:   EsHandle=0;
 GLESv2Lib:   EsHandle=0;
{$ENDIF}


function convLoadLibrary(Name: string):  EsHandle;
begin
  {$IFDEF UNIX}
   result:=dlopen(PWideChar(name),$001);
  {$ELSE}
   Result := LoadLibrary(PAnsiChar(Name));
 {$ENDIF}
end;

function convFreeLibrary(LibHandle:  EsHandle): Boolean;
begin
     {$IFDEF UNIX}
      Result := dlclose(LibHandle);
      {$ELSE}
      Result := FreeLibrary(LibHandle);
    {$ENDIF}
end;

function GetGLProcAddress(LibHandle:  EsHandle ;ProcName: string): Pointer;
begin
   {$IFDEF UNIX}
      Result := dlsym(LibHandle, pchar(ProcName));
     // if not assigned(result) then logmsg('NULL :'+ProcName);
     {$ELSE}
      Result := GetProcAddress(LibHandle, PAnsiChar(ProcName));
    //   if not assigned(result) then writeln('NULL :'+ProcName);
   {$ENDIF}
end;


  { was #define dname def_expr }
  function EGL_DEFAULT_DISPLAY : EGLNativeDisplayType;
      begin
         EGL_DEFAULT_DISPLAY:=EGLNativeDisplayType(0);
      end;

  { was #define dname def_expr }
  function EGL_NO_CONTEXT : EGLContext;
      begin
         EGL_NO_CONTEXT:=EGLContext(0);
      end;

  { was #define dname def_expr }
  function EGL_NO_DISPLAY : EGLDisplay;
      begin
         EGL_NO_DISPLAY:=EGLDisplay(0);
      end;

  { was #define dname def_expr }
  function EGL_NO_SURFACE : EGLSurface;
      begin
         EGL_NO_SURFACE:=EGLSurface(0);
      end;

  { was #define dname def_expr }
  function EGL_DONT_CARE : EGLint;
      begin
         EGL_DONT_CARE:=EGLint(-(1));
      end;

  { was #define dname def_expr }
  function EGL_UNKNOWN : EGLint;
      begin
         EGL_UNKNOWN:=EGLint(-(1));
      end;

  { was #define dname def_expr }
  function EGL_NO_IMAGE_KHR : EGLImageKHR;
      begin
         EGL_NO_IMAGE_KHR:=EGLImageKHR(0);
      end;


  procedure FreeEGL;
    begin
     {$IFDEF UNIX}
  if EGLLib<>nil then
        convFreeLibrary(EGLLib);

     {$ELSE}
      if EGLLib<>0 then
        convFreeLibrary(EGLLib);

   {$ENDIF}


      eglGetError:=nil;
      eglGetDisplay:=nil;
      eglInitialize:=nil;
      eglTerminate:=nil;
      eglQueryString:=nil;
      eglGetConfigs:=nil;
      eglChooseConfig:=nil;
      eglGetConfigAttrib:=nil;
      eglCreateWindowSurface:=nil;
      eglCreatePbufferSurface:=nil;
      eglCreatePixmapSurface:=nil;
      eglDestroySurface:=nil;
      eglQuerySurface:=nil;
      eglBindAPI:=nil;
      eglQueryAPI:=nil;
      eglWaitClient:=nil;
      eglReleaseThread:=nil;
      eglCreatePbufferFromClientBuffer:=nil;
      eglSurfaceAttrib:=nil;
      eglBindTexImage:=nil;
      eglReleaseTexImage:=nil;
      eglSwapInterval:=nil;
      eglCreateContext:=nil;
      eglDestroyContext:=nil;
      eglMakeCurrent:=nil;
      eglGetCurrentContext:=nil;
      eglGetCurrentSurface:=nil;
      eglGetCurrentDisplay:=nil;
      eglQueryContext:=nil;
      eglWaitGL:=nil;
      eglWaitNative:=nil;
      eglSwapBuffers:=nil;
      eglCopyBuffers:=nil;
      eglGetProcAddress:=nil;
    end;


  procedure LoadEGL(lib:string);
    begin
      FreeEGL;
      EGLLib:=convLoadLibrary(pchar(lib)); //9999


   {$IFDEF UNIX}
      if (EGLLib=nil) then
        logmsg('EGL2 Loaded FAIL') else         logmsg('EGL2 Loaded OK');

     {$ELSE}
            if (EGLLib=0) then
        writeln('eGL2 Loaded FAIL') else         writeln('eGL2 Loaded OK');

   {$ENDIF}


      eglGetProcAddress:=GetGLProcAddress(EGLLib,'glGetProcAddress');
      eglGetError:=GetGLProcAddress(EGLLib,'eglGetError');
      eglGetDisplay:=GetGLProcAddress(EGLLib,'eglGetDisplay');
      eglInitialize:=GetGLProcAddress(EGLLib,'eglInitialize');
      eglTerminate:=GetGLProcAddress(EGLLib,'eglTerminate');
      eglQueryString:=GetGLProcAddress(EGLLib,'eglQueryString');
      eglGetConfigs:=GetGLProcAddress(EGLLib,'eglGetConfigs');
      eglChooseConfig:=GetGLProcAddress(EGLLib,'eglChooseConfig');
      eglGetConfigAttrib:=GetGLProcAddress(EGLLib,'eglGetConfigAttrib');
      eglCreateWindowSurface:=GetGLProcAddress(EGLLib,'eglCreateWindowSurface');
      eglCreatePbufferSurface:=GetGLProcAddress(EGLLib,'eglCreatePbufferSurface');
      eglCreatePixmapSurface:=GetGLProcAddress(EGLLib,'eglCreatePixmapSurface');
      eglDestroySurface:=GetGLProcAddress(EGLLib,'eglDestroySurface');
      eglQuerySurface:=GetGLProcAddress(EGLLib,'eglQuerySurface');
      eglBindAPI:=GetGLProcAddress(EGLLib,'eglBindAPI');
      eglQueryAPI:=GetGLProcAddress(EGLLib,'eglQueryAPI');
      eglWaitClient:=GetGLProcAddress(EGLLib,'eglWaitClient');
      eglReleaseThread:=GetGLProcAddress(EGLLib,'eglReleaseThread');
      eglCreatePbufferFromClientBuffer:=GetGLProcAddress(EGLLib,'eglCreatePbufferFromClientBuffer');
      eglSurfaceAttrib:=GetGLProcAddress(EGLLib,'eglSurfaceAttrib');
      eglBindTexImage:=GetGLProcAddress(EGLLib,'eglBindTexImage');
      eglReleaseTexImage:=GetGLProcAddress(EGLLib,'eglReleaseTexImage');
      eglSwapInterval:=GetGLProcAddress(EGLLib,'eglSwapInterval');
      eglCreateContext:=GetGLProcAddress(EGLLib,'eglCreateContext');
      eglDestroyContext:=GetGLProcAddress(EGLLib,'eglDestroyContext');
      eglMakeCurrent:=GetGLProcAddress(EGLLib,'eglMakeCurrent');
      eglGetCurrentContext:=GetGLProcAddress(EGLLib,'eglGetCurrentContext');
      eglGetCurrentSurface:=GetGLProcAddress(EGLLib,'eglGetCurrentSurface');
      eglGetCurrentDisplay:=GetGLProcAddress(EGLLib,'eglGetCurrentDisplay');
      eglQueryContext:=GetGLProcAddress(EGLLib,'eglQueryContext');
      eglWaitGL:=GetGLProcAddress(EGLLib,'eglWaitGL');
      eglWaitNative:=GetGLProcAddress(EGLLib,'eglWaitNative');
      eglSwapBuffers:=GetGLProcAddress(EGLLib,'eglSwapBuffers');
      eglCopyBuffers:=GetGLProcAddress(EGLLib,'eglCopyBuffers');
    end;




  procedure FreeGLESv2;
    begin

{$IFDEF UNIX}
  if GLESv2Lib<>nil then
        convFreeLibrary(GLESv2Lib);

  {$ELSE}
      if EGLLib<>0 then
        convFreeLibrary(GLESv2Lib);

   {$ENDIF}

      glActiveTexture:=nil;
      glAttachShader:=nil;
      glBindAttribLocation:=nil;
      glBindBuffer:=nil;
      glBindFramebuffer:=nil;
      glBindRenderbuffer:=nil;
      glBindTexture:=nil;
      glBlendColor:=nil;
      glBlendEquation:=nil;
      glBlendEquationSeparate:=nil;
      glBlendFunc:=nil;
      glBlendFuncSeparate:=nil;
      glBufferData:=nil;
      glBufferSubData:=nil;
      glCheckFramebufferStatus:=nil;
      glClear:=nil;
      glClearColor:=nil;
      glClearDepthf:=nil;
      glClearStencil:=nil;
      glColorMask:=nil;
      glCompileShader:=nil;
      glCompressedTexImage2D:=nil;
      glCompressedTexSubImage2D:=nil;
      glCopyTexImage2D:=nil;
      glCopyTexSubImage2D:=nil;
      glCreateProgram:=nil;
      glCreateShader:=nil;
      glCullFace:=nil;
      glDeleteBuffers:=nil;
      glDeleteFramebuffers:=nil;
      glDeleteProgram:=nil;
      glDeleteRenderbuffers:=nil;
      glDeleteShader:=nil;
      glDeleteTextures:=nil;
      glDepthFunc:=nil;
      glDepthMask:=nil;
      glDepthRangef:=nil;
      glDetachShader:=nil;
      glDisable:=nil;
      glDisableVertexAttribArray:=nil;
      glDrawArrays:=nil;
      glDrawElements:=nil;
      glEnable:=nil;
      glEnableVertexAttribArray:=nil;
      glFinish:=nil;
      glFlush:=nil;
      glFramebufferRenderbuffer:=nil;
      glFramebufferTexture2D:=nil;
      glFrontFace:=nil;
      glGenBuffers:=nil;
      glGenerateMipmap:=nil;
      glGenFramebuffers:=nil;
      glGenRenderbuffers:=nil;
      glGenTextures:=nil;
      glGetActiveAttrib:=nil;
      glGetActiveUniform:=nil;
      glGetAttachedShaders:=nil;
      glGetAttribLocation:=nil;
      glGetBooleanv:=nil;
      glGetBufferParameteriv:=nil;
      glGetError:=nil;
      glGetFloatv:=nil;
      glGetFramebufferAttachmentParameteriv:=nil;
      glGetIntegerv:=nil;
      glGetProgramiv:=nil;
      glGetProgramInfoLog:=nil;
      glGetRenderbufferParameteriv:=nil;
      glGetShaderiv:=nil;
      glGetShaderInfoLog:=nil;
      glGetShaderPrecisionFormat:=nil;
      glGetShaderSource:=nil;
      glGetString:=nil;
      glGetTexParameterfv:=nil;
      glGetTexParameteriv:=nil;
      glGetUniformfv:=nil;
      glGetUniformiv:=nil;
      glGetUniformLocation:=nil;
      glGetVertexAttribfv:=nil;
      glGetVertexAttribiv:=nil;
      glGetVertexAttribPointerv:=nil;
      glHint:=nil;
      glIsBuffer:=nil;
      glIsEnabled:=nil;
      glIsFramebuffer:=nil;
      glIsProgram:=nil;
      glIsRenderbuffer:=nil;
      glIsShader:=nil;
      glIsTexture:=nil;
      glLineWidth:=nil;
      glLinkProgram:=nil;
      glPixelStorei:=nil;
      glPolygonOffset:=nil;
      glReadPixels:=nil;
      glReleaseShaderCompiler:=nil;
      glRenderbufferStorage:=nil;
      glSampleCoverage:=nil;
      glScissor:=nil;
      glShaderBinary:=nil;
      glShaderSource:=nil;
      glStencilFunc:=nil;
      glStencilFuncSeparate:=nil;
      glStencilMask:=nil;
      glStencilMaskSeparate:=nil;
      glStencilOp:=nil;
      glStencilOpSeparate:=nil;
      glTexImage2D:=nil;
      glTexParameterf:=nil;
      glTexParameterfv:=nil;
      glTexParameteri:=nil;
      glTexParameteriv:=nil;
      glTexSubImage2D:=nil;
      glUniform1f:=nil;
      glUniform1fv:=nil;
      glUniform1i:=nil;
      glUniform1iv:=nil;
      glUniform2f:=nil;
      glUniform2fv:=nil;
      glUniform2i:=nil;
      glUniform2iv:=nil;
      glUniform3f:=nil;
      glUniform3fv:=nil;
      glUniform3i:=nil;
      glUniform3iv:=nil;
      glUniform4f:=nil;
      glUniform4fv:=nil;
      glUniform4i:=nil;
      glUniform4iv:=nil;
      glUniformMatrix2fv:=nil;
      glUniformMatrix3fv:=nil;
      glUniformMatrix4fv:=nil;
      glUseProgram:=nil;
      glValidateProgram:=nil;
      glVertexAttrib1f:=nil;
      glVertexAttrib1fv:=nil;
      glVertexAttrib2f:=nil;
      glVertexAttrib2fv:=nil;
      glVertexAttrib3f:=nil;
      glVertexAttrib3fv:=nil;
      glVertexAttrib4f:=nil;
      glVertexAttrib4fv:=nil;
      glVertexAttribPointer:=nil;
      glViewport:=nil;
      glEGLImageTargetTexture2DOES:=nil;
      glEGLImageTargetRenderbufferStorageOES:=nil;
      glGetProgramBinaryOES:=nil;
      glProgramBinaryOES:=nil;
      glMapBufferOES:=nil;
      glUnmapBufferOES:=nil;
      glGetBufferPointervOES:=nil;
      glTexImage3DOES:=nil;
      glTexSubImage3DOES:=nil;
      glCopyTexSubImage3DOES:=nil;
      glCompressedTexImage3DOES:=nil;
      glCompressedTexSubImage3DOES:=nil;
      glFramebufferTexture3DOES:=nil;
      glGetPerfMonitorGroupsAMD:=nil;
      glGetPerfMonitorCountersAMD:=nil;
      glGetPerfMonitorGroupStringAMD:=nil;
      glGetPerfMonitorCounterStringAMD:=nil;
      glGetPerfMonitorCounterInfoAMD:=nil;
      glGenPerfMonitorsAMD:=nil;
      glDeletePerfMonitorsAMD:=nil;
      glSelectPerfMonitorCountersAMD:=nil;
      glBeginPerfMonitorAMD:=nil;
      glEndPerfMonitorAMD:=nil;
      glGetPerfMonitorCounterDataAMD:=nil;
    end;


  procedure LoadGLESv2(lib :string);
    begin
      FreeGLESv2;
      GLESv2Lib:=convLoadLibrary(pchar(lib)); //9999

   {$IFDEF UNIX}
      if (GLESv2Lib=nil) then
        logmsg('GL2 Loaded FAIL') else         logmsg('GL2 Loaded OK');

     {$ELSE}
      if (GLESv2Lib=0) then
        writeln('GL2 Loaded FAIL') else         writeln('GL2 Loaded OK');

   {$ENDIF}


     glActiveTexture:=GetGLProcAddress(GLESv2Lib,'glActiveTexture');
     glAttachShader:=GetGLProcAddress(GLESv2Lib,'glAttachShader');
     glBindAttribLocation:=GetGLProcAddress(GLESv2Lib,'glBindAttribLocation');
     glBindBuffer:=GetGLProcAddress(GLESv2Lib,'glBindBuffer');
     glBindFramebuffer:=GetGLProcAddress(GLESv2Lib,'glBindFramebuffer');
     glBindRenderbuffer:=GetGLProcAddress(GLESv2Lib,'glBindRenderbuffer');
     glBindTexture:=GetGLProcAddress(GLESv2Lib,'glBindTexture');
     glBlendColor:=GetGLProcAddress(GLESv2Lib,'glBlendColor');
     glBlendEquation:=GetGLProcAddress(GLESv2Lib,'glBlendEquation');
     glBlendEquationSeparate:=GetGLProcAddress(GLESv2Lib,'glBlendEquationSeparate');
     glBlendFunc:=GetGLProcAddress(GLESv2Lib,'glBlendFunc');
     glBlendFuncSeparate:=GetGLProcAddress(GLESv2Lib,'glBlendFuncSeparate');
     glBufferData:=GetGLProcAddress(GLESv2Lib,'glBufferData');
     glBufferSubData:=GetGLProcAddress(GLESv2Lib,'glBufferSubData');
     glCheckFramebufferStatus:=GetGLProcAddress(GLESv2Lib,'glCheckFramebufferStatus');
     glClear:=GetGLProcAddress(GLESv2Lib,'glClear');
     glClearColor:=GetGLProcAddress(GLESv2Lib,'glClearColor');
     glClearDepthf:=GetGLProcAddress(GLESv2Lib,'glClearDepthf');
     glClearStencil:=GetGLProcAddress(GLESv2Lib,'glClearStencil');
     glColorMask:=GetGLProcAddress(GLESv2Lib,'glColorMask');
     glCompileShader:=GetGLProcAddress(GLESv2Lib,'glCompileShader');
     glCompressedTexImage2D:=GetGLProcAddress(GLESv2Lib,'glCompressedTexImage2D');
     glCompressedTexSubImage2D:=GetGLProcAddress(GLESv2Lib,'glCompressedTexSubImage2D');
     glCopyTexImage2D:=GetGLProcAddress(GLESv2Lib,'glCopyTexImage2D');
     glCopyTexSubImage2D:=GetGLProcAddress(GLESv2Lib,'glCopyTexSubImage2D');
     glCreateProgram:=GetGLProcAddress(GLESv2Lib,'glCreateProgram');
     glCreateShader:=GetGLProcAddress(GLESv2Lib,'glCreateShader');
     glCullFace:=GetGLProcAddress(GLESv2Lib,'glCullFace');
     glDeleteBuffers:=GetGLProcAddress(GLESv2Lib,'glDeleteBuffers');
     glDeleteFramebuffers:=GetGLProcAddress(GLESv2Lib,'glDeleteFramebuffers');
     glDeleteProgram:=GetGLProcAddress(GLESv2Lib,'glDeleteProgram');
     glDeleteRenderbuffers:=GetGLProcAddress(GLESv2Lib,'glDeleteRenderbuffers');
     glDeleteShader:=GetGLProcAddress(GLESv2Lib,'glDeleteShader');
     glDeleteTextures:=GetGLProcAddress(GLESv2Lib,'glDeleteTextures');
     glDepthFunc:=GetGLProcAddress(GLESv2Lib,'glDepthFunc');
     glDepthMask:=GetGLProcAddress(GLESv2Lib,'glDepthMask');
     glDepthRangef:=GetGLProcAddress(GLESv2Lib,'glDepthRangef');
     glDetachShader:=GetGLProcAddress(GLESv2Lib,'glDetachShader');
     glDisable:=GetGLProcAddress(GLESv2Lib,'glDisable');
     glDisableVertexAttribArray:=GetGLProcAddress(GLESv2Lib,'glDisableVertexAttribArray');
     glDrawArrays:=GetGLProcAddress(GLESv2Lib,'glDrawArrays');
     glDrawElements:=GetGLProcAddress(GLESv2Lib,'glDrawElements');
     glEnable:=GetGLProcAddress(GLESv2Lib,'glEnable');
     glEnableVertexAttribArray:=GetGLProcAddress(GLESv2Lib,'glEnableVertexAttribArray');
     glFinish:=GetGLProcAddress(GLESv2Lib,'glFinish');
     glFlush:=GetGLProcAddress(GLESv2Lib,'glFlush');
     glFramebufferRenderbuffer:=GetGLProcAddress(GLESv2Lib,'glFramebufferRenderbuffer');
     glFramebufferTexture2D:=GetGLProcAddress(GLESv2Lib,'glFramebufferTexture2D');
     glFrontFace:=GetGLProcAddress(GLESv2Lib,'glFrontFace');
     glGenBuffers:=GetGLProcAddress(GLESv2Lib,'glGenBuffers');
     glGenerateMipmap:=GetGLProcAddress(GLESv2Lib,'glGenerateMipmap');
     glGenFramebuffers:=GetGLProcAddress(GLESv2Lib,'glGenFramebuffers');
     glGenRenderbuffers:=GetGLProcAddress(GLESv2Lib,'glGenRenderbuffers');
     glGenTextures:=GetGLProcAddress(GLESv2Lib,'glGenTextures');
     glGetActiveAttrib:=GetGLProcAddress(GLESv2Lib,'glGetActiveAttrib');
     glGetActiveUniform:=GetGLProcAddress(GLESv2Lib,'glGetActiveUniform');
     glGetAttachedShaders:=GetGLProcAddress(GLESv2Lib,'glGetAttachedShaders');
     glGetAttribLocation:=GetGLProcAddress(GLESv2Lib,'glGetAttribLocation');
     glGetBooleanv:=GetGLProcAddress(GLESv2Lib,'glGetBooleanv');
     glGetBufferParameteriv:=GetGLProcAddress(GLESv2Lib,'glGetBufferParameteriv');
     glGetError:=GetGLProcAddress(GLESv2Lib,'glGetError');
     glGetFloatv:=GetGLProcAddress(GLESv2Lib,'glGetFloatv');
     glGetFramebufferAttachmentParameteriv:=GetGLProcAddress(GLESv2Lib,'glGetFramebufferAttachmentParameteriv');
     glGetIntegerv:=GetGLProcAddress(GLESv2Lib,'glGetIntegerv');
     glGetProgramiv:=GetGLProcAddress(GLESv2Lib,'glGetProgramiv');
     glGetProgramInfoLog:=GetGLProcAddress(GLESv2Lib,'glGetProgramInfoLog');
     glGetRenderbufferParameteriv:=GetGLProcAddress(GLESv2Lib,'glGetRenderbufferParameteriv');
     glGetShaderiv:=GetGLProcAddress(GLESv2Lib,'glGetShaderiv');
     glGetShaderInfoLog:=GetGLProcAddress(GLESv2Lib,'glGetShaderInfoLog');
     glGetShaderPrecisionFormat:=GetGLProcAddress(GLESv2Lib,'glGetShaderPrecisionFormat');
     glGetShaderSource:=GetGLProcAddress(GLESv2Lib,'glGetShaderSource');
     glGetString:=GetGLProcAddress(GLESv2Lib,'glGetString');
     glGetTexParameterfv:=GetGLProcAddress(GLESv2Lib,'glGetTexParameterfv');
     glGetTexParameteriv:=GetGLProcAddress(GLESv2Lib,'glGetTexParameteriv');
     glGetUniformfv:=GetGLProcAddress(GLESv2Lib,'glGetUniformfv');
     glGetUniformiv:=GetGLProcAddress(GLESv2Lib,'glGetUniformiv');
     glGetUniformLocation:=GetGLProcAddress(GLESv2Lib,'glGetUniformLocation');
     glGetVertexAttribfv:=GetGLProcAddress(GLESv2Lib,'glGetVertexAttribfv');
     glGetVertexAttribiv:=GetGLProcAddress(GLESv2Lib,'glGetVertexAttribiv');
     glGetVertexAttribPointerv:=GetGLProcAddress(GLESv2Lib,'glGetVertexAttribPointerv');
     glHint:=GetGLProcAddress(GLESv2Lib,'glHint');
     glIsBuffer:=GetGLProcAddress(GLESv2Lib,'glIsBuffer');
     glIsEnabled:=GetGLProcAddress(GLESv2Lib,'glIsEnabled');
     glIsFramebuffer:=GetGLProcAddress(GLESv2Lib,'glIsFramebuffer');
     glIsProgram:=GetGLProcAddress(GLESv2Lib,'glIsProgram');
     glIsRenderbuffer:=GetGLProcAddress(GLESv2Lib,'glIsRenderbuffer');
     glIsShader:=GetGLProcAddress(GLESv2Lib,'glIsShader');
     glIsTexture:=GetGLProcAddress(GLESv2Lib,'glIsTexture');
     glLineWidth:=GetGLProcAddress(GLESv2Lib,'glLineWidth');
     glLinkProgram:=GetGLProcAddress(GLESv2Lib,'glLinkProgram');
     glPixelStorei:=GetGLProcAddress(GLESv2Lib,'glPixelStorei');
     glPolygonOffset:=GetGLProcAddress(GLESv2Lib,'glPolygonOffset');
     glReadPixels:=GetGLProcAddress(GLESv2Lib,'glReadPixels');
     glReleaseShaderCompiler:=GetGLProcAddress(GLESv2Lib,'glReleaseShaderCompiler');
     glRenderbufferStorage:=GetGLProcAddress(GLESv2Lib,'glRenderbufferStorage');
     glSampleCoverage:=GetGLProcAddress(GLESv2Lib,'glSampleCoverage');
     glScissor:=GetGLProcAddress(GLESv2Lib,'glScissor');
     glShaderBinary:=GetGLProcAddress(GLESv2Lib,'glShaderBinary');
     glShaderSource:=GetGLProcAddress(GLESv2Lib,'glShaderSource');
     glStencilFunc:=GetGLProcAddress(GLESv2Lib,'glStencilFunc');
     glStencilFuncSeparate:=GetGLProcAddress(GLESv2Lib,'glStencilFuncSeparate');
     glStencilMask:=GetGLProcAddress(GLESv2Lib,'glStencilMask');
     glStencilMaskSeparate:=GetGLProcAddress(GLESv2Lib,'glStencilMaskSeparate');
     glStencilOp:=GetGLProcAddress(GLESv2Lib,'glStencilOp');
     glStencilOpSeparate:=GetGLProcAddress(GLESv2Lib,'glStencilOpSeparate');
     glTexImage2D:=GetGLProcAddress(GLESv2Lib,'glTexImage2D');
     glTexParameterf:=GetGLProcAddress(GLESv2Lib,'glTexParameterf');
     glTexParameterfv:=GetGLProcAddress(GLESv2Lib,'glTexParameterfv');
     glTexParameteri:=GetGLProcAddress(GLESv2Lib,'glTexParameteri');
     glTexParameteriv:=GetGLProcAddress(GLESv2Lib,'glTexParameteriv');
     glTexSubImage2D:=GetGLProcAddress(GLESv2Lib,'glTexSubImage2D');
     glUniform1f:=GetGLProcAddress(GLESv2Lib,'glUniform1f');
     glUniform1fv:=GetGLProcAddress(GLESv2Lib,'glUniform1fv');
     glUniform1i:=GetGLProcAddress(GLESv2Lib,'glUniform1i');
     glUniform1iv:=GetGLProcAddress(GLESv2Lib,'glUniform1iv');
     glUniform2f:=GetGLProcAddress(GLESv2Lib,'glUniform2f');
     glUniform2fv:=GetGLProcAddress(GLESv2Lib,'glUniform2fv');
     glUniform2i:=GetGLProcAddress(GLESv2Lib,'glUniform2i');
     glUniform2iv:=GetGLProcAddress(GLESv2Lib,'glUniform2iv');
     glUniform3f:=GetGLProcAddress(GLESv2Lib,'glUniform3f');
     glUniform3fv:=GetGLProcAddress(GLESv2Lib,'glUniform3fv');
     glUniform3i:=GetGLProcAddress(GLESv2Lib,'glUniform3i');
     glUniform3iv:=GetGLProcAddress(GLESv2Lib,'glUniform3iv');
     glUniform4f:=GetGLProcAddress(GLESv2Lib,'glUniform4f');
     glUniform4fv:=GetGLProcAddress(GLESv2Lib,'glUniform4fv');
     glUniform4i:=GetGLProcAddress(GLESv2Lib,'glUniform4i');
     glUniform4iv:=GetGLProcAddress(GLESv2Lib,'glUniform4iv');
     glUniformMatrix2fv:=GetGLProcAddress(GLESv2Lib,'glUniformMatrix2fv');
     glUniformMatrix3fv:=GetGLProcAddress(GLESv2Lib,'glUniformMatrix3fv');
     glUniformMatrix4fv:=GetGLProcAddress(GLESv2Lib,'glUniformMatrix4fv');
     glUseProgram:=GetGLProcAddress(GLESv2Lib,'glUseProgram');
     glValidateProgram:=GetGLProcAddress(GLESv2Lib,'glValidateProgram');
     glVertexAttrib1f:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib1f');
     glVertexAttrib1fv:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib1fv');
     glVertexAttrib2f:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib2f');
     glVertexAttrib2fv:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib2fv');
     glVertexAttrib3f:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib3f');
     glVertexAttrib3fv:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib3fv');
     glVertexAttrib4f:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib4f');
     glVertexAttrib4fv:=GetGLProcAddress(GLESv2Lib,'glVertexAttrib4fv');
     glVertexAttribPointer:=GetGLProcAddress(GLESv2Lib,'glVertexAttribPointer');
     glViewport:=GetGLProcAddress(GLESv2Lib,'glViewport');
     glEGLImageTargetTexture2DOES:=GetGLProcAddress(GLESv2Lib,'glEGLImageTargetTexture2DOES');
     glEGLImageTargetRenderbufferStorageOES:=GetGLProcAddress(GLESv2Lib,'glEGLImageTargetRenderbufferStorageOES');
     glGetProgramBinaryOES:=GetGLProcAddress(GLESv2Lib,'glGetProgramBinaryOES');
     glProgramBinaryOES:=GetGLProcAddress(GLESv2Lib,'glProgramBinaryOES');
     glMapBufferOES:=GetGLProcAddress(GLESv2Lib,'glMapBufferOES');
     glUnmapBufferOES:=GetGLProcAddress(GLESv2Lib,'glUnmapBufferOES');
     glGetBufferPointervOES:=GetGLProcAddress(GLESv2Lib,'glGetBufferPointervOES');
     glTexImage3DOES:=GetGLProcAddress(GLESv2Lib,'glTexImage3DOES');
     glTexSubImage3DOES:=GetGLProcAddress(GLESv2Lib,'glTexSubImage3DOES');
     glCopyTexSubImage3DOES:=GetGLProcAddress(GLESv2Lib,'glCopyTexSubImage3DOES');
     glCompressedTexImage3DOES:=GetGLProcAddress(GLESv2Lib,'glCompressedTexImage3DOES');
     glCompressedTexSubImage3DOES:=GetGLProcAddress(GLESv2Lib,'glCompressedTexSubImage3DOES');
     glFramebufferTexture3DOES:=GetGLProcAddress(GLESv2Lib,'glFramebufferTexture3DOES');
     glGetPerfMonitorGroupsAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorGroupsAMD');
     glGetPerfMonitorCountersAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorCountersAMD');
     glGetPerfMonitorGroupStringAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorGroupStringAMD');
     glGetPerfMonitorCounterStringAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorCounterStringAMD');
     glGetPerfMonitorCounterInfoAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorCounterInfoAMD');
     glGenPerfMonitorsAMD:=GetGLProcAddress(GLESv2Lib,'glGenPerfMonitorsAMD');
     glDeletePerfMonitorsAMD:=GetGLProcAddress(GLESv2Lib,'glDeletePerfMonitorsAMD');
     glSelectPerfMonitorCountersAMD:=GetGLProcAddress(GLESv2Lib,'glSelectPerfMonitorCountersAMD');
     glBeginPerfMonitorAMD:=GetGLProcAddress(GLESv2Lib,'glBeginPerfMonitorAMD');
     glEndPerfMonitorAMD:=GetGLProcAddress(GLESv2Lib,'glEndPerfMonitorAMD');
     glGetPerfMonitorCounterDataAMD:=GetGLProcAddress(GLESv2Lib,'glGetPerfMonitorCounterDataAMD');
    end;


function InitGLES20 : Boolean;
begin

 {$IFDEF UNIX}

  EGLLib:=nil;
  LoadEGL(libEGL);
  GLESv2Lib:=nil;
  LoadGLESv2(libGLESv2);
  Result := Assigned( glClear ) and Assigned( glCreateShader );


  {$ELSE}
  EGLLib:=0;
  LoadEGL(libEGL);
  GLESv2Lib:=0;
  LoadGLESv2(libGLESv2);
    Result := Assigned( glClear ) and Assigned( glCreateShader );

  {
  Result := Assigned( eglGetDisplay ) and Assigned( eglInitialize ) and Assigned( eglTerminate ) and Assigned( eglChooseConfig ) and
            Assigned( eglCreateWindowSurface ) and Assigned( eglDestroySurface ) and Assigned( eglCreateContext ) and Assigned( eglDestroyContext ) and
            Assigned( eglMakeCurrent ) and Assigned( eglSwapBuffers ) and assigned(glCreateShader);
   }
   {$ENDIF}


end;

procedure FreeGLES20;
  begin
    FreeGLESv2;
    FreeEGL;
  end;

end.

